#!/bin/bash

# Obtener la lista de usuarios del sistema que no sean de servicio
users=$(awk -F: '$3 >= 1000 {print $1}' /etc/passwd)

# Iniciar el JSON para Zabbix LLD
json_start='['
json_end=']'

# Iterar sobre cada usuario y obtener la fecha de expiración de la contraseña
user_entries=()
for user in $users; do
  exp_date=$(sudo chage -l $user | grep "Password expires" | awk -F: '{print $2}' | xargs)

  if [[ "$exp_date" == "never" || -z "$exp_date" ]]; then
    # Si la contraseña no expira, establecer un valor especial (máxima fecha Unix Time)
    exp_date="253382413588"  # 9999-12-31 23:59:59 UTC en Unix Time
  elif [[ "$exp_date" == "password must be changed" ]]; then
    # Si la contraseña debe ser cambiada, establecer la fecha actual en Unix Time
    exp_date=$(date +%s)
  else
    # Convertir la fecha a formato Unix Time (epoch time)
    exp_date=$(date -d "$exp_date" +%s 2>/dev/null)
  fi

  # Agregar la entrada del usuario al JSON
  user_entries+=("{\"username\":\"$user\",\"expiration_date\":$exp_date}")
done

# Unir todas las entradas de usuarios con comas
json_content=$(IFS=,; echo "${user_entries[*]}")

# Formar el JSON completo
json_output="$json_start$json_content$json_end"

# Imprimir el JSON resultante
echo $json_output
