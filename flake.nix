{
  description = "gosha.net Jekyll site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Ruby 3.4
            ruby_3_4
            bundler

            # For native extensions
            libxml2
            libxslt
            zlib
            libffi
            pkg-config

            # For autoprefixer-rails (execjs)
            nodejs

            # For native extensions compilation
            gcc
            gnumake
          ];

          shellHook = ''
            export GEM_HOME="$PWD/.gems"
            export PATH="$GEM_HOME/bin:$PATH"
          '';
        };
      });
}
