# ALCRIS

Sistema para la gestión de un taller de latonería y pintura: trabajos, clientes, presupuestos, inventario y facturación.

[![License](https://img.shields.io/badge/license-MIT-green.svg)](./LICENSE) [![Node](https://img.shields.io/badge/node-%3E%3D16-brightgreen)](https://nodejs.org/)

## Tabla de contenidos
- [Descripción](#descripción)
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

## Descripción
ALCRIS es una aplicación orientada a talleres de reparación de carrocería (latonería y pintura) que ayuda a gestionar clientes, vehículos, presupuestos, órdenes de trabajo, inventario y facturación.

## Características
- Gestión de clientes y vehículos.
- Creación, envío y seguimiento de presupuestos y órdenes de trabajo.
- Control de inventario de repuestos y pinturas.
- Gestión de facturación y generación de recibos/facturas.
- Historial de trabajos, incluidas fotos y documentación adjunta.
- Reportes básicos (ventas, inventario, trabajos realizados).

## Demo / Capturas
Añade capturas de pantalla o GIFs explicativos en `docs/screenshots/`.

![Captura](docs/screenshots/ejemplo.png)

## Requisitos
- Node.js >= 16
- npm o yarn
- (Opcional) Base de datos: SQLite, PostgreSQL o MongoDB según implementación

## Instalación
1. Clona el repositorio:
   ```bash
   git clone https://github.com/JAHACARI/ALCRIS.git
   ```
2. Entra al directorio del proyecto:
   ```bash
   cd ALCRIS
   ```
3. Instala dependencias:
   ```bash
   npm install
   # o con yarn
   # yarn install
   ```

Dependencias adicionales (ejemplos usadas en el proyecto; revisa `package.json` para la lista precisa):
- @supabase/ssr, @supabase/supabase-js
- bcrypt o bcryptjs
- cloudinary, multer, multer-storage-cloudinary
- express, cors, dotenv
- jsonwebtoken
- nodemailer

4. Copia y configura las variables de entorno a partir del ejemplo:
   ```bash
   cp .env.example .env
   ```
   Edita `.env` con tus credenciales y ajustes.

## Uso (desarrollo)
- Iniciar en modo desarrollo:
  ```bash
  npm run dev
  ```
- Generar build de producción:
  ```bash
  npm run build
  ```
- Ejecutar servidor en producción:
  ```bash
  npm start
  ```

## Configuración
Ejemplo de variables en `.env` (añade las que tu aplicación necesite):
```
PORT=3000
DATABASE_URL=postgres://user:pass@localhost:5432/alcris
JWT_SECRET=tu_secreto_aqui
CLOUDINARY_URL=cloudinary://key:secret@cloud_name
EMAIL_USER=cuenta@ejemplo.com
EMAIL_PASS=tu_password
```
Incluye un archivo `.env.example` con las variables necesarias y valores de ejemplo.

## Estructura del proyecto (sugerida)
- /src — código fuente
- /public — archivos estáticos
- /docs — documentación y capturas
- /tests — pruebas
- /config — configuración y utilidades
- /scripts — scripts útiles

Ajusta la estructura real según la implementación en el repositorio.

## Scripts útiles
- `npm run dev` — iniciar en desarrollo
- `npm run build` — compilar para producción
- `npm start` — ejecutar en producción
- `npm test` — ejecutar pruebas
- `npm run lint` — ejecutar linters

Revisa `package.json` para confirmar los scripts disponibles.

## Contribuir
¡Gracias por querer contribuir!
1. Abre un issue describiendo la propuesta o bug.
2. Crea una rama para tu trabajo:
   ```bash
   git checkout -b feat/nueva-funcionalidad
   ```
3. Haz commits pequeños y descriptivos.
4. Envía un pull request explicando los cambios.

Lee `CONTRIBUTING.md` si existe para normas más detalladas.

## Licencia
Este proyecto está bajo la licencia MIT. Consulta el archivo `LICENSE` para más detalles.

## Contacto
- Autor: Janier Hair (JAHACARI) — https://github.com/JAHACARI
- Autor: Joan Felipe
- Correo: (añade un correo de contacto si lo deseas)

Si quieres que complete también el `.env.example`, `CONTRIBUTING.md` o agregue capturas en `docs/screenshots/`, dímelo y lo preparo.

## Agradecimientos
- Gracias a las librerías y recursos usados (por ejemplo: Express, Supabase, Cloudinary).
