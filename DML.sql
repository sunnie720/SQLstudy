/* DML(Data Manipulation Language) */

-- DML ����
-- 1)���̺� ���ο� ���� �߰��� �� - INSERT
-- 2)������ ���� ������ �� -- UPDATE
-- 3)������ ���� ������ �� -- DELETE
-- ������ Ʈ������ Ŀ���� ����Ǿ�� ��

-- CTAS(CREATE TABLE AS SELECT)
-- ������ ���̺�� ������ ���� ���̺� ����. ��, NOT NULL�� ������ ���������� ����X
DROP TABLE emp1;
CREATE TABLE emp1 AS SELECT * FROM employees;
SELECT COUNT(*) FROM emp1; -- 107
-- SELECT ������������ ��ȣ() �������� ����. WHERE���� FALSE�� ���� ������ ����
DROP TABLE emp2 IF EXISTS;
CREATE TABLE emp2 AS SELECT * FROM employees WHERE 1=2;
SELECT COUNT(*) FROM emp2; -- 0

-- INSERT �⺻
-- INSERT �� �ϳ��� �ϳ��� �� �߰�
-- �÷��� ������Ÿ���� ���缭 �Է��ؾ� ��
-- ���̺� ���� Ȯ��:
DESC departments;  -- department_id, department_name, managr_id, location_id
INSERT INTO departments 
VALUES (280, 'Data Analytics', null, 1700);
SELECT * FROM departments WHERE department_id=280;
INSERT INTO departments
    (department_id, department_name, location_id)
VALUES 
    (290, 'Data Analytics', 1700);
SELECT * FROM departments WHERE department_id>=280;
ROLLBACK; -- commit �ȵ� DML �������

-- INSERT ���������� ���� �� ����
-- ������ �� �߰� ����
DROP TABLE managers;
CREATE TABLE managers AS
SELECT employee_id, first_name, job_id, salary, hire_date
FROM employees
WHERE 1=2; -- ���̺� ������ ����
-- EMPLOYEES ���̺�κ��� SELECT �������� ��ȸ�� ����� MANAGERS ���̺� ����
INSERT INTO managers 
    (employee_id, first_name, job_id, salary, hire_date) -- ��������
    SELECT employee_id, first_name, job_id, salary, hire_date
    FROM employees
    WHERE job_id LIKE '%MAN'; -- 12�� �� ����
SELECT * FROM managers;

-- UPDATE �⺻
-- ������ �� ����. �ϳ� �̻��� �� ���� ����
DROP TABLE emps;
CREATE TABLE emps AS SELECT * FROM employees; -- �� ���̺� ����
ALTER TABLE emps
ADD (CONSTRAINTS emps_emp_id_pk PRIMARY KEY (employee_id),
     CONSTRAINTS emps_manager_id_fk FOREIGN KEY (manager_id)
        REFERENCES emps(employee_id)
); -- ���̺� �������� �߰�
-- 103�� ����� ��� ���̵�, �̸�, �޿�
SELECT employee_id, first_name, salary
FROM emps
WHERE employee_id=103;  -- �޿� 9000
-- ������Ʈ: 103 ����� �޿��� 10% �λ�
UPDATE emps
SET salary=salary*1.1
WHERE employee_id=103;
-- 103 ������� �ٽ� Ȯ��
SELECT employee_id, first_name, salary
FROM emps
WHERE employee_id=103;  -- �޿� 9900
COMMIT; -- DML�� Ʈ������ ����� ����

-- UPDATE ���������� ���� �� ����
-- ���� �� ������
SELECT employee_id, first_name, job_id, salary, manager_id
FROM emps
WHERE employee_id IN (108, 109);
-- 109�� ����� ����, �޿�, �Ŵ����� 108�� ����� �����ϰ� ����
UPDATE emps
SET (job_id, salary, manager_id) = (SELECT job_id, salary, manager_id
                                    FROM emps
                                    WHERE employee_id=108)
WHERE employee_id=109;
-- ���� �� ������
SELECT employee_id, first_name, job_id, salary, manager_id
FROM emps
WHERE employee_id IN (108, 109);

-- DELETE �⺻
-- ���̺� ���� ��, ���� ���Ἲ �������ǿ� ����
-- DELETE: �����͸� ����. rollback���� ������� ����
-- TRUNCATE: �����͸� ����. rollback���� ������� �Ұ���
-- DROP: �����Ϳ� ���� ��� ����. rollback���� ������� �Ұ���
SELECT * FROM emps 
WHERE employee_id=104;
-- 104�� ��� ������ ����
DELETE FROM emps 
WHERE employee_id=104;
-- 103�� ��� ������ ���� -- ����: ���Ἲ �������� ���� 
DELETE FROM emps 
WHERE employee_id=103; 
SELECT * FROM emps -- 103�� ��� ���̵� �ٸ� ����� �Ŵ��� ���̵�� �����ǰ� ����
WHERE manager_id=103;

-- DELETE ���������� ���� �� ����
DROP TABLE depts;
CREATE TABLE depts AS
SELECT * FROM departments;
DESC depts;
-- emps ���̺��� �μ����� Shipping�� ��� ��� ������ ����
DELETE from emps
WHERE department_id = (SELECT department_id
                       FROM depts
                       WHERE department_name='Shipping'
); -- 45�� �� ����
COMMIT;

-- RETURNING
-- DML ������ ���� ������ �޴� �� �˻�
-- SQL Developer���� �����ϸ� ���ε� ������ ���� �Է��϶�� â�� �����
-- �Ʒ� ������ SQL Command Line �Ǵ� SQL Plus �̿��ؼ� ����
-- VARIABLE emp_name VARCHAR2(50);
-- VARIABLE emp_sal NUMBER;
-- VARIABLE;
-- DELETE emps
-- WHERE employee_id=109
-- RETURNING first_name, salary INTO :emp_name, :emp_sal;
-- PRINT emp_name;
-- PRINT emp_sal;

-- MERGE
-- INSERT���� UPDATE�� ���ÿ� ���
CREATE TABLE emps_it AS SELECT * FROM employees WHERE 1=2; 
INSERT INTO emps_it
    (employee_id, first_name, last_name, email, hire_date, job_id)
VALUES
    (105, 'David', 'Kim', 'DAVIDKIM', '06/03/04', 'IT_PROG');
-- emps_it ���̺�� employees ���̺� ����
-- emps_it ���̺� ��� ���̵� ���� ����� 
-- ������ ���� ������ employees ���̺� �������� UPDATE / ������ INSERT
MERGE INTO emps_it a
    USING (SELECT * FROM employees WHERE job_id='IT_PROG') b -- ���� ����
    ON (a.employee_id=b.employee_id)
WHEN MATCHED THEN
    UPDATE SET 
        a.phone_number = b.phone_number,
        a.hire_date = b.hire_date,
        a.job_id = b.job_id,
        a.salary = b.salary,
        a.commission_pct = b.commission_pct,
        a.manager_id = b.manager_id,
        a.department_id = b.department_id
WHEN NOT MATCHED THEN
    INSERT VALUES
    (b.employee_id, b.first_name, b.last_name, b.email,
     b.phone_number, b.hire_date, b.job_id, b.salary,
     b.commission_pct, b.manager_id, b.department_id);
SELECT * FROM emps_it;

-- Multiple INSERT
-- �ϳ��� INSERT ������ �ϳ��� ���� ���� ���� ���̺� ���ÿ� �Է�

-- UNCONDITIONAL INSERT ALL
-- ���ǰ� �������, ����� ���� ���� ���̺� �����͸� �Է�
-- 300�� ��� ������ emp1��, 400�� ��� ������ emp2�� ����
INSERT ALL
  INTO emp1
    VALUES (300, 'Kildong', 'Hong', 'KHONG', '011.624.7902',
            TO_DATE('2015-05-11', 'YYYY-MM-DD'), 'IT_PROG', 6000,
            null, 100, 90)
  INTO emp2
    VALUES (400, 'Kilseo', 'Hong', 'KSHONG', '011.3402.7902',
            TO_DATE('2015-06-20', 'YYYY-MM-DD'), 'IT_PROG', 5500,
            null, 100, 90)
  SELECT * FROM dual;
-- employees ���̺� �����͸� �� ������ ������ ����
CREATE TABLE emp_salary AS
  SELECT employee_id, first_name, salary, commission_pct
  FROM employees
  WHERE 1=2;
CREATE TABLE emp_hire_date AS
  SELECT employee_id, first_name, hire_date, department_id
  FROM employees
  WHERE 1=2;
INSERT ALL
  INTO emp_salary VALUES
    (employee_id, first_name, salary, commission_pct)
  INTO emp_hire_date VALUES
    (employee_id, first_name, hire_date, department_id)
  SELECT * FROM employees;

-- CONDITIONAL INSERT ALL
-- Ư�� ���ǵ��� ����Ͽ� �� ���ǿ� �´� ����� ���ϴ� ���̺� ������ ����
CREATE TABLE emp_10 AS SELECT * FROM employees WHERE 1=2;
CREATE TABLE emp_20 AS SELECT * FROM employees WHERE 1=2;
-- �μ���ȣ�� 10�� ����� EMP_10�� �����ϰ�, �μ���ȣ�� 20�� ����� EMP_20�� ����
INSERT ALL
  WHEN department_id=10 THEN
    INTO emp_10 VALUES
        (employee_id, first_name, last_name, email, phone_number,
        hire_date, job_id, salary, commission_pct, manager_id, department_id)
  WHEN department_id=20 THEN
    INTO emp_20 VALUES
        (employee_id, first_name, last_name, email, phone_number,
        hire_date, job_id, salary, commission_pct, manager_id, department_id)
  SELECT * FROM employees;
SELECT * FROM emp_10;
SELECT * FROM emp_20;

-- CONDITIONAL INSERT FIRST
-- ù ��° WHEN ������ ������ ������ ��� ������ WHEN ���� �������� ����
CREATE TABLE emp_sal5000 AS
  SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal10000 AS
  SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal15000 AS
  SELECT employee_id, first_name, salary FROM employees WHERE 1=2;  
CREATE TABLE emp_sal20000 AS
  SELECT employee_id, first_name, salary FROM employees WHERE 1=2;
CREATE TABLE emp_sal25000 AS
  SELECT employee_id, first_name, salary FROM employees WHERE 1=2;  
-- �޿� ������ ���� ���� �ٸ� ���̺� �����͸� ������ ����
INSERT FIRST
  WHEN salary <= 5000 THEN
    INTO emp_sal5000 VALUES (employee_id, first_name, salary)
  WHEN salary <= 10000 THEN
    INTO emp_sal10000 VALUES (employee_id, first_name, salary)
  WHEN salary <= 15000 THEN
    INTO emp_sal15000 VALUES (employee_id, first_name, salary)
  WHEN salary <= 20000 THEN
    INTO emp_sal20000 VALUES (employee_id, first_name, salary)
  WHEN salary <= 25000 THEN
    INTO emp_sal25000 VALUES (employee_id, first_name, salary)
  SELECT employee_id, first_name, salary FROM employees;
SELECT COUNT(*) FROM emp_sal5000;  -- 49��
SELECT COUNT(*) FROM emp_sal10000; -- 43
SELECT COUNT(*) FROM emp_sal15000;  --12
SELECT COUNT(*) FROM emp_sal20000;  --2
SELECT COUNT(*) FROM emp_sal25000;  --1

-- PIVOTING INSERT
-- ���� ���� into ���� ����� �� ������, into �� �ڿ� ���� ���̺��� ��� ���ƾ� ��
-- ������� �����ͺ��̽��� ������ �����ͺ��̽� ������ ���� �� ��� 
select * from sales;
-- sales ���̺��� �����͸� UNPIVOT �Ͽ� �����ϱ� ���� ���̺� ����
TRUNCATE TABLE sales_data;
select * from sales_data;
-- sales�� �� ������ ����Ǿ� �ִ� ���̺��� �����͸� ������� ����
INSERT ALL
  INTO sales_data
    VALUES(employee_id, week_id, 'SALES_MON', sales_mon)
  INTO sales_data
    VALUES(employee_id, week_id, 'SALES_TUE', sales_tue)
  INTO sales_data
    VALUES(employee_id, week_id, 'SALES_WED', sales_wed)
  INTO sales_data
    VALUES(employee_id, week_id, 'SALES_THU', sales_thu)
  INTO sales_data
    VALUES(employee_id, week_id, 'SALES_FRI', sales_fri)
  SELECT employee_id, week_id, sales_mon, sales_tue, sales_wed, 
         sales_thu, sales_fri
  FROM sales;
