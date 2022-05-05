/* 2��. SELECT�� �̿��� ������ ��ȸ */

-- ����Ī(alias) 
-- ��Ī�� ����, Ư������(#,$��), ��ҹ��ڸ� �����ϸ� �����ο��ȣ("")�� �ѷ��ξ���
select first_name as �̸�, salary �޿�
from employees;
select first_name "Employee Name",
        salary*12 "Annual Salary"
from employees;

-- ���ͷ�(literal): select ���� ���Ե� ����,ǥ����,����
-- ���� �Ȱ��� ���. ��¥, ���� ���ͷ��� ���� �ο��ȣ('') ��� (���ڴ� x)
select first_name||' '||last_name||'''s salary is $'||salary 
from employees; --���� �ο��ȣ('') ���̿� 's ǥ���ϱ� ���ؼ� '�� �ϳ� �� 

-- DISTINCT: SELECT ������ DISTINCT Ű���� ����Ͽ� �ߺ��Ǵ� �� ����
select department_id
from employees;
select distinct department_id
from employees;

-- ROWID, ROWNUM �ǻ翭
-- �ǻ翭(Pseudo column)�� ���� ���̺��� ������ SELECT ���� ��ó�� ���Ǵ� ������ ��
-- ROWID: �����ͺ��̽����� ���� ������ �ּҰ� ��ȯ
-- ROWNUM: SELECT�� ������ ���ؼ� ��ȯ�Ǵ� ���� ��ȣ�� ������� ���
select ROWID, ROWNUM, employee_id, first_name
from employees;

/* Selection: ���ϴ� ���� ���������� ��ȸ (where��) */
-- ��ҹ��� ����. ���ڿ� ��¥�� ���� �ο��ȣ('') 
select first_name, job_id, department_id
from employees
where job_id='IT_PROG'; -- 'IT_PROG'�� JOB_ID ���� ��ġ�ǵ��� �빮�ڷ� �Է�
-- �Ի����� ��2004�� 1�� 30�ϡ��� ����� ����
select first_name, salary, hire_date
from employees
where hire_date='04/01/30'; --(��¥���� RR/MM/DD)
-- �޿��� $10,000 ���� $12,000 ���̿� �ִ� ���
select first_name, salary
from employees
where salary between 10000 and 12000; --(between: ���Ѱ�, ���Ѱ� ��� ����)
-- �̸��� A�Ǵ� B�� �����ϴ� ����� �̸�, �޿�, �Ի���
select first_name, salary, hire_date
from employees
where first_name between 'A' and 'Bzzzzzzzz';
-- �������� �����ȣ�� 101, 102, �Ǵ� 103�� ��� ��� ����
select employee_id, first_name, salary, manager_id
from employees
where manager_id in (101, 102, 103); --(in: ��õ� ����� �ִ� ���� �׽�Ʈ)
-- ���ϵ�ī��(wildcard) �˻�: ���� ���� ��ġ ���� (LIKE ������ ���)
-- %(�ۼ�Ʈ)�� ���ڰ� ���ų� �ϳ� �̻� ���ڵ� ���
-- _ (���ٹ���)�� ������ �� ���� ���
select first_name, last_name, job_id, department_id
from employees
where job_id LIKE  'IT%'; -- ���ڿ� �״�� �˻�! ('it%'�� �˻��ϸ� ��ȯ�Ǵ� ��x)
-- 2005�⿡ �Ի���, job_id�� "SA_M"�� �����ϴ� ����� �̸��� �������̵� ���
select first_name, job_id, hire_date
from employees
where job_id LIKE 'SA/_M%' ESCAPE '/'  --�˻��� ���ڿ� "_","%"�� ���Ե� ��� ESCAPE
     and hire_date LIKE '05%';
-- �� ������ �켱����: �񱳿����� > NOT > AND > OR

/* ������ ���� */
-- ORDER BY ���� ���� �����ϴµ� ���. SELECT ������ �� �ڿ� ��ġ
-- ASC: ��������, DESC: ��������
select first_name, hire_date
from employees
ORDER BY hire_date, first_name;
-- ORDER BY ���� ����Ī �Ǵ� select���� ������ ��ȣ���� ���
select first_name, salary*12 annual
from employees
ORDER BY annual DESC;
select first_name, salary*12 annual
from employees
ORDER BY 2 DESC; -- ������ ���

/* �������� */
--1. ��� ����� �����ȣ, �̸�, �Ի���, �޿��� ����ϼ���.
select employee_id, first_name, hire_date, salary
from employees;

--2. ��� ����� �̸��� ���� �ٿ� ����ϼ���. �� ��Ī�� name���� �ϼ���.
select first_name||' '||last_name name
from employees;

--3. 50�� �μ� ����� ��� ������ ����ϼ���.
select * from employees
where department_id=50;

--4. 50�� �μ� ����� �̸�, �μ���ȣ, �������̵� ����ϼ���.
select first_name, department_id, job_id
from employees
where department_id=50;

--5. ��� ����� �̸�, �޿� �׸��� 300�޷� �λ�� �޿��� ����ϼ���.
select first_name, salary, salary+300 
from employees;

--6. �޿��� 10000���� ū ����� �̸��� �޿��� ����ϼ���.
select first_name, salary
from employees
where salary>10000;

--7. ���ʽ��� �޴� ����� �̸��� ����, ���ʽ����� ����ϼ���.
select first_name, job_id, commission_pct
from employees
where commission_pct is not null;

--8. 2003�⵵ �Ի��� ����� �̸��� �Ի��� �׸��� �޿��� ����ϼ���. (BETWEEN ������ ���)
select first_name, hire_date, salary
from employees
where hire_date between '03/01/01' and '03/12/31';

--9. 2003�⵵ �Ի��� ����� �̸��� �Ի��� �׸��� �޿��� ����ϼ���. (LIKE ������ ���)
select first_name, hire_date, salary
from employees
where hire_date like '03%';

--10. ��� ����� �̸��� �޿��� �޿��� ���� ������� ���� ��� ������ ����ϼ���.
select first_name, salary
from employees 
order by salary desc;

--11. �� ���Ǹ� 60�� �μ��� ����� ���ؼ��� �����ϼ���.
select first_name, salary
from employees 
where department_id=60
order by salary desc;

--12. �������̵� IT_PROG �̰ų�, SA_MAN�� ����� �̸��� �������̵� ����ϼ���.
select first_name, job_id
from employees
where job_id in ('IT_PROG', 'SA_MAN');

--13. Steven King ����� ������ "Steven King ����� �޿��� 24000�޷��Դϴ�" ��������
select first_name||' '||last_name||' ����� �޿��� '||salary||'�޷��Դϴ�' info
from employees
where first_name='Steven' and last_name='King';

--14. �Ŵ���(MAN) ������ �ش��ϴ� ����� �̸��� �������̵� ����ϼ���.
select first_name, job_id
from employees
where job_id like '%MAN';

--15. �Ŵ���(MAN) ������ �ش��ϴ� ����� �̸��� �������̵� �������̵� ������� ����ϼ���.
select first_name, job_id
from employees
where job_id like '%MAN'
order by job_id;

