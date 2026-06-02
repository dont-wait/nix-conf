{
  inputs,
  pkgs,
  ...
}:

{
  systemd.user.services.waybar = {
    Service = {
      StandardOutput = "null";
      StandardError = "null";
    };
  };

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
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "cpu" "memory" "disk" "pulseaudio" "battery" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
          format = "{name}";
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
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
        min-height: 0;
        background: transparent;
      }

      window#waybar {
        background: transparent;
      }

      #workspaces button {
        color: #6c7086;
        background: rgba(30, 30, 46, 0.6);
        border-radius: 8px;
        padding: 0 6px;
        margin: 2px 2px;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: #a6e3a1;
        background: rgba(166, 227, 161, 0.15);
      }

      #workspaces button.visible {
        color: #89b4fa;
        background: rgba(137, 180, 250, 0.1);
      }

      #workspaces button.urgent {
        color: #f38ba8;
        background: rgba(243, 139, 168, 0.15);
      }

      #clock,
      #cpu,
      #memory,
      #disk,
      #pulseaudio,
      #battery {
        color: #cdd6f4;
        padding: 0 10px;
        margin: 2px 2px;
      }

      #cpu {
        color: #89b4fa;
      }

      #memory {
        color: #a6e3a1;
      }

      #disk {
        color: #f9e2af;
      }

      #battery {
        color: #a6e3a1;
      }

      #battery.warning {
        color: #f9e2af;
      }

      #battery.critical {
        color: #f38ba8;
      }

      #pulseaudio {
        color: #cdd6f4;
      }

      #pulseaudio.muted {
        color: #6c7086;
      }
    '';
  };
}
