{
  description = "My blog";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable"; };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      buildInputs = with pkgs; [ hugo just ];
    in rec { devShell.${system} = pkgs.mkShell { inherit buildInputs; }; };
}
