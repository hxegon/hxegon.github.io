{
  description = "a jekyll static site flake for my blog, hxegon.github.io.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in rec {
      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = with pkgs; [ ruby_3_2 ];
      };
    };
}
