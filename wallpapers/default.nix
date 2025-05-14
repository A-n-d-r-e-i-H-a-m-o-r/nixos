{ pkgs }:

let
  ptMono = pkgs.stdenv.mkDerivation {
    pname = "pt-mono";
    version = "1.0";
    src = ./PTMono;
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/fonts/truetype
      cp $src/PTMono-Regular.ttf $out/share/fonts/truetype/PTMono-Regular.ttf
    '';
  };

  ppNeue = pkgs.stdenv.mkDerivation {
    pname = "PPNeueMachina";
    version = "1.0";
    src = ./PPNeueMachina;
    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/share/fonts/opentype
      cp $src/PPNeueMachina-Light.otf $out/share/fonts/opentype/
      cp $src/PPNeueMachina-Regular.otf $out/share/fonts/opentype/
      cp $src/PPNeueMachina-Ultrabold.otf $out/share/fonts/opentype/
    '';
  };

in {
  inherit ptMono;
  inherit ppNeue;
}
