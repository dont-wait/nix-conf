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
        module-margin-left = 0;
        module-margin-right = 0;
        modules-left = "i3";
        modules-center = "date";
        modules-right = "cpu memory disk volume battery";
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

      "module/cpu" = {
        type = "internal/cpu";
        interval = 3;
        label = " 󰍛 %percentage%% ";
        label-background = bg;
        label-foreground = "\${colors.foreground}";
      };

      "module/memory" = {
        type = "internal/memory";
        interval = 5;
        label = "󰾆 %used% ";
        label-background = bg;
        label-foreground = "\${colors.foreground}";
      };

      "module/disk" = {
        type = "internal/fs";
        "mount-0" = "/";
        interval = 30;
        format-mounted = "<label-mounted>";
        label-mounted = "󰋊 %free% ";
        label-mounted-background = bg;
        label-mounted-foreground = "\${colors.foreground}";
      };

      "module/volume" = {
        type = "internal/pulseaudio"; # event-driven, realtime
        format-volume = "<label-volume>";
        label-volume = "󰕾 %percentage%% ";
        label-volume-background = bg;
        label-volume-foreground = "\${colors.foreground}";
        label-muted = "󰝟 --- ";
        label-muted-background = bg;
        label-muted-foreground = "\${colors.muted}";
      };

      "module/battery" = {
        type = "internal/battery";
        battery = "BAT0";
        adapter = "AC";
        full-at = 98;
        format-charging = "<animation-charging> <label-charging>";
        format-charging-background = bg;
        format-discharging = "<ramp-capacity> <label-discharging>";
        format-discharging-background = bg;
        format-full = "<label-full>";
        format-full-background = bg;
        label-charging = "%percentage%% ";
        label-discharging = "%percentage%% ";
        label-full = "󰁹 100% ";
        ramp-capacity-0 = "󰁺";
        ramp-capacity-1 = "󰁼";
        ramp-capacity-2 = "󰁾";
        ramp-capacity-3 = "󰂀";
        ramp-capacity-4 = "󰂂";
        ramp-capacity-foreground = "\${colors.yellow}";
        animation-charging-0 = "󰢜";
        animation-charging-1 = "󰂆";
        animation-charging-2 = "󰂈";
        animation-charging-3 = "󰂉";
        animation-charging-foreground = "\${colors.green}";
        animation-charging-framerate = 600;
      };
    };
  };
}
