FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y curl gcc-arm-linux-gnueabihf gcc-aarch64-linux-gnu && \
    rm -rf /var/lib/apt/lists/*

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# - install rust target
# rustup target add armv7-unknown-linux-gnueabihf
# rustup target add aarch64-unknown-linux-gnu
RUN /root/.cargo/bin/rustup target add armv7-unknown-linux-gnueabihf
RUN /root/.cargo/bin/rustup target add aarch64-unknown-linux-gnu

# - install a linker for arm:
# sudo apt install gcc-arm-linux-gnueabihf
# sudo apt install gcc-aarch64-linux-gnu

# TODO
# - configure the linker in <projectroot>/.cargo/config.toml
# [target.armv7-unknown-linux-gnueabihf]
# linker = "arm-linux-gnueabihf-gcc"

# [target.aarch64-unknown-linux-gnu]
# linker = "gcc-aarch64-linux-gnu"

# - enable armhf in package manager
# sudo dpkg --add-architecture armhf
# sudo dpkg --add-architecture arm64
RUN dpkg --add-architecture armhf && dpkg --add-architecture arm64

# - add the deb sources
# sudo touch /etc/apt/sources.list.d/arm-cross-compile-sources.list
# insert this into it, change focal to whatever ubuntu release you're using
# deb [arch=armhf,arm64] http://ports.ubuntu.com/ focal main restricted
# deb [arch=armhf,arm64] http://ports.ubuntu.com/ focal-updates main restricted
# deb [arch=armhf,arm64] http://ports.ubuntu.com/ focal universe
# deb [arch=armhf,arm64] http://ports.ubuntu.com/ focal-updates universe
# deb [arch=armhf,arm64] http://ports.ubuntu.com/ focal multiverse
# deb [arch=armhf,arm64] http://ports.ubuntu.com/ focal-updates multiverse
# deb [arch=armhf,arm64] http://ports.ubuntu.com/ focal-backports main restricted universe multiverse
ADD arm-cross-compile-sources.list /etc/apt/sources.list.d/arm-cross-compile-sources.list

# - edit source.list to make sure apt uses the correct packages
# https://askubuntu.com/questions/430705/how-to-use-apt-get-to-download-multi-arch-library
# sudo nano /etc/apt/sources.list
# add your default arch, in this case probably [arch=amd64] to each of the existing lines
ADD sources.list /etc/apt/sources.list

# - pull the new package info
# sudo apt update
RUN apt-get update

# - install webkitgtk
# sudo apt install libwebkit2gtk-4.0-dev:armhf
# sudo apt install libwebkit2gtk-4.0-dev:arm64
# RUN apt-get install libwebkit2gtk-4.0-dev:armhf libwebkit2gtk-4.0-dev:arm64

# - tell pkgconfig where it can find the libs for that arch
# export PKG_CONFIG_SYSROOT_DIR=/usr/arm-linux-gnueabihf/
# export PKG_CONFIG_SYSROOT_DIR=/usr/aarch64-linux-gnu/

# - build the app
# tauri build --target armv7-unknown-linux-gnueabihf
# tauri build --target aarch64-unknown-linux-gnu