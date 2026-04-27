{ config, pkgs, ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;
    
    settings = {
      corner-radius = 12;
      round-borders = 1;
      
      rounded-corners-exclude = [
        "window_type = 'desktop'"
        "class_g = 'slop'"
      ];

      # Đặt độ mờ cho Polybar
      opacity-rule = [
        "85:class_g = 'Polybar'"
      ];

      unredir-if-possible = false;
      mark-ovredir-focused = true;
    };
  };
}
