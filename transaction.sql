/* Ʈ�����(Transaction) */
-- ������ �۾� �����̸�, �и��Ǹ� �ȵ�
-- COMMIT, ROLLBACK�� ���ؼ� ��������� �����ϰų�, DDL�̳� DCL �������� �ڵ� Ŀ��
-- SAVEPOINT�� �߰� ROLLBACK�� ���� ���� ����

-- SAVEPOINT & ROLLBACK
-- ��, ���̺�����Ʈ�� �ѹ� �Ǿ��ٰ� �ؼ� �� �������� Ŀ�ԵǴ� ���� �ƴ�
-- emps ���̺��� 10�� �μ� ��� ���� ����
DELETE FROM emps WHERE department_id=10;
-- �ѹ� ���� ���� (10�� ��� ������)
SAVEPOINT delete_10;
-- 20�� �μ� ��� ���� ����
DELETE FROM emps WHERE department_id=20;
-- �ѹ� ���� ���� (10��,20�� ��� ������)
SAVEPOINT delete_20;
-- 30�� �μ� ��� ���� ����
DELETE FROM emps WHERE department_id=30;
SELECT * FROM emps WHERE department_id=30; -- �����Ǿ� ���� ����
-- 30�� �μ� ��� ���� ���� ���
ROLLBACK TO SAVEPOINT delete_20;
SELECT * FROM emps WHERE department_id=30; -- ������ҵǾ� ���� ��Ÿ��

-- LOCK
-- �б� �ϰ���
-- ������ ����ڰ� DML �۾��� �����ϱ� ����, ������ Ŀ�� �ÿ� ����� �����͸� �� �� �ֵ��� ����
-- ���߼��ǿ��� ���� �ð��� ������ �����͸� �����ϴ� ���� ����
-- �ְ��� ������ ���ü� ���� ���: LOCK TABLE table_name IN EXCLUSIVE MODE

-- DML�� LOCK
DROP TABLE emp;
CREATE TABLE emp AS
SELECT employee_id AS empno, first_name AS ename,
salary AS sal, department_id AS deptno
FROM employees;









