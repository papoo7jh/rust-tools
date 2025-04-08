# --------- STAGE 1: Builder ---------
FROM rust:1.86-slim AS builder

# Install system dependencies
RUN apt-get update && \
    apt-get install -y curl git build-essential pkg-config libssl-dev \
    libpq-dev libclang-dev clang cmake sqlite3 libsqlite3-dev

# Install Rust toolchains and targets
RUN rustup update && \
    rustup install nightly && \
    rustup target add wasm32-wasip1 wasm32-unknown-unknown --toolchain stable && \
    rustup target add wasm32-wasip1 wasm32-unknown-unknown --toolchain nightly

# Install Rust dev tools
RUN cargo install diesel_cli --no-default-features --features postgres --locked && \
    cargo install trunk wasm-bindgen-cli dioxus-cli --locked

RUN rustup default nightly && \
    rustup default stable

RUN rustup component add rust-analyzer && \
    rustup component add rustfmt && \
    rustup component add clippy && \
    rustup component add rls rust-analysis rust-src

# --------- STAGE 2: Runtime ---------
FROM debian:bookworm-slim

LABEL maintainer="papoo7jh <papoo7jh@gmail.com>"
LABEL version="1.0.0"
LABEL description="Rust Tools Optimized"

# Runtime dependencies only
RUN apt-get update && \
    apt-get install -y git libpq-dev sqlite3 libssl3 ca-certificates unzip curl tree jq && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Workdir
WORKDIR /app

# Copy compiled dev tools from builder
COPY --from=builder /usr/local/cargo/bin/trunk /usr/local/bin/trunk
COPY --from=builder /usr/local/cargo/bin/wasm-bindgen /usr/local/bin/wasm-bindgen
COPY --from=builder /usr/local/cargo/bin/dx /usr/local/bin/dx
COPY --from=builder /usr/local/cargo/bin/diesel /usr/local/bin/diesel

# Copy optional rust tooling (to use rustup/cargo/rustc inside container)
COPY --from=builder /usr/local/cargo/bin/cargo /usr/local/bin/cargo
COPY --from=builder /usr/local/cargo/bin/rustup /usr/local/bin/rustup
COPY --from=builder /usr/local/rustup/toolchains/stable-x86_64-unknown-linux-gnu/bin/rustc /usr/local/bin/rustc

# Entrypoint
COPY ./entrypoint.sh .
RUN chmod +x ./entrypoint.sh

ENV PATH="/usr/local/cargo/bin:/usr/local/rustup/bin:$PATH"

ENTRYPOINT ["./entrypoint.sh" ]
CMD ["bash"]
