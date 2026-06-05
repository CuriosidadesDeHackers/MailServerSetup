#!/bin/bash
# ============================================================
# install.sh — Instalación del stack de correo en Debian 13
# Postfix + Dovecot + OpenDKIM + Roundcube + Apache2 + Certbot
# ============================================================

set -e

# ── Variables — EDITAR ANTES DE EJECUTAR ────────────────────
DOMAIN="tudominio.com"
HOSTNAME="mx.tudominio.com"
MAIL_USER="mail"
# ────────────────────────────────────────────────────────────

echo "==> Actualizando sistema..."
apt update && apt upgrade -y

echo "==> Instalando paquetes necesarios..."
DEBIAN_FRONTEND=noninteractive apt install -y \
    postfix \
    postfix-pcre \
    dovecot-core \
    dovecot-imapd \
    dovecot-lmtpd \
    opendkim \
    opendkim-tools \
    roundcube \
    roundcube-sqlite3 \
    roundcube-plugins \
    apache2 \
    certbot \
    python3-certbot-apache \
    curl \
    wget \
    unzip \
    sshpass

echo "==> Creando usuario y grupo vmail (UID/GID 5000)..."
groupadd -g 5000 vmail 2>/dev/null || true
useradd -g vmail -u 5000 vmail -d /var/mail/vhosts -s /sbin/nologin 2>/dev/null || true

echo "==> Creando estructura de directorios de correo..."
mkdir -p /var/mail/vhosts/${DOMAIN}/${MAIL_USER}/Maildir/{new,cur,tmp}
chown -R vmail:vmail /var/mail/vhosts
chmod -R 700 /var/mail/vhosts

echo "==> Habilitando módulos Apache..."
a2enmod ssl rewrite proxy proxy_http headers

echo "==> Configurando hostname..."
hostnamectl set-hostname ${HOSTNAME}

echo ""
echo "✅ Instalación completada."
echo ""
echo "Próximos pasos:"
echo "  1. Copiar configs/ a sus rutas correspondientes"
echo "  2. Adaptar los valores de dominio e IP"
echo "  3. Ejecutar: postmap /etc/postfix/vmailbox"
echo "  4. Ejecutar: postmap /etc/postfix/virtual"
echo "  5. Ejecutar: postmap /etc/postfix/transport"
echo "  6. Generar clave DKIM: bash scripts/setup-dkim.sh"
echo "  7. Obtener SSL: bash scripts/renew-cert.sh"
echo "  8. Crear usuario de correo: bash scripts/setup-mailuser.sh"
echo "  9. Reiniciar servicios: systemctl restart postfix dovecot opendkim apache2"
