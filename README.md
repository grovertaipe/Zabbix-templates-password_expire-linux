# Zabbix-templates-password_expire-linux
Este script de bash está diseñado para monitorear la expiración de contraseñas de usuarios en sistemas Linux, y está destinado a ser utilizado con Zabbix.

Configuración
1. Colocar el Script en la Ruta Específica
Copia el script expire_pwd.sh en la siguiente ruta en tu servidor Zabbix:

/etc/zabbix/zabbix_agent2.d/plugins.d/
2. Agregar la Línea de Configuración al Archivo de Configuración de Zabbix Agent
Abre el archivo de configuración de Zabbix Agent en tu servidor:

/etc/zabbix/zabbix_agent2.conf
Agrega la siguiente línea al final del archivo:

UserParameter=expiration.pwd,bash /etc/zabbix/zabbix_agent2.d/plugins.d/expire_pwd.sh
Guarda los cambios y cierra el archivo.

3. Configurar Permisos para el Usuario Zabbix
Abre el archivo /etc/sudoers en tu servidor utilizando el comando visudo:

sudo visudo
Agrega la siguiente línea al final del archivo para permitir que el usuario Zabbix ejecute el comando chage sin contraseña:

zabbix ALL=(ALL) NOPASSWD: /usr/bin/chage
Guarda los cambios y cierra el archivo.

4. Reiniciar el Servicio de Zabbix Agent
Para aplicar los cambios, reinicia el servicio de Zabbix Agent:

sudo systemctl restart zabbix-agent2
Uso en Zabbix
Una vez configurado, puedes usar este script junto con Zabbix para monitorear la expiración de contraseñas de usuarios en sistemas Linux.
