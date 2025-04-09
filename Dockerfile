# --------- STAGE 1: Builder ---------
FROM rust:1.86-slim AS builder

# Install system dependencies
RUN apt-get update && \
    apt-get install -y curl git build-essential pkg-config libssl-dev \
    libpq-dev libclang-dev clang cmake sqlite3 libsqlite3-dev && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set default Rust toolchain to stable
RUN rustup default stable && rustup update

# Add only the necessary Rust targets
RUN rustup target add wasm32-unknown-unknown

# Install Diesel CLI (heavy build)
RUN cargo install diesel_cli \
    --no-default-features --features postgres \
    --locked --jobs 4

# Install Trunk (web build tool)
RUN cargo install trunk --locked --jobs 4

# Install wasm-bindgen (WASM bindings)
RUN cargo install wasm-bindgen-cli --locked --jobs 4

# Install Dioxus CLI (frontend dev)
RUN cargo install dioxus-cli --locked --jobs 4

# --------- STAGE 2: Runtime ---------
FROM debian:bookworm-slim

LABEL org.opencontainers.image.description="Rust Tools Optimized"
LABEL org.opencontainers.image.url="https://hub.docker.com/r/ymk1/rust-tools"
LABEL org.opencontainers.image.vendor="papoo7jh <papoo7jh@gmail.com>"
LABEL org.opencontainers.image.licenses=""
LABEL org.opencontainers.image.title="Rust Tools"
LABEL org.opencontainers.image.base.name="hub.docker.com/r/ymk1/rust-tools"
LABEL org.opencontainers.image.version="${VERSION}"

# Runtime dependencies only
RUN apt-get update && \
    apt-get install -y git libpq-dev sqlite3 libssl3 ca-certificates unzip curl tree jq && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy compiled binaries
COPY --from=builder /usr/local/cargo/bin/trunk /usr/local/bin/trunk
COPY --from=builder /usr/local/cargo/bin/wasm-bindgen /usr/local/bin/wasm-bindgen
COPY --from=builder /usr/local/cargo/bin/dx /usr/local/bin/dx
COPY --from=builder /usr/local/cargo/bin/diesel /usr/local/bin/diesel

# Copy Rust tooling if needed inside container
COPY --from=builder /usr/local/cargo /usr/local/cargo
COPY --from=builder /usr/local/rustup /usr/local/rustup

# Add Rust to PATH (optional for dev container use)
ENV PATH="/usr/local/cargo/bin:/usr/local/rustup/bin:$PATH"

# Entrypoint script
COPY ./entrypoint.sh .
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
CMD ["bash"]
