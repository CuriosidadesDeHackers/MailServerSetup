# 📬 Mail Server Setup — Postfix + Dovecot + Roundcube + DKIM

Guía completa para montar un servidor de correo independiente en un VPS Debian 13, con webmail Roundcube, autenticación DKIM/SPF/DMARC y soporte multi-dominio (relay a otro proveedor para dominios secundarios).

## 🏗️ Arquitectura

```
Internet
   │
   ▼
[Cloudflare DNS]
   │  MX record → mx.tudominio.com
   │  A record  → IP del VPS
   ▼
[VPS Debian 13]
   ├── Postfix (SMTP :25, :587)
   ├── Dovecot (IMAP :143/:993)
   ├── OpenDKIM (milter :12301)
   ├── Apache2 (webmail :80/:443)
   └── Roundcube (webmail)
```

**Routing especial:** el VPS actúa como MX primario del dominio. Los correos para `info@` se reenvían automáticamente al proveedor externo (OVH, Gmail, etc.) mediante `transport_maps`, sin que el usuario note nada.

---

## 📋 Requisitos previos

- VPS con Debian 13 (Trixie) y IP pública estática
- Dominio gestionado en Cloudflare (u otro DNS)
- Puerto 25 desbloqueado por el proveedor del VPS
- PTR/rDNS configurado apuntando al hostname del servidor
- Acceso root o sudo al VPS

---

## 📁 Estructura del repositorio

```
MailServerSetup/
├── README.md                  ← Esta guía
├── configs/
│   ├── postfix-main.cf        ← Configuración principal de Postfix
│   ├── postfix-master.cf      ← Servicios adicionales (submission 587)
│   ├── postfix-vmailbox       ← Buzones virtuales
│   ├── postfix-virtual        ← Alias virtuales
│   ├── postfix-transport      ← Relay de cuentas a proveedores externos
│   ├── dovecot.conf           ← Configuración de Dovecot 2.4
│   ├── opendkim.conf          ← Configuración de OpenDKIM
│   ├── opendkim-KeyTable      ← Tabla de claves DKIM
│   ├── opendkim-SigningTable   ← Tabla de firma DKIM
│   ├── opendkim-TrustedHosts  ← Hosts de confianza DKIM
│   ├── roundcube-config.php   ← Configuración de Roundcube
│   ├── apache-mail-http.conf  ← VHost Apache HTTP (Cloudflare Flexible)
│   └── apache-mail-https.conf ← VHost Apache HTTPS
├── scripts/
│   ├── install.sh             ← Script de instalación de paquetes
│   ├── setup-mailuser.sh      ← Crear nuevo usuario de correo
│   └── renew-cert.sh          ← Renovación SSL con certbot
└── docs/
    ├── 01-dns-cloudflare.md   ← Configuración DNS paso a paso
    ├── 02-ptr-rdns.md         ← Configurar PTR/rDNS
    ├── 03-ssl-letsencrypt.md  ← Obtener certificado SSL
    ├── 04-dkim-record.md      ← Publicar registro DKIM en DNS
    └── 05-microsoft-delist.md ← Desbloquear IPs en Microsoft/Outlook
```

---

## 🚀 Instalación rápida

```bash
# 1. Clonar el repositorio
git clone https://github.com/CuriosidadesDeHackers/MailServerSetup.git
cd MailServerSetup

# 2. Ejecutar el script de instalación
sudo bash scripts/install.sh

# 3. Seguir los pasos de la guía
```

> **Nota:** Sustituye `tudominio.com` y `tu-ip` por tus valores reales en todos los archivos de configuración.

---

## 📖 Guía paso a paso

### Paso 1 — DNS en Cloudflare
Ver [`docs/01-dns-cloudflare.md`](docs/01-dns-cloudflare.md)

### Paso 2 — PTR / rDNS
Ver [`docs/02-ptr-rdns.md`](docs/02-ptr-rdns.md)

### Paso 3 — Instalar paquetes
Ver [`scripts/install.sh`](scripts/install.sh)

### Paso 4 — Configurar Postfix
Copiar y adaptar [`configs/postfix-main.cf`](configs/postfix-main.cf)

### Paso 5 — Configurar Dovecot
Copiar y adaptar [`configs/dovecot.conf`](configs/dovecot.conf)

### Paso 6 — Configurar DKIM
Copiar y adaptar los archivos `configs/opendkim*`

### Paso 7 — SSL con Let's Encrypt
Ver [`docs/03-ssl-letsencrypt.md`](docs/03-ssl-letsencrypt.md)

### Paso 8 — Configurar Roundcube
Copiar y adaptar [`configs/roundcube-config.php`](configs/roundcube-config.php)

### Paso 9 — Publicar DKIM en DNS
Ver [`docs/04-dkim-record.md`](docs/04-dkim-record.md)

### Paso 10 — Verificar entregabilidad
- https://mail-tester.com → objetivo: 9+/10
- https://mxtoolbox.com/SuperTool.aspx
- https://dmarcian.com/dmarc-inspector/

---

## 🔐 Autenticación de correo implementada

| Mecanismo | Estado | Descripción |
|-----------|--------|-------------|
| SPF | ✅ | Autoriza la IP del VPS a enviar |
| DKIM | ✅ | Firma criptográfica en cada email |
| DMARC | ✅ | Política de validación SPF+DKIM |
| PTR/rDNS | ✅ | IP reversa apunta al hostname |
| TLS | ✅ | Cifrado en SMTP e IMAP |

---

## 📧 Datos de conexión (personalizar)

| Protocolo | Servidor | Puerto | Seguridad |
|-----------|----------|--------|-----------|
| SMTP | mx.tudominio.com | 587 | STARTTLS |
| IMAP | mx.tudominio.com | 993 | SSL/TLS |
| Webmail | https://mail.tudominio.com | 443 | HTTPS |

---

## ⚠️ Problemas comunes

| Error | Causa | Solución |
|-------|-------|----------|
| Microsoft/Outlook bloquea | IP nueva sin reputación | Ver `docs/05-microsoft-delist.md` |
| `User unknown in virtual mailbox` | Falta entrada en vmailbox | Añadir cuenta a `/etc/postfix/vmailbox` |
| Dovecot `unknown setting` | Dovecot 2.4 usa sintaxis nueva | Usar configuración de este repo |
| Loop de redirección Apache+Cloudflare | Redirect 80→443 con Flexible SSL | Eliminar redirect en vhost HTTP |
| DKIM no firma | opendkim no conecta | `systemctl restart opendkim postfix` |

---

## 📜 Licencia

MIT — libre para usar, modificar y distribuir.

---

*Desarrollado por [CuriosidadesDeHackers](https://github.com/CuriosidadesDeHackers)*
