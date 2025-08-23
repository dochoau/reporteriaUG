#!/bin/bash

# Obtener la ruta absoluta del directorio donde está este script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Ruta al ambiente virtual
VENV_DIR="$SCRIPT_DIR/venv"

# Activar el ambiente virtual
source "$VENV_DIR/bin/activate"

# Ejecutar el script Python desde el mismo directorio
"$VENV_DIR/bin/python" "$SCRIPT_DIR/reporteria.py"

# Desactivar el ambiente virtual
deactivate
