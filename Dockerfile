FROM nginx:latest
SHELL ["/bin/bash", "-c"]
USER root
ENV DEBIAN_FRONTEND noninteractive
RUN apt update && apt upgrade -y
RUN apt update && apt install -y git unzip wget php8.2-fpm php8.2-dom
ENV GITLIST_BASE /usr/share/nginx/html/gitlist
VOLUME [ "$GITLIST_BASE" ]
RUN mkdir -p $GITLIST_BASE && chown -Rv nginx $GITLIST_BASE && chmod -Rv 777 $GITLIST_BASE

WORKDIR $GITLIST_BASE

COPY cfg/nginx.conf /etc/nginx/nginx.conf
ENV DEFAULT_REPOSITORY_DIR /home/repo/
RUN mkdir -p $DEFAULT_REPOSITORY_DIR && chown -Rv nginx $DEFAULT_REPOSITORY_DIR && chmod 777 $DEFAULT_REPOSITORY_DIR
VOLUME [ "$DEFAULT_REPOSITORY_DIR" ]

RUN wget -O /tmp/gitlist.zip https://github.com/klaussilveira/gitlist/releases/download/2.0.0/gitlist-2.0.0.zip
RUN unzip -o /tmp/gitlist.zip -d $GITLIST_BASE/
RUN mkdir -p $GITLIST_BASE/var/cache && \
chmod 777 $GITLIST_BASE/var/cache && \
mkdir -p $GITLIST_BASE/var/log && \
chmod 777 $GITLIST_BASE/var/log
#RUN chown -Rv nginx $GITLIST_BASE && chmod a+r -Rv $GITLIST_BASE

COPY cfg/php.ini /etc/php/8.2/fpm/php.ini
COPY cfg/php-fpm.conf /etc/php/8.2/fpm/php-fpm.conf
COPY cfg/gitlist_config $GITLIST_BASE
EXPOSE 80
USER root
COPY cfg/bootstrap.sh /home/bootstrap.sh
RUN chmod a+x /home/bootstrap.sh


RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log \
    && ln -sf /dev/stderr /var/log/php8.2-fpm.log

# run bootstrap
ENTRYPOINT [ "/bin/bash", "-c", "/home/bootstrap.sh" ]
