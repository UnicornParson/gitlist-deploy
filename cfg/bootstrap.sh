php-fpm8.2 -F -R &
mkdir -p /usr/share/nginx/html/gitlist/src/../var/cache/prod
mkdir -p /usr/share/nginx/html/gitlist/src/../var/log
chmod 777 /usr/share/nginx/html/gitlist/src/../var/cache/prod
chmod 777 /usr/share/nginx/html/gitlist/src/../var/log
nginx -g 'daemon off;'