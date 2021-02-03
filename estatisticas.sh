#!/bin/bash
#set -x

# Apresenta APENAS  o valor da ultima hora (2 digitos)
hora=`date --date='1 hour ago' +%H`

ZABBIX=`URL_ZABBIX-SERVER`
host=`hostname`
# Salva as estatisticas do dia no arquivo estatistica.txt
# pflogsumm.pl /var/log/zimbra.log -d today > /etc/zabbix/scripts/estatistica.txt | Alterado pela linha abaixo para funcionar com o CRON
/usr/local/bin/pflogsumm.pl /var/log/zimbra.log -d today > /etc/zabbix/scripts/estatisticas.txt

# Le os valores do arquivo, filtrando o valor da ultima hora de acordo com a variavel.
recebidos=`head -53 /etc/zabbix/scripts/estatisticas.txt | tail -32 | grep $hora"00-" | tr -s ' ' | cut -d ' ' -f3`
entregues=`head -53 /etc/zabbix/scripts/estatisticas.txt | tail -32 | grep $hora"00-" | tr -s ' ' | cut -d ' ' -f4`
deferred=`head -53 /etc/zabbix/scripts/estatisticas.txt | tail -32 | grep $hora"00-" | tr -s ' ' | cut -d ' ' -f5`
erros=`head -53 /etc/zabbix/scripts/estatisticas.txt | tail -32 | grep $hora"00-" | tr -s ' ' | cut -d ' ' -f6`
rejeitados=`head -53 /etc/zabbix/scripts/estatisticas.txt | tail -32 | grep $hora"00-" | tr -s ' ' | cut -d ' ' -f7`
total=$(($rebidos+$entregues+$deferred+$erros+$rejeitados))


envia () {
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -z $ZABBIX -p 10051 -k recebidos -s $host -o $recebidos
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -z $ZABBIX -p 10051 -k entregues -s $host -o $entregues
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -z $ZABBIX -p 10051 -k deferred -s $host -o $deferred
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -z $ZABBIX -p 10051 -k erros -s $host -o $erros
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -z $ZABBIX -p 10051 -k rejeitados -s $host -o $rejeitados
zabbix_sender -c /etc/zabbix/zabbix_agentd.conf -z $ZABBIX -p 10051 -k total -s $host -o $total
}

main () {
envia
}
main
