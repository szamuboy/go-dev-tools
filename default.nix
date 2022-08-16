{ pkgs, lib, config, ... }:
let
  godoctor = pkgs.buildGoModule {
    pname = "godoctor";
    version = "v0.7.0";
    src = pkgs.fetchFromGitHub {
      owner = "godoctor";
      repo = "godoctor";
      rev = "49e5b8f37b8bd9f3c49099e6033ed98bc088c26f";
      sha256 = "sha256-WaO4FZTTbpDqBANe8JD4xQbFXXujXbE5nq2pdZaqqN4=";
    };
    vendorSha256 = null;
    doCheck = false;
  };
  gopkgs = pkgs.buildGoPackage {
    pname = "gopkgs";
    version = "v1.0.0";
    goPackagePath = "github.com/haya14busa/gopkgs";
    src = pkgs.fetchFromGitHub {
      owner = "haya14busa";
      repo = "gopkgs";
      rev = "872b4d7288118d998d3d44007bb6870aab240255";
      sha256 = "sha256-k7RZsjvPJTj5EkHsB3IQIgPMx7RFadabKPvKwLIQG7Y=";
    };
    goDeps = ./gopkgs-deps.nix;
  };
  reftools = pkgs.buildGoModule {
    name = "reftools";
    src = pkgs.fetchFromGitHub {
      owner = "davidrjenni";
      repo = "reftools";
      rev = "40322ffdc2e46fd7920d1f8250051bbd2f3bd34d";
      sha256 = "sha256-fHWtUoVK3G0Kn69O6/D0blM6Q/u4LuLinT6sxF18nFo=";
    };
    vendorSha256 = null;
    doCheck = false;
  };
in {
  options = {
    programs.go-dev-tools = {
      enable = lib.mkOption {
        default = false;
        description = "Whether to enable the go developer tools.";
      };
    };
  };
  config = lib.mkIf config.programs.go-dev-tools.enable {
    home.packages = [
      godoctor
      gopkgs
      pkgs.godef
      pkgs.gomodifytags
      pkgs.gopls
      pkgs.gotests
      pkgs.gotools
      pkgs.impl
      reftools
    ];
  };
}
