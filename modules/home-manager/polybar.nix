{
  inputs,
  pkgs,
  ...
}:

let
  pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${pkgs.system};
  bg = "#cc1e1e2e";
  tr = "#00000000";
in
{
  services.polybar = {
    enable = true;
    package = pkgs-stable.polybar.override {
      i3Support = true;
      pulseSupport = true;
    };

    script = ''
      killall -q polybar || true
      polybar main 2>&1 | logger -t polybar &
    '';

    config = {
      "colors" = {
        background = tr;
        foreground = "#cdd6f4";
        primary = "#89b4fa";
        yellow = "#f9e2af";
        red = "#f38ba8";
        green = "#a6e3a1";
        muted = "#6c7086";
        module-bg = bg;
      };

      "bar/main" = {
        monitor = "\${env:MONITOR:}";
        width = "100%";
        height = 42;
        offset-y = 8;
        background = tr;
        foreground = "\${colors.foreground}";
        font-0 = "JetBrainsMono Nerd Font Mono:size=10;2";
        padding-left = 1;
        padding-right = 1;
        module-margin-left = 1;
        module-margin-right = 1;
        modules-left = "i3";
        modules-center = "date";
        modules-right = "sysinfo";
        fixed-center = true;
        separator = "";
        tray-position = "none";
        wm-restack = "i3";
        layer = "top";
        enable-ipc = true;
      };

      "module/i3" = {
        type = "internal/i3";
        format = "<label-state>";
        label-focused = " %index% ";
        label-focused-foreground = "\${colors.primary}";
        label-focused-background = bg;
        label-unfocused = " %index% ";
        label-unfocused-foreground = "\${colors.muted}";
        label-unfocused-background = bg;
        label-urgent = " %index% ";
        label-urgent-foreground = "\${colors.red}";
        label-urgent-background = bg;
      };

      "module/date" = {
        type = "internal/date";
        interval = 1;
        date = "%a %d/%m/%Y";
        time = "%H:%M";
        format = "<label>";
        label = "  %date%    %time% ";
        label-background = bg;
        label-foreground = "\${colors.foreground}";
      };

      "module/sysinfo" = {
        type = "custom/script";
        exec = "${pkgs.writeShellScript "sysinfo" ''
          cpu=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d. -f1)
          mem=$(free -h | awk '/^Mem:/ {print $3}')
          disk=$(df -h / | awk 'NR==2 {print $4}')
          vol=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%d%%", $2*100}')
          bat=$(cat /sys/class/power_supply/BAT0/capacity)
          status=$(cat /sys/class/power_supply/BAT0/status)
          bt=$(bluetoothctl show | grep -q "Powered: yes" && echo "on" || echo "off")
          case "$status" in
            "Charging") bat_icon="󰂄" ;;
            "Full"|"Not charging") bat_icon="󰁹" ;;
            *) bat_icon="󰁾" ;;
          esac
          echo " 󰍛 $cpu%  󰾆 $mem  󰋊 $disk  󰕾 $vol  $bat_icon $bat%  󰂱 $bt"
        ''}";
        interval = 5;
        format-background = bg;
        format-foreground = "\${colors.foreground}";
        label = "%output% ";
      };
    };
  };
}
