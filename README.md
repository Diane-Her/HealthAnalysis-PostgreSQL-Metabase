# Proyecto de Análisis comparativo.
Este proyecto tiene como objetivo comparar los sistemas de salud de México y Dinamarca utilizando datos reportados por la World Health Organization en el año 2024.
Debido a la naturaleza comparativa del análisis, el dashboard incluye gráficos de barras y barras apiladas para facilitar la interpretación visual.

**Puedes explorar el dashboard estático en el documento adjunto en el repositorio**

Para este proyecto se utilizó:
 - Excel
 - Microsoft VSCode
 - PostgreSQL
 - Java (Metabase)

 

## Pasos Realizados

1. **Limpieza previa de datos en Excel y Re-encoding en VSC**
   - Se realizó limpieza y eliminación de datos duplicados, espacios y caracteres no ASCII.
   - Se realizó reencoding del dataset a UTF-8 para evitar errores de carga en la base de datos.
   
2. **Importación de Datos a PostgreSQL**
   - Creación de tabla y asignación de formatos.
   - Verificación y limpieza del dataset para asegurar la integridad de los datos.
   
3. **Revisión y organización de la información**
   - Verificación de variables y clasificación en categorías para una mejor agrupación
   - Creación de vistas y tablas específicas para la realización de gráficos comparativos.

4. **Crear conexión con metabase mediante Java para la elaboración de gráficas**
  
5. **Creación de gráficas**
   - Cada gráfica del dashboard interactivo cuenta con su información en la caja informativa.
   - Para la versión estática del dashboard se adjuntó la información en cuadros de texto.
  
6. **Generación de Reporte final escrito**
   -Incluye la descripción de las gráficas y una breve discusión sobre la información presentada.
   - Se encuentra en la versión estática del dasboard

**Nota: Con Metabase es posible crear dashboards interactivos. Sin embargo, para compartir el enlace de forma pública,** 
      **es necesario instalar Metabase en una instancia accesible públicamente, como AWS. Este paso fue omitido en este proyecto.**


## Acceso a la descarga de base de datos original
 [WHO, 2024](https://data.who.int/)

## Autor
[Diana Herrera](https://www.linkedin.com/in/diana-herrera-aa7aa6197/)

