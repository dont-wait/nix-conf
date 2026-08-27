#!/usr/bin/env bash
# Firefox history as Look rows: one JSON object per line, most recent first.
# Declared by ~/.look/sources/history.toml.
#
# Every profile, merged and de-duplicated by URL. Look runs this on reload
# (Ctrl+Shift+;), never per keystroke, so the cost is paid once and typing
# filters the snapshot.
set -u

# Rows are also bounded by MAX_BYTES below, which is what usually binds; this is
# the ceiling on what the query builds.
LIMIT=${LOOK_HISTORY_LIMIT:-900}
ICON_DIR=${LOOK_HISTORY_ICONS:-$HOME/.look/cache/favicons}
# Look drops stdout past 256KB. Whole lines only, well under it, so a cut can
# never land mid-object and cost the whole batch.
MAX_BYTES=${LOOK_HISTORY_BYTES:-240000}
MAX_URL=300

# Non-zero, unlike the failures below: a missing interpreter is not transient,
# and Look shows the first stderr line on the reload banner. Exiting 0 here
# would keep the last run's rows and say nothing, which reads as the block being
# broken rather than a program not being installed.
command -v sqlite3 >/dev/null 2>&1 || {
    echo "sqlite3 is not installed" >&2
    exit 1
}

tmp=$(mktemp -d) || exit 0
trap 'rm -rf "$tmp"' EXIT INT TERM

n=0
attach=""
union=""

# The host a favicon is filed under. The writer and the reader of that filename
# have to agree exactly, so both interpolate this one expression: if they ever
# disagreed, icons would be written under one key and looked up under another
# and every one of them would silently vanish.
HOST_SQL="replace(substr(rest, 1, CASE WHEN instr(rest, '/') > 0 THEN instr(rest, '/') - 1 ELSE length(rest) END), ':', '_')"

# Every place Firefox keeps profiles on Linux: the ordinary one, Snap's and
# Flatpak's. One list, because a path added to only one of the two loops below
# would give history rows with no icons, which reads as an icon bug rather than
# a missing path.
FIREFOX_BASES="
$HOME/.mozilla/firefox
$HOME/snap/firefox/common/.mozilla/firefox
$HOME/.var/app/org.mozilla.firefox/.mozilla/firefox"

# A live browser holds a write lock and checkpoints lazily, so each database is
# read from a copy taken WITH its -wal: no lock is taken, and this session's
# pages are not missing. No -shm - SQLite rebuilds it from the WAL.
snapshot() {
    cp "$1" "$2" 2>/dev/null || return 1
    [ -f "$1-wal" ] && cp "$1-wal" "$2-wal" 2>/dev/null
    return 0
}

add() {
    # $1 live database, $2 SELECT template with @ where the alias goes.
    [ -f "$1" ] || return 0
    n=$((n + 1))
    snapshot "$1" "$tmp/db$n" || return 0
    attach="$attach ATTACH DATABASE '$tmp/db$n' AS d$n;"
    [ -n "$union" ] && union="$union UNION ALL "
    union="$union$(printf '%s' "$2" | sed "s/@/d$n/g")"
}

# Firefox: microseconds since the unix epoch.
FIREFOX='SELECT url, title, last_visit_date / 1000000 AS t FROM @.moz_places'
# A here-string, not a pipeline: a piped `while read` runs in a subshell and the
# state `add` accumulates would be discarded with it.
while IFS= read -r base; do
    [ -n "$base" ] || continue
    for db in "$base"/*/places.sqlite; do
        add "$db" "$FIREFOX"
    done
done <<< "$FIREFOX_BASES"

# --- favicons -----------------------------------------------------------
# One PNG per host, largest bitmap wins. Each database is queried in its own
# sqlite session: a profile that renamed a table costs its own icons and not
# everyone else's. Only PNGs, checked by magic number, because that is what the
# icon layer can decode - Firefox also stores SVG and ICO.
icons() {
    [ -f "$1" ] || return 0
    icon_n=$((icon_n + 1))
    snapshot "$1" "$tmp/icons$icon_n" || return 0
    sqlite3 -batch -noheader "$tmp/icons$icon_n" "
        SELECT writefile('$ICON_DIR/' || $HOST_SQL || '.png', data), max(w)
        FROM ($2)
        GROUP BY $HOST_SQL
        HAVING $HOST_SQL <> '';
    " >/dev/null 2>&1
}
icon_n=0

mkdir -p "$ICON_DIR" 2>/dev/null

FIREFOX_ICONS="SELECT substr(p.page_url, instr(p.page_url, '://') + 3) AS rest, i.data AS data, i.width AS w
    FROM moz_pages_w_icons p
    JOIN moz_icons_to_pages r ON r.page_id = p.id
    JOIN moz_icons i ON i.id = r.icon_id
    WHERE hex(substr(i.data, 1, 4)) = '89504E47'"
while IFS= read -r base; do
    [ -n "$base" ] || continue
    for db in "$base"/*/favicons.sqlite; do
        icons "$db" "$FIREFOX_ICONS"
    done
done <<< "$FIREFOX_BASES"

# Nothing readable. Printing nothing keeps the rows from the last good run,
# which is the whole point of saying nothing rather than saying "0 rows".
[ "$n" -eq 0 ] && exit 0

sqlite3 -batch -noheader :memory: "
$attach
WITH raw(url, title, t) AS ($union),
-- A trailing slash is the same page, so the two spellings collapse to one row.
-- A fragment is NOT stripped: hash-routed sites give real pages after the '#'.
norm AS (
    SELECT
        rtrim(url, '/') AS url,
        substr(rtrim(url, '/'), instr(url, '://') + 3) AS rest,
        nullif(trim(title), '') AS title,
        t
    FROM raw
    WHERE url LIKE 'http%' AND length(url) <= $MAX_URL AND t > 0
),
-- Grouped on the scheme-less URL, so one page reached over http and later over
-- https is one row. max(url) keeps the https spelling ('s' sorts above ':').
-- max() over titles skips NULLs, so a page one profile recorded untitled keeps
-- the title another profile has for it.
kept AS (
    SELECT max(url) AS url, rest, max(title) AS title, max(t) AS t
    FROM norm
    GROUP BY rest
    ORDER BY t DESC
    LIMIT $LIMIT
)
-- Both lines carry host AND path: on a busy site the host alone made every page
-- read identically, and untitled rows had nothing else to show.
SELECT json_object(
    'id', url,
    'title', substr(coalesce(title, rest), 1, 110),
    -- The middle is what a long one loses: the host says which site, the tail
    -- says which page, so both ends have to survive.
    'subtitle', CASE
        WHEN length(rest) <= 72 THEN rest
        ELSE substr(rest, 1, 40) || '…' || substr(rest, length(rest) - 28)
    END || '  ·  ' || date(t, 'unixepoch', 'localtime'),
    -- Only when the file is really there: an unresolvable icon path is drawn as
    -- its own text. readfile() answers NULL for a miss, and so does the CASE,
    -- which is read as no icon. Tested and returned as one value, so the check
    -- and the answer cannot name different files.
    'icon', CASE WHEN readfile(icon_path) IS NOT NULL THEN icon_path END
)
FROM (SELECT url, title, t, rest, '$ICON_DIR/' || $HOST_SQL || '.png' AS icon_path FROM kept)
ORDER BY t DESC;
" 2>/dev/null | LC_ALL=C awk -v cap="$MAX_BYTES" '{ total += length($0) + 1; if (total > cap) exit; print }'
