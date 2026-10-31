{
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "dont-wait";
        email = "nguyentansang15042005@gmail.com";
      };

      ui = {
        editor = "nvim";
        default-command = "log";
      };

      aliases = {
        l = ["log" "-r" "all()" "-T" "builtin_log_detailed"];
        s = ["status"];
        d = ["diff"];
      };
    };
  };
}
