{
  inputs,
  pkgs,
  ...
}:

{
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        margin-top = 8;
        margin-left = 8;
        margin-right = 8;
        spacing = 0;
        modules-left = [ "sway/workspaces" "sway/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "disk" "pulseaudio" "battery" "tray" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{value}";
        };

        "sway/window" = {
          format = "{title}";
        };

        "tray" = {
          spacing = 10;
        };

        "clock" = {
          interval = 1;
          format = "{:%a %d/%m/%Y   %H:%M}";
        };

        "cpu" = {
          interval = 3;
          format = "  {usage}%";
        };

        "memory" = {
          interval = 5;
          format = "  {used}GiB";
        };

        "disk" = {
          interval = 30;
          format = "  {free}";
          path = "/";
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = "  ----";
          format-icons = {
            default = [ "" "" ];
          };
          scroll-step = 5;
          on-click = "pavucontrol";
        };

        "battery" = {
          interval = 5;
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time}";
          format-icons = [ "" "" "" "" "" ];
        };
      };
    };

    style = ''
      /* Kanagawa Wave palette. */
      @define-color fujiWhite #DCD7BA;
      @define-color fujiGray #727169;
      @define-color crystalBlue #7E9CD8;
      @define-color springGreen #98BB6C;
      @define-color carpYellow #E6C384;
      @define-color waveRed #E46876;
      @define-color oniViolet #957FB8;
      @define-color waveAqua #7AA89F;

      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
        min-height: 0;
        background: transparent;
      }

      window#waybar {
        background: transparent;
        color: @fujiWhite;
      }

      tooltip {
        background: rgba(31, 31, 40, 0.95);
        border: 1px solid #54546D;
        border-radius: 8px;
      }

      tooltip label {
        color: @fujiWhite;
      }

      #workspaces button {
        color: @fujiGray;
        background: rgba(31, 31, 40, 0.82);
        border-radius: 8px;
        padding: 0 6px;
        margin: 2px 2px;
      }

      #workspaces button:hover {
        color: @fujiWhite;
        background: rgba(54, 54, 70, 0.9);
        box-shadow: none;
      }

      #workspaces button.visible {
        color: @crystalBlue;
        background: rgba(34, 50, 73, 0.85);
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: @fujiWhite;
        background: rgba(45, 79, 103, 0.9);
      }

      #workspaces button.urgent {
        color: @waveRed;
        background: rgba(67, 36, 43, 0.9);
      }

      #clock,
      #window,
      #cpu,
      #memory,
      #disk,
      #pulseaudio,
      #battery,
      #tray {
        color: @fujiWhite;
        background: rgba(31, 31, 40, 0.82);
        border-radius: 8px;
        padding: 0 10px;
        margin: 2px 2px;
      }

      #cpu {
        color: @crystalBlue;
      }

      #window {
        color: @fujiWhite;
        padding-left: 12px;
      }

      #memory {
        color: @oniViolet;
      }

      #disk {
        color: @carpYellow;
      }

      #battery {
        color: @springGreen;
      }

      #battery.warning {
        color: @carpYellow;
      }

      #battery.critical {
        color: @waveRed;
      }

      #pulseaudio {
        color: @waveAqua;
      }

      #pulseaudio.muted {
        color: @fujiGray;
      }
    '';
  };

  # Niri uses its own IPC modules. Keep this as a complete config instead of
  # mixing niri/* with the Sway modules from mainBar.
  xdg.configFile."waybar/niri.json".text = builtins.toJSON {
    layer = "top";
    position = "top";
    height = 32;
    margin-top = 8;
    margin-left = 8;
    margin-right = 8;
    spacing = 0;
    modules-left = [ "niri/workspaces" "niri/window" ];
    modules-center = [ "clock" ];
    modules-right = [ "cpu" "memory" "disk" "pulseaudio" "battery" "tray" ];

    "niri/workspaces" = {
      all-outputs = true;
      disable-scroll = true;
      format = "{value}";
      sort-by-id = true;
    };

    "niri/window" = {
      format = "{title}";
    };

    "tray" = {
      spacing = 10;
    };

    "clock" = {
      interval = 1;
      format = "{:%a %d/%m/%Y   %H:%M}";
    };

    "cpu" = {
      interval = 3;
      format = "  {usage}%";
    };

    "memory" = {
      interval = 5;
      format = "  {used}GiB";
    };

    "disk" = {
      interval = 30;
      format = "  {free}";
      path = "/";
    };

    "pulseaudio" = {
      format = "{icon} {volume}%";
      format-bluetooth = "{icon} {volume}%";
      format-muted = "  ----";
      format-icons = {
        default = [ "" "" ];
      };
      scroll-step = 5;
      on-click = "pavucontrol";
    };

    "battery" = {
      interval = 5;
      format = "{icon} {capacity}%";
      format-charging = " {capacity}%";
      format-plugged = " {capacity}%";
      format-alt = "{time}";
      format-icons = [ "" "" "" "" "" ];
    };
  };
}
