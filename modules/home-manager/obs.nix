{ config, lib, pkgs, ... }:

let
  # Managed recording profile; select Untitled in OBS if using another profile.
  profileDirectory = "${config.xdg.configHome}/obs-studio/basic/profiles/Untitled";
  recordingDirectory = "${config.home.homeDirectory}/Documents/Videos";
  profile = (pkgs.formats.ini { }).generate "obs-basic.ini" {
    General.Name = "Untitled";
    Output.Mode = "Advanced";
    Video = {
      BaseCX = 1920;
      BaseCY = 1080;
      OutputCX = 1920;
      OutputCY = 1080;
      FPSType = 0;
      FPSCommon = 60;
      FPSInt = 60;
      FPSNum = 60;
      FPSDen = 1;
      ColorFormat = "NV12";
      ColorSpace = "709";
      ColorRange = "Partial";
    };
    AdvOut = {
      RecType = "Standard";
      RecEncoder = "obs-va-vah265enc";
      RecFilePath = recordingDirectory;
      RecFormat2 = "hybrid_mp4";
      RecUseRescale = "false";
      RecTracks = 1;
      RecAudioEncoder = "ffmpeg_aac";
      Track1Bitrate = 192;
    };
    Audio = {
      SampleRate = 48000;
      ChannelSetup = "Stereo";
    };
  };
  encoder = (pkgs.formats.json { }).generate "obs-recordEncoder.json" {
    # kbps: approximately 30 MB/minute of video, plus audio/container overhead.
    rate-control = "cbr";
    bitrate = 4000; # increase bitrate = 8000 when demo
    key-int-max = 60;
    b-frames = 0;
    target-usage = 4;
  };
in
{
  programs.obs-studio = {
    enable = true;
    plugins = [ pkgs.obs-studio-plugins.obs-vaapi ];
  };

  # OBS must be able to rewrite its files. Install writable copies, restoring
  # the declared profile on every activation; user.ini and scenes stay intact.
  home.activation.configureObs = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    if ${pkgs.procps}/bin/pgrep -u "$(${pkgs.coreutils}/bin/id -u)" -x obs >/dev/null; then
      echo "Close OBS before switching Home Manager so it cannot overwrite recording settings." >&2
      exit 1
    fi

    obsProfile=${lib.escapeShellArg profileDirectory}
    run ${pkgs.coreutils}/bin/mkdir -p "$obsProfile" ${lib.escapeShellArg recordingDirectory}
    for file in basic.ini recordEncoder.json; do
      if [ -e "$obsProfile/$file" ] && [ ! -e "$obsProfile/$file.before-nix" ]; then
        run ${pkgs.coreutils}/bin/cp -p "$obsProfile/$file" "$obsProfile/$file.before-nix"
      fi
    done
    run ${pkgs.coreutils}/bin/install -m 600 ${profile} "$obsProfile/basic.ini"
    run ${pkgs.coreutils}/bin/install -m 600 ${encoder} "$obsProfile/recordEncoder.json"
  '';
}
