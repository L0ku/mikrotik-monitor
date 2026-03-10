# MikroTik VPN Monitor

Monitoron 2 MikroTik pajisje çdo 10 minuta me GitHub Actions.

## Setup

1. Fork këtë repo
2. Shto secrets në Settings > Secrets:
   - `MT1_HOST`: 185.9.139.65
   - `MT1_PORT`: 6677
   - `MT1_USER`: loku
   - `MT1_PASS`: loku@12#
   - `MT2_HOST`: 158.173.160.34
   - `MT2_PORT`: 6677
   - `MT2_USER`: loku
   - `MT2_PASS`: loku!@34

3. Enable Actions në repo

## Si funksionon

- Çdo 10 min → GitHub Action fillon
- Lidhet me Telnet në MikroTik
- Ekzekuton: `ping 8.8.8.8 count=3 interface=wg-Loku`
- Nëse OK → ✅
- Nëse FAIL → ❌
