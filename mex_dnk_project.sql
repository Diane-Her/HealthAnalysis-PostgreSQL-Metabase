DROP TABLE IF EXISTS t_health;
CREATE TABLE t_health(
      ind_name TEXT,
	  dim_geo_name VARCHAR(150),
	  ind_code VARCHAR(100),
	  dim_geo_code VARCHAR(50),
	  dim_time_year INT,
	  dim_1_code VARCHAR(50),
	  value_numeric REAL,
	  value_string TEXT,
	  value_text TEXT);

-- Para poder importar los valores a la tabla se hizo una limpieza previa y re encoding
-- utilizando Excel para sustitución de caracteres NO ASCII y eliminación de espaciado innecesario 
-- y MicrosoftVSC para verificación y re encoding UTF8

SELECT * FROM t_health;

-- Verificar las diferentes variables que se evaluaron

SELECT COUNT(*) FROM t_health
WHERE dim_geo_name = 'Afghanistan'; -- Existen 55 registros

SELECT COUNT(*) FROM t_health
WHERE dim_geo_name = 'African Region'; --Existen 58 registros


-- Esto indica que no se evaluaron el mismo número de variables para todos los países

SELECT COUNT(DISTINCT(dim_geo_name)) AS "paises"
FROM t_health;

-- Se evaluaron 206 países

SELECT dim_geo_name, COUNT(*) AS num_variables
FROM t_health
GROUP BY dim_geo_name
ORDER BY num_variables DESC;

-- Con esto podemos observar que las variables evaluadas por país varían desde
-- 4 para para la región del sud este de la región de Asia, hasta 62 para países como Colombia
-- y República Unida de Tanzania


--Para este proyecto vamos a comparar los valores de salud en México contra los de Dinamarca
--Uno de los mejores sistemas de salud del mundo.


SELECT COUNT(ind_name), dim_geo_name
FROM t_health WHERE dim_geo_name IN ('Denmark', 'Mexico')
GROUP BY dim_geo_name
ORDER BY dim_geo_name;

--Podemos ver que se evaluaron 51 variables para Dinamarca y 57 para México
--Se realizarán algunas comparaciones. Nota: a falta del dato de Dinamarca, se colocará un dato de 
--Estados Unidos, Canadá o Cuba -Cualquiera que lo tenga disponible, en ese orden.

-- Monitorear el UHC (Indicador que mide la cobertura de servicios de salud escenciales)
-- Los resultados corresponden al año 2021, se utilizó USA a falta del dato para DNK


CREATE VIEW uhc_index AS
(SELECT dim_geo_code AS Country, value_numeric AS "UHC: Service coverage Index"
FROM t_health WHERE dim_geo_code IN('DNK', 'MEX', 'CUB') --Agregamos Cuba para las variables faltantes 
AND ind_name = 'UHC: Service coverage index');
SELECT * FROM uhc_index;

-- "Asistencia oficial neta total para el desarrollo destinada a la investigación médica y a los sectores básicos de salud per cápita (USD), por país receptor"
-- "Total net official development assistance to medical research and basic health sectors per capita (US$), by recipient country "
--Datos del 2022

CREATE VIEW medical_research AS (
SELECT dim_geo_code AS Country, value_numeric AS "Medical research and basic health sectors per capita (US$)" 
FROM t_health WHERE dim_geo_code IN('MEX','CUB')
AND ind_name LIKE '%research%');
SELECT* FROM medical_research;


--"Average of 15 International Health Regulations core capacity scores" 2023

CREATE VIEW health_regulations AS (
SELECT dim_geo_code AS Country, value_numeric AS "AVG of 15 International Health Regulations core capacity scores" 
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%scores%');
SELECT * FROM health_regulations;

-- "Amount of water- and sanitation-related official development assistance that is part of a government-coordinated spending plan (constant 2020 US$ millions)"

CREATE VIEW spending_plan AS(
SELECT dim_geo_code AS Country, value_numeric AS "Water- and sanitation-related spending plan (US$ millions)"
FROM t_health WHERE dim_geo_code IN('MEX', 'CUB')
AND ind_name = 'Amount of water- and sanitation-related official development assistance that is part of a government-coordinated spending plan (constant 2020 US$ millions)');
SELECT * FROM spending_plan;

--CREAR TABLA CON LAS 4 VISTAS government_coverage
CREATE TABLE t_government_coverage AS (
SELECT uhc_index.Country, uhc_index."UHC: Service coverage Index",
       health_regulations."AVG of 15 International Health Regulations core capacity scores",
	   medical_research."Medical research and basic health sectors per capita (US$)",
	   spending_plan."Water- and sanitation-related spending plan (US$ millions)"
FROM uhc_index
FULL JOIN health_regulations ON uhc_index.Country = health_regulations.Country
FULL JOIN medical_research ON uhc_index.Country = medical_research.Country
FULL JOIN spending_plan ON uhc_index.Country = spending_plan.Country);

SELECT * FROM t_government_coverage;



-- Analisis de porcentaje de población con acceso a servicios de sanitización seguros 2022
CREATE VIEW sanitation AS
(SELECT dim_geo_code AS Country, value_numeric AS "Safely-managed sanititation services access (%)"
FROM t_health WHERE dim_geo_code IN ('DNK', 'MEX')
AND ind_name LIKE '%sanitation services%');
SELECT* FROM sanitation;


-- Los datos corresponden al 2022
CREATE VIEW drinking_water AS
(SELECT dim_geo_code AS Country, value_numeric AS "Safely-managed drinking-water services access (%)"
FROM t_health WHERE dim_geo_code IN('DNK', 'MEX')
AND ind_name = 'Proportion of population using safely-managed drinking-water services (%)'
);
SELECT * FROM drinking_water;

--Proportion of safely treated domestic wastewater flows (%), 2022
CREATE VIEW wastewater AS
(SELECT dim_geo_code AS Country, value_numeric AS "Treated wastewater flows (%)"
FROM t_health WHERE dim_geo_code IN('DNK', 'MEX')
AND ind_name LIKE '%wastewater%');
SELECT * FROM wastewater;


--Crear la tabla con las tres vistas acerca de acceso a agua

DROP TABLE IF EXISTS t_water_sanitation;
CREATE TABLE t_water_sanitation AS(
SELECT 
 sanitation.Country, sanitation."Safely-managed sanititation services access (%)",
 drinking_water."Safely-managed drinking-water services access (%)",
 wastewater."Treated wastewater flows (%)"
 FROM sanitation 
 FULL JOIN drinking_water ON sanitation.Country = drinking_water.Country
 FULL JOIN wastewater ON sanitation.Country = wastewater.Country);
SELECT * FROM t_water_sanitation;


--ANALISIS DE ACCESO A DIFERENTES ESPECIALISTAS
--Crear las vistas para la tabla

--Los datos corresponden a datos de entre 2020 (DNK) a 2021(MEX)
CREATE VIEW dentists AS (
SELECT dim_geo_code AS Country, value_numeric AS "Density of dentists (per 10 000 population)"
FROM t_health WHERE dim_geo_code IN('DNK', 'MEX')
AND ind_name LIKE '%dentists%');

--Los datos corresponden a datos del 2020(DNK) 2021(MEX)
CREATE VIEW doctors AS (
SELECT dim_geo_code AS Country, value_numeric AS "Density of medical doctors (per 10 000 population)"
FROM t_health WHERE dim_geo_code IN('DNK', 'MEX')
AND ind_name LIKE '%doctors%');

-- "Density of nursing and midwifery personnel (per 10 000 population) "
--DNK(2021), MEX(2021)
CREATE VIEW nursing AS (
SELECT dim_geo_code AS Country, value_numeric AS "Dens of nursing & midwifery pers (per 10 000 population)"
FROM t_health WHERE dim_geo_code IN('DNK', 'MEX')
AND ind_name LIKE '%nursing%');


--"Density of pharmacists (per 10 000 population) "
-- Sin valores para México, por lo que se omitió


--Personal capacitado para atender partos, 2022.
CREATE VIEW birth_personnel AS (
SELECT dim_geo_code AS Country, value_numeric AS "Births attended by skilled health personnel (%)"
FROM t_health WHERE dim_geo_code IN('DNK', 'MEX')
AND ind_name = 'Proportion of births attended by skilled health personnel (%)');
SELECT *FROM birth_personnel;

CREATE TABLE t_medical_personnel AS (
SELECT 
	dentists.Country, dentists."Density of dentists (per 10 000 population)",
	doctors."Density of medical doctors (per 10 000 population)",
	nursing."Dens of nursing & midwifery pers (per 10 000 population)",
	birth_personnel."Births attended by skilled health personnel (%)"
FROM dentists 
	INNER JOIN doctors ON dentists.Country = doctors.Country
	INNER JOIN nursing ON dentists.Country = nursing.Country
	INNER JOIN birth_personnel ON dentists.Country = birth_personnel.Country);
	
SELECT * FROM t_medical_personnel;


--ACCESO A VACUNACIÓN 2022


--"Diphtheria-tetanus-pertussis (DTP3) immunization coverage among 1-year-olds (%)"
CREATE VIEW diphteria AS (
SELECT dim_geo_code AS Country, value_numeric AS "Diphteria-tetanus-pertussis % coverage (1-year-olds)"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%Diphtheria%');

--"Human papillomavirus (HPV) immunization coverage estimates among 15 year-old girls (%)"
CREATE VIEW hpv AS (
SELECT dim_geo_code AS Country, value_numeric AS "HPV % coverage (15 year-old girls)"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%HPV%');

--"Measles-containing-vaccine second-dose (MCV2) immunization coverage by the locally recommended age (%)"
CREATE VIEW mcv AS (
SELECT dim_geo_code AS Country, value_numeric AS "Measles-containing-vaccine 2-dose % coverage (recomended age)"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%MCV2%');

--"Pneumococcal conjugate 3rd dose (PCV3) immunization coverage  among 1-year olds (%)"
CREATE VIEW pcv AS (
SELECT dim_geo_code AS Country, value_numeric AS "Pneumococcal conjugate 3-dose % coverage (1-year-old)"
FROM t_health WHERE dim_geo_code IN('MEX','DNK')
AND ind_name LIKE '%PCV3%');

--CREACIÓN DE LA TABLA
DROP TABLE IF EXISTS t_immunization;
CREATE TABLE t_immunization AS (
SELECT 
    diphteria.Country, 
    diphteria."Diphteria-tetanus-pertussis % coverage (1-year-olds)",
    hpv."HPV % coverage (15 year-old girls)",
    mcv."Measles-containing-vaccine 2-dose % coverage (recomended age)",
    pcv."Pneumococcal conjugate 3-dose % coverage (1-year-old)"
FROM diphteria
LEFT JOIN hpv ON diphteria.Country = hpv.Country
LEFT JOIN mcv ON diphteria.Country = mcv.Country
LEFT JOIN pcv ON diphteria.Country = pcv.Country);
SELECT * FROM t_immunization;


--ENFERMEDADES POR VIRUS O BACTERIAS

--"New HIV infections (per 1000 uninfected population)" -2022
CREATE VIEW hiv AS (
SELECT dim_geo_code AS "Country", value_numeric AS "New HIV infections (per 1000 uninfected population)" 
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%HIV%');

--"Tuberculosis incidence (per 100 000 population)"--2022
CREATE VIEW  tuberculosis AS(
SELECT dim_geo_code AS "Country", value_numeric AS "Tuberculosis incidence (per 100 000 population)"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%Tuberculosis%');

--"Number of cases of poliomyelitis caused by wild poliovirus (WPV)" -2023
CREATE VIEW wpv AS (
SELECT dim_geo_code AS "Country", value_numeric AS "No. of cases of poliomyelitis caused by wild poliovirus (WPV)"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%WPV%');
--El indicador es cero para ambos países, probablemente debería omitirlo y colocarlo como leyenda.

--"Reported number of people requiring interventions against NTDs"-2022
CREATE VIEW ntds AS (
SELECT dim_geo_code AS "Country", value_numeric AS "Reported number of people requiring interventions against NTDs"
FROM t_health WHERE dim_geo_code IN('MEX','DNK')
AND ind_name LIKE '%NTDs%');


--CREAR LA TABLA CON LOS CUATRO INDICADORES
CREATE TABLE t_sickness AS (
SELECT hiv."Country", hiv."New HIV infections (per 1000 uninfected population)",
       tuberculosis."Tuberculosis incidence (per 100 000 population)",
       wpv."No. of cases of poliomyelitis caused by wild poliovirus (WPV)",
	   ntds."Reported number of people requiring interventions against NTDs"
FROM hiv
RIGHT JOIN tuberculosis ON hiv."Country" = tuberculosis."Country"
RIGHT JOIN wpv ON hiv."Country" = wpv."Country"
RIGHT JOIN ntds ON hiv."Country" = ntds."Country");
SELECT * FROM t_sickness;

--RESISTENCIA A ANTIBIÓTICOS
--IMPORTANTE:!Sin datos para México para las categorías relacionadas a consumo y resistencia antibióticos!


--CREAER TABLAS DE MORTALIDAD.

--MORTALIDAD TABLA 1 - POR CAUSAS DE INSALUBRIDAD
--"Mortality rate attributed to exposure to unsafe WASH services (per 100 000 population)"--2019
CREATE VIEW mr_wash AS
SELECT dim_geo_code AS "Country", value_numeric AS "Exposure to unsafe WASH services"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%unsafe WASH%';

--"Mortality rate from unintentional poisoning (per 100 000 population)"--2021
CREATE VIEW mr_poisoning AS (
SELECT dim_geo_code AS "Country", value_numeric AS "Unintentional poisoning"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%poisoning%');

--"Age-standardized mortality rate attributed to household and ambient air pollution  (per 100 000 population) "--2019
CREATE VIEW mr_pollution AS (
SELECT dim_geo_code AS "Country", value_numeric AS "Age-standardized M-R due to household and ambient air pollution"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%pollution%');

--CREACIÓN DE LA TABLA 
--Mortality rate due to unsalubrity (per 100 000 population) 2019-2021
CREATE TABLE t_mortality_1 AS (
SELECT mr_wash."Country", 
	   mr_wash."Exposure to unsafe WASH services",
	   mr_poisoning."Unintentional poisoning",
	   mr_pollution."Age-standardized M-R due to household and ambient air pollution"
FROM mr_wash
RIGHT JOIN mr_poisoning ON mr_wash."Country" = mr_poisoning."Country"
RIGHT JOIN mr_pollution ON mr_wash."Country" = mr_pollution."Country");
SELECT * FROM t_mortality_1;


--MORTALIDAD TABLA 2 - MATERNAL Y NIÑOS
--"Neonatal mortality rate (per 1000 live births)"-2022
CREATE VIEW neonatal AS (
SELECT dim_geo_code AS "Country", value_numeric AS "Neonatal M-R (per 1000 live births)"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%Neonatal%');

--"Maternal mortality ratio (per 100 000 live births)"
CREATE VIEW maternal AS (
SELECT dim_geo_code AS "Country", value_numeric AS "Maternal mortality ratio (per 100 000 live births)"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%Maternal%');

--"Under-five mortality rate (per 1000 live births)"--2022
CREATE VIEW under_five AS (
SELECT dim_geo_code AS "Country", value_numeric AS "Under-five mortality rate (per 1000 live births)" 
FROM t_health WHERE dim_geo_code IN('MEX','DNK')
AND ind_name LIKE '%Under-five%');

--CREACIÓN DE LA TABLA
CREATE TABLE t_mortality_2 AS (
SELECT neonatal."Country",
	   neonatal."Neonatal M-R (per 1000 live births)",
	   maternal."Maternal mortality ratio (per 100 000 live births)",
	   under_five."Under-five mortality rate (per 1000 live births)"
FROM neonatal
RIGHT JOIN maternal ON neonatal."Country" = maternal."Country"
RIGHT JOIN under_five ON neonatal."Country" = under_five."Country");
SELECT * FROM t_mortality_2;

--MORTALIDAD TABLA 3 --OTRAS CAUSAS
--Mortality rate causes (per 100 00 population)

--"Mortality rate due to homicide (per 100 000 population)"-2021
CREATE VIEW homicide AS (
SELECT dim_geo_code AS "Country", value_numeric AS "Homicide"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%homicide%');
SELECT * FROM homicide;

--"Road traffic mortality rate (per 100 000 population)"-2021
CREATE VIEW traffic AS (
SELECT dim_geo_code AS "Country", value_numeric AS "Road traffic"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%traffic%');
SELECT * FROM traffic;

--"Suicide mortality rate (per 100 000 population)" -2021
CREATE VIEW suicide AS (
SELECT dim_geo_code AS "Country", value_numeric AS "Suicide"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%Suicide%');
SELECT * FROM suicide;

--CREAR LA TABLA 3 -- MORTALITY RATE, OTHER CAUSES (PER 100 000 POPULATION)-2021
CREATE VIEW t_mortality_3 AS (
SELECT homicide."Country",
       homicide."Homicide",
	   traffic."Road traffic",
	   suicide."Suicide"
FROM homicide
RIGHT JOIN traffic ON homicide."Country" = traffic."Country"
RIGHT JOIN suicide ON homicide."Country" = suicide."Country");
SELECT * FROM t_mortality_3;

--CREAR TABLAS DE ENFERMEDADES CRÓNICAS 

--"Prevalence of anaemia in women of reproductive age (15-49 years) (%)"--2019
CREATE VIEW anaemia AS (
SELECT dim_geo_code AS "Country", value_numeric AS "Prevalence of anaemia in 15-49 years women(%)"
FROM t_health WHERE dim_geo_code IN('MEX','DNK')
AND ind_name LIKE '%anaemia%');

--"Prevalence of obesity among children and adolescents (5-19 years) (%)"-2022
CREATE VIEW obesity_1 AS (
SELECT dim_geo_code AS "Country", value_numeric AS "Prevalence of obesity among 5-19 years-old(%)"
FROM t_health WHERE dim_geo_code IN('MEX','DNK')
AND ind_code LIKE '%NCD_BMI_PLUS2C%');
SELECT * FROM obesity_1;

--"Age-standardized prevalence of obesity among adults (18+ years) (%)"-2022
CREATE VIEW obesity_2 AS (
SELECT dim_geo_code AS "Country", value_numeric AS "Prevalence of obesity among adults 18+ years-old(%)" 
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_code LIKE '%NCD_BMI_30A%');
SELECT * FROM obesity_2;

--CREACIÓN DE LA TABLA --2019-2022
CREATE TABLE t_sickness_2 AS (
SELECT anaemia."Country",
	   anaemia."Prevalence of anaemia in 15-49 years women(%)",
	   obesity_1."Prevalence of obesity among 5-19 years-old(%)",
	   obesity_2."Prevalence of obesity among adults 18+ years-old(%)" 
FROM anaemia
RIGHT JOIN obesity_1 ON anaemia."Country" = obesity_1."Country"
RIGHT JOIN obesity_2 ON anaemia."Country" = obesity_2."Country");
SELECT * FROM t_sickness_2;


--ESPERANZA DE VIDA

--"Life expectancy at birth (years)"-women-2021
CREATE VIEW women_le AS (
SELECT dim_geo_code AS "Country", value_numeric "Female life expectancy at birth (years)"
FROM t_health WHERE dim_geo_code IN ('MEX', 'DNK')
AND ind_name LIKE '%Life expectancy at birth (years)%'
AND dim_1_code = 'SEX_FMLE');
SELECT * FROM women_le;

--"Life expectancy at birth (years)"-men-2021
CREATE VIEW male_le AS (
SELECT dim_geo_code AS "Country", value_numeric "Male life expectancy at birth (years)"
FROM t_health WHERE dim_geo_code IN ('MEX', 'DNK')
AND ind_name LIKE '%Life expectancy at birth (years)%'
AND dim_1_code = 'SEX_MLE');
SELECT * FROM male_le;

--"Life expectancy at birth (years)"-average-2021
CREATE VIEW average_le AS (
SELECT dim_geo_code AS "Country", value_numeric "Average life expectancy at birth (years)"
FROM t_health WHERE dim_geo_code IN ('MEX', 'DNK')
AND ind_name LIKE '%Life expectancy at birth (years)%'
AND dim_1_code = 'SEX_BTSX');
SELECT * FROM average_le;

--CREACIÓN DE LA TABLA DE ESPERANZA DE VIDA
CREATE VIEW t_life_expectancy AS (
SELECT women_le."Country",
 	   women_le."Female life expectancy at birth (years)",
	   male_le."Male life expectancy at birth (years)",
	   average_le."Average life expectancy at birth (years)"	   
FROM  women_le 
RIGHT JOIN male_le ON women_le."Country" = male_le."Country"
RIGHT JOIN average_le ON women_le."Country" = average_le."Country");
SELECT * FROM t_life_expectancy;


--CONSUMO DE ALCOHOL Y TABACO

--"Total alcohol per capita (?�15 years of age) consumption (litres of pure alcohol)" 2019
--value_text: "WHO Global Information System on Alcohol and Health (GISAH)"
CREATE VIEW alcohol AS 
SELECT dim_geo_code AS "Country", value_numeric AS "Alcohol litres per capita (15 years and older)"
FROM t_health WHERE dim_geo_code IN ('MEX', 'DNK')
AND ind_name LIKE '%alcohol%';

--"Age-standardized prevalence of tobacco use among persons 15 years and older (%) " FOR 2022
--Value text:This is a projection basen on surveys made on 2020 DNK and 2021 MEX

CREATE VIEW tobacco AS
SELECT dim_geo_code AS "Country", value_numeric AS "% Prevalence of tobacco use (15 years and older)"
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%tobacco%';


--CREACIÓN DE LA TABLA CONSUMO DE ALCOHOL Y TABACO

CREATE TABLE t_alcohol_tobacco AS (
SELECT alcohol."Country",
       alcohol."Alcohol litres per capita (15 years and older)",
	   tobacco."% Prevalence of tobacco use (15 years and older)"
FROM alcohol LEFT JOIN tobacco ON alcohol."Country" = tobacco."Country");
SELECT * FROM t_alcohol_tobacco;
	 
	 
--EXPOSISION A VIOLENCIA 2018

SELECT* 
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_name LIKE '%violence%'

--Los datos mostrados son de un indicador demasiado especifico, por lo que el porcentaje es demasiado bajo y no representa el
--problema real de exposisión a violencia en México.
--"Proportion of ever-partnered women and girls aged 15-49 years subjected to physical and/or sexual violence by a current or former intimate partner in the previous 12 months (%) "
--Según datos del INEGI (2022), En México, el 66.1% de las mujeres de 15 años y más han sufrido algún tipo de violencia a lo largo de su vida.
--https://www.inegi.org.mx/contenidos/saladeprensa/aproposito/2019/Violencia2019_Tams.docx

--"Proportion of ever-partnered women and girls aged 15-49 years subjected to physical and/or sexual violence by a current or former intimate partner in their lifetime (%) "
DROP VIEW IF EXISTS violence_1;
CREATE VIEW violence_1 AS
SELECT dim_geo_code AS "Country", value_numeric AS "% Women aged 15-49 subjucted to violence by intimate partner" 
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_code = 'SDGIPVLT';

--"Proportion of ever-partnered women and girls aged 15-49 years subjected to physical and/or sexual violence by a current or former intimate partner in the previous 12 months (%) "
CREATE VIEW violence_2 AS
SELECT dim_geo_code AS "Country", value_numeric AS "In the previous 12 months" 
FROM t_health WHERE dim_geo_code IN('MEX', 'DNK')
AND ind_code = 'SDGIPV12M';

--CREACIÓN DE LA TABLA
CREATE TABLE t_violence AS(
SELECT violence_1."Country",
       violence_1."% Women aged 15-49 subjucted to violence by intimate partner",
	   violence_2."In the previous 12 months"
FROM violence_1 LEFT JOIN violence_2
ON violence_1."Country" = violence_2."Country");
SELECT * FROM t_violence;


