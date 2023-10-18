FROM ubuntu
LABEL org.opencontainers.image.authors="Tony DJA"

# Installation serveur NGINX
RUN apt-get update
RUN apt install -y nginx

# Ouverture du port 80
#EXPOSE 80

# Suppression des fichiers par défaut à la racine du serveur
RUN rm -R /var/www/html/*

# Copie du site web à la racine du serveur NGINX
COPY . /var/www/html/
COPY default.conf.template /etc/nginx/conf.d/default.conf.template
COPY nginx.conf /etc/nginx/nginx.conf

# Exécution NGINX
#ENTRYPOINT ["/script.sh"]
#CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
CMD /bin/bash -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'