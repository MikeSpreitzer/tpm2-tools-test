FROM fedora:32
RUN dnf makecache
RUN dnf -y install automake libtool autoconf autoconf-archive libstdc++-devel gcc pkg-config uriparser-devel libgcrypt-devel dbus-devel glib2-devel libcurl-devel
RUN dnf -y install openssl-devel python3-pyyaml pandoc which doxygen gcc-c++ json-c-devel
RUN dnf -y install git
# RUN dnf -y install 'dnf-command(builddep)'

RUN cd; \
    git clone https://github.com/tpm2-software/tpm2-tss; \
    cd tpm2-tss; \
    # dnf -y builddep tpm2-tss; \
    ./bootstrap; \
    ./configure --prefix=/usr/local; \
    # ./configure --prefix=/usr; \
    make -j$(nproc); \
    make install

RUN cd; \
    git clone https://github.com/tpm2-software/tpm2-abrmd; \
    cd tpm2-abrmd; \
    ./bootstrap; \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$(pkg-config --variable pc_path pkg-config) ./configure --with-dbuspolicydir=/etc/dbus-1/system.d --with-udevrulesdir=/usr/lib/udev/rules.d --with-systemdsystemunitdir=/usr/lib/systemd/system --libdir=/usr/lib64 --disable-defaultflags --prefix=/usr/local; \
    # ./configure --with-dbuspolicydir=/etc/dbus-1/system.d --with-udevrulesdir=/usr/lib/udev/rules.d --with-systemdsystemunitdir=/usr/lib/systemd/system --libdir=/usr/lib64 --disable-defaultflags --prefix=/usr; \
    make -j$(nproc); \
    make install

RUN cd; \
    echo clone tpm2-tools; \
    git clone https://github.com/tpm2-software/tpm2-tools; \
    cd tpm2-tools; \
    ./bootstrap; \
    PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$(pkg-config --variable pc_path pkg-config) ./configure --prefix=/usr/local; \
    # ./configure --prefix=/usr; \
    echo next ls -l /usr/include/efivar; \
    ls -l /usr/include/efivar ; \
    echo next ls -l /usr/local/include/efivar; \
    ls -l /usr/local/include/efivar ; \
    echo next make; \
    make -j$(nproc); \
    make install

