#!/bin/bash
# ============================================================
# setup-dkim.sh — Generar clave DKIM y configurar OpenDKIM
# ============================================================

set -e

DOMAIN="tudominio.com"
SELECTOR="mail"
KEY_DIR="/etc/opendkim/keys/${DOMAIN}"

echo "==> Creando directorio de claves..."
mkdir -p ${KEY_DIR}

echo "==> Generando par de claves RSA 2048..."
opendkim-genkey -b 2048 -d ${DOMAIN} -D ${KEY_DIR} -s ${SELECTOR} -v

echo "==> Ajustando permisos..."
chown -R opendkim:opendkim /etc/opendkim/keys
chmod 600 ${KEY_DIR}/${SELECTOR}.private

echo "==> Configurando KeyTable..."
echo "${SELECTOR}._domainkey.${DOMAIN} ${DOMAIN}:${SELECTOR}:${KEY_DIR}/${SELECTOR}.private" \
    > /etc/opendkim/KeyTable

echo "==> Configurando SigningTable..."
echo "*@${DOMAIN} ${SELECTOR}._domainkey.${DOMAIN}" \
    > /etc/opendkim/SigningTable

echo "==> Reiniciando OpenDKIM..."
systemctl restart opendkim

echo ""
echo "✅ DKIM configurado correctamente."
echo ""
echo "📋 Añade este registro TXT en tu DNS:"
echo "   Nombre: ${SELECTOR}._domainkey.${DOMAIN}"
echo "   Valor:"
cat ${KEY_DIR}/${SELECTOR}.txt
