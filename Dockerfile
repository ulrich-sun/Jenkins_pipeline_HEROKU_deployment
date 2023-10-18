FROM nginx
LABEL org.opencontainers.image.authors="Tony DJA"

# Installation serveur NGINX
#RUN apt-get update
#RUN apt install -y nginx

# Ouverture du port 80
#EXPOSE 80
COPY static-html-directory /usr/share/nginx/html
# Suppression des fichiers par défaut à la racine du serveur
RUN rm -R /usr/share/nginx/html*
RUN rm -R /etc/nginx/sites-available/*
RUN rm /etc/nginx/nginx.conf

# Copie du site web à la racine du serveur NGINX
COPY . /usr/share/nginx/html
COPY default /etc/nginx/sites-available/
COPY nginx.conf /etc/nginx/

# Exécution NGINX
#ENTRYPOINT ["/script.sh"]
#CMD [ "/usr/sbin/nginx", "-g", "daemon off;"]
CMD sed -i -e 's/$PORT/'"$PORT"'/g' /etc/nginx/sites-available/default && nginx -g 'daemon off;'