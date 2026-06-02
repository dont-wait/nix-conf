{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = "Mod4";
  wallpaperPath = "$HOME/Documents/git/nix-conf/dotfiles/bg/bg1.jpg";
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    checkConfig = false;
    config = {
      modifier = mod;
      bars = [ ];
      gaps = {
        inner = 4;
        outer = 3;
      };
      terminal = "ghostty";

      input = {
        "*" = {
          xkb_layout = "us";
          xkb_options = "caps:escape";
        };
      };

      keybindings = lib.mkOptionDefault {
        # Terminal
        "${mod}+Return" = "exec ghostty";

        # App shortcuts
        "${mod}+Shift+f" = "exec firefox";
        "${mod}+Shift+d" = "exec zathura";
        "${mod}+Shift+t" = "exec bash $HOME/.config/zathura/change-theme.bash";
        "${mod}+Shift+m" =
          "exec bash -c 'ghostty --title=kew-player -e bash -c \"kew all shuffle\" & sleep 0.5 && swaymsg \"[title=kew-player] move to workspace 9\"'";
        "${mod}+d" = "exec rofi -show drun";

        # Window control
        "${mod}+Shift+q" = "kill";
        "${mod}+r" = "reload";
        "${mod}+Shift+r" = "reload";
        "${mod}+Shift+e" = "exec swaymsg exit";
        "${mod}+Shift+p" = "exec wdisplays";

        # Fullscreen & floating
        "${mod}+f" = "fullscreen toggle";
        "${mod}+Shift+space" = "floating toggle";

        # Scratchpad
        "${mod}+minus" =
          "exec swaymsg scratchpad show || bash -c 'swaymsg floating enable && swaymsg resize set 1280px 1080px && swaymsg move position center && swaymsg move scratchpad'";
        "${mod}+Shift+minus" = "move scratchpad";

        # Focus (vim style)
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move window
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        # Resize
        "${mod}+Ctrl+h" = "resize shrink width 10px";
        "${mod}+Ctrl+l" = "resize grow width 10px";
        "${mod}+Ctrl+j" = "resize shrink height 10px";
        "${mod}+Ctrl+k" = "resize grow height 10px";

        # Workspaces
        "${mod}+1" = "workspace 1";
        "${mod}+2" = "workspace 2";
        "${mod}+3" = "workspace 3";
        "${mod}+4" = "workspace 4";
        "${mod}+5" = "workspace 5";

        "${mod}+Shift+1" = "move container to workspace 1";
        "${mod}+Shift+2" = "move container to workspace 2";
        "${mod}+Shift+3" = "move container to workspace 3";
        "${mod}+Shift+4" = "move container to workspace 4";
        "${mod}+Shift+5" = "move container to workspace 5";

        # Multi-monitor
        "${mod}+F1" = "exec swaymsg output eDP-1 enable, output HDMI-A-1 disable";
        "${mod}+F2" = "exec swaymsg output HDMI-A-1 enable, output eDP-1 disable";
        "${mod}+F3" = "focus output eDP-1";
        "${mod}+F4" = "focus output HDMI-A-1";
        "${mod}+F5" = "exec swaymsg output eDP-1 enable, output HDMI-A-1 enable";
        "${mod}+Shift+F1" = "move container to output eDP-1";
        "${mod}+Shift+F2" = "move container to output HDMI-A-1";

        # Screenshot
        "${mod}+Shift+s" = "exec bash -c 'grim -g \"$(slurp)\" - | wl-copy'";

        # Random wallpaper
        "${mod}+Shift+n" =
          "exec bash -c 'swaymsg output \"*\" bg \"$(find $HOME/Documents/git/nix-conf/dotfiles/bg -type f | shuf -n1)\" fill'";

        # Audio
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        # Brightness
        "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%-";

        # Waybar toggle
        "${mod}+b" = "exec pkill -SIGUSR1 waybar";

        # Bluetooth
        "${mod}+Shift+b" = "exec blueman-manager";
      };

      assigns = {
        "2" = [
          { app_id = "firefox"; }
          { class = "firefox"; }
        ];
      };
    };

    extraConfig = ''
      # Window rules
      default_border pixel 1
      workspace 1 output eDP-1
      for_window [app_id="ghostty"] border none
      for_window [class=".*"] border pixel 0
      for_window [title="kew-player"] move to workspace 9
      for_window [title="Look"] floating enable, border none


      # Font
      font pango:JetBrainsMono Nerd Font 16

      # Wallpaper
      output * bg ${wallpaperPath} fill

      # Autostart
      exec udiskie --tray
      exec lookapp
      exec dunst
      exec blueman-applet
      exec nm-applet
      exec fcitx5
      exec swaymsg workspace 1
    '';
  };
}
