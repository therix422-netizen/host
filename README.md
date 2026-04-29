# OmniRoute auf Fly.io

OmniRoute ist eine **Next.js App**. Der Container baut sie automatisch und startet sie mit `npm start` (=  `next start` über `scripts/run-next.mjs`).

## Wichtige Secrets setzen (PFLICHT!)

```bash
# Admin-Passwort SETZEN — sonst läuft es mit "CHANGEME" (unsicher!)
fly secrets set INITIAL_PASSWORD="rassa123" -a host-otmeba
```

## Deploy

```bash
cd flyio-omniroute
fly deploy -a host-otmeba
```

## RAM
512 MB reicht für Next-Build NICHT — wir nutzen 1024 MB. Falls der Build trotzdem OOM:
```bash
fly scale memory 2048 -a host-otmeba
```

## Logs
```bash
fly logs -a host-otmeba
```

## Nach erfolgreichem Deploy
1. `https://host-otmeba.fly.dev` öffnen → mit deinem `INITIAL_PASSWORD` einloggen
2. Provider + API-Key in OmniRoute UI einrichten
3. In OmniRoute einen API-Token generieren
4. In Lovable die Secrets updaten:
   - `OMNIROUTE_URL` = `https://host-otmeba.fly.dev`
   - `OMNIROUTE_TOKEN` = dein neuer Token
