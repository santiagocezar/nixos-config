{
  description = "NixOS Flake";

  # This is the standard format for flake.nix.
  # `inputs` are the dependencies of the flake,
  # and `outputs` function will return all the build results of the flake.
  # Each item in `inputs` will be passed as a parameter to
  # the `outputs` function after being pulled and built.
  inputs = {
    # There are many ways to reference flake inputs.
    # The most widely used is `github:owner/name/reference`,
    # which represents the GitHub repository URL + branch/commit-id/tag.

    # Official NixOS package source, using nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # `outputs` are all the build result of the flake.
  #
  # A flake can have many use cases and different types of outputs.
  #
  # parameters in function `outputs` are defined in `inputs` and
  # can be referenced by their names. However, `self` is an exception,
  # this special parameter points to the `outputs` itself(self-reference)
  #
  # The `@` syntax here is used to alias the attribute set of the
  # inputs's parameter, making it convenient to use inside the function.
  outputs = { self, nixpkgs, home-manager, lanzaboote, ... }@inputs: {
    nixosConfigurations =
      let
        eachHost = hosts: f:
          builtins.listToAttrs (
            builtins.map (
              host: {
                name = host;
                value = nixpkgs.lib.nixosSystem (f host);
              }
            ) hosts
          );
      in
        eachHost ["e102" "e123"] (host: {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            ./hardware/${host}.nix
            ./hosts/${host}.nix
            ./common

            ({ pkgs, lib, ... }: {
              networking.hostName = host;
            })
          ];
        });
  };
}
