<!-- markdownlint-disable MD033 MD041 -->
<div align="center">
  <h2>my dots :3</h2>
</div>

<br />
<!-- markdownlint-enable MD033 MD041 -->

personal NixOS system configuration using flakes and home-manager.

## structure

```text
.
├── flake.nix              # flake configuration
├── nixos/                 # System-level NixOS config
│   └── configuration.nix
└── home-manager/          # user-level config
    ├── home.nix
    ├── fish.nix
    ├── ghostty/
    ├── fonts/
    └── modules/           # custom modules (pkgs)
```

## info

- NixOS 25.11 (stable)
- home-manager for user environment
- nixvim for nvim configuration
- fish
- ghostty

## License

MIT
