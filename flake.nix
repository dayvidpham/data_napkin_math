{
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs@{ self, nixpkgs-unstable, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

        # Node
        nodePkgs = pkgs-unstable.nodejs_22.pkgs;
        node = pkgs-unstable.nodejs_22;

        # Python
        pythonPkgs = pkgs-unstable.python313Packages;
        python3 = pkgs-unstable.python313;
        uv = pkgs-unstable.uv;
      in
      {
        devShells.default = pkgs-unstable.mkShell {
          packages = [
            node
            pkgs-unstable.ripgrep

            python3
            uv
          ];

          shellHook = ''
            echo "node `node --version`"
            echo "npm `npm --version`"
            export PATH="$(pwd)/node_modules/.bin:$PATH"
          '';

          allowSubstitutes = false;
        };

      });
}
