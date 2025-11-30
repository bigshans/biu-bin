# Maintainer: Areian

pkgname=biu-bin
pkgver=1.5.3
_pkgver=1.5.3
_electron_exec=electron
pkgrel=1
pkgdesc="Bilibili音乐播放器"
arch=("x86_64")
url="https://github.com/wood3n/biu"
license=("AGPL-3.0")
depends=("$_electron_exec")
source=("Biu-v${pkgver}.AppImage::https://github.com/wood3n/biu/releases/download/v${pkgver}-beta.1/Biu-${_pkgver}-beta.1-linux-x86_64.AppImage"
    "biu.desktop"
    "biu.sh"
)
sha256sums=('86422bbb7f57a9bd98fb495a3a032d1413be1bb1eec9e2085abf4760213e496d'
            'ed65e7755796671c943a006a0b93fd6cbfb79942335ff28680900107e55755d3'
            '11f1f3940979e176b3caea08c3793ba1783ca4f55661ba6ba12aada7722593d0')

build() {
    sed -i 's#__ROOT_DIR__#/usr/lib/biu#g' biu.sh
    sed -i "s#__ELECTRON__#/usr/bin/$_electron_exec#g" biu.sh
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
