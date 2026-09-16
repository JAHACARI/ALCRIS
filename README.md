# ALCRIS

## Backend

Descripción
- Backend en Node.js para ALCRIS que gestiona autenticación, catálogo, chat, reservas, servicios, técnicos, usuarios y vehículos. Está organizado en controladores, rutas, modelos y servicios. Usa Supabase (config/supabase.js) como proveedor de datos/autenticación y dispone de un servicio de correo (services/emailService.js).

Stack
- **Lenguaje:** JavaScript (Node.js)
- **Runtime / framework:** Node.js (aplicación basada en `index.js`)
- **Componentes notables:** Supabase (config/supabase.js), middleware de autenticación (middleware/authMiddleware.js), servicio de correo (services/emailService.js)

Estructura importante

backend/
- .env.example                 — plantilla de variables de entorno
- package.json                 — dependencias y scripts
- package-lock.json
- index.js                     — punto de entrada de la aplicación
- config/
  - supabase.js                — configuración/cliente de Supabase
- middleware/
  - authMiddleware.js          — protección de rutas / verificación de token
- services/
  - emailService.js            — envío de correos
- controllers/                 — controladores por dominio (subcarpetas)
  - auth/, catalogo/, chat/, reserva/, servicio/, tecnico/, usuario/, vehiculo/
- models/                      — modelos por dominio (subcarpetas)
  - auth/, catalogo/, chat/, reserva/, servicio/, tecnico/, usuario/, vehiculo/
- routes/                      — definición de rutas por dominio (subcarpetas)
  - auth/, catalogo/, chat/, reserva/, servicio/, tecnico/, usuario/, vehiculo/

Cómo se integra (resumen)
- La aplicación arranca desde `index.js`, monta middleware (p. ej. `authMiddleware`) y registra rutas agrupadas por dominio (carpetas en `routes/`). Las rutas delegan en controladores (`controllers/`) que usan servicios (`services/`) y modelos (`models/`) para acceder a la persistencia (Supabase está configurado en `config/supabase.js`).

Cómo ejecutar (mínimo)
1. Clona el repositorio y cambia a la rama JANIER:
   ```bash
   git clone https://github.com/JAHACARI/ALCRIS.git
   cd ALCRIS
   git checkout JANIER
   ```
2. Ve al directorio backend e instala dependencias:
   ```bash
   cd backend
   npm install
   ```
3. Configura variables de entorno copiando el ejemplo y completando los valores:
   ```bash
   cp .env.example .env
   # editar .env con Supabase URL/KEY, credenciales de correo, PORT, etc.
   ```
4. Arranca la app (según scripts en package.json):
   ```bash
   node index.js
   # o
   npm run start
   # para desarrollo (si existe):
   npm run dev
   ```

Variables de entorno
- Rellena `.env` a partir de `.env.example`. Presta especial atención a:
  - Datos de Supabase (URL y KEY)
  - Configuración SMTP o credenciales de servicio de correo si `emailService.js` lo requiere
  - PORT y NODE_ENV

Rutas / endpoints (vista general)
- La API está organizada por dominios; espera endpoints en rutas como:
  - `/auth`
  - `/catalogo`
  - `/chat`
  - `/reserva`
  - `/servicio`
  - `/tecnico`
  - `/usuario`
  - `/vehiculo`
- Cada dominio tiene su carpeta `routes/` y `controllers/` — revisa esas carpetas para ver los endpoints y la lógica específica.

Notas para desarrolladores
- `middleware/authMiddleware.js` valida tokens y protege rutas: revísalo antes de añadir endpoints públicos.
- `config/supabase.js` centraliza la conexión con Supabase; comprueba que las variables de entorno usadas coinciden con las definidas en `.env.example`.
- `services/emailService.js` sugiere integración con SMTP o un proveedor de correo; revisa credenciales y plantillas.
- La estructura modular (routes → controllers → services → models) facilita pruebas y mantenimiento.

Recomendaciones y comprobaciones rápidas
- Abrir `backend/package.json` para ver scripts útiles (`start`, `dev`, `test`).
- Probar los endpoints con Postman o curl tras levantar la app.
- Añadir un README en `backend/` con detalles de endpoints si deseas documentación por módulo.

Cómo contribuir
- Crear una rama `feature/<nombre>`, hacer cambios y abrir PR contra `JANIER` (o contra la rama principal según el flujo del proyecto).
- Añadir tests para nuevas funciones si la base los soporta.
- Documentar cualquier nueva variable de entorno en `.env.example`.

Contacto
- Para dudas o detalles sobre rutas específicas, indícame qué módulo quieres que documente (por ejemplo: `auth`, `reserva` o `servicio`) y preparo una sección de endpoints con ejemplos de request/response.

---

_He generado este README basándome en el contenido de la rama `JANIER`, inspeccionando `backend/index.js`, `package.json`, `.env.example`, `config/supabase.js`, `middleware/authMiddleware.js`, `services/emailService.js` y la estructura de carpetas `controllers/`, `models/` y `routes/`._