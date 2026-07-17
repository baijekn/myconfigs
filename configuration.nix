{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./happ-nixos/happ-module.nix
    ];
  
  services.displayManager.sddm.enable = true; 
  services.displayManager.sddm.wayland.enable = true;
  services.upower.enable = true;
  services.happ.enable = true;
  
  programs.nix-ld.enable = true;
  programs.niri.enable = true;
  
 
  hardware.bluetooth = {
    enable = true;
    # Принудительно включает Bluetooth при старте системы и выходе из сна
    powerOnBoot = true; 
    settings = {
      General = {
        # Включает экспериментальные функции (показ заряда батареи, современные протоколы)
        Experimental = true;
        # Решает проблему с сопряжением большинства современных наушников (Sony, Apple и др.)
        ControllerMode = "dual"; 
      };
    };
  };
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Включаем управление профилями питания (performance, balanced, power-saver)
  services.power-profiles-daemon.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Ограничение на количество конфигураций в меню загрузки (удаляет старые профили системы)
  boot.loader.systemd-boot.configurationLimit = 3;
  
  services.logind = {
    # "suspend" — ноутбук уснет и заблокируется (рекомендуется для батареи)
    # "lock" — ноутбук продолжит работать, но экран заблокируется
    lidSwitch = "suspend"; 
  };
  
  # Автоматический запуск сборщика мусора для очистки диска
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking.hostName = "nixos"; 
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Simferopol";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  services.xserver.xkb = {
    layout = "ru";
    variant = "";
  };

  users.users."baije" = {
    isNormalUser = true;
    description = "baije";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "update" ''
    cd /etc/nixos
    git add configuration.nix
    sudo nixos-rebuild switch --flake .#nixos'')
    neovim 
    wget
    xwayland-satellite
    niri
    noctalia-shell
  ];

  system.stateVersion = "26.05";
}
