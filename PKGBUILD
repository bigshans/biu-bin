# Maintainer: Areian

pkgname=biu-bin
pkgver=1.6.0
_pkgver=1.6.0
_electron_exec=electron
pkgrel=5
pkgdesc="Bilibili音乐播放器"
arch=("x86_64")
url="https://github.com/wood3n/biu"
license=("AGPL-3.0")
depends=("$_electron_exec" bubblewrap)
source=("Biu-v${pkgver}.AppImage::https://github.com/wood3n/biu/releases/download/v${pkgver}-beta.${pkgrel}/Biu-${_pkgver}-beta.${pkgrel}-linux-x86_64.AppImage"
    "biu.desktop"
    "biu.sh"
)

sha256sums=('9c933bf7a49406bc2c81cce46a3e89cb1d32e19c46775d2efbf983f047bcb32f'
            'ed65e7755796671c943a006a0b93fd6cbfb79942335ff28680900107e55755d3'
            'c19467e3f6f4c44cd81f806f5c2f83408f32f03a78bd956eb4c9b32ebda3d9a1')

build() {
    sed -i 's#__ROOT_DIR__#/usr/lib/biu#g' biu.sh
    sed -i "s#__ELECTRON__#$_electron_exec#g" biu.sh
    chmod +x ./Biu-v${pkgver}.AppImage
    ./Biu-v${pkgver}.AppImage --appimage-extract
}

package() {
    install -d "$pkgdir/usr/bin"
    install -d "$pkgdir/usr/share/icons/hicolor/512x512/apps"
    install -d "$pkgdir/usr/share/applications"

    install -m755 biu.sh "$pkgdir/usr/bin/biu"
    install -m644 biu.desktop "$pkgdir/usr/share/applications/biu.desktop"

    cd squashfs-root/resources
    find . -type d -exec install -d "$pkgdir/usr/lib/biu/{}" \;
    find . -type f -exec install -m644 "{}" "$pkgdir/usr/lib/biu/{}" \;

    install -m644 $srcdir/squashfs-root/usr/share/icons/hicolor/512x512/apps/Biu.png "$pkgdir/usr/share/icons/hicolor/512x512/apps/Biu.png"
}
