FROM archlinux

# install base packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm rustup gcc cmake pkg-config openssl base-devel jq git python python-pip

# install rust
RUN rustup install nightly && \
    rustup component add rust-analyzer

# install espup tool
RUN cargo install espup && \
   /root/.cargo/bin/espup install

RUN ln -s /root/.rustup/toolchains/esp/bin/* /usr/local/bin/ && rm /usr/local/bin/cargo
COPY ./cargo-proxy.sh /usr/local/bin/cargo
RUN ln -s /root/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/bin/rust-analyzer /usr/local/bin/rust-analyzer

ENV LIBCLANG_PATH "/root/.rustup/toolchains/esp/xtensa-esp32-elf-clang/esp-16.0.4-20231113/esp-clang/lib"
ENV PATH "/usr/local/bin:/root/.rustup/toolchains/esp/xtensa-esp-elf/esp-13.2.0_20230928/xtensa-esp-elf/bin:$PATH"

ENTRYPOINT [ "/usr/bin/bash" ]
