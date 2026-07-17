{ config, pkgs, ... }:

{
  home.username = "baije";
  home.homeDirectory = "/home/baije";
  home.stateVersion = "26.05"; 

  home.packages = with pkgs; [
    telegram-desktop
    nerd-fonts.jetbrains-mono
    wl-clipboard 
    typst
    python3
    zed-editor

    # Зависимости для сборки и работы плагинов LazyVim
    ripgrep
    fd
    gnumake
    gcc

    # Дополнительные утилиты
    lsd
    fastfetch
  ];

  fonts.fontconfig.enable = true;

  # Явно линкуем файлы LazyVim, чтобы обойти баг директорий в Home Manager
  xdg.configFile."nvim/init.lua".source = ./nvim/init.lua;
  xdg.configFile."nvim/lua/config/lazy.lua".source = ./nvim/lua/config/lazy.lua;
  xdg.configFile."nvim/lua/plugins/init.lua".source = ./nvim/lua/plugins/init.lua;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 18;
    };
    settings = {
      background_opacity = "0.9";
      cursor_shape = "beam";
      cursor_trail = "1";
      confirm_os_window_close = "0";
      shell = "fish";
    };
    extraConfig = ''
      include themes/noctalia.conf
    '';
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set -g fish_greeting ""
    '';
    shellAliases = {
      ls = "lsd";
      l = "ls -l";
      la = "ls -a";
      lla = "ls -la";
      lt = "ls --tree";
      cat = "bat";
    };
  };

  # Включаем модули программ с автоматической интеграцией в Fish
  programs.bat.enable = true;
  programs.btop.enable = true;
  
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.lazygit.enable = true;

  programs.git = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
  };

  programs.home-manager.enable = true;
}
