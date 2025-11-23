# Maintainer: Areian

pkgname=biu-bin
pkgver=1.5.2
_pkgver=1.5.1
_electron_exec=electron
pkgrel=1
pkgdesc="Bilibili音乐播放器"
arch=("x86_64")
url="https://github.com/wood3n/biu"
license=("AGPL-3.0")
depends=("$_electron_exec")
source=("Biu-v${pkgver}.AppImage::https://github.com/wood3n/biu/releases/download/v${pkgver}/Biu-${_pkgver}-linux-x86_64.AppImage"
    "biu.desktop"
    "biu.sh"
)
sha256sums=('0bf8c6aea40557d96fd4c580b46f05ca2ab765fb400409872bfdac6fe51a564d'
            'b51c7fa1a63b36ef4f86a9d492511d971392153e452a249cd57ed5de016c9215'
            '11f1f3940979e176b3caea08c3793ba1783ca4f55661ba6ba12aada7722593d0')

build() {
    sed -i 's#__ROOT_DIR__#/usr/lib/biu#g' biu.sh
    sed -i "s#__ELECTRON__#/usr/bin/$_electron_exec#g" biu.sh
    chmod +x ./Biu-v${pkgver}.AppImage
    ./Biu-v${pkgver}.AppImage --appimage-extract
}

package() {
    install -d "$pkgdir/usr/lib/biu/app"
    install -d "$pkgdir/usr/bin"
    install -d "$pkgdir/usr/share/icons"
    install -d "$pkgdir/usr/share/applications"

    install -m755 biu.sh "$pkgdir/usr/bin/biu"
    install -m644 biu.desktop "$pkgdir/usr/share/applications/biu.desktop"

    cd squashfs-root/resources
    find ../usr/share/icons -type d -exec install -d "$pkgdir/usr/share/icons/{}" \;
    find . -type d -exec install -d "$pkgdir/usr/lib/biu/{}" \;
    find . -type f -exec install -m644 "{}" "$pkgdir/usr/lib/biu/{}" \;
}
