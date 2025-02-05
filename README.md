# flutter_estructura

lib/
├── main.dart                  # Punto de entrada de la aplicación.
├── models/                    # Define las clases de datos o estructuras del modelo.
│   └── reserva.dart           # Modelo de datos para manejar una reserva.
├── services/                  # Contiene la lógica para interactuar con APIs u otras fuentes de datos.
│   ├── api_findReserva.dart   # Lógica para consultar reservas desde el servidor.
│   ├── api_addReserva.dart    # Lógica para agregar reservas al servidor.
│   └── reserva_service.dart   # Abstracción de servicios relacionados con reservas (interfaz común).
├── viewmodels/                # Maneja la lógica y estado de las vistas.
│   └── reserva_viewmodel.dart # ViewModel para manejar el estado y lógica de la página de selección de horario.
├── views/                     # Contiene las pantallas o vistas principales de la app.
│   └── time_selection_page.dart # Vista para seleccionar una fecha y hora.
├── utils/                     # Funciones auxiliares y utilitarias.
│   └── time_utils.dart        # Funciones relacionadas con manejo de tiempo (generar horarios, etc.).
├── widgets/                   # Widgets personalizados reutilizables.
│   └── custom_date_picker.dart # Widget para manejar selección de fechas personalizado.
└── themes/                    # Temas y estilos globales.
    └── app_theme.dart         # Configuración de tema (colores, tipografías, etc.).

