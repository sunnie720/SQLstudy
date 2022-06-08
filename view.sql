/* �� */
-- �� ���� Ȯ��
SELECT * FROM USER_VIEWS;

-- �� ���� ����
-- ���� ����ڿ��� �־��� ���� �� ROLE Ȯ��
SELECT * FROM USER_SYS_PRIVS; 
SELECT * FROM USER_ROLE_PRIVS;
-- hr ����ڿ��� �� ���� ���� �ο�: GRANT CREATE VIEW TO hr

-- �� ����
-- CREATE VIEW ���� ������ ��������(����,�׷�,�������� ���� ����)�� �ۼ�
-- [WITH CHECK OPTION]: ���� �������ǿ� ���� ������ ������ �ุ DML ������ ���
-- [WITH READ ONLY]: �並 ���� DML �۾��� �Ұ����� ���
-- 60�� �μ��� ��� ����� ���� ���λ����� �����ϴ� ��
CREATE OR REPLACE VIEW emp_view_dept60 
AS SELECT employee_id, first_name, last_name, job_id, salary
   FROM employees
   WHERE department_id=60;
DESC emp_view_dept60; 
SELECT * FROM emp_view_dept60;
DROP VIEW emp_view_dept60;
-- ���� ���� Ư�� �̸�����: 1) SELECT ���� ����Ī ��� 2) CREATE VIEW ���� ���̸� ����
CREATE OR REPLACE VIEW emp_dept60_salary
AS SELECT employee_id AS empno,
          first_name||' '||last_name AS name,
          salary AS monthly_salary
   FROM employees
   WHERE department_id=60;
DESC emp_dept60_salary;
DROP VIEW emp_dept60_salary;
CREATE VIEW emp_dept60_salary (empno, name, monthly_salary)
AS SELECT employee_id, first_name||' '||last_name, salary
   FROM employees
   WHERE department_id=60;
DESC emp_dept60_salary;

-- �� ����
-- �� ���� �� ����Ŭ ���� �۾� �ܰ�
-- 1) USER_VIEWS ������ ���� ���̺��� �� ���� �˻�
-- 2) ��� ���̺� ���� �׼��� ���� Ȯ��
-- 3) �����͸� �⺻ ���̺��� �˻� �Ǵ� �⺻ ���̺��� �����Ϳ� ����
SELECT * FROM USER_VIEWS;

-- �� ����
-- CREATE OR REPLACE VIEW �� ���
CREATE OR REPLACE VIEW emp_dept60_salary
AS SELECT employee_id AS empno,
          first_name || ' ' || last_name AS name,
          job_id AS job, -- ���� �信�� job �߰�
          salary
FROM employees
WHERE department_id=60;
DESC emp_dept60_salary;

-- ���� �� ����
-- ���� ��: �� �� �̻� ���̺�κ��� ���� ���÷��� �ϴ� ��, DML �Ұ���
-- ��� ����� ���̵�, �̸�, �μ��̸�, �����̸� �� (DEPARTMENTS, JOBS ���̺� ����)
CREATE VIEW emp_view
AS SELECT employee_id id, 
          first_name name, 
          department_name department, 
          job_title job
FROM employees e
LEFT JOIN departments d ON e.department_id=d.department_id
LEFT JOIN jobs j ON e.job_id=j.job_id;
SELECT * FROM emp_view;
-- hr ��Ű���� �̹� ����Ǿ� �ִ� ��ǥ���� ���� ��
SELECT * FROM emp_details_view;

-- �� ����
DROP VIEW emp_dept60_salary;

-- �並 �̿��� DML ����
-- ���� ��Ģ
-- 1) �ܼ� �信�� DML ������ ������ �� ����
-- 2) �� ���� �Ұ��� ����: �信 �׷��Լ�, GROUP BY��, DISTINCT ����
-- 3) �� ���� �Ұ��� ����: �信 �� 2)����, ǥ�������� ���ǵ� ��, ROWNUM �ǻ翭 ����
-- 4) �� �߰� �Ұ��� ����: �信 �� 3)���� ����, �信 �������� ���� NN���� �⺻���̺� ����
DROP TABLE emps;
CREATE TABLE emps -- �ǽ��� ���̺� ����
AS SELECT * FROM employees;

-- DML ������ ��
CREATE OR REPLACE VIEW emp_dept60
AS SELECT * FROM emps WHERE department_id=60;
-- �並 ���� �⺻ ���̺� emps���� 104�� ��� ���� ����
DELETE FROM emp_dept60 WHERE employee_id=104;
-- �⺻ ���̺� emps���� 104�� ��� ���� Ȯ�� -- no row selected
SELECT * FROM emps WHERE employee_id=104;

-- �� ���� �Ұ����� ��
CREATE OR REPLACE VIEW emp_dept60
AS SELECT DISTINCT * FROM emps WHERE department_id=60;
-- �並 ���� �⺻ ���̺� emps���� 106�� ��� ���� ���� �õ� -- ����
DELETE FROM emp_dept60 WHERE employee_id=106; 

-- �� ���� �Ұ����� ��
CREATE OR REPLACE VIEW emp_dept60
AS SELECT
        employee_id,
        first_name || ', ' || last_name AS name, 
        salary*12 AS annual_salary -- ǥ����
    FROM emps WHERE department_id=60;
-- 106�� ��� ���� ���� �õ� -- ����
UPDATE emp_dept60 SET annual_salary=annual_salary*1.1
WHERE employee_id=106;
-- ������ �� ��� ���Ŵ� ����
DELETE FROM emp_dept60 WHERE employee_id=106;

-- �� �߰� �Ұ����� ��
CREATE OR REPLACE VIEW emp_dept60 
AS SELECT employee_id, first_name, last_name, email, salary 
   FROM emps WHERE department_id=60;
DESC emp_dept60;
-- hire_date, job_id�� NN�������� ���õ��� ����
DESC emps;
-- hire_date, job_id���� null �Ұ��̹Ƿ� �並 ���� �߰��Ϸ��� �ϸ� ����
INSERT INTO emp_dept60
    VALUES (500, 'JinKyoung', 'Heo', 'HEOJK', 8000);

-- WITH CHECK OPTION
-- ���Ἲ �������ǰ� ������ ���� üũ ���
-- ��, �並 ������ �˻��� �� ���� �� ���� �Ǵ� ������ ������� ����
CREATE OR REPLACE VIEW emp_dept60
AS SELECT employee_id, first_name, hire_date, salary, department_id
   FROM emps
   WHERE department_id=60
WITH CHECK OPTION;
-- 105�� ����� �μ��� 10���� ���� �õ� -- ����
---- �μ���ȣ 10������ �ٲ�� �䰡 ���̻� ���� �信 �ִ� ������� �� �� ����. ���� ����
UPDATE emp_dept60
SET department_id=10 
WHERE employee_id=105;

-- WITH READ ONLY
-- DML ���� ����� �� ������ ���
CREATE OR REPLACE VIEW emp_dept60
AS SELECT employee_id, first_name, hire_date, salary, department_id
   FROM emps
   WHERE department_id=60
WITH READ ONLY;
select * from emp_dept60;
-- �信�� �� �����Ϸ��� �ϸ� ����
DELETE FROM emp_dept60
WHERE employee_id=105;

-- �ζ��� ��
-- FROM ���� ���������� �� ��
-- SQL �������� ��� ������ ��Ī(��� �̸�)�� ����ϴ� ��������
-- �޿��� ���� ���� �޴� ������� ���� 10�� ����� �̸��� �޿� ���
SELECT row_number, first_name, salary
FROM (SELECT first_name, salary,
             ROW_NUMBER() OVER (ORDER BY salary DESC) row_number
      FROM employees) 
WHERE row_number<=10;