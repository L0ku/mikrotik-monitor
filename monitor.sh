#!/bin/bash
# MikroTik VPN Monitor - Ping 8.8.8.8 interface=wg-Loku

log() {
    echo "[$(date -u '+%Y-%m-%d %H:%M:%S UTC')] $1"
}

ping_mikrotik() {
    local HOST=$1
    local PORT=$2
    local USER=$3
    local PASS=$4
    
    log "📡 PING $HOST:$PORT"
    
    RESULT=$(expect -c "
        set timeout 45
        spawn telnet $HOST $PORT
        expect \"Login:\"
        send \"$USER\r\"
        expect \"Password:\"
        send \"$PASS\r\"
        expect \">\"
        send \"ping 8.8.8.8 count=3 interface=wg-Loku\r\"
        sleep 8
        expect \">\"
        send \"quit\r\"
        expect eof
    " 2>&1)
    
    if echo "$RESULT" | grep -q "packet-loss=0%"; then
        log "  ✅ $HOST - OK"
        return 0
    else
        log "  ❌ $HOST - FAIL"
        return 1
    fi
}

log "=== MikroTik VPN Monitor Started ==="

# MikroTik 1
ping_mikrotik "${MT1_HOST:-185.9.139.65}" "${MT1_PORT:-6677}" "${MT1_USER:-loku}" "${MT1_PASS:-loku@12#}"

# MikroTik 2  
ping_mikrotik "${MT2_HOST:-158.173.160.34}" "${MT2_PORT:-6677}" "${MT2_USER:-loku}" "${MT2_PASS:-loku!@34}"

log "=== Monitor Finished ==="
