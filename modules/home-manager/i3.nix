{
  config,
  lib,
  pkgs,
  ...
}:
let
  mod = "Mod4";
in
{
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;

      # ========================
      # TERMINAL
      # ========================
      terminal = "wezterm";

      # ========================
      # BAR — dùng polybar bên ngoài
      # ========================
      bars = [ ];

      # ========================
      # GAPS
      # ========================
      gaps = {
        inner = 2;
        outer = 1;
      };

      # ========================
      # FONTS
      # ========================
      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size = 16.0;
      };

      # ========================
      # KEYBINDINGS
      # ========================
      keybindings = lib.mkOptionDefault {
        # Terminal
        "${mod}+Return" = "exec wezterm";

        # App shortcuts
        "${mod}+Shift+f" = "exec firefox";
        "${mod}+Shift+d" = "exec zathura";
        "${mod}+Shift+t" = "exec --no-startup-id bash $HOME/.config/zathura/change-theme.bash";

        # App launcher
        "${mod}+d" = "exec rofi -show drun";

        # Window control
        "${mod}+Shift+q" = "kill";
        "${mod}+r" = "reload";
        "${mod}+Shift+r" = "restart";
        "${mod}+Shift+e" = "exec i3-msg exit";
        "${mod}+Shift+p" = "exec arandr";

        # Fullscreen & floating
        "${mod}+f" = "fullscreen";
        "${mod}+Shift+space" = "floating toggle";

        # Scratchpad
        "${mod}+minus" = "scratchpad show";
        "${mod}+Shift+minus" = "move scratchpad";

        # ========================
        # FOCUS (vim style)
        # ========================
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # ========================
        # MOVE WINDOW
        # ========================
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        # ========================
        # RESIZE
        # ========================
        "${mod}+Ctrl+h" = "resize shrink width 10 px";
        "${mod}+Ctrl+l" = "resize grow width 10 px";
        "${mod}+Ctrl+j" = "resize shrink height 10 px";
        "${mod}+Ctrl+k" = "resize grow height 10 px";

        # ========================
        # WORKSPACES
        # ========================
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

        # ========================
        # MULTI-MONITOR
        # ========================
        # Just laptop screen
        "${mod}+F1" = "exec --no-startup-id xrandr --output eDP-1 --auto --primary --output HDMI-1 --off";
        # Just second screen
        "${mod}+F2" =
          "exec --no-startup-id xrandr --output HDMI-1 --mode 1920x1080 --primary --output eDP-1 --off";
        # Focus output
        "${mod}+F3" = "focus output eDP-1";
        "${mod}+F4" = "focus output HDMI-1";
        # Dual screen
        "${mod}+F5" =
          "exec --no-startup-id xrandr --output eDP-1 --auto --output HDMI-1 --mode 1920x1080 --right-of eDP-1";
        # Move container to output
        "${mod}+Shift+F1" = "move container to output eDP-1";
        "${mod}+Shift+F2" = "move container to output HDMI-1";

        # ========================
        # SCREENSHOT
        # ========================
        "${mod}+Shift+S" = "exec --no-startup-id flameshot gui";

        # ========================
        # AUDIO
        # ========================
        "XF86AudioRaiseVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
        "XF86AudioLowerVolume" = "exec wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-";
        "XF86AudioMute" = "exec wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

        # ========================
        # BRIGHTNESS
        # ========================
        "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5%";
        "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%-";

        # ========================
        # POLYBAR & BLUETOOTH
        # ========================
        "${mod}+b" = "exec --no-startup-id polybar-msg cmd toggle";
        "${mod}+Shift+b" = "exec blueman-manager";

        "${mod}+Shift+n" =
          "exec --no-startup-id feh --no-fehbg --randomize --bg-scale ~/nix-conf/dotfiles/bg/";
      };
    };

    extraConfig = ''
      # ========================
      # WINDOW RULES
      # ========================
      for_window [class=".*"] border pixel 1
      for_window [class="firefox"] move to workspace 2

      # ========================
      # COLORS (Catppuccin Mocha)
      # ========================
      client.focused          #a6adc8 #a6adc8 #11111b #a6adc8 #a6adc8
      client.unfocused        #1e1e2e #1e1e2e #6c7086 #1e1e2e #1e1e2e

      # ========================
      # AUTOSTART
      # ========================
      exec --no-startup-id autocutsel -fork
      exec --no-startup-id autocutsel -selection PRIMARY -fork
      exec --no-startup-id udiskie --tray
      exec_always --no-startup-id picom
      exec_always --no-startup-id dunst
      exec_always --no-startup-id blueman-applet
      exec_always --no-startup-id nm-applet
      exec_always --no-startup-id ~/.config/polybar/launch.sh
      exec_always --no-startup-id ${pkgs.feh}/bin/feh --bg-fill ~/dotfiles/bg/itachi2.png
    '';
  };
}
