# CONTRIBUTING

Gracias por querer contribuir a ALCRIS. Esta guía explica cómo colaborar de forma eficiente: abrir issues, crear ramas, escribir commits claros y enviar pull requests.

Si prefieres, puedes escribir en español o en inglés. Responderemos tan pronto como podamos.

## Código de conducta
Por favor, sigue un comportamiento respetuoso y constructivo. Si no hay un `CODE_OF_CONDUCT.md` en el repo y quieres que añada uno (por ejemplo el de Contributor Covenant), dímelo y lo agrego.

## Cómo abrir un issue
1. Revisa los issues existentes para ver si tu propuesta o bug ya fue reportado.
2. Crea un nuevo issue con un título claro y una descripción que incluya:
   - Qué esperabas que ocurriera
   - Qué ocurrió en su lugar
   - Pasos para reproducir (si aplica)
   - Versión de Node / sistema operativo / otras dependencias relevantes
   - Mensajes de error y stack traces (si hay)
3. Etiqueta el issue si lo consideras (bug, enhancement, question).

Plantilla sugerida para bugs:
- Title: "bug: descripción corta"
- Body: Descripción, pasos para reproducir, comportamiento esperado y actual, logs, entorno

Plantilla sugerida para mejoras:
- Title: "feat: añadir ..." o "proposal: ..."
- Body: Motivación, propuesta de implementación, impacto en usuarios

## Cómo contribuir con código
1. Haz un fork del repositorio (si no tienes acceso directo) y clona tu fork:
   ```bash
   git clone https://github.com/tu-usuario/ALCRIS.git
   cd ALCRIS
   ```
2. Crea una rama nueva con un nombre claro y corto:
   - feat/<descripción-corta> — para nuevas funcionalidades
   - fix/<descripción-corta> — para correcciones de bugs
   - chore/<descripción-corta> — para tareas de mantenimiento

   Ejemplo:
   ```bash
   git checkout -b feat/presupuestos-v1
   ```
3. Asegúrate de tener las dependencias instaladas y el entorno listo (revisa README.md):
   ```bash
   npm install
   npm run dev
   ```
4. Haz commits pequeños y con mensajes descriptivos. Sigue este formato recomendado para mensajes de commit (tipo: alcance — descripción breve):
   - feat(presupuestos): añadir creación de presupuesto
   - fix(api/auth): corregir validación de token

   Ejemplo de flujo:
   ```bash
   git add .
   git commit -m "feat(clientes): añadir endpoint para buscar clientes por placa"
   git push origin feat/clientes-busqueda
   ```
5. Abre un Pull Request desde tu rama hacia `main` (o la rama de desarrollo si existe). En la descripción del PR incluye:
   - Qué cambia
   - Por qué cambia
   - Cómo probarlo localmente
   - Screenshots o GIFs si aplica

## Revisión de Pull Requests
- Los PRs serán revisados por los mantenedores.
- Pueden pedirse cambios: responde a los comentarios con commits que aborden las observaciones.
- Mantén tu rama actualizada con la rama base si el PR tarda en revisarse:
  ```bash
  git fetch upstream
  git rebase upstream/main
  # o git merge upstream/main
  ```

## Estándares de código
- Usa ESLint / Prettier si están configurados en el proyecto. Ejecuta linters antes de abrir el PR:
  ```bash
  npm run lint
  npm run format
  ```
- Mantén consistencia en la estructura del proyecto y nombres.
- Escribe tests cuando añadas funcionalidad (si el proyecto usa pruebas):
  ```bash
  npm test
  ```

## Pruebas
- Añade tests unitarios/integración para cambios significativos.
- Asegúrate de que la suite de tests pase antes de solicitar revisión.

## Seguridad y secretos
- No añadas credenciales, claves o secretos al repositorio.
- Usa variables de entorno y añade ejemplos en `.env.example`.

## Licencia y encabezados
- Asegúrate de que tu contribución cumpla la licencia MIT del proyecto.

## Preguntas frecuentes
- ¿Necesito abrir un issue antes de un PR? No es obligatorio, pero ayuda a coordinar trabajo grande.
- ¿Cómo propongo una arquitectura o cambio grande? Abre un issue con la propuesta, discusión y alternativas — así los mantenedores y colaboradores pueden opinar antes de desarrollar.

## Contacto
Si necesitas ayuda urgente o quieres que un mantenedor revise algo, menciona a los autores en GitHub: @JAHACARI (Janier) y a Joan Felipe.

---

Si quieres, puedo:
- Añadir plantillas de issue y PR en `.github/ISSUE_TEMPLATE/` y `.github/PULL_REQUEST_TEMPLATE.md`.
- Añadir `CODE_OF_CONDUCT.md` y un `CONTRIBUTING` en inglés también.
Dime qué más preparas y lo agrego.