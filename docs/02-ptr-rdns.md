# 02 — Configurar PTR / rDNS

El registro PTR (reverse DNS) es **obligatorio** para que los servidores de correo destino (Gmail, Outlook, etc.) confíen en tu servidor. Debe resolver la IP del VPS al hostname exacto de Postfix (`myhostname`).

## Resultado esperado

```
TU-IP-VPS  →  mx.tudominio.com
```

---

## Configuración en OVH

1. Accede al **Panel OVH → Bare Metal Cloud → IP**
2. Localiza tu IP pública del VPS
3. Haz clic en `...` → **Modificar el reverso**
4. Introduce: `mx.tudominio.com`
5. Guarda

> **Nota:** El registro A `mx.tudominio.com → TU-IP-VPS` debe existir en DNS **antes** de configurar el PTR, o el proveedor lo rechazará.

---

## Configuración en Hetzner

1. Panel → **Networking → Floating IPs** (o la IP del servidor)
2. Clic en la IP → **Reverse DNS**
3. Introduce: `mx.tudominio.com`

---

## Configuración en otros proveedores

La mayoría de proveedores (DigitalOcean, Linode, Vultr...) permiten configurar el PTR desde el panel de red del servidor o desde la sección de IPs.

---

## Verificación (esperar 5-15 min tras configurar)

```bash
# Forma correcta (invertir IP manualmente):
# Para IP 51.38.131.70 → 70.131.38.51.in-addr.arpa
dig PTR 70.131.38.51.in-addr.arpa

# O con -x (lo hace automático):
dig -x 51.38.131.70
```

Debe devolver: `mx.tudominio.com`
