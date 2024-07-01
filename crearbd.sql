/* VENTA TICKETS PARIS */

-- CREACION DE LA BASE DE DATOS
CONNECT system/bdadmin
CREATE USER P1 IDENTIFIED BY VENTA_PARIS;
GRANT CONNECT, RESOURCE TO P1;
CONNECT P1/VENTA_PARIS;

-- TABLAS DE LA BASE DE DATOS
CREATE TABLE USUARIO
(
	dni			VARCHAR2(10) CONSTRAINT usu_dni_pk PRIMARY KEY,
	nombre		VARCHAR2(25),
	apellido	VARCHAR2(25),
	fechanacimiento	DATE
);

CREATE TABLE AGENCIA
(
	cif			VARCHAR2(10) CONSTRAINT age_cif_pk PRIMARY KEY,
	nombre		VARCHAR2(25),
	comision	NUMBER(6,2)
);

CREATE TABLE TICKET
(
	codigo 			VARCHAR2(10) CONSTRAINT tic_cod_pk PRIMARY KEY,
	fechacompra		DATE,
	precio			NUMBER(6,2)  CONSTRAINT tic_pre_nn NOT NULL
								 CONSTRAINT tic_pre_ch CHECK (precio >= 0),
	dniusuario		VARCHAR2(10) CONSTRAINT tic_usu_fk REFERENCES USUARIO(dni),
	cifagencia		VARCHAR2(10) CONSTRAINT tic_age_fk REFERENCES AGENCIA(cif)
);

CREATE TABLE PRODUCTO
(
	codigo VARCHAR2(10) CONSTRAINT pro_cod_pk PRIMARY KEY,
	precio NUMBER(6,2)  CONSTRAINT pro_pre_nn NOT NULL
					    CONSTRAINT pro_pre_ch CHECK (precio >= 0)
);

CREATE TABLE CONTENER
(
	codticket		VARCHAR2(10) CONSTRAINT con_tic_fk REFERENCES TICKET(codigo),
	codproducto		VARCHAR2(10) CONSTRAINT con_pro_fk REFERENCES PRODUCTO(codigo),
	cantidad		NUMBER(6) 	 CONSTRAINT con_can_nn NOT NULL
								 CONSTRAINT con_can_ch CHECK (cantidad >= 0),
	CONSTRAINT con_codtic_codpro_pk PRIMARY KEY (codticket,codproducto)
);

CREATE TABLE AEROPUERTO
(
	codigo		VARCHAR2(10) CONSTRAINT aer_cod_pk PRIMARY KEY,
	nombre		VARCHAR2(25),
	distancia	NUMBER(6,2)  CONSTRAINT aer_dis_ch CHECK (distancia > 0)
);

CREATE TABLE BUS
(
	numero				NUMBER(3)	 CONSTRAINT bus_numero_ch CHECK (numero >= 0),
	codaeropuerto		VARCHAR2(10) CONSTRAINT bus_aer_fk REFERENCES AEROPUERTO(codigo),
	numplazas			NUMBER(3)	 CONSTRAINT bus_numpla_ch CHECK (numplazas > 0),
	nombreconductor		VARCHAR2(25),
	fechamatriculacion	DATE,
	CONSTRAINT bus_num_cod_pk PRIMARY KEY(numero,codaeropuerto)
);

CREATE TABLE BUS_AEROPUERTO
(
	codproducto		VARCHAR2(10) CONSTRAINT busaer_pro_fk REFERENCES PRODUCTO(codigo)
								 CONSTRAINT busaer_cod_pk PRIMARY KEY,
	diatrayecto		DATE,
	codaeropuerto	VARCHAR2(10),
	numbus			NUMBER(3),
	CONSTRAINT busaer_bus_fk FOREIGN KEY (codaeropuerto,numbus) REFERENCES BUS(codaeropuerto,numero)
);

CREATE TABLE BARCO
(
	codigo			VARCHAR2(10)	CONSTRAINT bar_cod_pk PRIMARY KEY,
	maxpasajeros	NUMBER(3)		CONSTRAINT bar_max_ch CHECK (maxpasajeros > 0)
);

CREATE TABLE CRUCERO_SENA
(
	codproducto		VARCHAR2(10) CONSTRAINT cru_pro_fk REFERENCES PRODUCTO(codigo)
								 CONSTRAINT cru_codpro_pk PRIMARY KEY,
	tipocrucero		VARCHAR2(25),
	fecha			DATE,
	hora			VARCHAR2(40),
	codbarco		VARCHAR2(10) CONSTRAINT cru_codbar_fk REFERENCES BARCO(codigo)
								 CONSTRAINT cru_codbar_nn NOT NULL
);

CREATE TABLE BUS_TURISTICO
(
	codproducto		VARCHAR2(10) CONSTRAINT bustur_pro_fk REFERENCES PRODUCTO(codigo)
								 CONSTRAINT bustur_cod_pk PRIMARY KEY,
	trayecto		VARCHAR2(100),
	plazas			NUMBER(3)	 CONSTRAINT bustur_pla_ch CHECK (plazas >= 0)
);

CREATE TABLE HORARIO_BUS
(
	dia		VARCHAR2(20),
	hora	VARCHAR2(20),
	CONSTRAINT hor_dia_hora_pk PRIMARY KEY(dia,hora)
);

CREATE TABLE CONDUCTOR
(
	dni				VARCHAR2(10)	CONSTRAINT con_dni_pk PRIMARY KEY,
	nombre			VARCHAR2(25),
	apellido		VARCHAR2(25),
	anyosservicio	NUMBER(2)		CONSTRAINT con_any_ch CHECK (anyosservicio >= 0)
);

CREATE TABLE RESTRINGIR
(
	dniconductor	VARCHAR2(10)		CONSTRAINT res_dni_fk REFERENCES CONDUCTOR(dni),
	diahorario		VARCHAR2(20),
	horahorario		VARCHAR2(20),
	codproducto		VARCHAR2(10)		CONSTRAINT res_cod_fk REFERENCES PRODUCTO(codigo)
										CONSTRAINT res_cod_nn NOT NULL,
	CONSTRAINT res_hor_fk FOREIGN KEY (diahorario,horahorario) REFERENCES HORARIO_BUS(dia,hora),
	CONSTRAINT res_dni_dia_hora_pk PRIMARY KEY(dniconductor,diahorario,horahorario),
	CONSTRAINT res_cod_dia_hora_uq UNIQUE (codproducto,diahorario,horahorario)
);

