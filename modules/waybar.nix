/*
nix doesn't have a way to write \uXXXX escapes, but it doesn't error when
it finds a string with that, nope, instead it gets interpreted as "uXXXX".

what the hell.

and the feature probably WON'T get added in the near future because it's
considered to be a breaking change??! aparently already broken code should
continue to be broken for some reason??

and workaround is kinda funny, JSON does have this feature, so we use that:
*/
let
u = codepoint: builtins.fromJSON ''"\u${codepoint}"'';
icon = codepoint: ''<span class="icon">${u codepoint}</span>'';
in

{
  e102.home = [
    {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
      };
      programs.waybar.style = ../resources/waybar-style.css;
      programs.waybar.settings.mainBar = {
        backlight = {
          format = "{percent}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        battery = {
          format = "{capacity}% {icon}";
          format-alt = "{time} {icon}";
          format-charging = "{capacity}% ";
          format-full = "{capacity}% {icon}";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          format-plugged = "{capacity}% ";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        "battery#bat2" = {
          bat = "BAT2";
        };
        clock = {
          format-alt = "{:%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        cpu = {
          format = "{usage}% ${icon"e322"}";
          tooltip = false;
        };
        "custom/media" = {
          escape = true;
          exec = "$HOME/.config/waybar/mediaplayer.py 2> /dev/null";
          format = "{icon} {}";
          format-icons = {
            default = "🎜";
            spotify = "";
          };
          max-length = 40;
          return-type = "json";
        };
        height = 30;
        idle_inhibitor = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
        };
        keyboard-state = {
          capslock = true;
          format = "{name} {icon}";
          format-icons = {
            locked = "";
            unlocked = "";
          };
          numlock = true;
        };
        memory = {
          format = "{}% ";
        };
        modules-center = [ "sway/window" ];
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "sway/scratchpad"
          "custom/media"
        ];
        modules-right = [
          "mpd"
          "idle_inhibitor"
          "pulseaudio"
          "network"
          "power-profiles-daemon"
          "cpu"
          "memory"
          "temperature"
          "backlight"
          "keyboard-state"
          "sway/language"
          "battery"
          "battery#bat2"
          "clock"
          "tray"
        ];
        mpd = {
          consume-icons = {
            on = " ";
          };
          format = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}{artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) ⸨{songPosition}|{queueLength}⸩ {volume}% ";
          format-disconnected = "Disconnected ";
          format-stopped = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}Stopped ";
          interval = 5;
          random-icons = {
            off = "<span color=\"#f53c3c\"></span> ";
            on = " ";
          };
          repeat-icons = {
            on = " ";
          };
          single-icons = {
            on = "1 ";
          };
          state-icons = {
            paused = "";
            playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          unknown-tag = "N/A";
        };
        network = {
          format-alt = "{ifname}: {ipaddr}/{cidr}";
          format-disconnected = "Disconnected ⚠";
          format-ethernet = "{ipaddr}/{cidr} ";
          format-linked = "{ifname} (No IP) ";
          format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format = "{ifname} via {gwaddr} ";
        };
        power-profiles-daemon = {
          format = "{icon}";
          format-icons = {
            balanced = "";
            default = "";
            performance = "";
            power-saver = "";
          };
          tooltip = true;
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
        };
        pulseaudio = {
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-icons = {
            car = "";
            default = [
              ""
              ""
              ""
            ];
            hands-free = "";
            headphone = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "pavucontrol";
        };
        spacing = 4;
        temperature = {
          critical-threshold = 80;
          format = "{temperatureC}°C {icon}";
          format-icons = [
            ""
            ""
            ""
          ];
        };
        tray = {
          spacing = 10;
        };
      };
    }
  ];
}
