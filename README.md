# Venta de Tickets París 

Proyecto grupal de la asignatura **Diseño y Gestión de Bases de Datos** (curso 2023/2024) cuyo objetivo es diseñar y gestionar un sistema de información para la **venta de tickets turísticos** en París y para el transporte a aeropuertos.

---

## Descripción del sistema

El sistema permite gestionar:

- **Usuarios** que compran tickets (DNI, nombre, apellido, fecha de nacimiento).
- **Agencias** con CIF único, nombre y comisión.
- **Tickets** con código, fecha, precio y relación con usuario/agencia.
- **Productos** disponibles:
  - Bus a aeropuertos.
  - Bus turístico.
  - Crucero por el Sena.
- **Recursos asociados**:
  - Aeropuertos, buses, barcos.
  - Horarios y conductores.
- **Restricciones**:
  - Conductores limitados a ciertos productos/días/horarios.
  - Prohibición de venta a menores de edad.

---

## Modelo de datos

- **Diagrama E-R**: Representa todas las entidades y relaciones necesarias para el proceso.
- **Esquema lógico** implementado en SQL con claves primarias, foráneas y restricciones.

---

## Funcionalidades en PL/SQL

### Funciones
1. `CONTAR_BUSES` – Calcula número de buses, plazas totales y conductor del bus más antiguo por aeropuerto.
2. `TOTAL_VENTAS_USUARIO` – Suma total gastado por un usuario.
3. `DETALLE_USUARIO` – Lista tickets comprados, importe total y cantidad.

### Procedimientos
1. `INSERTAR_USUARIO` – Inserta un nuevo cliente.
2. `CALCULAR_TOTAL_TICKETS` – Calcula el beneficio total de las ventas.
3. Procedimiento de **promedio de tickets por conductor**.
4. `ACTUALIZAR_PRECIO_TICKET` – Actualiza el precio de un ticket.

### Disparadores (triggers)
1. `CHECK_CONDICIONES_AEROPUERTO` – Valida datos de aeropuertos antes de insertarlos.
2. `VERIFICAR_EDAD_USUARIO` – Impide la venta a menores de 18 años.

---

## Archivos principales

- `crearbd.sql` → Creación de tablas y relaciones.
- `datos.sql` → Inserción de datos de ejemplo.
- `bloques.sql` → Funciones, procedimientos y disparadores.
- `borrar.sql` → Eliminación de tablas y datos para reiniciar el sistema.

---


## Pasos para la ejecución

### 1️⃣ Conectarse como administrador
En **SQL*Plus**:
```sql
CONNECT system/bdadmin
```
> Sustituir `bdadmin` por la contraseña real del usuario SYSTEM.

---

### 2️⃣ Crear el usuario del proyecto
```sql
CREATE USER P1 IDENTIFIED BY VENTA_PARIS;
GRANT CONNECT, RESOURCE TO P1;
```

---

### 3️⃣ Conectarse con el nuevo usuario
```sql
CONNECT P1/VENTA_PARIS
```

---

### 4️⃣ Crear la estructura de la base de datos
```sql
@C:\oracle\scripts\crearbd.sql
```
⚠ **Nota**: Si el script intenta crear el usuario `P1`, dará el error `ORA-01920: user name 'P1' conflicts with another user or role name`. En ese caso, comenta o elimina esas líneas.

---

### 5️⃣ Insertar datos de ejemplo
```sql
@C:\oracle\scripts\datos.sql
```

---

### 6️⃣ Cargar funciones, procedimientos y disparadores
```sql
@C:\oracle\scripts\bloques.sql
```

---

### 7️⃣ (Opcional) Reiniciar la base de datos
```sql
@C:\oracle\scripts\borrar.sql
```

---

### 8️⃣ Verificar instalación
Listar tablas:
```sql
SELECT table_name FROM user_tables;
```
Probar una función:
```sql
SELECT contar_buses('BVS') FROM dual;
```



   
