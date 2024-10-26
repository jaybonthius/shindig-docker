# Start with Racket as the base image
FROM racket/racket:8.14

# Install Node.js and development dependencies
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update && \
    apt-get install -y \
        nodejs=18.* \
        curl \
        git \
        xvfb \
        sudo \
        build-essential \
        inotify-tools \
        && \
    npm install -g pnpm@9.10.0 && \
    apt-get clean && \
    apt-get autoremove -y && \
    rm -rf \
        /var/lib/apt/lists/* \
        /var/cache/apt/archives/* \
        /usr/share/doc \
        /usr/share/man \
        /tmp/*

# Create a non-root user for development
RUN useradd -ms /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/vscode

# Install shindig package with debugging
RUN git --version && \
    # Clone the repository first
    git clone https://github.com/jaybonthius/shindig.git /tmp/shindig && \
    # Install from local path instead
    raco pkg install --auto /tmp/shindig && \
    # Clean up
    rm -rf /tmp/shindig

# Switch to non-root user
USER vscode
WORKDIR /home/vscode

# Set default shell
ENV SHELL=/bin/bash
CMD ["bash"]
