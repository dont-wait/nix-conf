{ pkgs, ... }:

{
  home.packages = [
    (pkgs.prismlauncher.override {
      # Some mods expect ffmpeg to be available in PATH.
      additionalPrograms = [ pkgs.ffmpeg ];

      jdks = with pkgs; [
        graalvmPackages.graalvm-ce
        zulu8
        zulu17
        zulu
      ];
    })
  ];
}
