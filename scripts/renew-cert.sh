#!/bin/bash
# ============================================================
# renew-cert.sh — Obtener/renovar certificado SSL con certbot
# Funciona con Cloudflare en modo Flexible (proxy activo)
# ============================================================

DOMAIN="mail.tudominio.com"
WEBROOT="/var/www/html"

echo "==> Obteniendo certificado para ${DOMAIN}..."
certbot certonly \
    --webroot \
    -w ${WEBROOT} \
    -d ${DOMAIN} \
    --non-interactive \
    --agree-tos \
    --email admin@tudominio.com

echo "==> Recargando servicios con nuevo certificado..."
systemctl reload apache2
systemctl reload postfix
systemctl reload dovecot

echo "✅ Certificado obtenido/renovado para ${DOMAIN}"
echo "   Ruta: /etc/letsencrypt/live/${DOMAIN}/"
