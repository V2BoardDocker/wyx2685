# Docker版安装教程

本构建分为全新安装和恢复安装

如果你没有使用network，请移除指令中的 ` --network 1panel-network `，以及 ` docker-compose.yml ` 中的 ` network ` 标签

### 全新安装

1. 构建镜像

    ```bash
    docker build -t wyx .
    ```

2. 导入数据库、注册管理员账户

    ```bash
    docker run --rm -it --network 1panel-network -v ./data/config.env:/www/config.env --entrypoint sh wyx "-c" "php artisan v2board:install && cat /www/.env > /www/config.env"
    ```

3. 启动

    ```bash
    docker-compose up -d
    ```

### 恢复安装

1. 构建镜像

    ```bash
    docker build -t wyx .
    ```

2. 恢复数据库连接(可选)

    修改config.env内的配置

3. 启动

    ```bash
    docker-compose up -d
    ```

## 常见问题

- 无法保存设置、白屏、无权限

    请检查 ` /www ` 的读写权限和拥有者

    请在容器内部执行

    ```bash
    chmod 755 /www
    chown www /www
    ```

    快速操作

    ```bash
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
