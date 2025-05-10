{
  config,
  lib,
  pkgs,
  inputs,
  fonts,
  host_name,
  user_name,
  ...
}: let
  zsh-vi-mode-custom = pkgs.stdenv.mkDerivation {
    pname = "zsh-vi-mode-custom";
    version = "0.9.0-custom";

    src = ./.zsh/zsh-vi-mode;

    installPhase = ''
      mkdir -p $out/share/zsh/plugins/zsh-vi-mode
      cp -r . $out/share/zsh/plugins/zsh-vi-mode
    '';
  };

  sddm-live = pkgs.stdenv.mkDerivation {
    pname = "sddm-live";
    version = "0.1.0";

    src = ./.sddm/sddm-live;

    installPhase = ''
      mkdir -p $out/share/sddm/themes
      cp -r . $out/share/sddm/themes/sddm-live
    '';

    meta = with lib; {
      description = "test";
      license = licenses.mit;
      platforms = platforms.linux;
    };
  };
in {
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    loader.timeout = 0;
    initrd.kernelModules = ["i915"];
    plymouth = {
      enable = true;
      theme = "hexagon_2";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["hexagon_2"];
        })
      ];
    };

    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  nix.settings.auto-optimise-store = true;
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages."${pkgs.system}".default
    inputs.home-manager.packages."${pkgs.system}".default
    gnome-text-editor
    zenity
    nur.repos.ataraxiasjel.waydroid-script
    poweralertd
    pamixer
    overskride
    git
    fastfetch
    neovim
    wireplumber
    brightnessctl
    pavucontrol
    zsh-powerlevel10k
    man-pages
    man-pages-posix
    python3
    alejandra
    kitty
    tmux
    sddm-live

    zoxide
    eza
    zsh-fzf-tab

    curl
    wget
    killall
    jq
    unzip
    fzf
    ffmpeg
    wl-clipboard

    xdg-user-dirs
    xdg-utils
    glib
    gsettings-qt

    #qt5
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum

    #qt6
    kdePackages.qtmultimedia
    kdePackages.qt6ct
    kdePackages.qtwayland
    kdePackages.qtstyleplugin-kvantum
  ];

  # Waydroid

  security.sudo.extraRules = [
    {
      users = ["andrei_hamor"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
  services = {
    dbus.enable = true;
    gvfs.enable = true;

    xserver = {
      enable = true;
    };

    logind.lidSwitch = "suspend";
    logind.lidSwitchExternalPower = "suspend";
    logind.lidSwitchDocked = "ignore";
    thermald.enable = true;
  };

  services.displayManager = {
    sddm = {
      enable = true;
      package = pkgs.kdePackages.sddm;
      extraPackages = [pkgs.kdePackages.qtmultimedia];
      theme = "sddm-live";
      wayland.enable = true;
    };

    defaultSession = "hyprland";
  };

  powerManagement.enable = true;

  virtualisation.waydroid.enable = true;
  services.tlp = {
    enable = true;

    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      CPU_MIN_PERF_ON_AC = 0;
      CPU_MAX_PERF_ON_AC = 100;
      CPU_MIN_PERF_ON_BAT = 0;
      CPU_MAX_PERF_ON_BAT = 20;

      START_CHARGE_THRESH_BAT1 = 40;
      STOP_CHARGE_THRESH_BAT1 = 80;
    };
  };

  programs.hyprland = {
    enable = true;  
    xwayland.enable = true;
  };

  security.polkit.enable = true;
  programs.dconf.enable = true;

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt
      intel-media-driver
      vaapiIntel
    ];
  };

  systemd.sleep.extraConfig = "HibernateDelaySec=1h";

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ]; 

  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["JetBrainsMono"];})
      inputs.apple-fonts.packages.${system}.sf-pro
      inputs.apple-fonts.packages.${system}.sf-mono
      fonts.ptMono
      fonts.ppNeue
      jetbrains-mono
      font-awesome
    ];

    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = ["JetBrains Mono"];
      };
    };
  };
  networking.hostName = "${host_name}";
  networking.wireless.enable = false; # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  time.timeZone = "UTC";
  time.hardwareClockInLocalTime = false;
  services.timesyncd.enable = true;

  services.upower = {
    enable = true;
    percentageLow = 20;
    percentageCritical = 10;
    percentageAction = 7;
    criticalPowerAction = "PowerOff";
  };

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    runtime = {
      "init.vim".text = ''
               set number relativenumber
        nnoremap o v
        nnoremap O V

        nnoremap K :t.<CR>
        nnoremap I O<Esc>

        inoremap jk <Esc>
        nnoremap j h
        nnoremap k j
        nnoremap i k
        nnoremap u a
        nnoremap a i
        nnoremap J 0
        nnoremap L $

        vnoremap j h
        vnoremap k j
        vnoremap i k
        vnoremap u a
        vnoremap a i
        vnoremap J 0
        vnoremap L $

        vnoremap o <Esc>

      '';
    };
  };

  hardware.xpadneo.enable = true; # For Xbox controllers
  hardware.steam-hardware.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.${user_name} = {
    isNormalUser = true;
    extraGroups = ["wheel"];
    shell = pkgs.zsh;
  };

  users.users.root = {
    shell = pkgs.zsh;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    autosuggestions.highlightStyle = "fg=cyan";
    autosuggestions.strategy = [
      "history"
      "completion"
    ];
    shellAliases = {
      ls = "eza --icons --tree --level=1 --git-ignore -a --group-directories-first";
      c = "clear";
    };
    histSize = 5000;
    histFile = "$HOME/.zsh_history";
  };

  users.defaultUserShell = pkgs.zsh;

  environment.etc."p10k.zsh".source = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
  programs.zsh.interactiveShellInit = ''
                  source /etc/p10k.zsh
                  source ${zsh-vi-mode-custom}/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh
                  source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
                  source ${pkgs.fzf}/share/fzf/key-bindings.zsh
                  source ${pkgs.fzf}/share/fzf/completion.zsh


                  ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
                  ZVM_VI_VISUAL_ESCAPE_BINDKEY=o

                  function zvm_after_init() {

                      zvm_bindkey vicmd 'j' backward-char
                      zvm_bindkey vicmd 'k' down-line-or-history
                      zvm_bindkey vicmd 'i' up-line-or-history
                      zvm_bindkey vicmd 'K' history-beginning-search-forward
                      zvm_bindkey vicmd 'I' history-beginning-search-backward
                      zvm_bindkey vicmd 'l' forward-char
                      zvm_bindkey vicmd 'J' beginning-of-line
                      zvm_bindkey vicmd 'L' end-of-line


                      zvm_bindkey visual 'j' backward-char
                      zvm_bindkey visual 'k' down-line-or-history
                      zvm_bindkey visual 'i' up-line-or-history
                      zvm_bindkey visual 'l' forward-char
                      zvm_bindkey visual 'J' beginning-of-line
                      zvm_bindkey visual 'L' end-of-line

                  }

            eval "$(${pkgs.zoxide}/bin/zoxide init --cmd cd zsh)"

            bindkey '^[[A' history-beginning-search-backward
            bindkey '^[[B' history-beginning-search-forward

            HISTDUP=erase
            setopt appendhistory
            setopt sharehistory
            setopt hist_ignore_all_dups
            setopt hist_save_no_dups
            setopt hist_ignore_dups
            setopt hist_find_no_dups

            zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
            zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
