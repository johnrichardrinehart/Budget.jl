let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  buildInputs = [
    pkgs.julia-stable-bin
    pkgs.conda # pyplot
    pkgs.python3
    pkgs.gnuplot
    # gr()
    pkgs.qt5.full
    pkgs.qtcreator
    pkgs.xorg.libXt
    pkgs.xorg.libXrender
    pkgs.xorg.libXext
    pkgs.mesa
    pkgs.libGL
  ];
}
