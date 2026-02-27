# Arquitectura de la Aplicación Navy PFA (Armada del Ecuador)

La aplicación ha sido reestructurada utilizando una **Arquitectura Basada en Funcionalidades (Feature-First Architecture)**. Este enfoque organiza el código no por tipo de archivo, sino por la funcionalidad de negocio a la que pertenece.

Esta estructura favorece la escalabilidad, la legibilidad y el trabajo en equipo, ya que todos los archivos relacionados con una característica específica están contenidos en su propio directorio.

## Árbol de Directorios Principal

El código fuente (`lib/`) está dividido en tres grandes bloques:

```text
lib/
├── core/                # 1. Base de la Aplicación
│   ├── constants/       # Variables globales, colores, espaciados
│   ├── routing/         # Configuración principal de navegación y menú inferior
│   └── theme/           # Definiciones globales de estilo (Temas oscuros y claros)
│
├── shared/              # 2. Componentes Compartidos
│   ├── models/          # Entidades de datos que se usan en más de una funcionalidad
│   ├── providers/       # Gestores de estado globales (Usuario, Políticas, etc.)
│   └── services/        # Servicios transversales (Base de Datos, Puntuación Local, JSON)
│
├── features/            # 3. Módulos / Funcionalidades (El Corazón de la App)
│    ├── chatbot/        # Asistente virtual basado en IA
│    ├── common/         # Pantallas genéricas (e.g. "En Construcción")
│    ├── exercise_tracking/# Seguimiento de ejercicio físico semanal
│    ├── home/           # Pantalla principal (Dashboard)
│    ├── nutrition/      # Guía nutricional
│    ├── offline/        # Estado offline / Sincronización
│    ├── performance/    # Rendimiento histórico del PFA
│    ├── regulations/    # Repositorio de reglamentos navales
│    ├── simulator/      # Calculadora interactiva del PFA
│    ├── training/       # Planes de entrenamiento y categorías
│    └── videos/         # Videoteca de instrucción física
│
└── main.dart            # Punto de entrada de la aplicación
```

## Beneficios del Enfoque Feature-First

1. **Contexto Aislado:** Si un desarrollador necesita modificar la lógica del simulador PFA, solo necesita revisar `lib/features/simulator/`. Ahí encontrará la interfaz visual (`simulator_screen.dart`), su lógica de negocio (`simulator_provider.dart`), y componentes visuales específicos si los hubiera.
2. **Menor Acoplamiento:** Promueve que las características sean independientes entre sí. Por ejemplo, el `chatbot` interactúa internamente con su `gemini_service.dart` sin interferir con la lógica del módulo de nutrición.
3. **Mantenibilidad a Largo Plazo:** A medida que la aplicación crezca, simplemente se agregarán nuevas carpetas bajo `lib/features/` (por ejemplo, `tienda`, `ajustes`, `mensajes`) sin hacer más grandes o caóticas las carpetas globales como `models` o `providers`.
