name: Generador de Contraseñas

on:
  workflow_dispatch:
    inputs:
      semilla:
        description: 'Palabras base para generar la contraseña'
        required: false
        default: 'Eduardo Luis'
      admin_password:
        description: 'Contraseña de administrador para verificación'
        required: false
        default: 'YjQ2ZTYzNz'

jobs:
  generar:
    runs-on: ubuntu-latest
    steps:
      - name: Clonar repositorio
        uses: actions/checkout@v3

      - name: Instalar dependencias
        run: sudo apt-get update && sudo apt-get install -y openssl

      - name: Ejecutar generador
        run: |
          chmod +x generador.sh
          INPUT_SEMILLA="${{ github.event.inputs.semilla }}" \
          INPUT_ADMIN_PASSWORD="${{ github.event.inputs.admin_password }}" \
          ./generador.sh