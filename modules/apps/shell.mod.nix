{
  _all.home = {
    programs.nushell = {
      enable = true;
      extraConfig = ''
        $env.config = {
          show_banner: false
          keybindings: [
            {
              name: jump_left
              modifier: CONTROL
              keycode: left
              mode: emacs
              event: [
                { edit: movewordleft }
              ]
            }
            {
              name: jump_right
              modifier: CONTROL
              keycode: right
              mode: emacs
              event: [
                { edit: movewordright }
              ]
            }
            {
              name: backspace_word
              modifier: CONTROL
              keycode: backspace
              mode: emacs
              event: [
                { edit: backspaceword }
              ]
            }
            {
              name: delete_word
              modifier: CONTROL
              keycode: delete
              mode: emacs
              event: [
                { edit: deleteword }
              ]
            }
          ]
        }
      '';
      shellAliases = {
        j = "just";
      };
    };
    programs.carapace.enable = true;
    programs.carapace.enableNushellIntegration = true;
    programs.zoxide.enable = true;
    programs.direnv.enable = true;
  };
}
