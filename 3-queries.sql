CREATE TABLE EMPLEADO (
	ID INT(8),
	NOMBRE VARCHAR(50),
	APELLIDO VARCHAR(59),
	SEXO CHAR(1),
	FECHA_NACIMIENTO DATE,
	SALARIO DOUBLE(10,2)
);

CREATE TABLE VACACIONES(
	ID INT(8),
	ID_EMP INT(8),
	FECHA_INICIO DATE,
	FECHA_FIN DATE,
	ESTADO CHAR(1),
	CANTIDAD_DIAS INT(8)
);

/*EN ESTA TABLA SE ALMACENA LA INFORMACIÓN BASICA DE LOS EMPLEADOS*/
INSERT INTO EMPLEADO VALUES (1,"JUAN","PELAEZ","M",'1985-01-29',3500000);
INSERT INTO EMPLEADO VALUES (2,"ANDRES","GARCIA","M",'1975-05-22',5500000);
INSERT INTO EMPLEADO VALUES (3,"LAURA","PEREZ","F",'1991-09-10',2500000);
INSERT INTO EMPLEADO VALUES (4,"PEPE","MARTINEZ","M",'1987-12-01',3800000);
INSERT INTO EMPLEADO VALUES (5,"MARGARITA","CORRALES","F",'1990-07-02',4500000);

/*EN ESTA TABLA SE ALMACENA LAS SOLCITUDES DE VACIONES DE CADA EMPLEADO*/
INSERT INTO VACACIONES VALUES (1,1,'2019-07-01','2019-07-15','A',14);
INSERT INTO VACACIONES VALUES (2,2,'2019-03-01','2019-03-15','R',14);
INSERT INTO VACACIONES VALUES (3,2,'2019-04-01','2019-04-15','A',14);
INSERT INTO VACACIONES VALUES (4,2,'2019-08-14','2019-08-20','A',6);
INSERT INTO VACACIONES VALUES (5,3,'2019-08-20','2019-08-25','A',5);
INSERT INTO VACACIONES VALUES (6,3,'2019-12-20','2019-12-31','A',11);

/*Seleccione nombre, apellido y salario de todos los empleados*/
SELECT nombre, apellido, salario
FROM empleado;

/*Seleccione nombre, apellido y salario de todos los empleados que ganen más de 4 millones*/
SELECT nombre, apellido, salario
FROM empleado
WHERE salario > 4000000;

/*Cuente los empleados por sexo.*/
SELECT sexo, COUNT(*) AS Total
FROM empleado
GROUP BY sexo;
	
/*Seleccione los empleados que no han hecho solicitud de vacaciones*/
SELECT nombre
FROM empleado e
LEFT JOIN vacaciones v
ON e.ID = v.ID_EMP
WHERE v.ID IS NULL;

/*Seleccione los empleados que no han hecho solicitud de vacaciones (otra manera)*/	
SELECT nombre
FROM empleado e
WHERE ID NOT IN (
	SELECT e.ID					
	FROM empleado e
	INNER JOIN vacaciones v
	ON e.ID = v.ID_EMP);

/*Seleccione los empleados que tengan más de una solicitud de vacaciones y muestre cuantas solicitudes tienen los que cumplen*/						
SELECT e.nombre, COUNT(*) AS dias_totales		
FROM empleado e
INNER JOIN vacaciones v ON e.ID = v.ID_EMP
GROUP BY e.nombre
ORDER BY dias_totales DESC;

/*Determine el salario promedio de los empleados*/
SELECT AVG(salario) AS salario_promedio
FROM empleado;

/*Determine la cantidad de días promedio solicitados de vacaciones por cada empleado*/

/*Seleccione el empleado que mayor cantidad de días de vacaciones ha solicitado, muestre el nombre, apellido y cantidad de días totales solicitados*/
SELECT e.nombre, e.apellido, COUNT(*) AS dias_totales		
FROM empleado e
INNER JOIN vacaciones v ON e.ID = v.ID_EMP
GROUP BY e.nombre, e.apellido
HAVING COUNT(*) = (
    SELECT MAX(dias_totales)
    FROM (
        SELECT COUNT(*) AS dias_totales
        FROM empleado e
        INNER JOIN vacaciones v ON e.ID = v.ID_EMP
        GROUP BY e.nombre, e.apellido
    )subquery
);

/*Consulte la cantidad de días aprobados y rechazados por cada empleado, en caso de no tener solicitudes mostrar 0*/
SELECT e.nombre, v.estado, COUNT(v.ESTADO) AS Total
FROM empleado e
LEFT JOIN vacaciones v
ON e.ID = v.ID_EMP
GROUP BY e.nombre, v.estado;