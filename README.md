# ALCRIS

![License](https://img.shields.io/badge/license-MIT-green.svg)
![Node](https://img.shields.io/badge/node-%3E%3D16-brightgreen)

ALCRIS — Sistema para la gestión de un taller de latonería y pintura. Permite gestionar clientes, vehículos, presupuestos, órdenes de trabajo, inventario y facturación.

## Tabla de contenidos
- [Características](#características)
- [Demo / Capturas](#demo--capturas)
- [Requisitos](#requisitos)
- [Instalación](#instalación)
- [Uso (desarrollo)](#uso-desarrollo)
- [Configuración](#configuración)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Scripts útiles](#scripts-útiles)
- [Contribuir](#contribuir)
- [Licencia](#licencia)
- [Contacto](#contacto)
- [Agradecimientos](#agradecimientos)

## Características
- Gestión de clientes y vehículos.
- Creación y seguimiento de presupuestos y órdenes de trabajo.
- Control de inventario (repuestos y pintura).
- Generación de facturas y reportes.
- Historial de trabajos y fotos asociadas.

## Demo / Capturas
Añadí capturas o GIFs en `docs/screenshots/`. Ejemplo de imagen:
![Captura](docs/screenshots/ejemplo.png)

## Requisitos
- Node.js >= 16
- npm o yarn
- (Opcional) Base de datos: SQLite / PostgreSQL / MongoDB (configurable según implementación)

## Instalación
1. Clona el repositorio:
   git clone https://github.com/JAHACARI/ALCRIS.git
2. Entra al directorio:
   cd ALCRIS
3. Instala dependencias (ejemplo):
   npm install
   # Dependencias usadas en el proyecto (ejemplo):
   npm install @supabase/ssr @supabase/supabase-js bcrypt bcryptjs cloudinary cors dotenv express jsonwebtoken multer multer-storage-cloudinary nodemailer

4. Copia y configura variables de entorno:
   cp .env.example .env
   Edita `.env` con tus credenciales y ajustes.

## Uso (desarrollo)
- Iniciar en modo desarrollo:
  npm run dev
- Generar build de producción:
  npm run build
- Ejecutar servidor en producción:
  npm start

## Configuración
Ejemplo mínimo de `.env`:
PORT=3000
DATABASE_URL=postgres://user:pass@localhost:5432/alcris
JWT_SECRET=tu_secreto_aqui
CLOUDINARY_URL=cloudinary://api_key:api_secret@cloud_name

Asegurate de añadir un `.env.example` con las variables necesarias.

## Estructura del proyecto
- /src — código fuente
- /public — archivos estáticos
- /docs — documentación y capturas
- /tests — pruebas
(Ajusta según la estructura real del repo)

## Scripts útiles
- npm run dev — desarrollo
- npm run build — compilar
- npm test — ejecutar pruebas
- npm run lint — linters

## Contribuir
1. Abre un issue describiendo tu propuesta o bug.
2. Crea una rama: `git checkout -b feat/nueva-funcionalidad`
3. Haz commits pequeños y descriptivos.
4. Envía un pull request explicando los cambios.

Lee `CONTRIBUTING.md` si existe para normas más detalladas.

## Licencia
Este proyecto está bajo la licencia MIT. Consulta el archivo LICENSE para más detalles.

## Contacto
- Autores:
  - Janier Hair (JAHACARI) — https://github.com/JAHACARI
  - Joan Felipe — (añadir perfil/email)
- Email: (opcional — añadir si querés)

