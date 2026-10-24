# Look of the showmethekey keys window: a dark keycast-style pill.
# The package, its defaults and the layer-shell placement live in
# pkgs/showmethekey.nix (NixOS side); the toggle bind is in niri.nix / sway.nix.
#
# Only the window chrome is CSS. The key glyphs are drawn with cairo at a
# size derived from the schema's height, so font and color are not here.
# Corners are rounded here rather than by niri because the window is a layer
# surface, which niri's window-rule geometry-corner-radius does not touch.
#
# The dconf settings are the same values as the schema defaults baked in
# pkgs/showmethekey.nix. They are repeated here because an existing user dconf
# database wins over schema defaults: a GUI-resized window left width/height at
# 1280x1080, which made the "pill" cover the whole screen.
{ ... }:
{
  dconf.settings."one/alynx/showmethekey" = {
    first-time = false;
    mode = "compact";
    alignment = "center";
    width = 560.0;
    height = 64.0;
    timeout = 1200.0;
    draw-border = false;
    show-shift = false;
    show-mouse = false;
    paused-modifier = "none";
    clickable-modifier = "none";
  };

  gtk.gtk4.extraCss = ''
    /* showmethekey keys window: dark pill, no visible header bar. */
    window.smtk-keys-win,
    window.smtk-keys-win.background {
      /* Semi-transparent so the compositor blur behind the layer surface
         (niri layer-rule / swayfx layer_effects for namespace "keycast")
         shows through. 0.85 was opaque enough to hide it. */
      background: rgba(18, 18, 18, 0.55);
      border-radius: 20px;
    }
    window.smtk-keys-win headerbar {
      min-height: 0;
      padding: 0;
      margin: 0;
    }
    window.smtk-keys-win headerbar windowhandle box windowtitle {
      font-size: 1px;
      opacity: 0;
    }
  '';
}
