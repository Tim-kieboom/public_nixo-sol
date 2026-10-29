# Settings every machine gets. Machine-specific things live in hosts/<name>/ and the
# optional modules (nvidia, gaming, dev-services, ai) that a host imports.
{ config, pkgs, self, inputs, vars, ... }:

{
  imports = [
    inputs.sol-shell.nixosModules.greeter
  ];

# --Desktop--
  # -fileManager-
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      # enabled archive
      thunar-archive-plugin
      # enable temp storage (like a usb stick)
      thunar-volman
    ];
  };

  # let Thunar save preferences
  programs.xfconf.enable = true;
  # trash, mounting, network shares
  services.gvfs.enable = true;
  # thumbnails
  services.tumbler.enable = true;

  # -LoginManager-
  # enable sol-shell loginscreen
  sol-shell.greeter.enable = true;
  services.displayManager.gdm.enable = true;

  # dont require to relogin every reboot for stuff like claude-desktop
  # (no login prompt: remove this on a laptop or shared machine)
  services.displayManager.autoLogin = {
    enable = true;
    user = vars.username;
  };

  # -Hyperland-
  services.displayManager.defaultSession = "hyprland";

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
   };
  };

# --Files--
  security.polkit.enable = true;

  # lets file manager mount drives
  services.udisks2.enable = true;

  # folder location for lock screen of sol-shell
  security.pam.services.sol-shell = {};

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];   # provides the FileChooser
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [ "hyprland" "gtk" ];
    };
  };

# --Passwords--
  # -Keyring-
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # enable PAM unlocking for the display manager
  security.pam.services.login.enableGnomeKeyring = true;

# --BlueTooth--
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services.blueman.enable = true;

# --Graphics--
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # required for playing most steam games
  };

  # Makes Electron/Chromium apps run natively in Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

# --Packages--
  services.flatpak.enable = true;

  environment.systemPackages = with pkgs; [
    
    # Code
    vscode-json-languageserver  # json language server
    lua-language-server         # lua language server
    nil                         # nix language server
    nixfmt                      # nix formatter
    lld                         # linker
    python3                     # python

    # version control
    git 
    gh                          # github cli
    
    # ai
    opencode                    # ai agent coder tui
    inputs.llm-agents.packages.${pkgs.system}.claude-desktop # ai app claude desktop 
     
    
    # hardware displayer
    htop                        # task manager
    btop                        # gpu displayer
    
    # other apps 
    wl-clipboard                # clipboard (used in cliphist for copy history)
    wtype                       # keyboard simulator (used for copy history)
    teams-for-linux             # teams
    inputs.terminal_code.packages.${pkgs.stdenv.hostPlatform.system}.default  # trcode terminal ide
    
  ];

  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib   # libstdc++
      zlib
      openssl
      curl
      icu
    ];
  };

  programs.yazi.enable = true;
# --Unordered--

  # max number of configs displayed in systemd-boot menu
  boot.loader.systemd-boot.configurationLimit = 10;

  # optimize nix store
  nix.optimise.automatic = true;

  # delete every week packages that are unused that are older then 30 days
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # terminal editor settings
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    configure = {
      packages.myPlugins = with pkgs.vimPlugins; {
        start = [ nvim-treesitter.withAllGrammars ];
      };
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Set a password once with `passwd` after the first install.
  users.users.${vars.username} = {
    isNormalUser = true;
    # pin down uid so ntfs mounts always work
    uid = vars.uid;
    description = vars.fullName;
    extraGroups = [ "networkmanager" "wheel" ];
    home = "/home/${vars.username}";
  };
}
