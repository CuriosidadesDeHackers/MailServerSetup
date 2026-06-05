# 03 — Certificado SSL con Let's Encrypt

Obtenemos un certificado gratuito para `mail.tudominio.com` usando el método **webroot**, que funciona aunque Cloudflare esté en modo proxy (naranja).

## Requisitos

- Apache2 activo y sirviendo `mail.tudominio.com` en el puerto 80
- Registro DNS `mail.tudominio.com` ya propagado
- Si usas Cloudflare: modo **Flexible** activado para este subdominio

## Instalar certbot

```bash
apt install certbot python3-certbot-apache -y
```

## Obtener el certificado

```bash
certbot certonly \
  --webroot \
  -w /var/www/html \
  -d mail.tudominio.com \
  --email admin@tudominio.com \
  --agree-tos \
  --non-interactive
```

El certificado se guarda en:
```
/etc/letsencrypt/live/mail.tudominio.com/fullchain.pem
/etc/letsencrypt/live/mail.tudominio.com/privkey.pem
```

## Renovación automática

Certbot instala un timer de systemd automáticamente. Para verificar:

```bash
systemctl status certbot.timer
# o
certbot renew --dry-run
```

## Dar acceso a Postfix y Dovecot

```bash
chmod 755 /etc/letsencrypt/live
chmod 755 /etc/letsencrypt/archive
```

## Habilitar el VHost HTTPS en Apache

```bash
cp configs/apache-mail-https.conf /etc/apache2/sites-available/mail.tudominio.com-ssl.conf
a2ensite mail.tudominio.com-ssl.conf
a2enmod ssl
systemctl reload apache2
```
