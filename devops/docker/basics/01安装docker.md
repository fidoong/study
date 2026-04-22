# 更新系统包
* 首先，确保系统包是最新的：
```bash
$ sudo apt update

$ sudo apt install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
```
# 安装依赖包
* 安装 Docker 所需的依赖包：
```bash
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
```
# 添加 Docker 官方 GPG 密钥
* 添加 Docker 的官方 GPG 密钥以确保下载的软件包是安全的：
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

# 添加 Docker 仓库
* 将 Docker 的稳定版仓库添加到 APT 源列表中：
```bash 
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

# 更新包索引
```bash 
sudo apt update
```

# 安装 Docker

```bash
sudo apt install -y docker-ce docker-ce-cli containerd.io
```