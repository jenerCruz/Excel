#!/bin/bash

# --- Configuración ---
HISTORIAL_FILE="output/historial_contrasenas.txt"
DICCIONARIO="diccionario_comun.txt"
mkdir -p output

# --- Detecta si está en GitHub Actions ---
if [ "$GITHUB_ACTIONS" = "true" ]; then
    palabras=${INPUT_SEMILLA:-"Eduardo Luis"}
    echo "⚙️ Modo automático (GitHub Actions). Semilla: '$palabras'"
else
    read -p "🔑 Ingresa las palabras para generar la contraseña (Enter para 'Eduardo Luis'): " palabras
    palabras=${palabras:-"Eduardo Luis"}
fi

# --- Crear diccionario si no existe ---
if [ ! -f "$DICCIONARIO" ]; then
  cat > "$DICCIONARIO" <<EOF
password
123456
admin
eduardo
luis
wifi
telmex
huawei
contraseña
EOF
fi

# --- Validar semilla contra diccionario ---
while IFS= read -r palabra; do
  if [[ "$palabras" == *"$palabra"* ]]; then
    echo "⚠️ Semilla contiene palabra común: '$palabra'."
    if [ "$GITHUB_ACTIONS" != "true" ]; then
      read -p "¿Quieres continuar de todos modos? (s/n): " respuesta
      if [ "$respuesta" != "s" ]; then
        echo "🔄 Generación cancelada."
        exit 1
      fi
    fi
  fi
done < "$DICCIONARIO"

# --- Generar contraseña segura ---
contrasena=$(echo -n "$palabras" | sha256sum | base64 | cut -c1-12)
fecha_hora=$(date +"%Y-%m-%d %H:%M:%S")
echo "📅 $fecha_hora | Contraseña: $contrasena | Semilla: '$palabras'" >> "$HISTORIAL_FILE"
echo "🔐 Contraseña generada: $contrasena"