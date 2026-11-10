{
  pkgs,
  inputs,
  vars,
  lib,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    # Code
    # language servers
    vscode-langservers-extracted # html/css/json
    typescript-language-server # ts
    lua-language-server # lua
    nil # nix

    # C
    gcc # c compiler/linker

    # rust
    cargo
    rustfmt
    rustc
    rust-analyzer
    lldb # debugger
    cargo-nextest # rust better test extenstion
    pkg-config # how crates find lib

    nixfmt # nix formatter
    lld # linker
    python3 # python

    # version control
    git
    gh # github cli

    # trcode terminal ide
    inputs.terminal_code.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # linker
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib # libstdc++
      zlib
      openssl
      curl
      icu
    ];
  };

  # docker
  virtualisation.docker.enable = true;

  # postgress SQL database
  services.postgresql.enable = true;
}
