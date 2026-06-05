# 04 — Publicar registro DKIM en DNS

Tras generar las claves con `scripts/setup-dkim.sh`, necesitas publicar la clave pública en DNS.

## Obtener el valor del registro

```bash
cat /etc/opendkim/keys/tudominio.com/mail.txt
```

Verás algo así:
```
mail._domainkey IN TXT ( "v=DKIM1; h=sha256; k=rsa; "
    "p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA..." )
```

## Crear el registro en Cloudflare

| Campo | Valor |
|-------|-------|
| Tipo | TXT |
| Nombre | `mail._domainkey` |
| Contenido | `v=DKIM1; h=sha256; k=rsa; p=MIIBIjAN...` |

> **Importante:** El contenido debe ser **una sola línea** sin comillas ni paréntesis. Concatena las partes si el archivo las tiene separadas.

## Verificar propagación

```bash
dig TXT mail._domainkey.tudominio.com
```

Debe devolver la clave pública.

## Probar firma DKIM

```bash
# Enviar un correo de prueba y verificar en las cabeceras:
# Authentication-Results: ... dkim=pass

# O usar mail-tester.com para análisis completo
```

## Comprobar todo el stack

```bash
# Comprobar que opendkim firma correctamente
echo "Test" | mail -s "DKIM test" tuCorreo@gmail.com

# En las cabeceras del correo recibido deberías ver:
# DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tudominio.com; s=mail; ...
# Authentication-Results: ... dkim=pass
```
