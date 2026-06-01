{ pkgs, ... }:
let
  pname = "openwhispr";
  version = "1.7.2";

  src = pkgs.fetchurl {
    url = "https://github.com/OpenWhispr/openwhispr/releases/download/v${version}/OpenWhispr-${version}-linux-x86_64.AppImage";
    hash = "sha256-EPJTZFtd2bQ026KNcI/FOHfoAMu96HKfJxTPceTc5jw=";
  };

  # Unpacked AppImage, used to lift out the .desktop entry and icons.
  appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };

  openwhispr = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/open-whispr.desktop \
        $out/share/applications/${pname}.desktop

      # Point the launcher at the wrapped binary instead of AppRun.
      substituteInPlace $out/share/applications/${pname}.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox' 'Exec=${pname} --no-sandbox'

      cp -r ${appimageContents}/usr/share/icons $out/share/icons
    '';

    meta = with pkgs.lib; {
      description = "Open source voice-to-text dictation app (whisper.cpp / Parakeet, local + cloud)";
      homepage = "https://openwhispr.com/";
      license = licenses.mit;
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };
in
{
  # kdotool lets OpenWhispr detect the focused window's class on KDE Wayland.
  # Without it, OpenWhispr's only KDE fallback reads the class back from the
  # journal via `--identifier=kwin_wayland_wrapper`, but NixOS logs KWin under
  # `kwin_wayland`, so detection fails. It then can't tell it is pasting into a
  # terminal and sends plain Ctrl+V (which Claude Code reads as image paste)
  # instead of Ctrl+Shift+V. kdotool is tried first, before that broken path.
  home.packages = [
    openwhispr
    pkgs.kdotool
  ];
}
