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
RUN apk add --no-cache wget && \
    wget https://github.com/nginxinc/nginx-prometheus-exporter/releases/download/v0.10.0/nginx-prometheus-exporter-linux-amd64 && \
    chmod +x nginx-prometheus-exporter-linux-amd64 && \
    mv nginx-prometheus-exporter-linux-amd64 /usr/bin/nginx-prometheus-exporter

# Exponer los puertos necesarios
EXPOSE 80 9113

# Comando por defecto para ejecutar Nginx y el Exportador
CMD ["sh", "-c", "nginx -g 'daemon off;' & nginx-prometheus-exporter -nginx.scrape-uri=http://127.0.0.1/nginx_status"]
