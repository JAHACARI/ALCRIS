# ALCRIS

[Descripción corta]
ALCRIS — Sistema para la gestión de un negocio de latonería y pintura. Permite gestionar trabajos, clientes, presupuestos, inventario y facturación para talleres de carrocería.

<!-- Badges: reemplaza las URLs según tengas CI/paquetes -->
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Node](https://img.shields.io/badge/node-%3E%3D16-brightgreen)

## Tabla de contenidos
- [Características](#características)
- [Demo / Capturas](#demo--capturas)
- [Requisitos](#requisitos)
- [Instalación](#instalación)
- [Uso](#uso)
- [Configuración](#configuración)
- [Estructura del proyecto](#estructura-del-proyecto)
- [Scripts útiles](#scripts-útiles)
- [Contribuir](#contribuir)
- [Licencia](#licencia)
- [Contacto](#contacto)

## Características
- Gestión de clientes y vehículos.
- Creación y seguimiento de presupuestos y órdenes de trabajo.
- Control de inventario de repuestos y pintura.
- Generación de facturas y reportes.
- Historial de trabajos y fotos asociadas.

## Demo / Capturas
> Añade aquí capturas de pantalla o GIFs explicativos
![Captura](docs/screenshots/ejemplo.png)

## Requisitos
- Node.js >= 16
- npm o yarn
- (Opcional) base de datos: SQLite / PostgreSQL / MongoDB (especificar según implementes)

## Instalación
1. Clona el repositorio:
   git clone https://github.com/JAHACARI/ALCRIS.git
2. Entra al directorio:
   cd ALCRIS
3. Instala dependencias:
4. 
   npm install @supabase/ssr @supabase/supabase-js bcrypt bcryptjs cloudinary cors dotenv express jsonwebtoken multer multer-storage-cloudinary nodemailer
5. Copia y configura variables de entorno:
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
- .env (ejemplo)
  PORT=3000
  DATABASE_URL=postgres://user:pass@localhost:5432/alcris
  JWT_SECRET=tu_secreto_aqui

Incluye un archivo `.env.example` con las variables necesarias.

## Estructura del proyecto
- /src — código fuente
- /public — archivos estáticos
- /docs — documentación y capturas
- /tests — pruebas

(Ajusta la estructura real según tu repo)

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
Lee `CONTRIBUTING.md` para normas más detalladas.

## Licencia
-Este proyecto está bajo la licencia MIT. Consulta el archivo LICENSE para más detalles.

## Contacto
-Autor: JAHACARI- Janier Hair
-Autor: Joan Felipe
-Correo / GitHub: https://github.com/JAHACARI
-Correo / GitHub: 

## Agradecimientos
- Gracias a las librerías y recursos usados (menciona los que uses, p.ej., Express, React, Sequelize).
