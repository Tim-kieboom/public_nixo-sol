# Local AI (needs an NVIDIA GPU for ollama-cuda).
{ pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama-cuda;
    # downloads the model (~18 GB) when the service starts
    loadModels = [ "qwen3-coder:30b" ];
  };
}
