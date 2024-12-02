# Usar la imagen oficial de Nginx
FROM nginx:alpine

# Copiar el archivo index.html al directorio de Nginx
COPY index.html /usr/share/nginx/html/index.html
COPY VERSION /VERSION

# Reemplazar el marcador de versión en index.html
RUN sed -i "s/{{VERSION}}/$(cat /VERSION)/g" /usr/share/nginx/html/index.html

# Copiar la configuración personalizada de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Descargar e instalar el Nginx Prometheus Exporter
RUN apk add --no-cache wget tar && \
    wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v1.3.0/nginx-prometheus-exporter_1.3.0_linux_amd64.tar.gz && \
    tar -xvf nginx-prometheus-exporter_1.3.0_linux_amd64.tar.gz && \
    mv nginx-prometheus-exporter /usr/bin/nginx-prometheus-exporter && \
    chmod +x /usr/bin/nginx-prometheus-exporter && \
    rm -f nginx-prometheus-exporter_1.3.0_linux_amd64.tar.gz

# Exponer los puertos necesarios
EXPOSE 80 9113

# Comando por defecto para ejecutar Nginx y el Exportador
CMD ["sh", "-c", "nginx -g 'daemon off;' & nginx-prometheus-exporter -nginx.scrape-uri=http://127.0.0.1/nginx_status"]
