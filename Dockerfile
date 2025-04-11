# --------- STAGE UNIQUE: Alpine Rust Dev ---------
FROM rust:1.86.0-alpine

ENV RUST_VERSION=1.86.0-alpine
ENV PATH="/home/rust-tools/.cargo/bin:/home/rust-tools/.rustup/bin:$PATH"

# Créer l'utilisateur rust-tools avec l'UID 0 (donc root)
RUN adduser -D -s /bin/sh -u 0 rust-tools

# Dépendances pour compiler Dioxus, Diesel, WASM
RUN apk update && apk add --no-cache \
    bash \
    curl \
    git \
    clang \
    cmake \
    sqlite-dev \
    postgresql-dev \
    openssl-dev \
    libffi-dev \
    build-base \
    unzip \
    xz \
    tree \
    jq

# Installer les cibles et composants rust nécessaires
RUN rustup component add \
    rustfmt \
    clippy \
    rust-analyzer \
    llvm-tools-preview \
    rust-docs \
    rust-docs-json \
    rustc-dev && \
    rustup target add \
    x86_64-unknown-linux-musl \
    x86_64-unknown-linux-gnu \
    wasm32-unknown-unknown \
    wasm32-wasip1 \
    x86_64-pc-windows-msvc

# Installer les outils Rust
RUN cargo install diesel_cli --no-default-features --features postgres --locked --jobs 4 && \
    cargo install wasm-bindgen-cli --locked --jobs 4 && \
    cargo install dioxus-cli --locked --jobs 4

# Copier un entrypoint si besoin
COPY ./entrypoint.sh /home/rust-tools/entrypoint.sh
RUN chmod +x /home/rust-tools/entrypoint.sh && chown -R rust-tools:rust-tools /home/rust-tools

USER rust-tools
WORKDIR /home/rust-tools

ENTRYPOINT ["./entrypoint.sh"]




# # --------- STAGE 1: Builder ---------
# FROM rust:1.86-slim AS builder

# # Après installation des paquets
# # Installer les dépendances d’abord, y compris sudo
# RUN apk update && \
#     apk install -y curl git build-essential pkg-config libssl-dev \
#     libpq-dev libclang-dev clang cmake sqlite3 libsqlite3-dev sudo && \
#     apk clean && rm -rf /var/lib/apt/lists/*

# # # Créer le répertoire sudoers.d si besoin + utilisateur rust-tools
# # RUN mkdir -p /etc/sudoers.d && \
# #     useradd -m -s /bin/bash rust-tools && \
# #     echo "rust-tools ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/rust-tools

# # Set default Rust toolchain to stable
# RUN rustup default stable && rustup update

# # Add only the necessary Rust targets
# RUN rustup target add wasm32-unknown-unknown

# # Install Diesel CLI (heavy build)
# RUN cargo install diesel_cli \
#     --no-default-features --features postgres \
#     --locked --jobs 4

# # Install Trunk (web build tool)
# RUN cargo install trunk --locked --jobs 4

# # Install wasm-bindgen (WASM bindings)
# RUN cargo install wasm-bindgen-cli --locked --jobs 4

# # Install Dioxus CLI (frontend dev)
# RUN cargo install dioxus-cli --locked --jobs 4

# # --------- STAGE 2: Runtime ---------
# FROM debian:bookworm-slim

# ARG VERSION=latest

# LABEL org.opencontainers.image.description="Rust Tools Optimized"
# LABEL org.opencontainers.image.url="https://hub.docker.com/r/ymk1/rust-tools"
# LABEL org.opencontainers.image.vendor="papoo7jh <papoo7jh@gmail.com>"
# LABEL org.opencontainers.image.licenses="GNU GENERAL PUBLIC LICENSE"
# LABEL org.opencontainers.image.title="Rust Tools"
# LABEL org.opencontainers.image.base.name="hub.docker.com/r/ymk1/rust-tools"
# LABEL org.opencontainers.image.version="${VERSION}"
# LABEL org.opencontainers.image.source="https://github.com/papoo7jh/rust-tools"

# # Runtime dependencies only
# RUN apk update && \
#     apk install -y git libpq-dev sqlite3 libssl3 ca-certificates unzip curl tree jq sudo && \
#     apk clean && rm -rf /var/lib/apt/lists/*

# RUN mkdir -p /etc/sudoers.d && \
# useradd -m -s /bin/bash rust-tools && \
# echo "rust-tools ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/rust-tools

# # Set working directory
# WORKDIR /home/rust-tools

# # Copy compiled binaries
# COPY --from=builder /usr/local/cargo/bin/trunk /usr/local/bin/trunk
# COPY --from=builder /usr/local/cargo/bin/wasm-bindgen /usr/local/bin/wasm-bindgen
# COPY --from=builder /usr/local/cargo/bin/dx /usr/local/bin/dx
# COPY --from=builder /usr/local/cargo/bin/diesel /usr/local/bin/diesel

# # Copy Rust tooling if needed inside container
# COPY --from=builder /usr/local/cargo /usr/local/cargo
# COPY --from=builder /usr/local/rustup /usr/local/rustup

# # Add Rust to PATH (optional for dev container use)
# ENV PATH="/usr/local/cargo/bin:/usr/local/rustup/bin:$PATH"

# # Entrypoint script
# # COPY ./README.md /home/rust-tools/
# COPY ./entrypoint.sh /home/rust-tools/
# RUN chmod +x /home/rust-tools/entrypoint.sh && chown -R rust-tools:rust-tools /home/rust-tools

# USER rust-tools
# WORKDIR /home/rust-tools

# ENTRYPOINT ["./entrypoint.sh"]
# CMD ["bash"]
