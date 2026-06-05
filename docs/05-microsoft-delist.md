# 05 — Desbloquear IP en Microsoft / Outlook (Error S3140)

Las IPs nuevas de VPS suelen estar en listas negras de Microsoft (Outlook, Hotmail, Live). El error típico es:

```
550 5.7.606 Access denied, banned sending IP [TU-IP].
Error: S3140
```

## Paso 1 — Verificar si la IP está bloqueada

1. Ve a https://sender.office.com
2. Introduce tu IP del VPS
3. Si aparece bloqueada, continúa con el paso 2

> Si dice "no está bloqueada" pero los correos rebotan, puede ser una restricción temporal por reputación nueva. Espera 24-48h.

## Paso 2 — Solicitar desbloqueo

1. Ve a https://sender.office.com
2. Haz clic en **"Delist my IP"** o **"Submit a delist request"**
3. Rellena el formulario:
   - **Email address:** una cuenta válida (puede ser tuya)
   - **IP address:** TU-IP-VPS
   - **Description:** explica brevemente que es un servidor legítimo
4. Envía el formulario
5. Recibirás un número de ticket (guárdalo)

## Paso 3 — Esperar propagación

- El proceso tarda **24-48 horas**
- Microsoft no envía notificación cuando se desbloquea
- Prueba enviando a una cuenta de Outlook/Hotmail después de 24h

## Límites de envío para IPs nuevas

Microsoft impone límites temporales a IPs sin historial:
- ~**100-200 correos/día** los primeros días
- El límite sube gradualmente según la reputación
- Mantener tasa de rebotes < 10% y quejas < 0.3%

## Herramientas de diagnóstico

```bash
# Comprobar listas negras
# https://mxtoolbox.com/blacklists.aspx

# Comprobar reputación Microsoft
# https://sendersupport.olc.protection.outlook.com/pm/

# Test completo de entregabilidad
# https://mail-tester.com  (objetivo: 9+/10)
```

## Smart Network Data Services (SNDS)

Regístrate en https://sendersupport.olc.protection.outlook.com/snds/ para monitorizar la reputación de tu IP con Microsoft a largo plazo.
