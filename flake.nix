{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = { self, nixpkgs, flake-parts } @ inputs: 
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = nixpkgs.lib.platforms.all;
      perSystem = { config, pkgs, ... }: let 
        clang-tools = pkgs.llvmPackages_19.clang-tools;
        libcxxClang = pkgs.llvmPackages_19.libcxxClang.overrideAttrs (oldAttrs: {
          postFixup = ''
            ${oldAttrs.postFixup}
            ln -sf  ${oldAttrs.passthru.libcxx}/lib/libc++.modules.json $out/resource-root/libc++.modules.json
            ln -sf  ${oldAttrs.passthru.libcxx}/share $out
          '';
        });
        main = pkgs.llvmPackages_19.libcxxStdenv.mkDerivation {
          name = "main";
          src = ./.;
          nativeBuildInputs = [
            pkgs.cmake
            pkgs.ninja
            clang-tools
            libcxxClang
          ];
          installPhase = ''
            mkdir -p $out/bin
            cp main $out/bin/main
          '';
        };
      in {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.cmake
            pkgs.ninja
            clang-tools
            libcxxClang
          ];
        };
        apps.default = {
          type = "app";
          program = main;
        };
      };
    };
}
