nixos:
    nh os switch -f . "nixos.$HOSTNAME"
home:
    nh home switch -f . "home.$HOSTNAME"
