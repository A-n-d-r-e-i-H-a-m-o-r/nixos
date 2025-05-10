{
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
          path        = $wallpaper

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
}
