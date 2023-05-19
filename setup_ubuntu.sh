#!/bin/bash

get_codename() {
    local codename=$(lsb_release -sc)
    echo "$codename"
}

# Function to backup the software sources configuration file
# $1: User name
backup_sources() {
    local sources_file="/etc/apt/sources.list"
    local backup_dir="/root/"

    # Prompt for the backup localtion
    read -p "Enter the backup directory [$backup_dir]: " backup_dir
    # Remove trailing slash if present
    backup_dir=$(echo "$backup_dir" | sed 's:/*$::')

    # Check if the backup directory exists, create it if it doesn't
    if [[ ! -d $backup_dir ]]; then
        mkdir -p $backup_dir
    fi

    local backup_file="$backup_dir/sources.list.backup"

    # Backup the software sources configuration file
    cp $sources_file $backup_file
    echo "Software sources configuration file backed up to $backup_file"
}

# Function to replace software sources with Tsinghua University mirror
replace_sources_to_tsinghua() {
    local sources_file="/etc/apt/sources.list"

    echo "# tsinghua ubuntu" > $sources_file
    echo "# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释" >> $sources_file
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $1 main restricted universe multiverse" >> $sources_file
    echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $1 main restricted universe multiverse" >> $sources_file
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $1-updates main restricted universe multiverse" >> $sources_file
    echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $1-updates main restricted universe multiverse" >> $sources_file
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $1-backports main restricted universe multiverse" >> $sources_file
    echo "# deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $1-backports main restricted universe multiverse" >> $sources_file
    echo "" >> $sources_file
    echo "# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $1-security main restricted universe multiverse" >> $sources_file
    echo "# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $1-security main restricted universe multiverse" >> $sources_file
    echo "" >> $sources_file
    echo "deb http://security.ubuntu.com/ubuntu/ $1-security main restricted universe multiverse" >> $sources_file
    echo "# deb-src http://security.ubuntu.com/ubuntu/ $1-security main restricted universe multiverse" >> $sources_file
    echo "" >> $sources_file
    echo "# 预发布软件源，不建议启用" >> $sources_file
    echo "# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $1-proposed main restricted universe multiverse" >> $sources_file
    echo "# # deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $1-proposed main restricted universe multiverse" >> $sources_file

    echo "Software sources replaced with Tsinghua University mirror."
}

# Function to install Vim, Neovim, and Git
install_tools() {
  # Update package lists
  sudo apt update

  # Install Vim
  sudo apt install vim -y

  # Install Neovim
  sudo apt install neovim -y

  # Install Git
  sudo apt install git -y

  echo "Vim, Neovim, and Git installed successfully."
}

codename=$(get_codename)

# backup the software soucres configuration file
backup_sources

# replace the software sources
replace_sources_to_tsinghua $codename

# install some tools
install_tools
