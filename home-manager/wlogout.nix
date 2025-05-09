{
    programs.wlogout = {
        enable = true;

        style = ''
                            
        * {
            background-image: none;
            font-size: 12px;
        }


        window {
            background-color: rgba(20,20,20,0.8);
        }

        button {
            color: white;
            background-color: rgba(232,0,230,0.6);
            outline-style: none;
            border: none;
            border-width: 0px;
            background-repeat: no-repeat;
            background-position: center;
            background-size: 10%;
            border-radius: 0px;
            box-shadow: none;
            text-shadow: none;
            animation: gradient_f 20s ease-in infinite;
        }

        button:focus {
            background-color: rgba(123,12,123,0.8);
            background-size: 20%;
        }

        button:hover {
            background-color: rgba(43,52,67,0.6);
            background-size: 25%;
            border-radius: 12px;
            animation: gradient_f 20s ease-in infinite;
            transition: all 0.3s cubic-bezier(.55,0.0,.28,1.682);
        }

        button:hover#lock {
            border-radius: 12px 12px 0px 12px;
            margin : 6px 0px 0px 6px;
        }

        button:hover#logout {
            border-radius: 6px 0px 6px 6px;
            margin : 0px 0px 6px 6px;
        }

        button:hover#shutdown {
            border-radius: 6px 6px 6px 0px;
            margin : 6px 6px 0px 0px;
        }

        button:hover#reboot {
            border-radius: 0px 6px 6px 6px;
            margin : 0px 6px 6px 0px;
        }

        #lock {
            background-image: image(url("/home/andrei_hamor/.flakes/home-manager/.wlogout/icons/lock_white.png"));
            border-radius: 12px 0px 0px 0px;
            margin : 297px 0px 0px 528px;
        }

        #logout {
            background-image: image(url("./.wlogout/icons/logout_white.png"));
            border-radius: 0px 0px 0px 12px;
            margin : 0px 0px 297px 528px;
        }

        #shutdown {
            background-image: image(url("/home/andrei_hamor/.flakes/home-manager/.wlogout/icons/shutdown_white.png"));
            border-radius: 0px 12px 0px 0px;
            margin : 297px 528px 0px 0px;
        }

        #reboot {
            background-image: image(url("/home/andrei_hamor/.flakes/home-manager/.wlogout/icons/reboot_white.png"));
            border-radius: 0px 0px 12px 0px;
            margin : 0px 528px 297px 0px;
        }

        '';

        layout = [

        {
            action = "hyprlock";
            label = "lock";
            text = "Lock";
            keybind = "l";
        }

        {
            action = "hyprctl dispatch exit 0";
            label = "logout";
            text = "Logout";
            keybind = "e";
        }

        {
            action = "poweroff";
            label = "shutdown";
            text = "Shutdown";
            keybind = "s";
        }

        {
            action = "reboot";
            label = "reboot";
            text = "Reboot";
            keybind = "r";
        }


        ];
    };
}
