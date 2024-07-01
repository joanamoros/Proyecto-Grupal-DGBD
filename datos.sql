
insert into USUARIO values ('74384681J','Alejandro','Garcia','04/02/1994');
insert into USUARIO values ('11111222A','Antonio', 'Alonso','01/01/1992');
insert into USUARIO values ('22233334B','Euclides', 'Elen','05/02/1972');
insert into USUARIO values ('33344445C','Octavio', 'Orondo','21/11/1960');
insert into USUARIO values ('77728819D','Ulises', 'Uracilo','03/10/1990');
INSERT INTO USUARIO values ('99999999Z', 'Usuario menor', 'Test', TO_DATE('01/01/2008', 'DD/MM/YYYY'));


insert into AEROPUERTO values ('BVS', 'BEAUVAIS', 107);
insert into AEROPUERTO values ('ORL', 'ORLY', 17);
insert into AEROPUERTO values ('CDG', 'CHARLES DE GAULLE', 31);

insert into CONDUCTOR values('1234567A', 'Gerardo', 'Garcia', 12 );
insert into CONDUCTOR values('7654321B', 'Salomon', 'Sabio', 2 );
insert into CONDUCTOR values('0009182C', 'Mariana', 'Minesota', 5 );

insert into AGENCIA values ('11111111','VentaBus', 10);
insert into AGENCIA values ('9999999','ParisExpres', 20);

insert into BARCO values ('b1',123);
insert into BARCO values ('b2',11);
insert into BARCO values ('b3',22);
insert into BARCO values ('b4',111);

insert into BUS values(1,'BVS',33,'Ruben','01/01/2000');
insert into BUS values(1,'ORL',23,'Juan','04/02/2000');
insert into BUS values(2,'ORL',23,'Pedro','28/02/1999');
insert into BUS values(3,'ORL',33,'Yolanda','09/12/1970');
insert into BUS values(1,'CDG',20,'Agustina','01/12/1980');
insert into BUS values(2,'CDG',33,'Marta','11/09/1980');
insert into BUS values(3,'CDG',33,'Pepi','01/05/1982');


insert into PRODUCTO values('crucero1',123);
insert into PRODUCTO values('crucero2',50);
insert into PRODUCTO values('crucero3',29.1);
insert into PRODUCTO values('busAero1',12.12);
insert into PRODUCTO values('busAero2',20);
insert into PRODUCTO values('busAero3',38);
insert into PRODUCTO values('busTuris1',22.33);
insert into PRODUCTO values('busTuris2',44.2);
insert into PRODUCTO values('busTuris3',55.27);


insert into HORARIO_BUS values('Miercoles','3:15');
insert into HORARIO_BUS values('Martes','3:15');
insert into HORARIO_BUS values('Lunes','3:15');
insert into HORARIO_BUS values('Viernes','3:15');
insert into HORARIO_BUS values('Jueves','3:15');
insert into HORARIO_BUS values('Miercoles','12:32');
insert into HORARIO_BUS values('Martes','12:32');
insert into HORARIO_BUS values('Lunes','12:32');
insert into HORARIO_BUS values('Viernes','12:32');
insert into HORARIO_BUS values('Jueves','12:32');

insert into BUS_AEROPUERTO values('busAero1','01/02/2019','BVS',1);
insert into BUS_AEROPUERTO values('busAero2','02/02/2019','ORL',1);
insert into BUS_AEROPUERTO values('busAero3','02/01/2019','CDG',1);

insert into BUS_TURISTICO values('busTuris1','Centro Paris',50);
insert into BUS_TURISTICO values('busTuris2','Alrededores Paris',20);
insert into BUS_TURISTICO values('busTuris3','Barrios Paris',20);

insert into CRUCERO_SENA values ('crucero1', 'visita guiada', '12/10/2018','11:31','b1');
insert into CRUCERO_SENA values ('crucero2', 'visita guiada', '13/12/2018','11:31','b2');
insert into CRUCERO_SENA values ('crucero3', 'libre', '13/01/2019','11:32','b3');

insert into RESTRINGIR values ('1234567A','Miercoles','3:15','busTuris1');
insert into RESTRINGIR values ('7654321B','Viernes','3:15','busTuris2');
insert into RESTRINGIR values ('0009182C','Viernes','3:15','busTuris3');

insert into TICKET values ('AAA','01/02/2018',123,'74384681J',null);
insert into TICKET values ('AAB','02/02/2018',123,'74384681J',null);
insert into TICKET values ('AAC','03/02/2018',123,'74384681J',null);
insert into TICKET values ('AAD','02/02/2018',100,'74384681J','9999999');
insert into TICKET values ('ABA','03/02/2018',44.66,'11111222A',null);
insert into TICKET values ('ACA','05/10/2018',200,'22233334B','11111111');
insert into TICKET values ('ADA','02/10/2018',138,'22233334B',null);
insert into TICKET values ('CDA','07/01/2019',200,'22233334B','9999999');
insert into TICKET values ('CXA','05/01/2019',200,'11111222A','11111111');
insert into TICKET values ('CDZ','04/01/2019',200,'74384681J','9999999');



insert into CONTENER values ('AAA','crucero1',1);
insert into CONTENER values ('AAB','crucero1',1);
insert into CONTENER values ('AAC','crucero1',1);
insert into CONTENER values ('AAD','crucero2',2);
insert into CONTENER values ('ABA','busTuris1',2);
insert into CONTENER values ('ACA','busAero2',10);
insert into CONTENER values ('ADA','crucero2',2);
insert into CONTENER values ('ADA','busAero3',1);
insert into CONTENER values ('CDA','busAero2',2);
insert into CONTENER values ('CXA','busAero3',4);
insert into CONTENER values ('CDZ','busAero2',3);


commit;