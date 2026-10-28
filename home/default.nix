{ pkgs, inputs, vars, hostName, ... }:
let 
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    inputs.sol-shell.nixosModules.default
    inputs.zen-browser.homeModules.default
    inputs.spicetify-nix.homeManagerModules.default
  ];

  # Do NOT change this value 
  # unless you have manually inspected 
  # all the changes it would make to your configuration,
  # and migrated your data accordingly.
  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    # password manager
    keepassxc                  
    # zip decompresser
    unzip
    # image viewer
    imv
    # png->jpg converter
    imagemagick
    # note/documentation
    obsidian
    # clipboard history
    pkgs.cliphist
    # media player
    playerctl
    # mp4 watcher
    vlc
    # document writer
    libreoffice
    # free fusion
    inputs.solidcraft.packages.${pkgs.system}.solidcraft

    # --Games--
    # minecraft
    (prismlauncher.override {
      jdks = [ jdk25 ];
    })

    # --Programming--
    zed-editor              # ide
    
    # C
    gcc                     # c compiler/linker

    # rust
    lldb                    # debugger
    rustup                  # rust tools
    cargo-nextest           # rust better test extenstion
    pkg-config              # how crates find lib

    # --Hyperland--
    hyprsunset              # Night light
    hyprpicker              # colorPicker
    hyprshot                # for making screenshots
    wofi                    # app launcher
    pavucontrol             # audio of status bar
  ];

  # screen recorder
  programs.obs-studio.enable = true;

  # spotify custom theme's
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.text;
    colorScheme = "Spotify"; 
  };

  # clipboard history
  services.cliphist = {
    enable = true;
    systemdTargets = ["config.wayland.systemd.target"];
    extraOptions = [
      "-max-dedupe-search" "10"
      "-max-items" "500"
    ];
    allowImages = true;
  };

  # statusbar
  sol-shell.enable = true;
  sol-shell.themedApps.enable = true;

  # fireox extra browser
  programs.firefox.enable = true;

  # browser
  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  # cursor
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  # Hyprland
  # make hyprland.lua from source
  xdg.configFile."hypr/hyprland.lua".source = ./hypr/hyprland.lua;
  # monitor layout is per machine (hosts/<name>/monitors.lua)
  xdg.configFile."hypr/monitors.lua".source = ../hosts/${hostName}/monitors.lua;
  services.hyprpolkitagent.enable = true;
  wayland.windowManager.hyprland = {
    enable = true;
    # package is already defined in configurations.nix
    package = null;
    portalPackage = null;
    systemd.enable = false;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.xfce.Thunar.desktop";
      "text/html" = "zen-beta.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/about" = "zen-beta.desktop";
      "x-scheme-handler/unknown" = "zen-beta.desktop";
    };
  };

  # terminal
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.8";
      background_blur = 2;
      dynamic_background_opacity = "yes";
      text_composition_strategy = "platform";
      background = "#120e18";
      foreground = "#e8ebf7";
      cursor = "#d1c88f";
      font_family = "Noto Sans";
    };
  };   

  # fastfetch
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "file";
        source = ./fastfetchLogo.txt;
        color = { "1" = "38;2;255;209;102"; }; # gold
        padding.right = 2;
      };
      display = {
        separator = "  ";
        color = {
          keys = "#b86bff";
          title = "#37e6e6";
        };
      };
      modules = [
        "os"
        "kernel"
        "packages"
        "de"
        "wm"
        "cpu"
        "gpu"
        "memory"
      ];
    };
  };

  # git
  programs.git = {
    enable = true;
    settings = {
      user.name = vars.fullName;
      user.email = vars.gitEmail;
    };
  };

  # enable github cli
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  # enable home-manager
  programs.home-manager.enable = true;
}
