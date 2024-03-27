{
  description = "a jekyll static site flake for my blog, hxegon.github.io.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
    buildInputs = [ pkgs.ruby_3_2 ];
  in rec {
    devShell.${system} = pkgs.mkShell { inherit buildInputs; };
  };
}
