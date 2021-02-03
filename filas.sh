#!/bin/bash
#set -x

host=`hostname`
retidos=`/opt/zimbra/libexec/zmqstat | grep hold | cut -d"=" -f2`
corrompidos=`/opt/zimbra/libexec/zmqstat | grep corrupt | cut -d"=" -f2`
adiados=`/opt/zimbra/libexec/zmqstat | grep deferred | cut -d"=" -f2`
ativa=`/opt/zimbra/libexec/zmqstat | grep active | cut -d"=" -f2`
entrada=`/opt/zimbra/libexec/zmqstat | grep incoming | cut -d"=" -f2`

envia () {
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -z noc.ifsp.edu.br -p 10051 -k retidos -s $host -o $retidos
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -z noc.ifsp.edu.br -p 10051 -k corrompidos -s $host -o $corrompidos
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -z noc.ifsp.edu.br -p 10051 -k adiados -s $host -o $adiados
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -z noc.ifsp.edu.br -p 10051 -k ativa -s $host -o $ativa
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -z noc.ifsp.edu.br -p 10051 -k entrada -s $host -o $entrada
}


main () {
envia
}
main
