FROM phpswoole/swoole:php8.2-alpine

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions pcntl && \
    install-php-extensions bcmath

RUN install-php-extensions zip && \
    install-php-extensions redis

RUN apk --no-cache add shadow sqlite mysql-client mysql-dev mariadb-connector-c git patch supervisor redis git nginx

WORKDIR /www

RUN git clone https://github.com/wyx2685/v2board/ /www

RUN wget https://github.com/composer/composer/releases/latest/download/composer.phar -O composer.phar
RUN php composer.phar install -vvv
RUN php composer.phar require joanhey/adapterman

RUN addgroup -S -g 1000 www && adduser -S -G www -u 1000 www

RUN (crontab -l 2>/dev/null; echo "* * * * * php /www/artisan schedule:run") | crontab -

COPY ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./httpd.conf /etc/nginx/http.d/default.conf
COPY ./data/config.php.example /www/config/v2board.php
RUN chown -R www /www

RUN mkdir /data
RUN chown -R www /data

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"] 
