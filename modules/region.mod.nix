{
  _all.nixos = {
    time.timeZone = "America/Argentina/Cordoba";

    i18n.defaultLocale = "es_AR.UTF-8";
    # i18n.extraLocales = ["es_AR.UTF-8"];
    # i18n.extraLocaleSettings = {
    #   LC_ADDRESS = "es_AR.UTF-8";
    #   LC_IDENTIFICATION = "es_AR.UTF-8";
    #   LC_MEASUREMENT = "es_AR.UTF-8";
    #   LC_MONETARY = "es_AR.UTF-8";
    #   LC_NAME = "es_AR.UTF-8";
    #   LC_NUMERIC = "es_AR.UTF-8";
    #   LC_PAPER = "es_AR.UTF-8";
    #   LC_TELEPHONE = "es_AR.UTF-8";
    #   LC_TIME = "es_AR.UTF-8";
    # };
    # Configure console keymap
    console.keyMap = "la-latin1";
  };
}
