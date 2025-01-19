{ pkgs, stdenv, lib, ... }:

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
    bear

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
    bear -- make -j
  '';

  installPhase = ''
    make install
      # 将 compile_commands.json 安装到输出目录
  if [ -f compile_commands.json ]; then
    mkdir -p $out/extra
    cp compile_commands.json $out/extra/compile_commands.json
  else
    echo "Error: compile_commands.json not found during installPhase!"
    exit 1
  fi
  '';

  meta = with lib; {
    description = "qemu with quard_star board";
    homepage = "https://github.com/QQxiaoming/quard_star_tutorial";
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
