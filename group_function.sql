/* �׷��Լ� */
/* �׷��Լ�,GROUP BY,HAVING,GROUPING SETS,ROLLUP,CUBE,GROUPING,GROUPING_ID */
-- ������ �Լ��� �޸� �׷� �� �ϳ��� ����� �ֵ��� ���� �׷쿡 ���� ����
-- COUNT(*)�� ������ ��� �׷� �Լ��� ���� �ִ� Null ���� ���꿡�� ����

-- AVG, SUM, MIN, MAX �Լ�
--��� �Ǹſ��� ���ؼ� �޿��� ���, �ְ��, ������, �հ�
select avg(salary), max(salary), min(salary), sum(salary)
from employees
where job_id like 'SA%'; -- SA_MAN, SA_REP
--MIN, MAX�� ��¥, ����, ���� ��� ����
--���� ���� �Ի��� ����� �Ի��ϰ� ���� ���߿� �Ի��� ����� �Ի���
select min(hire_date), max(hire_date) from employees;
select first_name, hire_date
from employees
where hire_date=(select min(hire_date) from employees)
    OR hire_date=(select max(hire_date) from employees);
--���ĺ������� ���� ���� ����� �̸��� ���� ���� ���
select min(first_name), max(last_name)
from employees;
--���� ū �޿���
select max(salary) from employees;
select first_name, salary from employees
where salary = (select max(salary) from employees);

-- COUNT(*): ��ü ���̺� ���� �� (�ߺ�, Null ����)
-- COUNT(expr): Ư�� ������ Null�� �ƴ� ���� ��
--��� ����� ��
select count(*) from employees;  --107
-- Ŀ�̼��� �޴� ����� ��
select count(commission_pct) from employees;  --35

-- STDDEV(STDDEV_SAMP): Null ���� ������ ǥ��ǥ������ (��ǥ������ STDDEV_POP)
-- VARIANCE(VAR_SAMP): Null ���� ������ ǥ���л� (��л� VAR_POP)
--������� �޿��� ����, ��հ� ǥ������, �׸��� �л��� �Ҽ��� ���� �� ��° �ڸ������� ���
select sum(salary) �հ�, 
    round(avg(salary),2) ���, 
    round(stddev(salary),2) ǥ������, 
    round(variance(salary),2) �л�
from employees;

-- �׷��Լ��� NULL ��
-- COUNT(*)�� ������ ��� �׷� �Լ��� ���� �ִ� Null ���� ���꿡�� ����
select round(avg(salary*commission_pct),2) as avg_bonus
from employees; --����� ���ʽ��� �޴� ����� ���� 35�� ������ ���
select 
    round(sum(salary*commission_pct),2) as sum_bonus,
    count(*) as count,
    round(avg(salary*commission_pct),2) as avg_bonus1,
    -- avg_bonus1 �� ���� ���� (null�� �����ϰ� ���)
    round(sum(salary*commission_pct)/count(*),2) as avg_bonus2
    -- AVG_BONUS2�� ���ʽ��� ��(sum_bonus)�� ��� ����� ��(count)�� ���� ���
from employees; 
-- NVL �Լ� ����ϸ� null�� �� 0 ��ȯ�ؼ� null�� ������ ������ �� ����
select round(avg(NVL(salary*commission_pct,0)),2) as avg_bonus2
from employees;

-- GROUP BY
-- SELECT ������ �׷� �Լ��� ���Ե��� �ʴ� ���� �ݵ�� GROUP BY ���� ���ԵǾ�� ��
select department_id, avg(salary)
from employees
GROUP BY department_id;
-- �� �μ� ���� ������ �޿� �հ�
select department_id, job_id, sum(salary)
from employees
GROUP BY department_id, job_id
order by department_id;

-- HAVING
-- �׷��� �����ϱ� ���ؼ��� HAVING �� ��� (��. �μ��� �޿������ 8000 �ʰ�)
select department_id, round(avg(salary),2) as avg_sal
from employees
group by department_id
HAVING avg(salary)>8000
order by avg_sal desc;
-- ������ �޿������ 8000 �ʰ� & Sales ������ ����ϴ� ����� ����
select job_id, round(avg(salary),2) as avg_sal
from employees
where job_id NOT LIKE 'SA%'
group by job_id
HAVING avg(salary)>8000
order by avg_sal desc;

-- GROUPING SETS
-- GROUP BY ���� UNION ALL �������� ���յ� ������ ��� (����, �������)
-- GROUP BY �� �ȿ� �׷�ȭ�� ������ ���� ����: GROUP BY GROUPING SETS (��1, ��2,..)
-- �μ��� �޿��� ��հ� ������ �޿��� ��� ��� (GROUP BY + UNION ALL)
select to_char(department_id), round(avg(salary),2) avg_sal -- job_id�� ����ġ
    from employees
    GROUP BY department_id
UNION ALL
select job_id, round(avg(salary),2)
    from employees
    GROUP BY job_id
order by 1;
-- (�μ��� �޿����)�� (������ �޿����)�� ��� (GROUPING SETS)
select department_id, job_id, round(avg(salary),2)
from employees
group by GROUPING SETS (department_id, job_id)
order by 1,2;                                                                      -- department_id, job_id �� �� NULL�� ����?
-- 2�� �̻��� �� �׷�ȭ�� ����
-- (�μ���, ������ ��� �޿�)�� (������ �Ŵ����� ��� �޿�) ���
select department_id, job_id, manager_id,
        round(avg(salary),2) as avg_sal
from employees
GROUP BY
    GROUPING SETS ((department_id, job_id), -- �μ���, ������
                    (job_id, manager_id)) -- ������, �Ŵ�����
order by department_id, job_id, manager_id;                                         -- job_id 'SA_REP', manager_id (null) ���µ� ����?

-- ROLLUP, CUBE
-- �κ��� �Ǵ� ����ǥ�� ���� �� ���
-- �⺻: �μ���, ������ �޿��� ��հ� ����� ��
select department_id, job_id, round(avg(salary),2), count(*)
from employees
GROUP BY department_id, job_id
order by department_id, job_id;
-- ROLLUP: �⺻ + �� �μ��� (��հ� �����) + ��ü (��հ� �����) 
select department_id, job_id, round(avg(salary),2), count(*)
from employees
GROUP BY ROLLUP(department_id, job_id)
order by department_id, job_id;
-- CUBE: ROLLUP + �� ������ (��հ� �����) --ù��° �� �Ӹ� �ƴ϶� ������ ��� ����!
select department_id, job_id, round(avg(salary),2), count(*)
from employees
GROUP BY CUBE(department_id, job_id)
order by department_id, job_id;                                               -- kimberley �μ� null OK�ε� �� ������ SA_REP�� �ƴ϶� null��?

-- GROUPING
-- 1 �Ǵ� 0�� ��ȯ
-- 1 ��ȯ: GROUPING SETS, ROLLUP, CUBE���� '�Ұ�'�� ǥ���ϱ� ���� ���Ƿ� ������ (null)
-- 0 ��ȯ: �����Ͱ� ���� ������ �ְų� (null) ��ü�� ����� ���
-- DECODE�Լ��� �Բ� ����Ͽ� ����Ǵ� �κп� '�Ұ�' ���ڸ� ���
select 
    DECODE(GROUPING(department_id),1,'�Ұ�',to_char(department_id)) as �μ�,
    DECODE(GROUPING(job_id),1,'�Ұ�',job_id) as ����,
    round(avg(salary),2) as ���,
    count(*) as ����Ǽ�
from employees
GROUP BY CUBE(department_id, job_id)
order by �μ�, ����;

-- GROUPING_ID
-- �׷�ȭ ������ �ĺ��ϰ� ���� �� ���
-- GROUPING_ID�� ����ϸ� ���� GROUPING �Լ��� �ʿ� ���� 
-- �׷�ȭ ���غ� ���ڸ� ��ȯ�ϹǷ� DECODE�� �̿��� ���� �����Ͽ� ǥ�� ����
select 
    DECODE(GROUPING_ID(department_id, job_id), 
            2, '�Ұ�', 3, '�հ�', department_id) as �μ���ȣ,
    DECODE(GROUPING_ID(department_id, job_id),
            1, '�Ұ�', 3, '�հ�', job_id) as ����,
    GROUPING_ID(department_id, job_id) as GID, 
    round(avg(salary),2) as ���,
    count(*) as ����Ǽ�
from employees
GROUP BY CUBE(department_id, job_id)
order by �μ���ȣ, ����;


                        





