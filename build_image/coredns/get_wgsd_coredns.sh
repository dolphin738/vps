#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
plain='\033[0m'

arch=$(arch)

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
    arch="amd64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
    arch="arm64"
elif [[ $arch == "s390x" ]]; then
    arch="s390x"
else
    echo -e "${red}Failed to detect schema, use default schema: ${arch}${plain}"
fi

echo "CPU架构: ${arch}"

install_wgsd_coredns() {
    mkdir -p /go
    cd /go || exit
    last_version=$(curl -Ls "https://api.github.com/repos/jwhited/wgsd/releases/latest" |
        grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
    if [[ -z "$last_version" ]]; then
        echo -e "${red}GitHub API 限制，请稍后再试${plain}"
        exit 1
    fi
    echo -e "wgsd-coredns 版本: ${last_version}, 开始安装"
	last_version_1=${last_version#*v}
    wget -q -N --no-check-certificate \
        -O wgsd_coredns_linux_"${arch}".tar.gz \
        https://github.com/jwhited/wgsd/releases/download/"${last_version}"/wgsd-coredns_"${last_version_1}"_linux_"${arch}".tar.gz
    if [[ $? -ne 0 ]]; then
        echo -e "${red}下载失败 wgsd-coredns${plain}"
        exit 1
    fi
    tar zxvf wgsd_coredns_linux_"${arch}".tar.gz
    chmod +x /go/coredns
}

echo -e "${green}获取 wgsd-coredns 二进制文件${plain}"
install_wgsd_coredns