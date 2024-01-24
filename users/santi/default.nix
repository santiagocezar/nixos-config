{ config, pkgs, ... }:
/*
let
  steamFonts = fonts: derivation {
    system = pkgs.system;
    name = "steam-fonts";

    builder = "/bin/sh";
    args = [ (builtins.toFile "steamfonts" ''
      mkdir -p "$out/share/fonts"

    '') ];
  }
in*/

{
  home.username = "santi";
  home.homeDirectory = "/home/santi";

  # Backwards compatibility safety!
  home.stateVersion = "23.11";

  home.packages = with pkgs; [
    firefox
    steam
    steam-run
    neofetch
    nodejs
    nodePackages.pnpm
    python3
    srb2
    srb2kart
    gzdoom
    htop
    clang
    clang-tools
    jq
    godot_4
    qbittorrent
    libreoffice
    vnote
    vscode

    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    dejavu_fonts
  ];

  fonts.fontconfig.enable = true;

  # Add SDL2_gfx to the uh, sandbox? used by `steam-run`
  nixpkgs.config.packageOverrides = pkgs: {
    steam = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        SDL2_gfx

        # used by Sven Co-op
        noto-fonts
        dejavu_fonts
      ];
    };
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      set -gx PNPM_HOME
      if not string match -q -- $PNPM_HOME $PATH
        set -gx PATH "$PNPM_HOME" $PATH
      end
      function yup -d "Commit and update the system"
        cd ~/NixOS/
        git add .
        git commit -m $argv[1]
        sudo nixos-rebuild switch --flake .
      end
    '';
    shellAliases = {
    };
  };
  programs.starship.enable = true;
  programs.zoxide.enable = true;

  services.syncthing.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
    "$PNPM_HOME"
  ];

  home.file = {
    "${config.xdg.configHome}/plasma-workspace/env/hm.sh".text = ''
      source ${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh
    '';
    # ".screenrc".source = dotfiles/screenrc;
  };

  # Manually source 'hm-session-vars.sh' located at
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #  /etc/profiles/per-user/santi/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    EDITOR = "kwrite";
    PNPM_HOME = "/home/santi/.local/share/pnpm";
  };

  programs.home-manager.enable = true;
}
