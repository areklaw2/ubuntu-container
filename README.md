# ubuntu-container

Ubuntu-based container with an ARM64 reverse-engineering toolchain (gcc-aarch64, binutils, qemu-user, gdb-multiarch), a configured zsh (oh-my-zsh, starship prompt, autosuggestions + syntax-highlighting plugins), and LazyVim (with `asm-lsp` + treesitter pre-installed for `.s` files).

Built based on and for following along with [AArch64/ARM64 Full Beginner's Assembly Tutorial](https://mariokartwii.com/arm64/index.html).

## Build

```sh
docker build -t ubuntu-container .
```

## Run

First run, create a named container with the repo and your git identity mounted in — edit/commit `.s` files with the in-container nvim and they land in this repo on the host, same as editing locally:

```sh
docker run -it --name ubuntu-arm64 --hostname ubuntu-arm64 \
  -v "$(pwd)":/workspaces/ubuntu-container \
  -v "$HOME/.gitconfig":/root/.gitconfig:ro \
  -w /workspaces/ubuntu-container \
  ubuntu-container
```

Every run after, reattach to that same container instead of recreating it:

```sh
docker start -ai ubuntu-arm64
```

If you rebuild the image (`docker build` again), the named container's pinned to the old one — drop it first, then recreate:

```sh
docker rm ubuntu-arm64
```

Already running and you want another shell into it (e.g. one for nvim, one for gdb):

```sh
docker exec -it ubuntu-arm64 zsh
```
