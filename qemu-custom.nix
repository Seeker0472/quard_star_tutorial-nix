{ pkgs, stdenv, lib, fetchFromGitHub, ... }:

stdenv.mkDerivation rec {
  pname = "quard-star-qemu";
  version = "8.0.0-custom";

  src = ./qemu-8.0.0/.;

  nativeBuildInputs = with pkgs; [
    makeWrapper
    removeReferencesTo
    pkg-config
    flex
    bison
    meson
    ninja
    perl

    # Don't change this to python3 and python3.pkgs.*, breaks cross-compilation
    python3Packages.python

    wrapGAppsHook3
    glib

  ];

  buildInputs = with pkgs; [
    glib
    zlib
    libcap_ng
    gtk3
    gettext
    vte
  ];
  configureFlags = [
    "--target-list=riscv64-softmmu"
    "--enable-gtk"
    "--enable-virtfs"
    "--disable-gio"
  ];


  configurePhase = ''
    ./configure --prefix=$out $configureFlags
  '';

  buildPhase = ''
    make -j
  '';

  installPhase = ''
    make install
  '';

  meta = with lib; {
    description = "qemu with quard_star board";
    homepage = "https://github.com/QQxiaoming/quard_star_tutorial";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
