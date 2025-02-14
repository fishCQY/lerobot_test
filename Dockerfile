# 使用 Miniconda 作为基础镜像
FROM continuumio/miniconda3:latest

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

# 设置默认命令使用 conda run 启动 bash shell
CMD ["/opt/conda/bin/conda", "run", "-n", "lerobot", "bash"]

