{
  config,
  lib,
  pkgs,
  ...
}:
{
  # AMD CPU optimizations
  hardware.cpu.amd = {
    updateMicrocode = true;
  };

  # Enable AMD-specific kernel parameters for better performance
  boot.kernelParams = [
    "amd_pstate=active"
  ];

  boot.kernelModules = [ "kvm-amd" ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "schedutil";

  boot.initrd.kernelModules = [ "amdgpu" ];

  programs.corectrl = {
    enable = true;
  };

  # Zenpower3 for Ryzen power monitoring (alternative to k10temp)
  boot.extraModulePackages = with config.boot.kernelPackages; [
    zenpower
  ];
}
