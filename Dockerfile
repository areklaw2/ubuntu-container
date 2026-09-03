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
    ripgrep \
    fd-find \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# neovim (Ubuntu's apt package, and the neovim-ppa/stable channel, both lag
# below LazyVim's minimum version — pull the release binary directly instead)
RUN NVIM_ARCH=$(uname -m | sed 's/aarch64/arm64/') \
    && curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz" -o /tmp/nvim.tar.gz \
    && tar -C /opt -xzf /tmp/nvim.tar.gz \
    && ln -sf "/opt/nvim-linux-${NVIM_ARCH}/bin/nvim" /usr/local/bin/nvim \
    && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
    && rm /tmp/nvim.tar.gz

# oh-my-zsh with plugins (default robbyrussell theme, no starship)
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended \
    && sed -i 's/^plugins=.*/plugins=(zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc \
    && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions \
    && git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting \
    && printf '\nalias vim=nvim\n' >> ~/.zshrc

# LazyVim, pre-synced so plugins/parsers/LSP are baked into the image
RUN git clone https://github.com/LazyVim/starter ~/.config/nvim \
    && rm -rf ~/.config/nvim/.git
COPY nvim/plugins/asm.lua /root/.config/nvim/lua/plugins/asm.lua
RUN nvim --headless "+Lazy! sync" +qa \
    && nvim --headless "+MasonInstall asm-lsp" +qa

ENV SHELL=/bin/zsh

WORKDIR /root

CMD ["/bin/zsh"]
