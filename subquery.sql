/* �������� */
-- �ٸ� SELECT ������ ���� ����� SELECT ����
-- ���������� SELECT ���� ���Ǹ�, ��Į��(Scalar)��������
-- ���������� FROM ���� ������, �ζ��� ��(Inline view)
-- ���������� WHERE ���� ������, ��ø(Nested)��������
-- ��ø �������� �߿��� �����ϴ� ���̺��� �θ�/�ڽ� ���踦 ������, ��ȣ���� ��������

-- Nancy�� �޿����� �޿��� ���� �޴� ����̸�, �޿� (Nancy�� �޿��� ��?�� ���� �˾ƾ���)
select first_name, salary
from employees
where salary > (SELECT salary
                FROM employees
                WHERE first_name='Nancy');

-- ������ ��������
-- �������� ����� �ϳ��� �� ('=', '>=' �� ������ ������ ���)
-- 103�� ����� ������ ���� ����� �̸��� ����, �Ի���
select first_name, job_id, hire_date
from employees
where job_id=(SELECT job_id
              FROM employees
              WHERE employee_id=103);

-- ������ ��������
-- ���������� ����� 2�� �� �̻� (IN, EXISTS, ANY, SOME, ALL �� ������ ������ ���)
-- David ����� �޿����� �޿��� ���� �޴� ����̸�, �޿�
-- David ����� �������� (������ ��ȯ)
select first_name, department_id, salary
from employees
where first_name='David'; -- 3�� ��
-- �(ANY) David�� ��� �� David���� �޿��� ���� �޴� ����̸�, �޿� (David �ּڰ��� ��)
select first_name, salary
from employees
where salary > ANY (SELECT salary
                    FROM employees
                    WHERE first_name='David');
-- ���(ALL) David���ٵ� �޿��� ���� �޴� ����̸�, �޿� (David �ִ񰪰� ��)
select first_name, salary
from employees
where salary > ANY (SELECT salary
                    FROM employees
                    WHERE first_name='David');
-- IN ������
-- David�� ���� �μ�
SELECT first_name, department_id, job_id
FROM employees
WHERE department_id IN (SELECT department_id
                        FROM employees
                        WHERE first_name='David');
-- EXISTS ������
SELECT first_name, department_id, job_id
FROM employees e
WHERE EXISTS (SELECT *
              FROM departments d
              WHERE d.manager_id=e.employee_id);

-- ��ȣ���� ��������
-- ���������� ���������� ���� �̿��ϰ�, �׷��� ������ ���������� ���� �ٽ� ���������� �̿�
-- �ڽ��� ���� �μ��� ��պ��� ���� �޿��� �޴� ����� �̸��� �޿�
-- ���������� ���̺��� ������������ ���
SELECT first_name, salary
FROM employees a
WHERE salary > (SELECT avg(salary)
                FROM employees b
                WHERE b.department_id=a.department_id);

-- ��Į�� ��������(SELECT ���� ����ϴ� ��������)
-- ��� ����̸�, �μ��̸� (Join ���� ���� ����)
SELECT first_name, (SELECT department_name
                    FROM departments d
                    WHERE d.department_id=e.department_id) department_name
FROM employees e
ORDER BY first_name;
SELECT first_name, department_name
FROM employees e
JOIN departments d ON (e.department_id=d.department_id)
ORDER BY first_name;

-- �ζ��κ� (FROM ���� ��������)
-- �޿��� ���� ���� �޴� ������� ���� 10���� ��� �̸��� �޿�
-- �ζ��κ�+�м��Լ�
SELECT row_number, first_name, salary
FROM (SELECT first_name, salary,
      row_number() OVER (ORDER BY salary DESC) as row_number
      FROM employees)
WHERE row_number BETWEEN 1 AND 10;
-- ROWNUM �ǻ翭 �̿�
SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
      FROM employees
      ORDER BY salary DESC)
WHERE rownum<=10;
-- ��, ROWNUM�� ù����� ��ȸ�� �Ǿ�߸� �ϹǷ� ���� 11~20���� ��ȸ �Ұ�
SELECT rownum, first_name, salary
FROM (SELECT first_name, salary
      FROM employees
      ORDER BY salary DESC)
WHERE rownum BETWEEN 11 AND 20; -- �ƹ��͵� ��µ��� ����
-- 3������(�ζ��κ�+ROWNUM �ǻ翭) ��� �ڡڡ�
-- ROWNUM�� ������ ���� �״�� �ζ��κ�� ����ؼ� ROWNUM ��ȸ
SELECT rnum, first_name, salary
FROM (SELECT first_name, salary, rownum as rnum
      FROM (SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC)
      )
WHERE rnum BETWEEN 11 AND 20;
-- �ζ��κ�+�м��Լ�
SELECT row_number, first_name, salary
FROM (SELECT first_name, salary,
      row_number() OVER (ORDER BY salary DESC) as row_number
      FROM employees)
WHERE row_number BETWEEN 11 AND 20;

-- ������ �����ڡڡ�
-- ������ ���踦 �ΰ� �ִ� ����� ������ ������ ��ȸ (��ޱ���, BOM ��)
-- ���� ��ޱ��� Ȯ��
SELECT employee_id,
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL -- �ǻ�(Pseudo) ��
FROM employees
START WITH manager_id IS NULL  -- ����1 ���� (���� ���� ���)
CONNECT BY PRIOR employee_id=manager_id  -- ����1 �����ȣ�� = �Ŵ�����ȣ�� ����
ORDER SIBLINGS BY first_name;
-- 113�� ����� ���-�Ŵ��� ���赵 (����)
SELECT employee_id,
       LPAD(' ', 3*(LEVEL-1)) || first_name || ' ' || last_name,
       LEVEL
FROM employees
START WITH employee_id=113
CONNECT BY PRIOR manager_id=employee_id; -- ����1 �Ŵ�����ȣ�� = �����ȣ�� ����








