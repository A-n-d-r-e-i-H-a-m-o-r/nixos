{
  config,
  lib,
  pkgs,
  inputs,
  system,
  user_name,
  ...
}: let
  home_dir = "/home/${user_name}";
  scripts_dir = "${home_dir}/.scripts";
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
    ./waybar.nix
    ./rofi.nix
    ./neovim.nix
    ./kitty.nix
    ./wlogout.nix
  ];
  home.username = "${user_name}";
  home.homeDirectory = "${home_dir}";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    protontricks
    cartridges
    bottles
    kdePackages.kruler
    unstable.kiwix
    krita
    android-tools
    tela-circle-icon-theme
    colloid-icon-theme
    dracula-theme
    btop
    waybar
    rofi-wayland
    cava
    kittysay
    zathura
    vlc
    swaynotificationcenter
    avizo
    yazi
    ghostty
    gnome-system-monitor
    swww
    wlogout
    hyprshot
    hyprlock
    hypridle
    unstable.hyprsunset
    hyprpolkitagent
    hyprpicker
    unstable.hyprswitch
    hyprshade
    gvfs

    #gtk apps
    nautilus
    loupe
    file-roller
    baobab
    unstable.video-downloader
    mission-center
    upscaler

    stremio

    unstable.pcsx2
    unstable.duckstation
    unstable.mgba
    unstable.ppsspp
    unstable.cemu
    unstable.torzu
    unstable.melonDS
    unstable.azahar
    unstable.dolphin-emu

    unstable.scrcpy

    aseprite
    unstable.ollama
    unstable.obsidian
    vesktop
    unstable.godot

    wofi
    syncthing
    mpv
    libnotify
    playerctl
    wallust

    nwg-clipman
    unstable.nwg-dock-hyprland
    unstable.nwg-drawer
    nwg-displays
    nwg-look

    cliphist
    ags
  ];

  programs.zathura = {
    enable = true;
    extraConfig = ''
      set recolor-lightcolor "rgba(0, 0, 0, 0)"
      set recolor-darkcolor "rgba(255, 255, 255, 0.6)"
      map i recolor
      set recolor true
      set adjust-open "best"
      set guioptions none
      map k feedkeys "<C-Down>"
      map i feedkeys "<C-Up>"vibrancy

    '';
  };
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
    enable = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [
      adblock
      shuffle # shuffle+ (special characters are sanitized out of ext names)
    ];
  };

  wayland.windowManager.hyprland = {
    enable = true;
    plugins = [
      pkgs.hyprlandPlugins.hyprbars
      pkgs.hyprlandPlugins.hyprspace
      pkgs.hyprlandPlugins.hyprexpo
    ];

    settings = {
      exec-once = [
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      ];
      input = {
        touchpad = {
          natural_scroll = true;
        };

        sensitivity = 0.6;
      };
      animations = {
        enabled = true;

        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "fade_curve, 0, 0.55, 0.45, 1"
          "overshot,0.05,0.9,0.1,1.1"

          "wind, 0.05, 0.85, 0.03, 0.97"
          "winIn, 0.07, 0.88, 0.04, 0.99"
          "winOut, 0.20, -0.15, 0, 1"
          "liner, 1, 1, 1, 1"
          "md3_standard, 0.12, 0, 0, 1"
          "md3_decel, 0.05, 0.80, 0.10, 0.97"
          "md3_accel, 0.20, 0, 0.80, 0.08"
          "overshot, 0.05, 0.85, 0.07, 1.04"
          "crazyshot, 0.1, 1.22, 0.68, 0.98"
          "hyprnostretch, 0.05, 0.82, 0.03, 0.94"
          "menu_decel, 0.05, 0.82, 0, 1"
          "menu_accel, 0.20, 0, 0.82, 0.10"
          "easeInOutCirc, 0.75, 0, 0.15, 1"
          "easeOutCirc, 0, 0.48, 0.38, 1"
          "easeOutExpo, 0.10, 0.94, 0.23, 0.98"
          "softAcDecel, 0.20, 0.20, 0.15, 1"
          "md2, 0.30, 0, 0.15, 1"

          "OutBack, 0.28, 1.40, 0.58, 1"
          "easeInOutCirc, 0.78, 0, 0.15, 1"
        ];

        animation = [
          "windowsIn, 1, 3.2, winIn, slide"
          "windowsOut, 1, 2.8, easeOutCirc, slide"
          "windowsMove, 1, 3.0, wind, slide"
          "fade, 1, 1.8, md3_decel"
          "layersIn, 1, 1.8, menu_decel, slide"
          "layersOut, 1, 1.5, menu_accel"
          "fadeLayersIn, 1, 1.6, menu_decel"
          "fadeLayersOut, 1, 1.8, menu_accel"
          "workspaces, 1, 4.0, menu_decel, slide"
          "specialWorkspace, 1, 2.3, md3_decel, slidefadevert 15%"
        ];
      };
      general = {
        gaps_out = 5;
        border_size = 1;
      };

      "$file" = "nautilus";
      "$key" = "tab";
      "$reverse" = "shift";

      bind = [
        "SUPER+SHIFT, S, exec, hyprshot -m region"
        "SUPER+SHIFT, C, exec, hyprpicker -a"
        ", PRINT, exec, hyprshot -m window"
        ", XF86AudioRaiseVolume, exec, volumectl -u up"
        ", XF86AudioLowerVolume, exec, volumectl -u down"
        ", XF86AudioMute, exec, volumectl toggle-mute"

        ", XF86MonBrightnessUp, exec, lightctl up"
        ", XF86MonBrightnessDown, exec, lightctl down"
        "SUPER, F3, exec, lightctl up"
        "SUPER, F2, exec, lightctl down"

        "ALT, Space, exec, rofi -show drun"
        "SUPER, T, exec, kitty"
        "SUPER, C, killactive,"
        "SUPER, E, exec, $file"
        "SUPER, A, exec, swaync-client -t"
        "SUPER, Q, exit,"
        "SUPER, F, fullscreen, 0"
        "SUPER, G, togglefloating"
        "SUPER, N, exec, nwg-dock-hyprland -f -i 22 -x -c 'nwg-drawer -mt 5' -lp 'start'"
        "SUPER, V, exec, nwg-clipman"

        "SUPER SHIFT, T, pin"

        "SUPER SHIFT, J, movewindow, l"
        "SUPER SHIFT, L, movewindow, r"
        "SUPER SHIFT, I, movewindow, u"
        "SUPER SHIFT, K, movewindow, d"

        "SUPER CTRL, j, resizeactive, -80 0"
        "SUPER CTRL, k, resizeactive, 0 80"
        "SUPER CTRL, i, resizeactive, 0 -80"
        "SUPER CTRL, l, resizeactive, 80 0"

        "ALT, j, movefocus, l"
        "ALT, l, movefocus, r"
        "ALT, i, movefocus, u"
        "ALT, k, movefocus, d"

        "SUPER, J, workspace, 1"
        "SUPER, K, workspace, 2"
        "SUPER, L, workspace, 3"
        "SUPER, U, workspace, 4"
        "SUPER, I, workspace, 5"
        "SUPER, O, workspace, 6"

        "SUPER ALT, J, movetoworkspacesilent, 1"
        "SUPER ALT, K, movetoworkspacesilent, 2"
        "SUPER ALT, L, movetoworkspacesilent, 3"
        "SUPER ALT, U, movetoworkspacesilent, 4"
        "SUPER ALT, I, movetoworkspacesilent, 5"
        "SUPER ALT, O, movetoworkspacesilent, 6"

        "SUPER, mouse:274, killactive"
        "SUPER, mouse_up, workspace, +1"
        "SUPER, mouse_down, workspace, -1"

        "SUPER, 1, exec, zen-beta"
        "SUPER, 2, exec, obsidian"

        "SUPER, D, togglespecialworkspace, magic"
        "SUPER, D, movetoworkspace, +0"
        "SUPER, D, togglespecialworkspace, magic"
        "SUPER, D, movetoworkspace, special:magic"
        "SUPER, D, togglespecialworkspace, magic"

        "ALT, SPACE, exec, rofi -show drun"
        "CTRL SHIFT, Escape, exec, [float;size 60% 60%;noanim] missioncenter"
        "alt, $key, exec, hyprswitch gui --max-switch-offset 0 --mod-key alt_l --key $key --close mod-key-release --reverse-key=key=$reverse --sort-recent && hyprswitch dispatch"
        "alt $reverse, $key, exec, hyprswitch gui --max-switch-offset 0 --mod-key alt_l --key $key --close mod-key-release --reverse-key=key=$reverse --sort-recent && hyprswitch dispatch -r"

        "SUPER, $key , hyprexpo:expo, toggle"
      ];

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
      windowrule = [
      ];
      layerrule = [
        "blur, rofi"
        "blur, waybar"
        "blur, nwg-dock"
        "blur, nwg-drawer"
        "blur, swaync-control-center"
        "animation slide right, swaync-control-center"
        "animation slide bottom, nwg-drawer"
        "noanim, hyprswitch"
        "blur, hyprswitch"
        "blur, swaync-notification-window"
        "animation slide right, swaync-notification-window"
        "blur, logout_dialog"
        "blur, avizo"
        "animation slide bottom, avizo"
        "ignorezero, avizo"
        "ignorezero, hyprswitch"
        "ignorezero, nwg-dock"
        "ignorezero, rofi"
        "ignorezero, swaync-control-center"
        "ignorezero, swaync-notification-window"
      ];
      decoration = {
        active_opacity = 1;
        inactive_opacity = 0.7;

        rounding = 10;
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          brightness = 0.9;
          contrast = 1.6;
          noise = 0.0125;
          vibrancy = 0.25;
          ignore_opacity = true;
          new_optimizations = true;
          xray = false;
        };
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };
      env = [
        "XCURSOR_THEME, Bibata-Modern-Ice"
        "XCURSOR_SIZE, 24"
      ];
      xwayland = {
        force_zero_scaling = true;
      };
      monitor = [",preferred,auto,1"];
    };
    extraConfig = ''


        windowrulev2 = workspace 3 silent,class:^(Waydroid)$
        windowrulev2 = float, class:^(PacketTracer)$
        windowrulev2 = idleinhibit focus, class:^(mpv)$
        windowrulev2 = idleinhibit fullscreen, class:^(zen-beta)$
        windowrulev2 = idleinhibit fullscreen, class:^(com.stremio.stremio)$
        windowrulev2 = float,class:^(zen-beta)$,title:^(Picture-in-Picture)$
        windowrulev2 = float,class:^(xdg-desktop-portal-gtk)$
        windowrulev2 = stayfocused,class:^(xdg-desktop-portal-gtk)$
        windowrulev2 = stayfocused,class:^(io.missioncenter.MissionCenter)$
        windowrulev2 = stayfocused,class:^(zenity)$

          windowrulev2 = float, class:^(yad)$
          windowrulev2 = size 30% 30%, class:^(yad)$
          windowrulev2 = center, class:^(yad)$
          windowrulev2 = stayfocused, class:^(yad)$
          windowrulev2 = pin, class:^(yad)$


        exec-once = nwg-dock-hyprland  -f -i 22 -x -c "nwg-drawer -mt 5" -lp 'start'
        exec-once = waybar
        exec-once = swaync
        exec-once = swww-daemon
        exec-once = hypridle
        exec-once = hyprctl setcursor Bibata-Modern-Ice 24
        exec-once = systemctl --user start hyprpolkitagent
        exec-once = avizo-service
        exec-once = hyprswitch init --custom-css ${home_dir}/.config/hyprswitch/style.css --size-factor 5 --show-title false --workspaces-per-row 5
        exec-once = ollama serve
        exec-once = poweralertd
        exec-once = syncthing --no-browser
        exec-once = wl-paste --type text --watch cliphist store
        exec-once = wl-paste --type image --watch cliphist store
        exec-once = [workspace 2 silent] zen-beta
        exec-once = waydroid show-full-ui
        exec-once = [workspace 4 silent] spotify

        gestures {
          workspace_swipe = true
          workspace_swipe_cancel_ratio = 0.15
        }


      plugin {

          hyprbars {
              bar_color = rgba(20,20,20,0.6)
              bar_blur = true
              bar_text_font = JetBrains Mono
              bar_height = 20
              bar_text_size = 8
              bar_text_align = center
              bar_button_padding = 10

              # hyprbars-button = color, size, on-click
              hyprbars-button = rgb(ff4040), 12, , hyprctl dispatch killactive
              hyprbars-button = rgb(eeee11), 12, , hyprctl dispatch fullscreen 1
              hyprbars-button = rgb(28C840), 12, , hyprctl dispatch togglefloating
          }
          hyprexpo {
              columns = 3
              gap_size = 5
              bg_col = rgb(111111)
              workspace_method = center current # [center/first] [workspace] e.g. first 1 or center m+1

            enable_gesture = false
          }


      }

    '';
  };

  services.network-manager-applet.enable = true;

  gtk = {
    enable = true;
    font.name = "SF Mono";
    font.size = 10; # Or whatever size you prefer
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
    iconTheme = {
      name = "Colloid";
      package = pkgs.colloid-icon-theme;
    };

    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };
  };

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        ignore_dbus_inhibit = false;
      };
      listener = [
        {
          timeout = 600;
          on-timeout = "pidof hyprlock || hyprlock";
        }
        {
          timeout = 900;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 1200;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };

  fonts.fontconfig.enable = true;

  programs.git = {
    enable = true;
    userName = "A-n-d-r-e-i-H-a-m-o-r";
    userEmail = "andreihamor.academic@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      credential.helpter = "store";
    };
  };

  home.sessionVariables = {
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    MOZ_ENABLE_WAYLAND = 1;
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # For image files
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/gif" = "org.gnome.Loupe.desktop";
      "image/webp" = "org.gnome.Loupe.desktop";

      # For PDF files
      "application/pdf" = "org.pwmt.zathura.desktop";
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
      "text/html" = "zen-beta.desktop";
      "application/x-extension-htm" = "zen-beta.desktop";
      "application/x-extension-html" = "zen-beta.desktop";
      "application/x-extension-shtml" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "application/x-extension-xhtml" = "zen-beta.desktop";
      "application/x-extension-xht" = "zen-beta.desktop";
      "text/plain" = "org.gnome.TextEditor.desktop";
    };

    associations.added = {
      "x-scheme-handler/http" = "zen-beta.desktop";
      "x-scheme-handler/https" = "zen-beta.desktop";
      "x-scheme-handler/chrome" = "zen-beta.desktop";
      "text/html" = "zen-beta.desktop";
      "application/x-extension-htm" = "zen-beta.desktop";
      "application/x-extension-html" = "zen-beta.desktop";
      "application/x-extension-shtml" = "zen-beta.desktop";
      "application/xhtml+xml" = "zen-beta.desktop";
      "application/x-extension-xhtml" = "zen-beta.desktop";
      "application/x-extension-xht" = "zen-beta.desktop";
    };
  };

  xdg.configFile."avizo/config.ini".text = ''
    [default]
    time = 2.0
    fade-out = 0.2
    y-offset = 0.5
    background = rgba(255, 255, 255, 0.1)
  '';

  xdg.configFile."swaync/config.json".text = ''
    {
      "positionY": "top",
      "positionX": "right",

      "layer": "top",
      "layer-shell": "true",
      "cssPriority": "application",

      "control-center-exclusive-zone": false,
      "control-center-width": 650,
      "fit-to-screen": true,

      "notification-icon-size": 64,
      "notification-body-image-height": 128,
      "notification-body-image-width": 200,

      "timeout": 10,
      "timeout-low": 5,
      "timeout-critical": 0,

      "notification-window-width": 400,
      "keyboard-shortcuts": true,
      "image-visibility": "when-available",
      "transition-time": 200,
      "hide-on-clear": false,
      "hide-on-action": true,
      "script-fail-notify": true,
      "widgets": [
        "title",
        "backlight",
        "mpris",
        "volume",
        "dnd",
        "notifications"
      ],
      "widget-config": {
        "title": {
          "text": "Notifications",
          "clear-all-button": true,
          "button-text": " Clear All "
        },

        "backlight": {
          "label": " 󰃠 ",
          "device": "intel_backlight",
           "min" : 10
        },

        "volume": {
          "label": "",
          "expand-button-label": "",
          "collapse-button-label": "",
          "show-per-app": true,
          "show-per-app-icon": false,
          "show-per-app-label": true
        },
        "dnd": {
          "text": " Do Not Disturb"
        },
        "mpris": {
          "image-size": 85,
          "image-radius": 5
        }
      }
    }

  '';

  xdg.configFile."hyprswitch/style.css".text = ''
        * {
            color: white;
            font-family: "JetBrains Mono";
            font-size: 0px;
        }

    .monitor {
        padding: 25px;
        background: rgba(0,0,0,0.1);
        border-radius: 12px;
        border: 1px solid rgba(125,125,125,0.2);
    }


        .workspace {
            background: rgba(0,0,0,0.8);
        }

        .client-image {
            background: transparent;
        }

        .client {
            background: transparent;
            border: none;
        }

        .client_active {
            border: 1px solid white;
        }

  '';

  xdg.configFile."swaync/style.css".text = ''
    @define-color shadow rgba(0, 0, 0, 0.25);

    @define-color base #3C3836;
    @define-color mantle #282828;
    @define-color crust #1D2021;

    @define-color text #FBF1C7;
    @define-color subtext0 #CBDBB2;
    @define-color subtext1 #D5C4A1;

    @define-color surface0 #3C3836;
    @define-color surface1 #665C54;
    @define-color surface2 #7C6F64;

    @define-color green #98971A;

    * {
        font-family: "SF Mono";
        background-clip: border-box;
    }


    label {
        color: @text;
    }

    .notification {
        border: @green;
        box-shadow: none;
        border-radius: 4px;
        background: inherit;
        font-size: 11px;
    }

    .notification button {
        background: transparent;
        border-radius: 0px;
        border: none;
        margin: 0px;
        padding: 0px;
    }

    .notification button:hover {
        background: @surface0;
    }


    .notification-content {
        min-height: 64px;
        margin: 10px;
        padding: 0px;
        border-radius: 0px;
    }

    .close-button {
        background: @crust;
        color: @surface2;
    }

    .notification-default-action,
    .notification-action {
        background: transparent;
        border: none;
    }


    .notification-default-action {
        border-radius: 4px;
    }

    /* When alternative actions are visible */
    .notification-default-action:not(:only-child) {
        border-bottom-left-radius: 0px;
        border-bottom-right-radius: 0px;
    }

    .notification-action {
        border-radius: 0px;
        padding: 2px;
        color: @text;
        /* color: @theme_text_color; */
    }

    /* add bottom border radius to eliminate clipping */
    .notification-action:first-child {
        border-bottom-left-radius: 4px;
    }

    .notification-action:last-child {
        border-bottom-right-radius: 4px;
    }

    /*** Notification ***/
    /* Notification header */
    .summary {
        color: @text;
        /* color: @theme_text_color; */
        font-size: 16px;
        padding: 0px;
    }

    .time {
        color: @subtext0;
        font-size: 12px;
        text-shadow: none;
        margin: 0px 0px 0px 0px;
        padding: 2px 0px;
    }

    .body {
        font-size: 14px;
        font-weight: 500;
        color: @subtext1;
        text-shadow: none;
        margin: 0px 0px 0px 0px;
    }

    .body-image {
        border-radius: 4px;
        margin: 0 10px 0 0;
    }

    /* The "Notifications" and "Do Not Disturb" text widget */
    .top-action-title {
        color: @text;
        /* color: @theme_text_color; */
        text-shadow: none;
    }

    /* Control center */

    .control-center {
        padding: 10px;
        background: rgba( 0, 0, 0, 0.4 );
        border: 1px solid rgba( 255, 255, 255, 0.18 );
        border-radius: 12px;
    }

    .blank-window {
        background: alpha(black, 0.2);
    }

    /* .right.overlay-indicator { */
    /*   border: solid 5px red; */
    /* } */

    .control-center-list {
        background: transparent;
        min-height: 5px;
        border-top: none;
        border-radius: 0px 0px 4px 4px;
    }

    .control-center-list-placeholder,
    .notification-group-icon,
    .notification-group {
        /* opacity: 1.0; */
        /* opacity: 0; */
        color: alpha(@theme_text_color, 0.50);
    }


    .notification-group {
        /* unset the annoying focus thingie */
        all: unset;
        border: none;
        opacity: 0;
        padding: 0px;
        box-shadow: none;
    }

    .notification-group>box {
        all: unset;
        background: transparent;
        padding: 8px;
        margin: 0px;
        border: none;
        border-radius: 4px;
        box-shadow: none;
    }


    .notification-row {
        outline: none;
        transition: all 1s ease;
        background: rgba(20,20,20,0.6);
        border: 1px solid rgba(255,255,255,0.3);
        margin: 5px 5px 0px 5px;
        border-radius: 12px;
    }

    .notification-row:focus,
    .notification-row:hover {
        box-shadow: none;
    }

    .control-center-list>row,
    .control-center-list>row:focus,
    .control-center-list>row:hover {
        background: transparent;
        border: none;
        margin: 0px;
        padding: 5px 10px 5px 10px;
        box-shadow: none;
    }

    .control-center-list>row:last-child {
        padding: 5px 10px 10px 10px;
    }


    /* Window behind control center and on all other monitors */
    .blank-window {
        background: transparent;
    }

    /*** Widgets ***/

    /* Title widget */
    .widget-title {
        margin: 0px;
        background: transparent;
        border-radius: 4px 4px 0px 0px;
        border-bottom: none;
        padding-bottom: 20px;
    }

    .widget-title>label {
        margin: 18px 10px;
        font-size: 20px;
        font-weight: 500;
    }

    .widget-title>button {
        font-weight: 700;
        padding: 7px 3px;
        margin-right: 10px;
        background: transparent;
        color: @text;
        /* color: @theme_text_color; */
        /* border: none; */
        border-radius: 4px;
    }

    .widget-title>button:hover {
        background: @base;
        /* background: alpha(currentColor, 0.1); */
    }

    /* Label widget */
    .widget-label {
        margin: 0px;
        padding: 0px;
        min-height: 5px;
        background: transparent;
        /* background: @theme_bg_color; */
        border-radius: 0px 0px 4px 4px;
        /* border: 1px solid @surface1; */
        border-top: none;
    }

    .widget-label>label {
        font-size: 0px;
        font-weight: 400;
    }

    /* Menubar */
    .widget-menubar {
        background: transparent;
        /* background: @theme_bg_color; */
        /* border: 1px solid @surface1; */
        border-top: none;
        border-bottom: none;
    }

    .widget-menubar>box>box {
        margin: 5px 10px 5px 10px;
        min-height: 40px;
        border-radius: 4px;
        background: transparent;
    }

    .widget-menubar>box>box>button {
        background: transparent;
        min-width: 85px;
        min-height: 50px;
        margin-right: 13px;
        font-size: 17px;
        padding: 0px;
    }

    .widget-menubar>box>box>button:nth-child(4) {
        margin-right: 0px;
    }

    .widget-menubar button:focus {
        box-shadow: none;
    }

    .widget-menubar button:focus:hover {
        background: @base;
        /* background: alpha(currentColor,0.1); */
        box-shadow: none;
    }

    .widget-menubar>box>revealer>box {
        margin: 5px 10px 5px 10px;
        background: transparent;
        /* background: alpha(currentColor, 0.05); */
        border-radius: 4px;
    }

    .widget-menubar>box>revealer>box>button {
        background: transparent;
        min-height: 50px;
        padding: 0px;
        margin: 5px;
    }

    /* Buttons grid */
    .widget-buttons-grid {
        background-color: transparent;
        border-top: none;
        border-bottom: none;
        font-size: 14px;
        font-weight: 500;
        margin: 0px;
        padding: 5px;
        border-radius: 0px;
    }

    .widget-buttons-grid>flowbox>flowboxchild {
        background: transparent;
        border-radius: 4px;
        min-height: 50px;
        min-width: 85px;
        margin: 5px;
        padding: 0px;
    }

    .widget-buttons-grid>flowbox>flowboxchild>button {
        all: unset;
        background: transparent;
        border-radius: 4px;
        margin: 0px;
        border: none;
        box-shadow: none;
    }


    .widget-buttons-grid>flowbox>flowboxchild>button:hover {
        background: transparent;
        /* background: alpha(currentColor, 0.1); */
    }

    /* Mpris widget */
    .widget-mpris {
        padding: 10px;
        padding-bottom: 35px;
        padding-top: 35px;
        margin-bottom: -33px;
    }

    .widget-mpris>box {
        padding: 0px;
        margin: -5px 0px -10px 0px;
        padding: 0px;
        border-radius: 4px;
        background: transparent;
    }

    .widget-mpris>box>button:nth-child(1),
    .widget-mpris>box>button:nth-child(3) {
        margin-bottom: 0px;
    }

    .widget-mpris>box>button:nth-child(1) {
        margin-left: -25px;
        margin-right: -25px;
        opacity: 0;
    }

    .widget-mpris>box>button:nth-child(3) {
        margin-left: -25px;
        margin-right: -25px;
        opacity: 0;
    }

    .widget-mpris-album-art {
        all: unset;
    }

    /* Player button box */
    .widget-mpris>box>carousel>widget>box>box:nth-child(2) {
        margin: 5px 0px -5px 90px;
    }

    /* Player buttons */
    .widget-mpris>box>carousel>widget>box>box:nth-child(2)>button {
        border-radius: 4px;
    }

    .widget-mpris>box>carousel>widget>box>box:nth-child(2)>button:hover {
        background: alpha(currentColor, 0.1);
    }

    carouselindicatordots {
        opacity: 0;
    }

    .widget-mpris-title {
        color: #eeeeee;
        font-weight: bold;
        font-size: 1.25rem;
        text-shadow: 0px 0px 5px rgba(0, 0, 0, 0.5);
    }

    .widget-mpris-subtitle {
        color: #eeeeee;
        font-size: 1rem;
        text-shadow: 0px 0px 3px rgba(0, 0, 0, 1);
    }

    .widget-mpris-player {
        border-radius: 0px;
        margin: 0px;
    }

    .widget-mpris-player>box>image {
        margin: 0px 0px -48px 0px;
    }

    .notification-group>box.vertical {
        margin-top: 3px
    }

    .widget-backlight,
    .widget-volume {
        background-color: transparent;
        border-top: none;
        border-bottom: none;
        font-size: 13px;
        font-weight: 600;
        border-radius: 0px;
        margin: 0px;
        padding: 0px;
    }

    .widget-volume>box,
    .widget-backlight>box

    {
        background: transparent;
        border-radius: 4px;
        margin: 5px 10px 5px 10px;
        min-height: 50px;
    }

    .widget-volume>box>label {
        min-width: 50px;
        padding: 0px;
    }

    .widget-volume>box>button {
        min-width: 50px;
        box-shadow: none;
        padding: 0px;
    }

    .widget-volume>box>button:hover {
        /* background: alpha(currentColor, 0.05); */
        background: @surface0;
    }

    .widget-volume>revealer>list {
        background: transparent;
        border-radius: 4px;
        margin-top: 5px;
        padding: 0px;
    }

    .widget-volume>revealer>list>row {
        padding-left: 10px;
        min-height: 40px;
        background: transparent;
    }

    .widget-volume>revealer>list>row:hover {
        background: transparent;
        box-shadow: none;
        border-radius: 4px;
    }


    /* DND widget */
    .widget-dnd {
        margin: 8px;
        font-size: 1.1rem;
        padding-top: 20px;
    }

    .widget-dnd>switch {
        font-size: initial;
        border-radius: 12px;
        background: rgba(255,255,255,0.2);
        border: 1px solid white;
        box-shadow: none;
    }

    .widget-dnd>switch:checked {
        background: rgba(255,255,255,0.8);
    }

    .widget-dnd>switch slider {
        background: white;
        border-radius: 12px;
    }

    .toggle:checked {
        background: @surface1;
    }

    /*.toggle:not(:checked) {
        color: rgba(128, 128, 128, 0.5);
    }*/
    .toggle:checked:hover {
        background: @surface2;

    }

    scale {
        padding: 10px;
        margin: 0px 10px 0px 10px;
    }

    scale trough {
        border-radius: 12px;
        background: rgba(255,255,255,0.3);
    }

    scale highlight {
        border-radius: 12px;
        min-height: 10px;
        margin-right: -5px;
        background: rgb(255,255,255);
    }

    scale slider {
        margin: -10px;
        min-width: 10px;
        min-height: 20px;
        background: transparent;
        box-shadow: none;
        padding: 10px;
    }

    scale slider:hover {}

    .right.overlay-indicator {
        all: unset;
    }


  '';

  xdg.configFile."nwg-drawer/drawer.css".text = ''

    window {
        background-color: rgba(20, 22, 25, 0.8);
        color: #eeeeee
    }

    entry {
        background-color: rgba (0, 0, 0, 0.2)
    }

    button, image {
        all: unset;
        background: none;
        border: none;
        border-radius: 12px;
        padding: 6px;
        margin: 0px 4px;
    }

    button:hover {
        background-color: rgba (255, 255, 255, 0.1)

    }

    #category-button {
        margin: 0 10px 0 10px
    }

    #pinned-box {
        padding-bottom: 5px;
        border-bottom: 1px dotted gray
    }

    #files-box {
        padding: 5px;
        border: 1px dotted gray;
        border-radius: 15px
    }

    #math-label {
        font-weight: bold;
        font-size: 16px
    }

  '';
  xdg.configFile."nwg-dock-hyprland/style.css".text = ''


      window {
        background: rgba(20,20,20, 0.75);
      }

      #box {
        padding: 10px
      }

      #active {
      	border-bottom: solid 0px;
      	border-color: rgba(255, 255, 255, 0.3)
      }

      button, image {
      	background: none;
      	border-style: none;
      	box-shadow: none;
      	color: #999
      }

      button {
      	padding: 4px;
      	margin-left: 4px;
      	margin-right: 4px;
      	color: #eee;
        font-size: 12px
      }


      button:focus {
      	box-shadow: none
      }

    button:hover{
        outline: 1px solid rgba(255,255,255, 0.5);
        outline-offset: 1px;
    }


  '';
  home.file = {
    "Pictures/Wallpapers/scenery1.jpg".source = ./assets/scenery1.jpg;

    ".scripts/performance_toggle.sh" = {
      text = ''

        #!/usr/bin/env sh
        HYPRGAMEMODE=$(hyprctl getoption animations:enabled | awk 'NR==1{print $2}')
        if [ "$HYPRGAMEMODE" = 1 ] ; then
            hyprctl --batch "\
                keyword animations:enabled 0;\
                keyword decoration:blur:enabled 0;"

            exit
        fi
        hyprctl reload

      '';
      executable = true;
    };

    ".scripts/startup.sh" = {
      text = ''
        #!/run/current-system/sw/bin/bash

        sleep 1
        portal_list=$(ps -fu ${user_name}|grep xdg-desktop-portal|grep -v grep|sort|awk -F " " '{print $8}')

        for portal in $portal_list; do
          portal_name=$(basename -- "$portal")

          if [ -x "$portal" ]; then
            killall "$portal_name"
            sleep 2
            "$portal" &
            exit 0
          fi
        done
        echo "No valid xdg-portal-desktop found"
        exit
      '';
      executable = true;
    };
  };

  programs.hyprlock = {
    enable = true;
    extraConfig = ''

      $scrPath      = ./.hyprlock/scripts/
      $USER         = Andrei
      $host         = uname -n
      $wallpaper    = ./assets/scenery_wallpaper_1.jpg
      $blur         = 1

      # ADJUST HERE
      $rounding     = 12
      $shape-rd     = -1
      $font-text    = JetBrainsMono Nerd Font Mono
      $font-text0   = JetBrainsMono Nerd Font Mono
      $font-display = PP Neue Machina Ultra-Bold
      $font-symbol  = JetBrainsMono Nerd Font Mono

      # Input Var
      $weight       = 2
      $inner-color  = rgba(0, 0, 0, 0.5)
      $border-color = rgba(255, 255, 255, 0.15)

      # Colors
      $clock-color  = rgba(255, 255, 255, 1)
      $fg0          = rgba(255, 255, 255, 1)
      $fg1          = rgba(0, 0, 0, 1)
      $shape-col0   = rgba(255, 255, 255, 1)
      $shape-col1   = rgba(0, 0, 0, 0.25)
      $shape-col2   = rgba(255, 255, 255, 0.25)
      $shadow-pass  = 2
      $shadow-size  = 3
      $shadow-color = rgb(0,0,0)
      $shadow-boost = 1.2
      $text-shadow-pass   = 1
      $text-shadow-boost  = 0.5



      # GENERAL
      general {
          no_fade_in          = false
          grace               = 1
          disable_loading_bar = false
          hide_cursor         = true
          ignore_empty_input  = true
          text_trim           = true
      }

      #BACKGROUND
      background {
          monitor     =
          path                = $wallpaper
          blur_passes         = $blur
          contrast            = 0.8916
          brightness          = 0.7172
          vibrancy            = 0.1696
          vibrancy_darkness   = 0
      }




      # INPUT FIELD
      input-field {
          monitor     =
          size        = 275, 55
          rounding    = $rounding

          outline_thickness   = $weight
          outer_color         = $border-color
          dots_size           = 0.1 # Scale of input-field height, 0.2 - 0.8
          dots_spacing        = 1 # Scale of dots' absolute size, 0.0 - 1.0
          dots_center         = true

          inner_color         = $inner-color
          font_color          = $fg0
          fade_on_empty       = false

          font_family         = $font-text
          placeholder_text    = <span>󰢏 $USER</span>
          hide_input          = false

          position            = 0, -240
          halign              = center
          valign              = center
          zindex              = 10
      }

      # TIME HR
      label {
          monitor     =
          text        = cmd[update:1000] echo -e "$(date +"%H")" # 24-Hour Format
         #text        = cmd[update:1000] echo -e "$(date +"%I")" # 12-Hour Format
          color       = $clock-color

          shadow_pass         = $shadow-pass
          shadow_size         = $shadow-size
          shadow_color        = $shadow-color
          shadow_boost        = $shadow-boost

          font_size           = 150
          font_family         = $font-display

          position            = 0, -155
          halign              = center
          valign              = top
      }

      # TIME MM
      label {
          monitor     =
          text        = cmd[update:1000] echo -e "$(date +"%M")"
          color       = $clock-color

          shadow_pass         = $shadow-pass
          shadow_size         = $shadow-size
          shadow_color        = $shadow-color
          shadow_boost        = $shadow-boost

          font_size           = 150
          font_family         = $font-display

          position            = 0, -325
          halign              = center
          valign              = top
      }

      # AM/PM for 12-Hour Format
      #label {
          monitor     =
          text = cmd[update:1000] echo -e "$(date +"%p")"
          color       = $clock-color

          shadow_pass         = $shadow-pass
          shadow_size         = $shadow-size
          shadow_color        = $shadow-color
          shadow_boost        = $shadow-boost

          font_size           = 16
          font_family         = $font-display

          position            = 0, 17
          halign              = center
          valign              = center
          zindex		= 5
      }

      # AM/PM BG
      #shape {
          monitor     =
          size        = 70, 40

          shadow_passes       = $text-shadow-pass
          shadow_boost        = $text-shadow-boost

          color               = $shape-col2
          rounding            = $rounding
          border_size         =
          border_color        =

          position            = 0, 20
          halign              = center
          valign              = center
          zindex              = 1
      }

      # GREETING
      label {
          monitor     =
          text        = cmd[update:1000] echo "$(bash $scrPath/greeting.sh)"

          shadow_passes       = $text-shadow-pass
          shadow_boost        = $text-shadow-boost

          color               = $fg0
          font_size           = 11
          font_family         = $font-text

          position            = 0, -55
          halign              = center
          valign              = center
      }

      # TODAY IS
      label {
          monitor     =
          text        = cmd[update:1000] bash -c 'day=$(date +%A); echo "Today is $day"'

          shadow_passes       = $text-shadow-pass
          shadow_boost        = $text-shadow-boost

          color               = $fg0
          font_size           = 11
          font_family         = $font-text

          position            = 0, -75
          halign              = center
          valign              = center
      }

      # DATE
      label {
          monitor     =
          text        = cmd[update:1000] bash -c 'day=$(date +%d); case "$day" in 1) suffix="st";; 2) suffix="nd";; 3) suffix="rd";; *) suffix="th";; esac; echo -e "$(date +"%B %e")'$day'$suffix, $(date +%Y)"'

          shadow_passes       = $text-shadow-pass
          shadow_boost        = $text-shadow-boost

          color               = $fg0
          font_size           = 14
          font_family         = $font-text

          position            = 0, -115
          halign              = center
          valign              = center
      }














    '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/andrei_hamor/etc/profile.d/hm-session-vars.sh
  #
  #  home.sessionVariables = {
  # EDITOR = "emacs";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
