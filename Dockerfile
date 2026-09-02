FROM ubuntu:24.04

# ARM64 reverse-engineering toolchain (mariokartwii.com/arm64 ch2)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu-dbg \
    qemu-user \
    qemu-user-binfmt \
    gdb-multiarch \
    build-essential \
    zsh \
    curl \
    git \
    ca-certificates \
    neovim \
    && rm -rf /var/lib/apt/lists/*

# oh-my-zsh with plugins (prompt theming comes from starship, not oh-my-zsh)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && sed -i '/^ZSH_THEME=/d' ~/.zshrc \
    && sed -i 's/^plugins=.*/plugins=(zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

# starship prompt
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y \
    && mkdir -p ~/.config/starship
COPY starship.toml /root/.config/starship/starship.toml
RUN printf '\nalias vim=nvim\nexport STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"\neval "$(starship init zsh)"\n' >> ~/.zshrc

ENV SHELL=/bin/zsh

WORKDIR /root

CMD ["/bin/zsh"]
