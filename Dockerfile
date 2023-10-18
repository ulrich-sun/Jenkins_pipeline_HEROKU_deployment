#FROM nginx:1.23.3
#LABEL org.opencontainers.image.authors="Tony DJA"

# Installation serveur NGINX
#RUN apt-get update
#RUN apt install -y nginx

# Ouverture du port 80
#EXPOSE 80

# Suppression des fichiers par défaut à la racine du serveur
#RUN rm -R /usr/share/nginx/html*
#RUN rm -R /etc/nginx/sites-available/*
#RUN rm /etc/nginx/nginx.conf

# Copie du site web à la racine du serveur NGINX

#COPY default /etc/nginx/sites-available/
#COPY default.conf.template /etc/nginx/conf.d/default.conf.template
#COPY nginx.conf /etc/nginx/nginx.conf
#COPY ./website /usr/share/nginx/html

# Exécution NGINX
#ENTRYPOINT ["/script.sh"]
#CMD [ "/usr/sbin/nginx", "-g", "daemon off;"]
#CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
#CMD /bin/bash -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'

FROM ubuntu
LABEL org.opencontainers.image.authors="Tony DJA"

# Installation serveur NGINX
RUN apt-get update
RUN apt install -y nginx

# Ouverture du port 80
#EXPOSE 80

# Suppression des fichiers par défaut à la racine du serveur
#RUN rm -R /usr/share/nginx/html*
RUN rm -R /etc/nginx/sites-available/*
RUN rm /etc/nginx/nginx.conf

# Suppression des fichiers par défaut à la racine du serveur
RUN rm -R /var/www/html/*

# Copie du site web à la racine du serveur NGINX
COPY ./website /var/www/html/

# Copie du site web à la racine du serveur NGINX

COPY default /etc/nginx/sites-available/
COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf
#COPY ./website /usr/share/nginx/html

# Exécution NGINX
#ENTRYPOINT ["/script.sh"]
#CMD [ "/usr/sbin/nginx", "-g", "daemon off;"]
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'
#CMD /bin/bash -c "envsubst '\$PORT' < /etc/nginx/conf.d/default.conf.template > /etc/nginx/conf.d/default.conf" && nginx -g 'daemon off;'