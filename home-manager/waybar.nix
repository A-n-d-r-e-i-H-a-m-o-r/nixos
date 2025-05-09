{
  home.file.".config/waybar/config".text = ''

    {
            "layer": "top",
            "position": "top",
            "reload_style_on_change": true,
            "height": 45,
            "margin-top": 3,
            "margin-left": 5,
            "margin-right": 5,
            "modules-left": ["custom/notification", "custom/power", "clock","tray"],
            "modules-center": ["hyprland/workspaces"],
            "modules-right": ["mpris","group/expand", "battery"],

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
               "interval": 1
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
                "format": " {:%I:%M:%S %p} ",
                "interval": 1,
                "tooltip-format": "<tt>{calendar}</tt>",
                "calendar": {
                    "format": {
                        "today": "<span color='#fAfBfC'><b>{}</b></span>"
                    }
                },
                "actions": {
                    "on-click-right": "shift_down",
                    "on-click": "shift_up"
                }
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
                "modules": ["custom/expand", "temperature","cpu","memory","wireplumber","custom/endpoint"],
            },
            "custom/colorpicker": {
                "format": "{}",
                "return-type": "json",
                "interval": "once",
                "exec": "~/.config/waybar/scripts/colorpicker.sh -j",
                "on-click": "~/.config/waybar/scripts/colorpicker.sh",
                "signal": 1
            },
    "custom/power": {
        "format": "",
        "on-click": "wlogout -b 2 -c 0 -r 0 -m 0 --protocol layer-shell",
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
        font-size: 13px;
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

      #clock:hover,
      #custom-notification:hover,
      #custom-power:hover,
      #bluetooth:hover,
      #battery:hover,
      #cpu:hover,
      #memory:hover,
      #temperature:hover {
        transition: all 0.3s ease;
        color: #950CFB;
      }
        

      /* Module styling */
      #custom-power,
      #custom-notification,
      #clock,
      #bluetooth,
      #battery,
      #cpu,
      #memory,
      #wireplumber,
      #temperature {
        padding: 0 10px;
        color: #f8f8f2;
        transition: all 0.3s ease;
      }

      #temperature,
      #cpu,
      #memory,
      #wireplumber {
        font-size: 12px;
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

      #battery.critical:not(.charging) {
        color: #f53c3c;
        animation: blink 0.5s linear infinite alternate;
      }

      #custom-expand {
        padding: 0 10px;
        color: rgba(248, 248, 242, 0.2);
        text-shadow: 0 0 2px rgba(0, 0, 0, 0.7);
        transition: all 0.3s ease;
      }

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
