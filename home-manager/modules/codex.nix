{ pkgs-unstable, ... }:
let
  codex = pkgs-unstable.codex.overrideAttrs (old: rec {
    version = "0.137.0";
    src = pkgs-unstable.fetchFromGitHub {
      owner = "openai";
      repo = "codex";
      tag = "rust-v${version}";
      hash = "sha256-puszZqi1lZeq8iXWAD9U9+WMnNvzMYKf6wVT9mtjSUU=";
    };
    sourceRoot = "${src.name}/codex-rs";
    cargoDeps = pkgs-unstable.rustPlatform.fetchCargoVendor {
      inherit src sourceRoot;
      name = "codex-${version}-vendor";
      hash = "sha256-SX5LMO+IWismbH61Jd0g1mgykfav8DrqG+wjyNCWyCo=";
    };
  });
in
{
  home.packages = [
    codex
  ];
}
