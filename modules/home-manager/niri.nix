{ config, pkgs, ... }:

let
  wallpaperDir = ../../dotfiles/bg;
  wallpaperPath = ../../dotfiles/bg/nix-girl2.png;
  swaybg = "${pkgs.swaybg}/bin/swaybg";
  waybar = "${pkgs.waybar}/bin/waybar";
  waybarConfig = "${config.xdg.configHome}/waybar/niri.json";
  randomWallpaper = pkgs.writeShellScript "niri-random-wallpaper" ''
    pkill swaybg
    exec ${swaybg} -i "$(find ${wallpaperDir} -type f | shuf -n1)" -m fill
  '';
in
{
  xdg.configFile."niri/config.kdl".text = ''
    environment {
        // Let GTK use Wayland input in Niri; keep the global setting for Sway.
        GTK_IM_MODULE null
    }

    xwayland-satellite {
        path "${pkgs.xwayland-satellite}/bin/xwayland-satellite"
    }

    input {
        keyboard {
            xkb {
                layout "us"
                options "caps:escape"
            }
        }

        focus-follows-mouse

        touchpad {
            tap
            natural-scroll
        }
    }

    output "eDP-1" {
        focus-at-startup
        position x=0 y=0
    }

    output "HDMI-A-1" {
        position x=1920 y=0
    }

    workspace "1"
    workspace "2"
    workspace "3"
    workspace "4"
    workspace "5"
    workspace "6"
    workspace "7"
    workspace "8"
    workspace "9"

    layout {
        gaps 8
        center-focused-column "on-overflow"
        always-center-single-column

        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }

        focus-ring {
            width 4
            active-color "#a6adc8"
            inactive-color "#6c7086"
        }

        border {
            off
        }
    }

    prefer-no-csd

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    spawn-at-startup "fcitx5"
    spawn-at-startup "dunst"
    spawn-at-startup "udiskie" "--tray"
    spawn-at-startup "lookapp"
    spawn-at-startup "blueman-applet"
    spawn-at-startup "nm-applet"
    spawn-at-startup "${waybar}" "-c" "${waybarConfig}"
    spawn-sh-at-startup "${swaybg} -i ${wallpaperPath} -m fill"

    window-rule {
        match app-id="firefox$" title="^Picture-in-Picture$"
        open-floating true
        default-column-width { fixed 480; }
        default-window-height { fixed 270; }
        default-floating-position x=32 y=32 relative-to="bottom-left"
    }

    window-rule {
        match app-id="firefox$"
        open-on-workspace "2"
        default-column-width { proportion 1.0; }
    }

    window-rule {
        match title="^kew-player$"
        open-on-workspace "9"
    }

    window-rule {
        match title="^Look$"
        open-floating true
        focus-ring { off; }
        shadow { off; }
        clip-to-geometry false
    }

    window-rule {
        geometry-corner-radius 8
        clip-to-geometry true
    }

    window-rule {
        match is-floating=true

        border {
            on
            width 2
            active-color "#89b4fa"
            inactive-color "#6c7086"
        }

        shadow {
            on
            softness 20
            spread 4
            offset x=0 y=5
            color "#00000080"
        }
    }

    binds {
        Mod+Return repeat=false { spawn "ghostty"; }
        Mod+D repeat=false { spawn "fuzzel"; }
        Alt+Space allow-inhibiting=false repeat=false { spawn "${pkgs.glib}/bin/gdbus" "call" "--session" "--dest" "com.look.Desktop" "--object-path" "/com/look/Desktop" "--method" "com.look.Desktop.Toggle"; }

        Mod+Shift+F repeat=false { spawn "firefox"; }
        Mod+Shift+D repeat=false { spawn "zathura"; }
        Mod+Shift+T repeat=false { spawn-sh "bash $HOME/.config/zathura/change-theme.bash"; }
        Mod+Shift+M repeat=false { spawn-sh "ghostty --title=kew-player -e bash -lc 'kew all shuffle'"; }
        Mod+Shift+P repeat=false { spawn "wdisplays"; }

        Mod+Shift+Q repeat=false { close-window; }
        Mod+Shift+Space repeat=false { toggle-window-floating; }
        Mod+V repeat=false { toggle-window-floating; }
        Mod+Shift+V repeat=false { switch-focus-between-floating-and-tiling; }
        Mod+F repeat=false { fullscreen-window; }
        Mod+Shift+E repeat=false { quit; }
        Mod+Alt+L allow-inhibiting=false repeat=false { spawn "swaylock"; }

        Mod+Ctrl+Shift+4 repeat=false { screenshot; }
        Mod+Ctrl+4 repeat=false { screenshot-screen; }
        Mod+Ctrl+Shift+5 repeat=false { screenshot-window; }

        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }

        Mod+Shift+H { move-column-left; }
        Mod+Shift+J { move-window-down; }
        Mod+Shift+K { move-window-up; }
        Mod+Shift+L { move-column-right; }

        Mod+Ctrl+H { set-column-width "-5%"; }
        Mod+Ctrl+L { set-column-width "+5%"; }
        Mod+Ctrl+J { set-window-height "+5%"; }
        Mod+Ctrl+K { set-window-height "-5%"; }

        Mod+1 { focus-workspace "1"; }
        Mod+2 { focus-workspace "2"; }
        Mod+3 { focus-workspace "3"; }
        Mod+4 { focus-workspace "4"; }
        Mod+5 { focus-workspace "5"; }
        Mod+6 { focus-workspace "6"; }
        Mod+7 { focus-workspace "7"; }
        Mod+8 { focus-workspace "8"; }
        Mod+9 { focus-workspace "9"; }

        Mod+Shift+1 { move-window-to-workspace "1"; }
        Mod+Shift+2 { move-window-to-workspace "2"; }
        Mod+Shift+3 { move-window-to-workspace "3"; }
        Mod+Shift+4 { move-window-to-workspace "4"; }
        Mod+Shift+5 { move-window-to-workspace "5"; }
        Mod+Shift+6 { move-window-to-workspace "6"; }
        Mod+Shift+7 { move-window-to-workspace "7"; }
        Mod+Shift+8 { move-window-to-workspace "8"; }
        Mod+Shift+9 { move-window-to-workspace "9"; }

        Mod+F1 repeat=false { spawn-sh "niri msg output eDP-1 on && niri msg output HDMI-A-1 off"; }
        Mod+F2 repeat=false { spawn-sh "niri msg output HDMI-A-1 on && niri msg output eDP-1 off"; }
        Mod+F3 { focus-monitor-left; }
        Mod+F4 { focus-monitor-right; }
        Mod+F5 repeat=false { spawn-sh "niri msg output eDP-1 on && niri msg output HDMI-A-1 on"; }
        Mod+Shift+F1 { move-column-to-monitor-left; }
        Mod+Shift+F2 { move-column-to-monitor-right; }

        Print repeat=false { screenshot; }
        Ctrl+Print repeat=false { screenshot-screen; }
        Alt+Print repeat=false { screenshot-window; }

        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "6%-"; }
        XF86AudioMute allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }

        XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "set" "+5%"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "5%-"; }

        Mod+Shift+B repeat=false { spawn "blueman-manager"; }
        Mod+B repeat=false { spawn "pkill" "-SIGUSR1" "-f" "/waybar( |$)"; }
        Mod+Shift+N repeat=false { spawn "${randomWallpaper}"; }

        Mod+Escape allow-inhibiting=false { toggle-keyboard-shortcuts-inhibit; }
    }
  '';
}
