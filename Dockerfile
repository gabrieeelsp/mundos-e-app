# Usar la imagen oficial de Nginx
FROM nginx:alpine

# Copiar el archivo index.html al directorio de Nginx
COPY index.html /usr/share/nginx/html/index.html
COPY VERSION /VERSION

# Reemplazar el marcador de versión en index.html
RUN sed -i "s/{{VERSION}}/$(cat /VERSION)/g" /usr/share/nginx/html/index.html

# Copiar la configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer el puerto 80
EXPOSE 80

# Comando por defecto para correr Nginx
CMD ["nginx", "-g", "daemon off;"]
