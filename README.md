# OmniRoute auf Fly.io (24/7, PC kann aus)

OmniRoute (https://github.com/diegosouzapw/OmniRoute) ist Node.js — läuft perfekt im Container.

## 1. Fly CLI installieren
- Windows (PowerShell als Admin):
  ```
  iwr https://fly.io/install.ps1 -useb | iex
  ```
- Mac/Linux: `curl -L https://fly.io/install.sh | sh`

## 2. Login
```
fly auth signup     # oder: fly auth login
```
Karte hinterlegen (Free-Tier, kostet nichts solange du klein bleibst).

## 3. App + Volume anlegen (im Ordner mit Dockerfile + fly.toml)
```
fly launch --no-deploy --copy-config --name omniroute-tunnel --region fra
fly volumes create omniroute_data --region fra --size 1
```
Bei Fragen:
- "Existing fly.toml?" → **Yes / Copy**
- Postgres/Redis/Sentry/Tigris → **No**

## 4. Deploy (dauert beim ersten Mal ~5 Min, baut OmniRoute aus dem GitHub-Repo)
```
fly deploy
```

## 5. URL holen
```
fly status
```
→ deine URL: `https://omniroute-tunnel.fly.dev`

## 6. OmniRoute-Dashboard aufrufen
Geh auf `https://omniroute-tunnel.fly.dev` im Browser.
- Account anlegen (genau wie auf deinem PC)
- Provider/Connections (Kiro, Claude, Gemini etc.) konfigurieren
- API-Key kopieren

## 7. In deiner Lovable App
Update das Secret:
- `OMNIROUTE_URL` = `https://omniroute-tunnel.fly.dev/v1`  (oder was OmniRoute als Endpoint anzeigt)
- `OMNIROUTE_TOKEN` = der API-Key aus dem Dashboard

PC kann aus. ✅

## Logs
```
fly logs
```

## Falls der Build-Befehl/Start nicht passt
Schau ins Repo unter `package.json` → "scripts" und passe in der Dockerfile die letzte Zeile an:
```
CMD ["npm", "run", "start"]
```
