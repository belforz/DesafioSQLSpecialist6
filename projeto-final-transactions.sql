use company_constraints;
show tables;

-- Rotina 
START transaction;
SELECT * from employee_dept_v;
COMMIT;

START transaction;
SELECT fname as First_Name, lname as Last_Name from employee; 
COMMIT;
desc dependent;

START transaction;
SELECT e.fname as employee_name, d.dependent_name as Dep_Name,FLOOR(DATEDIFF(CURRENT_DATE, d.Bdate) / 365) AS age FROM
dependent d INNER JOIN employee e on e.ssn = d.Essn;
COMMIT;

use oficina;
show tables;

START transaction;
UPDATE clients SET fname = 'Americanas' where idClient=20;
COMMIT;

START transaction;
INSERT INTO clients(idPayment, Fname, Minit, Lname, Address, telefone, nascimento, email) VALUES (1, 'Michael', 'B', 'Johnson', '789 Maple Drive', '56789012375', '1982-11-30', 'michael@example.com');
COMMIT;
desc clients;
drop procedure teste;
DELIMITER //
-- Declaração de variaveis
CREATE PROCEDURE teste(new_idPayment INT, new_Fname VARCHAR(30), new_Minit CHAR(3), new_Lname VARCHAR(20), new_Address VARCHAR(30),
                       new_telefone CHAR(11), new_nascimento DATE, new_email VARCHAR(35))
                       -- Inicia Prodecure
BEGIN
    DECLARE client_count int;
    START TRANSACTION;
		SELECT COUNT(*) INTO client_count
    FROM clients
    WHERE Fname = new_Fname;
    -- Cria-se uma variavel que contabiliza o atributo para saber se são iguais
     IF client_count > 0 THEN 
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cliente já existe, voltando ao estado anterior';
        ROLLBACK;
    -- Caso seja mais que 1, if acionado
    
    INSERT INTO clients (idPayment, Fname, Minit, Lname, Address, telefone, nascimento, email)
    VALUES (new_idPayment, new_Fname, new_Minit, new_Lname, new_Address, new_telefone, new_nascimento, new_email);
    END IF;

    IF ROW_COUNT() = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nada foi inserido, voltando ao estado anterior';
        ROLLBACK;
    END IF;

    COMMIT;
    SELECT 'Transação feita com sucesso' AS Mensagem;
END;
//
DELIMITER ;

Call teste(1, 'John', 'Doe', 'Smith', '123 Main Street', '12345678901', '1990-01-01', 'john@example.com');
Call teste(2,'Joao','C','La','254 Main Street','1199852360','1995-05-02','macedobeira@gmail.com');
Call teste(2,'Caio','C','Hahaha','254 Main Street','1199852360','1995-05-02','macedobeira@gmail.com');
Call teste(2,'Billie','E','Elish','254 Main Street','1199852360','1995-05-02','macedobeira@gmail.com');





