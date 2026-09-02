# ubuntu-container

Ubuntu-based container with an ARM64 reverse-engineering toolchain (gcc-aarch64, binutils, qemu-user, gdb-multiarch) and a configured zsh (oh-my-zsh, starship prompt, autosuggestions + syntax-highlighting plugins). Based on [mariokartwii.com/arm64 ch2](https://mariokartwii.com/arm64).

## Build

```sh
docker build -t ubuntu-container .
```

Rebuild from scratch (skip Docker's layer cache, e.g. after bumping package versions):

```sh
docker build -t ubuntu-container . --no-cache
```

## Run

First run, create a named persistent container (state survives stop/exit):

```sh
docker run -it --name ubuntu-arm64 --hostname ubuntu-arm64 ubuntu-container
```

Every run after, reattach to the same container instead of creating a new one:

```sh
docker start -ai ubuntu-arm64
```

Already running and you want another shell into it:

```sh
docker exec -it ubuntu-arm64 zsh
```

With the current directory mounted into the container (share files host ↔ container), on first run:

```sh
docker run -it --name ubuntu-arm64 --hostname ubuntu-arm64 -v $(pwd):/root/work ubuntu-container
```

Note: `--rm` deletes the container on exit — omit it if you want the container to persist across sessions.

## VSCode (Dev Containers)

`.devcontainer/devcontainer.json` builds this same Dockerfile and mounts the repo at `/workspaces/ubuntu-container`.

Cmd+Shift+P → **Dev Containers: Reopen in Container**. Ships with C/C++ (`ms-vscode.cpptools`) and Native Debug (`webfreak.debug`, works with `gdb-multiarch`) extensions.
