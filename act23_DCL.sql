
--Ens conectem al usuari SYS per tindre persios per crear usuaris.
CONNECT SYS/1234 AS SYSDBA;
-- EX1
--Creem l'usuari ASIX amb els paràmetres especificats.
CREATE USER ASIX
    IDENTIFIED BY 1234
    DEFAULT TABLESPACE users
    TEMPORARY TABLESPACE temp
    QUOTA 700K ON users;
    --ACCOUNT LOCK

-- Quieres que tu usuario tenga una QUOTA ILIMITADA?
-- GRANT unlimited tablespace TO ASIX;


--EX2
--Crea el rol anomenar BASIC_PRIVS.
/*
Aquesta comanda crearà el rol BASIC_PRIVS i concedirà els permisos per connectar-se a la base de dades
i crear taules, vistes, seqüències i procediments en el propi esquema. Això permetrà als usuaris que
tinguin assignat aquest rol connectar-se a la base de dades i crear objectes en el seu propi esquema.
*/
CREATE ROLE basic_privs;

SELECT * FROM dba_sys_privs
    WHERE grantee IN ('HR','RESOURCE');
SELECT * FROM dba_role_privs
    WHERE grantee = 'HR';

GRANT CREATE SESSION TO basic_privs;
GRANT CREATE TABLE,
    CREATE VIEW,
    CREATE SEQUENCE,
    CREATE PROCEDURE,
    CREATE DATABASE LINK,
    CREATE SYNONYM,
    CREATE TYPE,
    CREATE INDEXTYPE
    
TO basic_privs;

-- EX3
--Atorgar el rol BASIC_PRIVS a l'usuari ASIX.
/*
Aquesta comanda concedirà el rol BASIC_PRIVS a l'usuari ASIX, permetent-li
connectar-se a la base de dades i crear objectes en el seu propi esquema.
*/
GRANT BASIC_PRIVS TO ASIX;

-- EX4
--Crear dues taules relacionades amb una clau estrangera que vincula la taula "Orders" amb la taula "Customers":
/*
En aquest exemple, la taula Customers té dos camps, CustomerID i CustomerName,
amb CustomerID com a clau primària. La taula Orders també té dos camps, OrderID
i OrderDate, amb OrderID com a clau primària. La clau estrangera CustomerID a la
taula Orders fa referència a la clau primària CustomerID de la taula Customers,
establint una relació 1-N entre les dues taules.
*/
CREATE TABLE Customers (
  CustomerID INT PRIMARY KEY,
  CustomerName VARCHAR(255)
);

CREATE TABLE Orders (
  OrderID INT PRIMARY KEY,
  OrderDate DATE,
  CustomerID INT,
  FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- EX5
--Inserirem dos registres a la taula Customers i dos registres per a cada registre de la taula Orders.
/*
hem inserit dos registres a la taula Customers amb els valors 1 i 'Customer A',
i 2 i 'Customer B'. Després, hem inserit registres a la taula Orders relacionats
amb els registres de Customers, creant dos registres per a cada registre de Customers.
En aquest exemple, hem inserit els registres a les Orders amb els valors següents:

OrderID = 1, OrderDate = '2023-04-23', CustomerID = 1
OrderID = 2, OrderDate = '2023-04-24', CustomerID = 1
OrderID = 3, OrderDate = '2023-04-23', CustomerID = 2
OrderID = 4, OrderDate = '2023-04-24', CustomerID = 2
OrderID = 5, OrderDate = '2023-04-23', CustomerID = 1
OrderID = 6, OrderDate = '2023-04-24', CustomerID = 2
*/

-- Inserir registres a la taula Customers
INSERT INTO Customers (CustomerID, CustomerName) VALUES (1, 'Customer A');
INSERT INTO Customers (CustomerID, CustomerName) VALUES (2, 'Customer B');

-- Inserir registres a la taula Orders
INSERT INTO Orders (OrderID, OrderDate, CustomerID) VALUES (1, '2023-04-23', 1);
INSERT INTO Orders (OrderID, OrderDate, CustomerID) VALUES (2, '2023-04-24', 1);
INSERT INTO Orders (OrderID, OrderDate, CustomerID) VALUES (3, '2023-04-23', 2);
INSERT INTO Orders (OrderID, OrderDate, CustomerID) VALUES (4, '2023-04-24', 2);
INSERT INTO Orders (OrderID, OrderDate, CustomerID) VALUES (5, '2023-04-23', 1);
INSERT INTO Orders (OrderID, OrderDate, CustomerID) VALUES (6, '2023-04-24', 2);

INSERT INTO asix. VALUES (1, 'Daniel', 'Olivares', 1);

-- EX6
--Crear un nou usuari a Oracle amb el nom SMX i la contrasenya 1234
CREATE USER SMX IDENTIFIED BY 1234;

-- EX7
/*
Atorgar permisos a l'usuari SMX que hem creat, utilitzarem les comandes GRANT.
Concretament, els permisos que es volen atorgar són els següents:

    Connectar-se a la base de dades.
    Crear vistes sobre les taules d'ASIX.
    Seleccionar dades de les taules d'ASIX.
    Modificar una columna d'una de les taules creades a ASIX.

Amb aquestes comandes, l'usuari SMX hauria de tenir els permisos necessaris per
connectar-se a la base de dades, crear vistes a la base de dades de l'usuari ASIX,
seleccionar dades de les taules Customers i Orders de l'usuari ASIX i modificar la
columna CustomerName de la taula Customers.
*/

-- Permetre la connexió a la base de dades
GRANT CONNECT TO SMX;

-- Permetre crear vistes a ASIX
GRANT CREATE VIEW TO SMX;

-- Permetre seleccionar dades de les taules d'ASIX (FER AMB USUARI ASIX)
GRANT SELECT ON Customers TO SMX;
GRANT SELECT ON Orders TO SMX;

-- Permetre modificar una columna de la taula Customers (FER AMB USUARI ASIX)
GRANT UPDATE (CustomerName) ON Customers TO SMX;

-- EX8
--Crear una vista que mostri totes les dades de les dues taules de l'esquema ASIX, l'usuari SMX hauria de connectar-se primerament a la base de dades com a l'usuari ASIX
CONNECT ASIX/1234;

/*
Aquesta vista crearia una nova vista anomenada "all_data" que conté totes les dades de les taules Customers i Orders
de l'esquema ASIX. L'usuari SMX ara pot accedir a aquesta vista per seleccionar les dades necessàries.
*/

--Una vegada connectat, l'usuari SMX pot crear la vista que mostra totes les dades de les dues taules.
CREATE VIEW all_data AS
SELECT *
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID;


-- EX9
/*
No serà possible per a l'usuari HR seleccionar tota la informació de la nova vista "all_data"
creada per l'usuari SMX perquè l'usuari HR no té permisos per accedir a les taules Customers i
Orders de l'esquema ASIX, així com tampoc té permisos per accedir a la vista creada per l'usuari SMX.

Per permetre que l'usuari HR pugui accedir a aquesta vista, hauríem de concedir els permisos SELECT
necessaris a l'usuari HR. Podem fer-ho executant la següent comanda SQL amb l'usuari que té els permisos
per concedir aquest accés (en aquest cas, l'usuari SMX):
*/

/*
D'aquesta manera, l'usuari HR tindria els permisos necessaris per seleccionar les dades de la vista "all_data".
*/
GRANT SELECT ON all_data TO HR;

-- EX10
/*
L'usuari ASIX hauria de ser capaç de seleccionar tota la informació de la nova
vista "all_data" que ha estat creada a l'esquema ASIX per l'usuari SMX, ja que
l'usuari ASIX té permisos per accedir a les taules Customers i Orders, així com
a la vista creada per l'usuari SMX.
*/
/*
Això retornarà totes les dades de les taules Customers i Orders que
es troben en la vista "all_data" creada per l'usuari SMX.
*/
SELECT * FROM all_data;

--EX11
/*
L'usuari SMX hauria de ser capaç de seleccionar tota la informació de la nova
vista "all_data" que ha estat creada a l'esquema ASIX per ell mateix, ja que ha
creat la vista i, per tant, té permisos per accedir-hi. 
*/
/*
Això retornarà totes les dades de les taules Customers i Orders que es troben en la vista "all_data" creada per l'usuari SMX.
*/
SELECT * FROM all_data;

-- EX12
--Per comprovar que es pot modificar una columna específica en una taula de l'esquema ASIX amb l'usuari SMX
UPDATE orders SET order_date = SYSDATE WHERE order_id = 1;

/*
Això modificarà la data de la comanda amb l'identificador 1 a la data actual del sistema.
Si l'usuari SMX té permisos per modificar la columna "order_date" de la taula "orders" en
l'esquema ASIX, la comanda s'executaria correctament.

D'altra banda, per comprovar que l'usuari SMX no pot modificar les altres columnes de la taula,
podem intentar modificar una altra columna a la taula, com ara la columna "customer_id".
Si l'usuari SMX no té permisos per modificar aquesta columna, la comanda fallarà i es mostrarà un missatge d'error. Per exemple:
*/
UPDATE orders SET customer_id = 2 WHERE order_id = 1;
/*
Això intentaria modificar el valor de la columna "customer_id" de la taula
"orders" en l'esquema ASIX per a la comanda amb l'identificador 1.
Si l'usuari SMX no té permisos per modificar aquesta columna,
la comanda fallarà i es mostrarà un missatge d'error.
*/


-- EX 13
-- Per treure el permís a l'usuari SMX per modificar la columna "customer_id" de la taula "orders" en l'esquema ASIX
REVOKE UPDATE(customer_id) ON orders FROM SMX;

/*
Això revocarà el permís per a l'usuari SMX per modificar la columna "customer_id" de la taula "orders" en l'esquema ASIX.

Per comprovar que ja no es poden fer modificacions a la columna "customer_id" de la taula
"orders" en l'esquema ASIX, podem executar la mateixa comanda SQL d'abans per intentar modificar la columna:
*/
UPDATE orders SET customer_id = 2 WHERE order_id = 1;
/*
Això hauria de mostrar un missatge d'error que indica que l'usuari SMX no té permisos per actualitzar la columna "customer_id".
*/

-- EX 14
/*
Per mostrar les vistes de diccionari que mostren informació sobre els usuaris creats,
els rols creats, els privilegis dels rols creats, els privilegis dels usuaris
creats i els rols otorgats als usuaris creats
*/

-- Per mostrar els usuaris creats:
SELECT * FROM dba_users;

-- Per mostrar els rols creats:
SELECT * FROM dba_roles;

-- Per mostrar els privilegis dels rols creats:
SELECT * FROM dba_role_privs;

-- Per mostrar els privilegis dels usuaris creats:
SELECT * FROM dba_sys_privs;

-- Per mostrar els rols otorgats als usuaris creats:
SELECT * FROM dba_role_privs WHERE grantee = 'nom_usuari';





-- PREGUNTAS DE EXAMEN:
/*
Que usuarios tiene el rol connect asignado?
    SELECT * FROM dba_role_privas
        WHERE granted_role = 'conncet';
*/


/*
Crea el usuario 'hola' y dale permisos de modificar columna 'buenos dias' de la tabla 'adios' del esquema 'suyo'.
CREATE USER HOLA
GRANT UPDATE (BuenosDias) ON Suyo.adios TO HOLA;
*/


--una tabla no tiene permisos
/*
Que privilegios tiene el usario 'HR' 
SELECT privileges FROM dba_system_privs
    WHERE grantee = 'HR';
-------------
Bloque el usuario/cuenta 'HR', que no pueda iniciar sesion.
ALTER USER HR ACCOUNT LOCK;
------------------
Desbloquear el usuario/cuenta 'HR'.
ALTER USER HR ACCOUNT UNLOCK;
------------------
Cambia el password de 'HR'.
ALTER USER HR IDENTIFIED BY 1234;
--------------------
BORAR USUARIO:
DROP USER
---------------------
Muestra la vista de los usuarios, y de esos usuarios que privilegios tienen.

Quien puede selecionar datos de la tambla employees de hr

*/


------------------APUNTES CLASES-------------------

--conectarse
GRANT CREATE SESSION TO smx;
-- priv. de sistema
GRANT CREATE ANY VIEW TO smx;
-- priv.objeto
GRANT SELECT ON daw.tutor TO smx;
GRANT SELECT ON daw.alumne TO smx;
GRANT UPDATE(id_tutor,nom) ON daw.alumne TO smx;

--luego comruebame los privilegios de la lista




CONNECT smx/1234;
CREATE VIEW daw.v_alumnes_daw AS
    SELECT a.id_alumne,
        a.nom AS nom_alumne,
        a.cognom AS cognom-alumne,
        t.nom AS nom_tutor,
        t.cognom AS cognom_tutor
    FROM daw.tutor t
        JOIN daw.alumne a
            ON (t.id_tutor=a.id_tutor);

SELECT * FROM daw.v_alummnes-daw;




--11
CONNECT smx/1234;
SELECT *FROM daw.v_alumnes_daww;
  -- NO funciona
  
--12

SELECT * FROM daw.alumne;

UPDATE daw.alumne
    SET id_autor = 2
    WHERE id_alumne = 1;

COMMIT;

-- BEFORE 13 Muestra tooodos los privilegios que tiene el usuario SMX

CONNECT sys/1234 AS sysdba;

SELECT * FROM dba_sys_privs
    WHERE grantee = 'SMX';

SELECT * FROM dba_tab_privs
    WHERE grantee = 'SMX';
    
SELECT * FROM dba_col_privs
    WHERE grantee = 'SMX';

SELECT * FROM dba_role_privs
    WHERE grantee = 'SMX';

DESC dba_role_privs;






-- QUE USUARIOS TIENEN ASIGNADOS EL ROL CONNECT?

SELECT * FROM dba_role_privs
    WHERE granted_role = 'CONNECT';


-- CREAMOS UN ROL LLAMADO def_role
CREATE ROLE def_role;

GRANT connect TO def_role;





-- 13

CONNECT system/1234;

REVOKE UPDATE ON daw.alumne FROM smx;

CONNECT smx/1234;

SELECT * FROM user_col_privs;
SELECT * FROM user_tab_privs;
SELECT * FROM user_sys_privs;



-- 14

CONNECT sys/1234 AS sysdba;

SELECT *FROM dba_users
    WHERE TO_CHAR(created, 'DD/MM/YY')='29/04/24';
    
SELECT * FROM dba_roles;

-- TE SALE TANTO COMO USUARIOS Y ROLES
SELECT * FROM dba_sys_privs
    WHERE grantee = 'BASIC_PRIVS';
-- TE SALE SOLO ROLES
SELECT * FROM role_sys_privs
    WHERE role = 'BASIC_PRIVS';

SELECT * FROM role_role_privs;

-- Como quito el rol connect a def_role
CONNECT sys/1234 AS sysdba;
REVOKE connect FROM def_role;
    


/*EXTRAS*/

/*Dale al usuario SMX2 privilegios para
connectarse, y tranferir ese privilegio a otros*/
CONNECT sys/1234 AS sysdba;
GRANT create session TO smx2 WITH ADMIN OPTION;

/*Dale al usuario SMX2 privilegios para
consultar los empleados de HR y transferir ese privilegio a otros*/

CONNECT sys/1234 AS sysdba;
GRANT SELECT ON hr.employees TO smx2 WITH GRANT OPTION;




------PREGUNTAS CLASE--------

-- crear usuario Mario

CREATE USER mario
    IDENTIFIED BY 1234
    ACCOUNT LOCK;


GRANT unlimited tablespace TO mario;

-- desbloquear al usuario mario

ALTER USER mario ACCOUNT UNLOCK;

-- Quitar el priv unlimited tablespace a mario
REVOKE unlimited tablespace FROM mario;


-- Mostrar el usuario
SELECT * FROM dba_users
    WHERE username = 'MARIO';

-- crear un rol llamdo "laja" con premisos para crear vistas y tablas
CREATE ROLE laja;
GRANT create tabla, create view TO laja;

-- dale premisos a "laja" para cambiar los sueldos de hr

GRANT update(salary) ON hr.employees TO laja;

-- Dale permisos a "laja" para crear roles y seleccionar empelados de HR
-- de sistema
GRANT create role TO laja;
-- y de objeto
GRANT select ON hr.employees TO laja

-- Muestra todos los privilegios que tiene "laja"
SELECT * FROM dba_sys_privs
    WHERE grantee = 'LAJA';
SELECT * FROM dba_tab_privs
    WHERE grantee = 'LAJA';
SELECT * FROM dba_col_privs
    WHERE grantee = 'LAJA';


-- Muestrame quien tiene el rol "laja"
CREATE USER rin IDENTIFIED BY 1234;
GRANT laja TO rin;

SELECT * FROM dba_role_privs
    WHERE granted_role = 'LAJA';


-- QUITAR PERMISOS DE SELECT Y UPDATE A "laja"
-- es de objeto
REVOKE select, update ON hr.employees FROM laja;















