#!/bin/bash
# ============================================================
# setup-mailuser.sh — Crear un nuevo usuario de correo
# ============================================================

set -e

DOMAIN="tudominio.com"
VMAIL_BASE="/var/mail/vhosts"
USERS_FILE="/etc/dovecot/users"
VMAILBOX_FILE="/etc/postfix/vmailbox"

read -p "Nombre de usuario (sin dominio, ej: mail): " USERNAME
EMAIL="${USERNAME}@${DOMAIN}"

read -s -p "Contraseña: " PASSWORD
echo ""
read -s -p "Confirmar contraseña: " PASSWORD2
echo ""

if [ "$PASSWORD" != "$PASSWORD2" ]; then
    echo "❌ Las contraseñas no coinciden."
    exit 1
fi

# Generar hash SHA512-CRYPT
HASH=$(doveadm pw -s SHA512-CRYPT -p "$PASSWORD")

echo "==> Creando directorio Maildir..."
mkdir -p ${VMAIL_BASE}/${DOMAIN}/${USERNAME}/Maildir/{new,cur,tmp}
chown -R vmail:vmail ${VMAIL_BASE}/${DOMAIN}/${USERNAME}
chmod -R 700 ${VMAIL_BASE}/${DOMAIN}/${USERNAME}

echo "==> Añadiendo usuario a Dovecot..."
echo "${EMAIL}:${HASH}:5000:5000::/var/mail/vhosts/${DOMAIN}/${USERNAME}::" >> ${USERS_FILE}

echo "==> Añadiendo buzón a Postfix vmailbox..."
echo "${EMAIL}    ${DOMAIN}/${USERNAME}/Maildir/" >> ${VMAILBOX_FILE}
postmap ${VMAILBOX_FILE}

echo "==> Recargando servicios..."
systemctl reload postfix dovecot

echo ""
echo "✅ Usuario ${EMAIL} creado correctamente."
echo "   IMAP: mx.${DOMAIN}:993 (SSL)"
echo "   SMTP: mx.${DOMAIN}:587 (STARTTLS)"
