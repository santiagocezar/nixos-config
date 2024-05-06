{ ... }:

{
  networking.hostName = "e102";

  # Turn media keys into text cursor movement keys
  services.udev.extraHwdb = ''
    evdev:input:b0011v0001p0001*
     KEYBOARD_KEY_90=home
     KEYBOARD_KEY_a2=pageup
     KEYBOARD_KEY_a4=pagedown
     KEYBOARD_KEY_99=end
  '';
}
