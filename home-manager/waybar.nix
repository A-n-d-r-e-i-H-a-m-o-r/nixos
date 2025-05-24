{
  home.file.".config/waybar/config".text = ''

        {
                "layer": "top",
                "position": "top",
                "reload_style_on_change": true,
                "height": 35,
                "margin-top": 3,
                "margin-left": 5,
                "margin-right": 5,
                "modules-left": ["custom/notification", "custom/power", "clock",  "group/expand_left", "tray"],
                "modules-center": ["hyprland/workspaces"],
                "modules-right": ["mpris","group/expand", "custom/wvkbd","custom/gamemode", "idle_inhibitor", "battery"],

                "mpris": {
                    "format": "PLAYING: {player_icon} {dynamic}",
                    "format-paused": "{status_icon} <i>{dynamic}</i>",
                    "player-icons": {
                        "default": "▶",
                        "spotify": " ",
                    },
                    "status-icons": {
                        "paused": "⏸"
                    },
                   "dynamic-importance-order": ["title", "artist", "position", "length", "album"],
                   "dynamic-len": 30,
                   "ignored-players": ["firefox"],
                   "interval": 1,
                   "on-scroll-up": "volumectl -u up",
                   "on-scroll-down": "volumectl -u down"
                },
                "hyprland/workspaces": {
                    "persistent-workspaces": {
                        "*": [ 1,2,3,4,5 ]
                    }
                },
                "custom/notification": {
                    "tooltip": false,
                    "format": "",
                    "on-click": "swaync-client -t -sw",
                    "escape": true
                },
                "clock": {
                    "format": "{:%a | %b %d, %Y | %I:%M:%S %p}",
                    "format-alt": "{:%I:%M:%S %p}",
                    "interval": 1,
                    "tooltip-format": "<tt>{calendar}</tt>",
                    "calendar": {
                        "format": {
                            "today": "<span color='#950CFB'><b>{}</b></span>"
                        }
                    },
                },
            "custom/gamemode": {
                "on-click": "/home/andrei_hamor/.scripts/performance_toggle.sh",
                "format": "",
                "tooltip": false
            },

                "bluetooth": {
                    "format-on": "󰂯",
                    "format-off": "BT-off",
                    "format-disabled": "󰂲",
                    "format-connected-battery": "{device_battery_percentage}% 󰂯",
                    "format-alt": "{device_alias} 󰂯",
                    "tooltip-format": "{controller_alias}\t{controller_address}\n\n{num_connections} connected",
                    "tooltip-format-connected": "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}",
                    "tooltip-format-enumerate-connected": "{device_alias}\n{device_address}",
                    "tooltip-format-enumerate-connected-battery": "{device_alias}\n{device_address}\n{device_battery_percentage}%",
                    "on-click-right": "blueman-manager",
                },
                "battery": {
                    "interval": 1,
                    "states": {
                        "good": 95,
                        "warning": 30,
                        "critical": 20
                    },
                    "format": "{capacity}% {icon}",
                    "format-charging": "{capacity}% 󰂄",
                    "format-alt": "{time} {icon}",
                    "format-icons": [
                        "󰁻",
                    "󰁼",
                    "󰁾",
                    "󰂀",
                    "󰂂",
                    "󰁹"
                    ],
                },


                "custom/expand": {
                    "format": "",
                    "tooltip": false
                },

                "custom/expand_left": {
                    "format": "",
                    "tooltip": false
                },

                "group/expand_left": {
                    "orientation": "horizontal",
                    "drawer": {
                        "transition-duration":300,
                        "transition-to-right": true,
                        "click-to-reveal": true
                    },
                    "modules": ["custom/expand_left",  "disk", "custom/expand_left"],
                },

                "custom/endpoint":{
                    "format": "|",
                    "tooltip": false
                },

                "group/expand": {
                    "orientation": "horizontal",
                    "drawer": {
                        "transition-duration": 600,
                        "transition-to-left": true,
                        "click-to-reveal": true
                    },
                    "modules": ["custom/expand", "temperature","cpu","memory", "backlight", "wireplumber","custom/endpoint"],
                },
                "custom/colorpicker": {
                    "format": "{}",
                    "return-type": "json",
                    "interval": "once",
                    "exec": "~/.config/waybar/scripts/colorpicker.sh -j",
                    "on-click": "~/.config/waybar/scripts/colorpicker.sh",
                    "signal": 1
                },
    "idle_inhibitor": {
        "format": "{icon}",
        "format-icons": {
            "activated": "",
            "deactivated": ""
        },
        "on-click": "notify-send -t 1500 'Idle Inhibitor' 'Updated'"
    },

    "custom/power": {
        "format": "",
        "on-click": "wlogout -b 2 -c 0 -r 0 -m 0 --protocol layer-shell",
        "tooltip": false
    },

    "custom/wvkbd": {
        "format": "",
        "on-click": "kill -34 $(ps -C wvkbd-mobintl)",
        "tooltip": false
    },
    "upower": {
         "icon-size": 13,
         "hide-if-empty": true,
         "tooltip": true,
         "tooltip-spacing": 20
    },

    "cpu": {
        "format": "󰻠  {usage}%",
        "tooltip": true
    },

    "wireplumber": {
        "format": "  {volume}%",
        "tooltip": false,
        "on-scroll-up": "volumectl -u up",
        "on-scroll-down": "volumectl -u down"
    },

    "backlight": {
        "device": "intel_backlight",
        "format": "{icon}  {percent}%",
        "format-icons": ["", ""],
        "on-scroll-up": "lightctl up",
        "on-scroll-down": "lightctl down",
        "tooltip": false
    },

    "disk": {
        "interval": 30,
        "format": "{specific_used:0.2f} GB used",
        "path": "/home",
        "unit": "GB"
    },

    "memory": {
        "interval": 10,
        "format": "  {}%"
    },

    "temperature": {
        "thermal-zone": 1,
        "critical-threshold": 80,
        "format": " {temperatureC}°C",
        "interval": 5
    },
                "tray": {
                    "icon-size": 14,
                    "spacing": 10
                },
        }


  '';

  programs.waybar = {
    enable = true;

    style = ''

      * {
        font-size: 11px;
        font-family: "JetBrains Mono Nerd Font";
      }

      window#waybar {
        all: unset;
        background: rgba(20, 20, 20, 0.75);
        border-radius: 12px;
      }

      .modules-left,
      .modules-center,
      .modules-right {
        margin: 5px 0 5px 5px;
        background: transparent;
      }

      .modules-right {
        margin: 5px 5px 5px 0;
      }

      tooltip {
        background: rgba(20, 20, 20, 0.8);
        color: #f8f8f2;
      }

      #idle_inhibitor.activated {
        color: #26A65B;
      }

      #clock:hover,
      #custom-notification:hover,
      #custom-power:hover,
      #idle_inhibitor:hover,
      #bluetooth:hover,
      #battery:hover,
      #cpu:hover,
      #memory:hover,
      #temperature:hover {
        transition: all 0.3s ease;
        color: #950CFB;
      }

      #custom-power,
      #custom-wvkbd,
      #custom-gamemode,
      #idle_inhibitor,
      #custom-notification,
      #clock,
      #bluetooth,
      #backlight,
      #disk,
      #battery,
      #cpu,
      #memory,
      #wireplumber,
      #temperature {
        padding: 0 10px;
        color: #f8f8f2;
        transition: all 0.3s ease;
      }


      #workspaces {
        padding: 0 10px;
      }

      #workspaces button {
        all: unset;
        padding: 5px 12px;
        border-radius: 5px;
        color: #A965A9;
        transition: all 0.2s ease;
      }


      #workspaces button.active {
        background: rgba(255,255,255, 0.1);
        color: rgb(255,255,255);
      }

      #workspaces button.empty {
        color: rgb(255,255,255);
      }

      #battery {
        background: transparent;
      }

      #battery.charging {
        color: #26A65B;
      }

      #battery.warning:not(.charging){
        color: #ffbe61;

      }

    #temperature.critical {
        color: #f53c3c;

    }

      #battery.critical:not(.charging) {
        color: #f53c3c;
        animation: blink 0.5s linear infinite alternate;
      }

      #custom-expand_left,
      #custom-expand {
        padding: 0 10px;
        color: rgba(248, 248, 242, 0.2);
        text-shadow: 0 0 2px rgba(0, 0, 0, 0.7);
        transition: all 0.3s ease;
      }

      #custom-expand_left:hover,
      #custom-expand:hover {
        color: rgba(255, 255, 255, 0.2);
        text-shadow: 0 0 2px rgba(255, 255, 255, 0.5);
      }

      #custom-endpoint {
        color: transparent;
        text-shadow: 0 0 1.5px rgba(0, 0, 0, 1);
      }

      #tray {
        padding: 0 10px;
        transition: all 0.3s ease;
      }

    '';
  };
}
