# 使用 Ubuntu 作为基础镜像
FROM ubuntu:latest

# 设置环境变量，确保系统能找到非交互的 apt 配置
ENV DEBIAN_FRONTEND=noninteractive
# 更新系统并安装必要的工具
RUN apt-get update -y && apt-get install -y \
    curl \
    wget \
    bzip2 \
    ca-certificates \
    libgl1 \
    mesa-utils \ 
    libglib2.0-0 \
    git \
    python3 \
    python3-pip \
    python3-dev \
    && rm -rf /var/lib/apt/lists/
# 使用 Tsinghua 的镜像下载 Miniconda
RUN wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh \
    && bash miniconda.sh -b -p /opt/conda \
    && rm miniconda.sh


# 设置 Conda 环境变量
ENV PATH=/opt/conda/bin:$PATH
    
# 设置工作目录
WORKDIR /workspace

# 将本地的 LeRobot 代码复制到容器中
COPY . /workspace/lerobot

# 设置 Conda 镜像源为清华镜像
RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/ \
    && conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ \
    && conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/r/ \
    && conda config --set show_channel_urls yes
# 设置 pip 镜像源为国内镜像
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

    
# 查看 lerobot 目录的内容，确保文件复制正确
RUN ls -R /workspace/lerobot

# 创建 Conda 环境并安装 Python 3.10
RUN conda create -y -n lerobot python=3.10

# 初始化 Conda 环境并安装 LeRobot
RUN /opt/conda/bin/conda init bash

# 设置默认命令启动 Conda 环境并进入 Bash，保持容器运行
CMD ["/bin/bash", "-c", "source activate lerobot && exec bash"]

