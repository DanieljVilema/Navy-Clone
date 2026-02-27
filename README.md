# Navy PFA - Armada Ecuador

Aplicación móvil Flutter offline-first para autoevaluación, entrenamiento, consulta de reglamentos y asistencia IA.

## Módulos
1. Simulador (Calculadora de Baremos)
2. Centro de Entrenamiento (Videos)
3. Mi Rendimiento (Historial)
4. Salud y Nutrición
5. Chatbot Asistente (IA)

## Tecnologías
- Flutter
- sqflite
- chewie
- fl_chart
- Gemini/OpenAI API

## Estructura
- lib/modules/
- lib/models/
- lib/services/
- assets/videos/
- assets/images/
- assets/baremos.json

## Requisitos Previos
- **Flutter SDK** (>=3.0.0) instalado y configurado en el PATH
- **Google Chrome** instalado (para correr en web)
- **Git** (opcional, para clonar el repositorio)

## Instalación y Configuración

1. **Clona el repositorio** (o descarga el ZIP):
   ```bash
   git clone <url-del-repositorio>
   cd Navy-Clone-main
   ```

2. **Crea el archivo `.env`** en la raíz del proyecto:
   ```bash
   GEMINI_API_KEY=tu_api_key_aqui
   ```
   > ⚠️ Sin una API Key válida de Gemini, el chatbot no funcionará, pero el resto de la app sí.

3. **Instala las dependencias**:
   ```bash
   flutter pub get
   ```

## Cómo Correr el Proyecto

### En Chrome (Web)
```bash
flutter run -d chrome
```

### Comandos útiles mientras corre
| Tecla | Acción |
|-------|--------|
| `r` | Hot reload (aplica cambios rápido) |
| `R` | Hot restart (reinicio completo) |
| `q` | Cerrar la aplicación |
| `d` | Desconectar (deja la app corriendo en el navegador) |

## Uso
- La app funciona **offline**, solo el chatbot requiere conexión a internet.

## Créditos
- Armada del Ecuador
- Desarrollador: [Tu Nombre]
