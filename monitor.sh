#!/bin/bash
# MikroTik VPN Monitor

log() {
    echo "[$(date -u '+%Y-%m-%d %H:%M:%S UTC')] $1"
}

ping_mikrotik() {
    local HOST=$1
    local PORT=$2
    local USER=$3
    local PASS=$4
    
    log "📡 PING $HOST:$PORT"
    
    # Provo me telnet dhe expect
    RESULT=$(timeout 60 expect -c "
        log_user 1
        set timeout 30
        spawn telnet $HOST $PORT
        expect {
            \"Login:\" { send \"$USER\r\" }
            timeout { puts \"TIMEOUT_LOGIN\"; exit 1 }
            eof { puts \"CONNECTION_FAILED\"; exit 1 }
        }
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
        log "  ✅ $HOST - OK (packet-loss=0%)"
        return 0
    elif echo "$RESULT" | grep -q "no route to host"; then
        log "  ❌ $HOST - VPN DOWN (no route)"
        return 1
    elif echo "$RESULT" | grep -q "CONNECTION_FAILED\|Connection refused"; then
        log "  ⚠️ $HOST - CONNECTION FAILED"
        return 2
    else
        log "  ❌ $HOST - FAIL"
        return 1
    fi
}

log "=== MikroTik VPN Monitor Started ==="

# MikroTik 1: 185.9.139.65
ping_mikrotik "185.9.139.65" "6677" "loku" 'loku@12#'

# MikroTik 2: 158.173.160.34  
ping_mikrotik "158.173.160.34" "6677" "loku" 'loku!@34'

log "=== Monitor Finished ==="
