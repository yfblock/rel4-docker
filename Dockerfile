FROM ubuntu:22.04

# Maybe add a new user in the future.
# RUN apt-get update && apt-get install -y sudo

# ARG USERNAME=user
# ARG GROUPNAME=user
# ARG UID=1000
# ARG GID=1000
# ARG PASSWORD=user
# RUN groupadd -g $GID $GROUPNAME && \
#     useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
#     echo $USERNAME:$PASSWORD | chpasswd && \
#     echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# USER $USERNAME
# WORKDIR /home/$USERNAME/

# Use Tsinghua Mirror to improve download speed.
# COPY ./sources.list /etc/apt/sources.list
# Update apt source
RUN apt update
# Install required packages
RUN apt install -y ninja-build g++ python3-pip libxml2-utils protobuf-compiler \
    cmake device-tree-compiler python3-protobuf cpio python3-libarchive-c \
    repo curl sudo
# Install required python modules
RUN pip install pyyaml jinja2 ply lxml google pyfdt pyelftools pygments future jsonschema
# Copy toolchain
# COPY ./toolchain /opt/riscv
ADD riscv.tar.gz /opt/


ARG USERNAME=rel4-dev
ARG GROUPNAME=rel4-dev
ARG UID=1000
ARG GID=1000
ARG PASSWORD=
RUN groupadd -g $GID $GROUPNAME && \
    useradd -m -s /bin/bash -u $UID -g $GID -G sudo $USERNAME && \
    echo "$USERNAME   ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER rel4-dev

# Install rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y --no-modify-path \
    --default-toolchain nightly-2024-02-01 \
    --component rust-src cargo clippy rust-docs rust-src rust-std rustc rustfmt \
    --target aarch64-unknown-none-softfloat riscv64imac-unknown-none-elf

# Add toolchain path to PATH environment variable
ENV PATH="/home/rel4-dev/.cargo/bin:${PATH}:/opt/riscv/bin"

# Install QEMU simulator
RUN sudo apt-get install -y qemu-system-aarch64
RUN sudo apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu

# Set working directory.
WORKDIR /home/rel4-docker
