{ pkgs, ... }:

{
  home.packages = [
    pkgs.ollama
  ];

  services.ollama.enable = true;

  # Home Manager khong co `services.ollama.loadModels`.
  # Neu can preload model, chay: `ollama pull llama3.2:3b` va `ollama pull deepseek-r1:1.5b`.
}
