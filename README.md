# Docker版安装教程

> [!IMPORTANT]  
> 这不是官方的V2Board/Xboard仓库

以下内容中，如果你没有使用1panel-network，请移除指令中的 `--network 1panel-network`，以及 `docker-compose.yml` 中的 `network` 标签

## 快速安装

1. 准备持久化的文件

```shell
mkdir -p ./data
wget "https://raw.githubusercontent.com/V2BoardDocker/wyx2685/refs/heads/main/data/config.env.example" -O ./data/config.env
wget "https://raw.githubusercontent.com/V2BoardDocker/wyx2685/refs/heads/main/data/config.php.example" -O ./data/config.php
```

2. 导入数据库、注册管理员账户

> [!NOTE]
> 如果你没有使用1panel-network，请移除指令中的 `--network 1panel-network`

```shell
docker run --rm -it --network 1panel-network \
-v ./data/config.env:/www/config.env \
--entrypoint sh \
ghcr.io/v2boarddocker/wyx2685:latest \
"-c" "php artisan v2board:install && cat /www/.env > /www/config.env"
```

3. 运行容器

```shell
docker run -d --network 1panel-network \
-v ./data/config.env:/www/.env \
-v ./data/config.php:/www/config/v2board.php \
-v ./data:/data \
-p 49992:80 \
ghcr.io/v2boarddocker/wyx2685:latest 
```

4. 打开浏览器看看吧

不出意外，你的面板将在49992端口可用。

你可以将其绑定到 `127.0.0.1:49992` 来避免公网访问

## 手动构建镜像

### 全新安装

1. 构建镜像

    ```shell
    docker build -t wyx .
    ```

2. 导入数据库、注册管理员账户

    ```shell
    docker run --rm -it --network 1panel-network -v ./data/config.env:/www/config.env --entrypoint sh wyx "-c" "php artisan v2board:install && cat /www/.env > /www/config.env"
    ```

3. 启动

    ```shell
    docker-compose up -d
    ```

### 恢复安装

1. 构建镜像

    ```shell
    docker build -t wyx .
    ```

2. 恢复数据库连接(可选)

    修改config.env内的配置

3. 启动

    ```shell
    docker-compose up -d
    ```

## 常见问题

- 无法保存设置、白屏、无权限

    请检查 ` /www ` 的读写权限和拥有者

    请在容器内部执行

    ```shell
    chmod 755 /www
    chown www /www
    ```

    快速操作

    ```shell
    docker exec <容器ID或容器名称> chmod 755 /www
    docker exec <容器ID或容器名称> chown www /www
    ```

- 500 主题不存在

    删除 ` ./data/config.php ` 中的如下内容后重启

    ```text
    'frontend_theme' => 'v2board',
    'frontend_theme_sidebar' => 'light',
    'frontend_theme_header' => 'dark',
    'frontend_theme_color' => 'default',
    'frontend_background_url' => NULL,
    ```

## 持久化数据

- ` ./data/config.php ` 站点的用户设置

- ` ./data/config.env ` 站点的静态设置（数据库等）

- ` ./data/redis.rdb ` Redis数据库
