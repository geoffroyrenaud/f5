# F5 BigIP

Personnal test & try with F5 BigIP.

### Irule

* irule_admin_iptable.tcl

This irule permit to quickly manage a "blacklist" table to block & maintain bad IPs for the irule irule_iptable.tcl
The goal is to dynamicaly blacklist some IPs with queries based on tools like Splunk or ELK on comportemental or statistics bad usage.

* irule_iptable.tcl

This irule is used to protect your virt, it can block IPs based on a table "blacklist"

### Python code

