# 🏥 Descripción del análisis

**Este estudio compara el sistema de salud en México con datos de la OMS (World Health Organization, 2024). Para el análisis, seleccioné países con sistemas de salud altamente eficientes según el World Health Statistics 2024:**

✔️ Dinamarca como referencia principal (sistema de salud público)

✔️ Cuba como alternativa para variables sin datos en Dinamarca

### ⚠️ Consideraciones
📌 Fuente de datos: Todas las fuentes de datos se encuentran citadas dentro del análisis.

📌 Factores externos: Algunas variables incluyen aspectos ajenos al sistema de salud (ej. violencia).

📌El análisis se realizó con fines de aprendizaje y práctica. 

### 📉 Hallazgos clave
🔹 Cobertura médica (UHC Index): México está 7.41 puntos por debajo de Dinamarca en la escala (1-100) que mide acceso a servicios de salud.

🔹 Agua potable y saneamiento: Dinamarca supera el 98% en cobertura, mientras México varía entre 43% y 64% según el servicio.

🔹 Inmunización (vacunación): México alcanza 80%+ de cobertura, pero Dinamarca supera el 90% en la mayoría de las campañas.

🔹 Mortalidad materna: En México es de 59.13 por cada 100,000 nacidos vivos, mientras que en Dinamarca es de solo 4.66.

🔹 Obesidad en adultos (+18 años): México 36%, Dinamarca 13.28%.

🔹 Esperanza de vida (nacidos en 2021): México 70.83 años, Dinamarca 80.18 años.

### 💡 Conclusión y reflexiones
México aún tiene grandes retos en su sistema de salud, pero no todo son malas noticias. La recolección de datos de organismos oficiales como la OMS permite identificar áreas de mejora y tomar decisiones informadas. Compararnos con países con sistemas eficientes como Dinamarca nos ayuda a visualizar qué funciona y qué necesita atención urgente.

**🛠 Metodología y herramientas utilizadas**

🔹 Excel & VS Code → Limpieza y reencoding del dataset.

🔹 PostgreSQL (PGAdmin) → Exploración, validación, creación de vistas/tablas comparativas.

🔹 Metabase (Java) → Visualización de los resultados.

**Extra info**

**🤔 ¿Vale la pena usar Metabase?**

✅ Pros:

✔️ Gratuito y fácil de usar.

✔️ Compatible con PostgreSQL, MySQL, SQL Server, Google BigQuery y otras.

✔️ No requiere programar en Java, aunque sí necesita Java 11 o superior.

⚠️ Contras:

❌ Para compartir dashboards interactivos, necesitas hospedar Metabase en servidores como AWS, Google Cloud o Azure.

❌ Solo permite compartir dashboards estáticos en PDF de forma local.
