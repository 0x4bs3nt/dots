{ config, pkgs, ... }:
{
  networking.hostName = "nixos";
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-l2tp
    ];
  };

  # Create writable /etc/ipsec.d for nm-l2tp secrets
  systemd.tmpfiles.rules = [
    "d /etc/ipsec.d 0755 root root -"
  ];

  # Strongswan config for nm-l2tp
  environment.etc."strongswan.conf".text = ''
    charon {
      load_modular = no
      plugins {
        include ${pkgs.strongswan}/etc/strongswan.d/charon/*.conf
      }
    }
    libstrongswan {
      integrity_test = no
    }
  '';
}
