                                        
                                        /*ACT_20*/

--EXERCICI 1 Creacio d'un usuari i assignacio de permisos a partir de comandes SQL:

-- a) Crea un usuari anomenat jv
CONNECT SYS/1234 AS sysdba;

CREATE USER jv IDENTIFIED BY 1234;
DROP USER JV CASCADE;

--comrobamos PUEDE ENTRAR EN EXAMEN
--una vista pra ver los usuarios.
SELECT * FROM dba_users
    WHERE LOWER(username) = 'jv';

--b) Es pot connectar a la BBDD? No Per que?

--c) Assigna-li el privilegi CREATE SESSION perque pugui connectar-se a la BBDD
GRANT CREATE SESSION TO jv;
    --GRANT CONNECT TO jv;

--d) Comprova que ara es pot connectar
CONNECT jv/1234;
    --SI

--e) Comprova quins privilegis incorpora el rol CONNECT. Es equivalent concedir el permis de CREATE SESSION a concedir el rol CONNECT? Si es equivalente 
    CONNECT system/1234;
    SELECT * FROM dba_sys_privs
        WHERE grantee = 'CONNECT';

    DESC role_sys_privs;

    SELECT * FROM role_sys_privs
        WHERE UPPER(role) = 'CONNECT';
        
-- CONNECT es un rol no un privilegio!
-- Si, es igual connect a create session

--f) Fes un llistat dels privilegis que te assignats aquest usuari consultant la taula dba_sys_privs del diccionari de dades.
    SELECT * FROM user_sys_rpvs WHERE grantee = 'JV';
    CONNECT jv/1234;
    SELECT * FROM user_sys_privs;
--g) Assigna-li el rol de RESOURCE
    CONNECT system/1234;
    GRANT RESOURCE TO JV;
    
    -- saber que roles tiene asegnados JV
    SELECT * FROM dba_role_privs
        WHERE UPPER(grantee) = 'JV';
 
    SELECT * FROM dba_sys_privs
        WHERE UPPER(grantee) = 'RESOURCE';
--h) Mira quins privilegis te ara assignats aquest usuari
    CONNECT system/1234;
    SELECT * FROM dba_sys_privs
        WHERE grantee = 'JV';

--i + j) Fes que pugui consultar la taula EMPLOYEES de l'usuari HR i Fes que pugui eliminar files d'aquella taula
--sys
    GRANT SELECT ON hr.employees TO jv;
    GRANT DELETE ON hr.employees TO jv;
    GRANT alter ON hr.employees TO jv;
    
    SELECT * FROM dba_tab_privs
        WHERE grantee = 'JV';

    REVOKE alter ON hr.employees FROM JV;

--k) Comprova que pots inserir nous empleats i eliminar-ne
--INSERT no puedo porque nunca he tenido permisos
--DELETE sí que puedo, pero no lo hago porque me da pena
insert into HR.employees (first_name,last_name,salary) values ('Daniel','Olivares',12000);



--EXERCICI 2 Creacio de rols i assignacio de rols a usuaris
--a) Crea 2 usuaris sense privilegis anomenats profe1 i alumne1
DROP USER alumne1;
DROP USER profe1;

CREATE USER alumne1 IDENTIFIED BY 1234;
CREATE USER profe1 IDENTIFIED BY 1234;

--b) Intenta entrar al sistema amb aquests usuaris. Que passa? No puedo iniciar session en el usuario Per que? porque no le eh puesto los permisos para crear la session
Connect profe1/1234;
connect alumne1/1234;

--c) Assigna-li el privilegi de Create Session als 2 usuaris.
-- No puedo porque no tengo permisos y ya lo sabia.
GRANT create session TO alumne1, peofe1;

--d) Comprova que ara poden entrar al sistema.
CONNECT alumne1/1234;
CONNECT profe1/1234;
    --Ya puedo.

--e + f) Crea el rol ROL alumne amb els privilegis (CREATE TABLE) i Crea el rol ROL profe amb els privilegis (CREATE TABLE, ALTER TABLE, DROP TABLE)
CREATE ROLE rolalumne;
CREATE ROLE rolprofe;

GRANT create table TO rolalumne;
GRANT create table,
        alter any table,
        drop any table TO rolprofe;

--g) Assigna-li el rol ROLprofe a l'usuari profe1 h. Assigna-li el rol de ROL alumne a l'usuari alumne1
GRANT rolalumne TO alumne1;
GRANT rolprofe TO profe1;

--EXERCICI 3 Comproveu les seguents dades:

--a) Comproveu que els usuaris que heu creat apareixen a la vista DBA_USERS. (Feu un DESC d'aquesta vista per poder entendre la informacio que conte). Quan es va crear l'usuari HR?
SELECT created FROM dba_users
    WHERE username = 'POLLOSPA';

--b) Mira la definicio de la taula dba_sys_privs, i fes una consulta que mostri els privilegis de sistema de l'usuari HR.
DESC dba_sys_privs;

SELECT privilege
FROM dba_sys_privs
WHERE LOWER(grantee) = 'hr';









