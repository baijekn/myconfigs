{
  description = "My NixOS Flake Configuration";

  inputs = {
    # Берем пакеты из ветки unstable (самые свежие версии)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; 

    # Подключаем Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        
        # Подключаем модуль Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Указываем, что настройки для пользователя baije лежат в home.nix
          home-manager.users.baije = import ./home.nix;
        }
      ];
    };
  };
}
