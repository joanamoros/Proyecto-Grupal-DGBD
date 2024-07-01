--Funcion CONTAR_BUSES
CREATE OR REPLACE FUNCTION CONTAR_BUSES(p_codaeropuerto VARCHAR2)
RETURN VARCHAR2 AS
	v_count NUMBER;
	v_total_plazas NUMBER;
	v_conductor VARCHAR2(25);
	v_ano_antiguo NUMBER;
BEGIN
	-- Contar el número de buses
	SELECT COUNT(*)
	INTO v_count
	FROM BUS
	WHERE codaeropuerto = p_codaeropuerto;

	-- Contar el número total de plazas
	SELECT SUM(numplazas)
	INTO v_total_plazas
	FROM BUS
	WHERE codaeropuerto = p_codaeropuerto;

	-- Encontrar el nombre del conductor con el bus más antiguo y el año de matriculación
	SELECT nombreconductor, EXTRACT(YEAR FROM fechamatriculacion)
	INTO v_conductor, v_ano_antiguo
	FROM (
    	SELECT nombreconductor, fechamatriculacion
    	FROM BUS
    	WHERE codaeropuerto = p_codaeropuerto
    	ORDER BY fechamatriculacion ASC
	)
	WHERE ROWNUM = 1;

	-- Devolver los resultados
	RETURN 'Numero de buses: ' || v_count || ', Total de plazas: ' || v_total_plazas || ', Conductor con bus más antiguo: ' || v_conductor || ', con fecha de matriculación en el anyo: ' || v_ano_antiguo;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
    	RETURN 'No hay datos disponibles para el aeropuerto ' || p_codaeropuerto;
END contar_buses;
/ 		

--FUNCION TOTAL_VENTAS_USUARIO
CREATE OR REPLACE FUNCTION TOTAL_VENTAS_USUARIO(p_dni VARCHAR2)
RETURN VARCHAR2 IS
total_ventas NUMBER(6,2);
usuario_existe NUMBER;
BEGIN
SELECT COUNT(*)
INTO usuario_existe 
FROM USUARIO
WHERE dni = p_dni;

IF usuario_existe = 0 THEN
	RAISE_APPLICATION_ERROR(-20001, 'El usuario no existe.');
END IF;

SELECT NVL(SUM(precio), 0)
INTO total_ventas
FROM TICKET
WHERE dniusuario = p_dni;

RETURN 'El total de ventas para el usuario con DNI ' || p_dni || ' es: ' || total_ventas || ' euros';
END;
/ 

--FUNCION DETALLES_USUARIO
CREATE OR REPLACE FUNCTION DETALLE_USUARIO(p_dni VARCHAR2)
RETURN VARCHAR2 IS
detalles_tickets VARCHAR2(4000);
total_tickets NUMBER;
total_gastado NUMBER;
cursor c_tickets is SELECT T.codigo, T.precio FROM TICKET T WHERE T.dniusuario = p_dni;
v_ticket c_tickets%ROWTYPE;
BEGIN
-- Inicializar detalles_tickets
detalles_tickets := '';

-- Abrir cursor
OPEN c_tickets;

-- Bucle para obtener los códigos y precios de los tickets que el usuario ha comprado
LOOP
	FETCH c_tickets INTO v_ticket;
	EXIT WHEN c_tickets%NOTFOUND;
	detalles_tickets := detalles_tickets || v_ticket.codigo || ' (' || v_ticket.precio || ' euros), ';
END LOOP;

-- Cerrar cursor
CLOSE c_tickets;

-- Eliminar la última coma y espacio
detalles_tickets := RTRIM(detalles_tickets, ', ');

IF detalles_tickets IS NULL THEN
RAISE_APPLICATION_ERROR(-20003, 'El usuario no ha comprado ningún ticket.');
END IF;

-- Obtener el total de tickets que el usuario ha comprado
SELECT COUNT(*)
INTO total_tickets
FROM TICKET T
WHERE T.dniusuario = p_dni;

-- Obtener el total gastado por el usuario en todos los tickets
SELECT SUM(T.precio)
INTO total_gastado
FROM TICKET T
WHERE T.dniusuario = p_dni;

RETURN 'El usuario con DNI ' || p_dni || ' ha comprado un total de ' || total_tickets || ' tickets por un total de ' || total_gastado || ' euros. Los tickets comprados son: ' || detalles_tickets;
EXCEPTION
WHEN NO_DATA_FOUND THEN
		RETURN 'El usuario no ha comprado tickets.';
END;
/
--PROCEDIMIENTO INSERTAR_USUARIO
CREATE OR REPLACE PROCEDURE INSERTAR_USUARIO (
	dni IN USUARIO.dni%TYPE,
	nombre IN USUARIO.nombre%TYPE,
	apellido IN USUARIO.apellido%TYPE,
	fechanacimiento IN VARCHAR2
)

IS
v_dni USUARIO.dni%TYPE;
v_fecha DATE;

BEGIN
-- Convertir la fecha de nacimiento al formato correcto
v_fecha := TO_DATE(fechanacimiento, 'DD/MM/YYYY');

-- Verificar si el usuario ya existe
SELECT dni INTO v_dni FROM USUARIO WHERE dni = INSERTAR_USUARIO.dni;

-- Si el usuario ya existe, lanzar una excepción
IF v_dni IS NOT NULL THEN
RAISE_APPLICATION_ERROR(-20001, 'El usuario con DNI ' || dni || ' ya existe.');
END IF;

-- Si el usuario no existe, insertarlo en la tabla
INSERT INTO USUARIO (dni, nombre, apellido, fechanacimiento)
VALUES (dni, nombre, apellido, v_fecha);


EXCEPTION
-- Si no se encuentra el usuario, continuar con la inserción
WHEN NO_DATA_FOUND THEN
		INSERT INTO USUARIO (dni, nombre, apellido, fechanacimiento)
	VALUES (dni, nombre, apellido, v_fecha);
END;
/
--PROCEDIMIENTO CALCULAR_TOTAL_TICKETS
SET SERVEROUTPUT ON
CREATE OR REPLACE PROCEDURE CALCULAR_TOTAL_TICKETS IS
CURSOR c_tickets IS
SELECT precio FROM TICKET;
v_precio TICKET.precio%TYPE;
v_total NUMBER := 0;
BEGIN
OPEN c_tickets;
LOOP
		FETCH c_tickets INTO v_precio;
		EXIT WHEN c_tickets%NOTFOUND;
		v_total := v_total + v_precio;
END LOOP;
CLOSE c_tickets;
 
IF v_total = 0 THEN
		DBMS_OUTPUT.PUT_LINE('No hay tickets o el total del precio de todos los tickets es 0.');
ELSE
		DBMS_OUTPUT.PUT_LINE('El total del precio de todos los tickets es: ' || v_total);
END IF;
END calcular_total_tickets;
/
--PROCEDIMIENTO TICKET_CONDUCTORES
CREATE OR REPLACE PROCEDURE TICKET_CONDUCTORES IS
v_total_tickets NUMBER;
v_total_conductores NUMBER;
v_promedio NUMBER;

BEGIN
-- Calcular el total de tickets
SELECT COUNT(*) INTO v_total_tickets FROM TICKET;

-- Calcular el total de conductores
SELECT COUNT(*) INTO v_total_conductores FROM CONDUCTOR;

-- Calcular el promedio de tickets por conductor
IF v_total_conductores > 0 THEN
		v_promedio := ROUND(v_total_tickets / v_total_conductores,2);
ELSE
		v_promedio := 0;
END IF;

-- Imprimir el total de tickets y conductores, incluso si son 0
DBMS_OUTPUT.PUT_LINE('Total de tickets: ' || v_total_tickets);
DBMS_OUTPUT.PUT_LINE('Total de conductores: ' || v_total_conductores);
IF v_promedio > 0 THEN
DBMS_OUTPUT.PUT_LINE('Promedio de tickets por conductor: ' || v_promedio);
END IF;

EXCEPTION
  		WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Se produjo un error: ' || SQLERRM);
END ticket_conductores;
/
--PROCEDIMIENTO ACTUALIZAR_PRECIO_TICKET
CREATE OR REPLACE PROCEDURE ACTUALIZAR_PRECIO_TICKET (
p_codigo IN TICKET.codigo%TYPE,
p_nuevo_precio IN TICKET.precio%TYPE
) IS
BEGIN
UPDATE TICKET
SET precio = p_nuevo_precio
WHERE codigo = p_codigo;

IF SQL%ROWCOUNT = 0 THEN
		DBMS_OUTPUT.PUT_LINE('No se encontró el ticket con ID: ' || p_codigo);
  	ELSE
		DBMS_OUTPUT.PUT_LINE('El precio del ticket con ID: ' || p_codigo || ' ha sido actualizado a: ' || p_nuevo_precio);
END IF;

COMMIT;
EXCEPTION
  		WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Se produjo un error: ' || SQLERRM);
	ROLLBACK;
END actualizar_precio_ticket;
/
--DISPARADOR CHECK_CONDICIONES_AEROPUERTO
CREATE OR REPLACE TRIGGER check_condiciones_aeropuerto
BEFORE INSERT OR UPDATE ON AEROPUERTO
FOR EACH ROW
DECLARE
v_nombre_len NUMBER;
v_codigo_len NUMBER;
BEGIN
v_nombre_len := LENGTH(:new.nombre);
v_codigo_len := LENGTH(:new.codigo);

IF v_nombre_len < 3 OR v_nombre_len > 25 THEN
	RAISE_APPLICATION_ERROR(-20001, 'El nombre debe tener entre 3 y 25 caracteres.');
END IF;

IF :new.distancia <= 0 THEN
	RAISE_APPLICATION_ERROR(-20002, 'La distancia debe ser mayor que 0.');
END IF;

IF v_codigo_len < 3 OR v_codigo_len > 10 THEN
	RAISE_APPLICATION_ERROR(-20003, 'El código del aeropuerto debe tener entre 3 y 10 caracteres.');
END IF;

IF NOT REGEXP_LIKE(:new.nombre, '^[A-Za-z ]+$') THEN
RAISE_APPLICATION_ERROR(-20004, 'El nombre solo puede contener letras y espacios.');
  	END IF;
END;
/
--DISPARADOR VERIFICAR_EDAD_USUARIO
CREATE OR REPLACE TRIGGER verificar_edad_usuario
BEFORE INSERT ON TICKET
FOR EACH ROW
DECLARE
v_fecha_nacimiento DATE;
v_edad NUMBER;
ex_menor_de_edad EXCEPTION;
BEGIN
-- Obtener la fecha de nacimiento del usuario
SELECT fechanacimiento INTO v_fecha_nacimiento
FROM USUARIO
WHERE dni = :NEW.dniusuario;

-- Calcular la edad del usuario
v_edad := (SYSDATE - v_fecha_nacimiento) / 365.25;

-- Si el usuario es menor de 18 años, lanzar una excepción
IF v_edad < 18 THEN
RAISE ex_menor_de_edad;
END IF;
EXCEPTION
WHEN ex_menor_de_edad THEN
RAISE_APPLICATION_ERROR(-20001, 'El usuario es menor de 18 años');
END;
/
