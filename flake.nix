{
  description = "A Phoenix project";

  inputs.pre-commit-hooks = {
    url = "github:cachix/pre-commit-hooks.nix";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachSystem [
      # TODO: Configure your supported system here.
      "x86_64-linux"
      "aarch64-linux"
      "i686-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ]
    (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };

        # Set the Erlang version
        erlangVersion = "erlangR24";
        # Set the Elixir version
        elixirVersion = "elixir_1_12";
        erlang = pkgs.beam.interpreters.${erlangVersion};
        elixir = pkgs.beam.packages.${erlangVersion}.${elixirVersion};
        elixir_ls = pkgs.beam.packages.${erlangVersion}.elixir_ls;

        inherit (pkgs.lib) optional optionals;

        fileWatchers = with pkgs; (optional stdenv.isLinux inotify-tools
        ++ optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
          CoreFoundation
          CoreServices
        ]));

        hooks = ''
          # this allows mix to work on the local directory
          mkdir -p .nix-mix
          mkdir -p .nix-hex
          export MIX_HOME=$PWD/.nix-mix
          export HEX_HOME=$PWD/.nix-hex
          export PATH=$MIX_HOME/bin:$PATH
          export PATH=$HEX_HOME/bin:$PATH
          export PATH=$PWD/assets/node_modules/.bin:$PATH
          export LANG=en_US.UTF-8
          export ERL_AFLAGS="-kernel shell_history enabled"
        '';
      in rec {
        # TODO: Add your Elixir package
        # packages = flake-utils.lib.flattenTree {
        # } ;

        devShells.default = nixpkgs.legacyPackages.${system}.mkShell {
          buildInputs =
            [
              erlang
              elixir
              elixir_ls
            ]
            ++ (with pkgs; [
              nodejs
            ])
            ++ fileWatchers;

          shellHook = hooks;

          LANG = "C.UTF-8";
          ERL_AFLAGS = "-kernel shell_history enabled";
        };
      }
    );
}
