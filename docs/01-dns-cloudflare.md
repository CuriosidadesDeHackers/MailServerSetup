# 01 — Configuración DNS en Cloudflare

## Registros necesarios

Accede a **Cloudflare → tu dominio → DNS → Records** y crea:

### A Records

| Tipo | Nombre | Contenido | Proxy |
|------|--------|-----------|-------|
| A | `mx` | `TU-IP-VPS` | ⚪ DNS only |
| A | `mail` | `TU-IP-VPS` | 🟠 Proxied |

> **Importante:** El registro `mx` debe estar en **DNS only (gris)** para que el correo llegue directamente al VPS. El registro `mail` puede estar proxiado (naranja) porque solo sirve el webmail HTTPS.

### MX Record

| Tipo | Nombre | Contenido | Prioridad |
|------|--------|-----------|-----------|
| MX | `@` | `mx.tudominio.com` | 10 |

### SPF (TXT)

| Tipo | Nombre | Contenido |
|------|--------|-----------|
| TXT | `@` | `v=spf1 ip4:TU-IP-VPS include:mx.ovh.com ~all` |

> Si no usas OVH, elimina el `include:mx.ovh.com`. Añade los includes de los servicios que envíen correo desde tu dominio.

### DKIM (TXT)

| Tipo | Nombre | Contenido |
|------|--------|-----------|
| TXT | `mail._domainkey` | *(valor generado por `scripts/setup-dkim.sh`)* |

### DMARC (TXT)

| Tipo | Nombre | Contenido |
|------|--------|-----------|
| TXT | `_dmarc` | `v=DMARC1; p=none; rua=mailto:mail@tudominio.com` |

> Empieza con `p=none` para monitorizar sin rechazar. Cuando tengas confianza sube a `p=quarantine` y luego `p=reject`.

---

## Verificación

```bash
# SPF
dig TXT tudominio.com

# DKIM
dig TXT mail._domainkey.tudominio.com

# DMARC
dig TXT _dmarc.tudominio.com

# MX
dig MX tudominio.com

# PTR (IP inversa)
dig -x TU-IP-VPS
```
