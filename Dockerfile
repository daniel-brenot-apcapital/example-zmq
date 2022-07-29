FROM rust:buster AS builder

# Enables pkg_config to find libraries needed at build time
ENV PKG_CONFIG_SYSROOT_DIR=/usr/lib/x86_64-linux-gnu
ENV PKG_CONFIG_LIBDIR=/usr/lib/x86_64-linux-gnu/pkgconfig

RUN apt-get update && apt-get install -y openssh-client musl-dev musl-tools gcc cmake libzmq3-dev pkg-config

RUN ln -s "/usr/bin/g++" "/usr/bin/musl-g++"

# Add rust target for architecture
RUN rustup target add x86_64-unknown-linux-musl

WORKDIR /home/user/src
COPY . .

RUN cargo install --target x86_64-unknown-linux-musl --path .

FROM alpine AS deploy

COPY --from=builder /usr/local/cargo/bin/ .
