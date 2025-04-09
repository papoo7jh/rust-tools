# 🦀 RUST-TOOLS

## 🚀 How to use this image

Start a Rust-tool instance running your app development.

The most straightforward way to use this image is to use a Rust container as both the build and runtime environment.  
In your Dockerfile, writing something along the lines of the following will compile and run your project:

```dockerfile
FROM ymk1/rust-tools

WORKDIR /app
COPY . .

RUN cargo build --release --path .

CMD ["/app/<>/target/<>"]
```

🛠️ Then, build and run the Docker image:

```shell
docker run -it --name rust-tools ymk1/rust-tools --user "$(id -u)":"$(id -g)" -v "$PWD":/app -w /app
```

Or simply:

```shell
docker run -it --name rust-tools ymk1/rust-tools
```

This creates an image that has all of the Rust tooling preinstalled (approx. 3.2GB).

💡 Note: Some shared libraries may need to be installed as shown above with extra-runtime-dependencies.

🔗 See Docker multistage builds for more info.

🧰 Compile your app inside the Docker container
There may be occasions where it is not appropriate to run your app inside a container.
To compile, but not run your app inside the Docker instance, you can write something like:

💻 Enjoy Rust dev!

## 🏷️ Supported tags and respective Dockerfile links

📝 TODO

## 🦀 What is Rust?

🦀 Rust is a systems programming language sponsored by Mozilla Research.
It is designed to be a "safe, concurrent, practical language", supporting both functional and imperative-procedural paradigms.
Rust is syntactically similar to C++, but is designed for better memory safety while maintaining performance.

## 🔗 Learn more about Rust on Wikipedia

## 📜 License

⚖️ GNU GENERAL PUBLIC LICENSE - Version 3, 29 June 2007

© 2007 Free Software Foundation, Inc. <https://fsf.org/>
Everyone is permitted to copy and distribute verbatim copies
of this license document, but changing it is not allowed.

The GNU General Public License is a free, copyleft license for software and other kinds of works.

The licenses for most software and other practical works are designed to take away your freedom to share and change the works.
By contrast, the GNU General Public License is intended to guarantee your freedom to share and change all versions of a program — to make sure it remains free software for all its users.
We, the Free Software Foundation, use the GNU General Public License for most of our software; it applies also to any other work released this way by its authors. You can apply it to your programs, too.

## 📇 Quick reference

👤 Maintained by: Oumar Makan (papoo7jh) <papoo7jh@gmail.com>

Enjoy Rusting! 🦀✨
