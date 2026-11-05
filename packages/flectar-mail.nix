{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "flectar-mail";
  version = "0.1.0-alpha.7";

  src = fetchurl {
    url = "https://github.com/flectar/mail/releases/download/v${version}/flectar-mail-${version}-linux-x64.AppImage";
    hash = "sha256-mv8NNbwC5nqT06FEJiSh+wdCs4/abRyCxDzMGl7ySQA=";
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm644 ${appimageContents}/usr/share/applications/com.flectar.mail.desktop \
      $out/share/applications/com.flectar.mail.desktop
    substituteInPlace $out/share/applications/com.flectar.mail.desktop \
      --replace-fail 'Exec=flectar-mail' "Exec=$out/bin/flectar-mail"
    cp -r ${appimageContents}/usr/share/icons $out/share/
    cp -r ${appimageContents}/usr/share/metainfo $out/share/
  '';

  meta = {
    description = "Native email client with IMAP, SMTP, and JMAP support";
    homepage = "https://github.com/flectar/mail";
    license = lib.licenses.agpl3Only;
    mainProgram = "flectar-mail";
    platforms = [ "x86_64-linux" ];
  };
}
