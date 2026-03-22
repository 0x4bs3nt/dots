{ config, pkgs, ... }:

let
  secrets = import /home/jan/nix/nixos/modules/fortivpn-secrets.nix;

  vpnName = "Nexe";
  gateway = secrets.gateway;
  port = "443";
  username = secrets.username;

  trustedCertHex = secrets.trustedCertHex;
  trustedCertB64 = secrets.trustedCertB64;

  nexe-vpn = pkgs.writeShellScriptBin "nexe-vpn" ''
    set -euo pipefail

    echo "=== ${vpnName} Fortinet SSL VPN (SSO) ==="
    echo "Gateway: ${gateway}:${port}"
    echo ""

    echo "[1/2] Opening SSO login window..."
    export QTWEBENGINE_DISABLE_SANDBOX=1
    export QTWEBENGINE_CHROMIUM_FLAGS="--disable-gpu --disable-software-rasterizer --in-process-gpu"
    export QT_OPENGL=software
    export LIBGL_ALWAYS_SOFTWARE=1
    export FONTCONFIG_FILE=${pkgs.fontconfig.out}/etc/fonts/fonts.conf
    SVPNCOOKIE=$(${pkgs.openfortivpn-webview-qt}/bin/openfortivpn-webview \
      --trusted-cert="${trustedCertB64}" \
      "${gateway}:${port}")

    if [ -z "$SVPNCOOKIE" ]; then
      echo "Error: SSO authentication failed — no cookie received."
      exit 1
    fi

    echo "[2/2] Connecting to ${vpnName} VPN..."
    sudo ${pkgs.openfortivpn}/bin/openfortivpn "${gateway}:${port}" \
      --username="${username}" \
      --trusted-cert="${trustedCertHex}" \
      --cookie="$SVPNCOOKIE" \
      "$@"
  '';
in
{
  environment.systemPackages = with pkgs; [
    openfortivpn
    openfortivpn-webview-qt
    networkmanager-fortisslvpn
    nexe-vpn
  ];

  networking.networkmanager.plugins = with pkgs; [
    networkmanager-fortisslvpn
  ];

  boot.kernelModules = [ "tun" ];

  security.sudo.extraRules = [
    {
      groups = [ "networkmanager" ];
      commands = [
        {
          command = "${pkgs.openfortivpn}/bin/openfortivpn";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.openfortivpn-webview-qt}/bin/openfortivpn-webview";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.pppd.enable = true;
}
