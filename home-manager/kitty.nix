{
  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = "0.6";
      cursor_trail = "1";
      confirm_os_window_close = 0;
      background_blur = 1;
      mouse_map = "right click ungrabbed paste_from_clipboard";
      window_padding_width = "10";
    };
    keybindings = {
      "ctrl+i" = "scroll_line_up";
      "ctrl+k" = "scroll_line_down";
    };
    font = {
      name = "JetBrains Mono Nerd Font Mono";
      size = 16;
    };
    themeFile = "Catppuccin-Mocha";
  };
}
