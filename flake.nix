{  
  description = "Helium browser (prebuilt binary, x86_64-linux)";  
  
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";  
  
  outputs = { self, nixpkgs }:  
    let  
      system = "x86_64-linux";  
      pkgs = import nixpkgs { inherit system; };  
      version = "0.22.1.1"; # keep in sync with package/helium-bin.spec  
    in  
    {  
      packages.${system}.default = pkgs.stdenv.mkDerivation {  
        pname = "helium-bin";  
        inherit version;  
  
        src = pkgs.fetchurl {  
          url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64_linux.tar.xz";  
          # fill in: nix store prefetch-file <url>  (or use pkgs.lib.fakeHash once)  
          hash = "sha256-5BWJi1G/HEHWvX1EAnd2yZvzbZ4O50FsHYvw3lO26gw=";  
        };  
  
        nativeBuildInputs = [ pkgs.autoPatchelfHook pkgs.makeWrapper ];  
  
        buildInputs = with pkgs; [  
          alsa-lib 
	  at-spi2-atk 
	  atk 
	  cairo 
	  cups 
	  dbus 
	  expat 
	  glib 
	  gtk3  
	  libdrm 
	  libgbm 
	  libxkbcommon 
	  mesa 
	  nspr 
	  nss 
	  pango  
          libx11 
	  libxcomposite 
	  libxdamage 
	  libxext  
          libxfixes 
	  libxrandr 
	  libxcb  
          libGL 
	  vulkan-loader 
        ];  
  
        sourceRoot = "helium-${version}-x86_64_linux";  
        installPhase = ''  
          runHook preInstall  
  
          mkdir -p $out/opt/helium $out/bin  
          cp -a . $out/opt/helium/  
  
          sed -Ei "s/(CHROME_VERSION_EXTRA=).*/\1nix/" $out/opt/helium/helium-wrapper  
          ln -s $out/opt/helium/helium-wrapper $out/bin/helium  
  
          install -Dm644 helium.desktop $out/share/applications/helium.desktop  
          install -Dm644 product_logo_256.png $out/share/icons/hicolor/256x256/apps/helium.png  
  
          runHook postInstall  
        '';

	autoPatchelfIgnoreMissingDeps = [  
          "libQt5Core.so.5" "libQt5Gui.so.5" "libQt5Widgets.so.5"  
         "libQt6Core.so.6" "libQt6Gui.so.6" "libQt6Widgets.so.6"  
        ];
  
  
        meta.mainProgram = "helium";  
      };  
  
      apps.${system}.default = {  
        type = "app";  
        program = "${self.packages.${system}.default}/bin/helium";  
      };  
    };  
}

