{
  _all.home = {
    programs.fish = {
      enable = true;
      shellInit = ''
        function fish_user_key_bindings
          bind \e\[3\;5~ kill-word
          bind \b backward-kill-word
          #bind \cC strike_cancel
        end
      '';
      shellAliases = {
        j = "just";
      };
    };
    programs.starship.enable = true;
    programs.zoxide.enable = true;
    programs.direnv.enable = true;
  };
}
