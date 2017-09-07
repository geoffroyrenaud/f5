# This irule is used to protect your virt, in order to maintain in a blacklist some ips

when RULE_INIT {
    # 10 min
    set static::timeout 600
}

when CLIENT_ACCEPTED {
# Layer 4
    set srcip [IP::remote_addr]
    if { [table lookup -subtable "blacklist" $srcip] != "" } {
        log local0. "Update timeout for $srcip (L4)"
        table timeout -subtable "blacklist" $srcip $static::timeout
        drop
        return
    }
}

when HTTP_REQUEST {
# Layer 7
    set srcip [IP::remote_addr]
    if { [table lookup -subtable "blacklist" $srcip] != "" } {
        log local0. "Update timeout for $srcip (L7)"
        table timeout -subtable "blacklist" $srcip $static::timeout
        drop
        return
    }
}
