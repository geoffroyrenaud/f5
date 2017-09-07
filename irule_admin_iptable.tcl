# This irule quickly manage a blacklist table to block & maintain bad ips with the irule irule_iptable.tcl

when RULE_INIT {
    # 10 min
    set static::timeout 600
}

when HTTP_REQUEST {

    set response "<html><body>\n"

    switch -glob [HTTP::path] {

        "/list*" {  
            set tablename "blacklist"
            if { [HTTP::path] contains "/list" } {
                foreach key [table keys -subtable $tablename -notouch] {
                    set remain [table timeout -subtable $tablename -remaining $key]
                    set response "$response$key : $remain seconds<br/>\n"
                }
                HTTP::respond 200 content "$response</body></html>"
                return
            } 
        }

        "/add*" {
            set myaddips [split [URI::query [HTTP::uri] ip] ","]
            if { [info exists myaddips] && ($myaddips != "") } {
                log local0. "ADD $myaddips"
                foreach ip $myaddips {
                    log local0. "SET BL ADD ip = $ip"
                    set response "$response BL ADD ip = $ip<br/>\n"
                    table set -subtable "blacklist" $ip "blocked" $static::timeout
                }
            }
        }
         
        "/del*" {
            set mydelips [split [URI::query [HTTP::uri] ip] ","]
            log local0. "DELL $mydelips"
            if {[info exists mydelips] && ($mydelips != "") } {
                foreach ip $mydelips {
                    log local0. "DEL BL ip = $ip"
                    set response "$response BL DEL ip = $ip<br/>\n"
                    table delete -subtable "blacklist" $ip
                }
            }
        }

        default {  
           HTTP::respond 501 content "<html><body> invalid query </body></html>"
           return
        }  
    }
    

    HTTP::respond 200 content "$response</body></html>"
}
