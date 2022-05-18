/* 5. �м� �Լ� */
-- �׷� ������ ���� ����Ѵٴ� ������ �׷� �Լ��� ����������,
-- �ึ�� 1���� ��� ���� ��ȯ�Ѵٴ� ������ ����
-- ������(window): �м��Լ������� �׷�
-- �м��Լ��� SELECT ���� ORDER BY ������ ����� �� ����

-- ���� ���ϱ� �Լ� - RANK, DENSE_RANK, ROW_NUMBER
-- RANK: �ش� ���� ���� ���� (�ߺ����� ���. 2�� 2���̸� ������ 4��)
-- DENSE_RANK: �ش� ���� ���� ���� (�ߺ����� ��� ����)
-- ROW_NUMBER: ������ �����ϴ� ��� ���� �Ϸù�ȣ ����
-- �޿��� ū ������� �̸�, �޿�, ���� ���
select employee_id, department_id, salary,
    RANK()          OVER (ORDER BY salary desc) sal_rank,
    DENSE_RANK()    OVER (ORDER BY salary desc) sal_dense_rank,
    ROW_NUMBER()    OVER (ORDER BY salary desc) sal_number
from employees;

-- ��������� ����(�ִ밪1�� �� ����� ��ġ) - CUME_DIST, PERCENT_RANK
-- CUME_DIST(����� ��ġ): ù��° �� 1/N, �ι�° �� 2/N, ����° �� 3/N, ...
-- PERCENT_RANK(����� ����): ù��° �� 0, �ι�° �� 1/N-1, ����° �� 2/N-1, ...
-- �޿��� ��� ���̵�, �μ���ȣ, �޿�����. �޿��� ����� ��ġ�� ����� ����
select employee_id, department_id, salary,
    CUME_DIST()     OVER (ORDER BY salary desc) sal_cume_dist,
    PERCENT_RANK()  OVER (ORDER BY salary desc) sal_pct_rank
from employees;
-- COMMISSION_PCT ���� ��������
select employee_id, department_id, salary,
    CUME_DIST()     OVER (ORDER BY commission_pct desc) comm_cume_dist,
    PERCENT_RANK()  OVER (ORDER BY commission_pct desc) comm_pct_rank
from employees; -- 1~n�� �� ���� ��� CUME_DIST�� ��� n/N��, PCT_RANK�� ��� 0

-- ���� �Լ� - RATIO_TO_REPORT
-- �׷� ������ �ش� ���� ������� �Ҽ������� ���� (0<��ȯ��<=1)
-- IT_PROG�� ������� ������� �μ��� ��ü �޿����� ������ �����ϴ� ����
select first_name, salary,
    round(RATIO_TO_REPORT(salary) OVER (), 4) as salary_ratio
from employees
where job_id='IT_PROG';

-- �м��Լ��� �ึ�� �� ���� ����� ��ȯ�Ѵٴ� �ǹ� Ȯ��
select department_id,
    round(AVG(salary) OVER (PARTITION BY department_id), 2)
from employees;  -- 107�� (�μ��� �޿� ����� ���ϰ� �� �ึ�� �� �μ� ������ ��ȯ)
select department_id, round(AVG(salary), 2)
from employees
GROUP BY department_id; -- 12��

-- �й��Լ� - NTILE
-- ��ü ������ ������ n���� �������� ������ ǥ��
-- �μ���ȣ�� 50�� �����(45��)�� 10�������� ������ ǥ��
select employee_id, department_id, salary,
    NTILE(10) OVER (ORDER BY salary desc) sal_quart_tile
from employees
where department_id=50; -- ����1~5������ 5��, ����6~10�� 4��

-- LAG(��,n[,0]): �������� ���� n��° ���� �� ��������. ������ 0 ���
-- LEAD(��,n[,1]): �������� ���� n��° ���� �� ��������. ������ 1 ���
-- ��� ��� ���� �޿� ���� �� �ܰ� ������ ���� ���� �޿� ���
select employee_id, salary,
    LAG(salary,1,0) OVER (ORDER BY salary) as lower_sal,
    LEAD(salary,1,0) OVER (ORDER BY salary) as higher_sal
from employees
order by salary;

-- LISTAGG(expr, 'delimiter') WITHIN GROUP(ORDER BY ��)
-- ǥ������ '������'�� �����ؼ� ���� ���� �ϳ��� ������ ��ȯ
-- WITHIN GROUP���� ������ �� �� �ȿ����� ���� (���� ����)
-- �μ��� ����� �̸�
select department_id, first_name
from employees
group by deparment_id; -- first_name�� group by�� ��õ��� �ʰ� select���� �ͼ� ����
select department_id, 
    LISTAGG(first_name,',') WITHIN GROUP(ORDER BY hire_date) as names
from employees
GROUP BY department_id; -- first_name�� �����Լ�ó�� �� ������ �����ָ� ���� 
-- order by ��� department_id�� ���ĵ�

-- ������ ��
-- ��Ƽ������ ���ҵ� �׷쿡 ���� �ٽ� �׷��� ����� ����
-- �м� �Լ��� ������ ������ ���� �� ���
-- ������ �� ���� �� ������ ������ ���� ��
-- ROWS BETWEEN n PRECEDING AND m FOLLOWING 
-- ���� n�� ����� ���� m�� ������� ������!

-- FIRST_VALUE: ���簪���� ������ or ������ ���ϱ�
-- LAST_VALUE: ���簪���� ū�� or ������ ���ϱ�
-- �޿��� �޿��� 1�� ������, 1�� ���İ� ��� (������: 1����~1����)
select employee_id,
  FIRST_VALUE(salary) 
    OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) lower_sal,
  salary as my_sal,
  LAST_VALUE(salary)
    OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) higher_sal
from employees;
-- �޿��� �޿��� 1�� ������, 2�� ���İ� ��� (1����~2����)
select employee_id,
  FIRST_VALUE(salary) 
    OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) lower_sal,
  salary as my_sal,
  LAST_VALUE(salary)
    OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) higher_sal
from employees;
-- �޿��� �޿��� 1�� ������, 2�� ���İ� ��� (1����~2����)
select employee_id,
  FIRST_VALUE(salary) 
    OVER (ORDER BY salary ROWS 1 PRECEDING) lower_sal,
  salary as my_sal,
  LAST_VALUE(salary)
    OVER (ORDER BY salary ROWS BETWEEN 1 PRECEDING AND 2 FOLLOWING) higher_sal
from employees;

-- ����ȸ�� �Լ�
-- REGR_AVGX(y,x): x�� ��� (x,y ��� not null�� ���� ���) 
-- REGR_AVGY(y,x): y�� ��� (x,y ��� not null�� ���� ���) 
-- SALARY�� ���� ����, COMMISSION_PCT�� ���� ������ 
select 
    avg(salary), -- ��� ����� ��� �޿�
    REGR_AVGX(commission_pct, salary) -- ���ʽ��� �޴� ����� ��� �޿�
from employees;
-- ���ʽ��� �޴� ����� ��� �޿��� �Ʒ��� ����
select avg(salary)
from employees
where commission_pct IS NOT NULL;

-- REGR_COUNT(y,x): y,x�� ��� NOT NULL�� ���� ����
-- �μ��� manager_id�� department_id�� ��� NOT NULL�� ���� ��
select distinct department_id,
    REGR_COUNT(manager_id, department_id) 
      OVER (PARTITION BY department_id) as "regr_count"
from employees
order by department_id; -- (90) ���� 2, (null) ���� 0
-- ��) �μ��� ��� ��
select department_id, count(*)
from employees
group by department_id
order by department_id; -- (90) ���� 3, (null) ���� 1

-- REGR_SLOPE(y,x): ȸ�� ������ ���� (=����л�/��л�)
-- REGR_INTERCEPT(y,x): ȸ�� ������ y���� (= AVG(y) - ����*AVG(x))
-- ������μ� ������� �ٹ��Ͽ� ���� �޿��� ������ ����� ����(bias; y����)
-- (�ٹ���(IV)�� ���� �޿�(DV), ������(PARTITION) ����) 
select 
    job_id, employee_id, salary, 
    round(SYSDATE-hire_date) "WORKING_DAY",
    round(REGR_SLOPE(salary, SYSDATE-hire_date) 
      OVER (PARTITION BY job_id), 2) "REGR_SLOPE",
    round(REGR_INTERCEPT(salary, SYSDATE-hire_date) 
      OVER (PARTITION BY job_id), 2) "REGR_INTERCEPT"
from employees
where department_id=80 -- ������ �μ�
order by job_id, employee_id desc;

-- REGR_R2(y,x): ȸ�ͺм��� ���� ������� 
-- ������μ� ������� �ٹ��Ͽ� ���� �޿��� ������ ����, y ����, �������
select 
    job_id, employee_id, salary, 
    round(SYSDATE-hire_date) "WORKING_DAY",
    round(REGR_SLOPE(salary, SYSDATE-hire_date) 
      OVER (PARTITION BY job_id), 2) "REGR_SLOPE",
    round(REGR_INTERCEPT(salary, SYSDATE-hire_date) 
      OVER (PARTITION BY job_id), 2) "REGR_INTERCEPT",
    round(REGR_R2(salary, SYSDATE-hire_date) 
      OVER (PARTITION BY job_id), 2) "REGR_R2"
from employees
where department_id=80; -- ������ �μ�

-- �ǹ� ���̺�
-- ������� �ֺ�, �Ϻ� �Ǹ� ����
-- ������ �����ͺ��̽� ����: �Ʒ� �������� �߰� (�� �߰�)
drop table sales_data;
CREATE TABLE sales_data(
    employee_id NUMBER(6),
    week_id     NUMBER(2),
    week_day    VARCHAR2(10),
    sales       NUMBER(8,2)
);
INSERT INTO sales_data values(1101, 4, 'SALES_MON', 100);
INSERT INTO sales_data values(1101, 4, 'SALES_TUE', 150);
INSERT INTO sales_data values(1101, 4, 'SALES_WED', 80);
INSERT INTO sales_data values(1101, 4, 'SALES_THU', 60);
INSERT INTO sales_data values(1101, 4, 'SALES_FRI', 120);
INSERT INTO sales_data values(1102, 5, 'SALES_MON', 300);
INSERT INTO sales_data values(1102, 5, 'SALES_TUE', 300);
INSERT INTO sales_data values(1102, 5, 'SALES_WED', 230);
INSERT INTO sales_data values(1102, 5, 'SALES_THU', 120);
INSERT INTO sales_data values(1102, 5, 'SALES_FRI', 150);
SELECT * FROM sales_data;
-- ���������Ʈ(�ǹ� ���̺�; ũ�ν��� ����Ʈ) ����: ������ �������� �߰� (�� �߰�)
-- �˾ƺ���� �������� �м��ϱ�� ����� 
-- DECODE �Լ� ���� ����, �������� �ڵ带 �ۼ����� �ʰ� ������ PIVOT �Լ� �̿�

-- PIVOT 
-- week_day�� ���ļ� ���ڴ�
select * 
from sales_data
PIVOT
(
  sum(sales)
  FOR week_day IN('SALES_MON' as sales_mon, 
                  'SALES_TUE' as sales_tue,
                  'SALES_WED' as sales_wed,
                  'SALES_THU' as sales_thu,
                  'SALES_FRI' as sales_fri)
) -- ����Ī ���� ���ϸ� ������� Ȭ����ǥ �״�� ��µ�
order by employee_id, week_id;
-- �ε���(e.g. week_id) �Ϻ� �����ϰ� �����Ϸ��� 1) ��(view) ���
CREATE OR REPLACE VIEW sales_data_view AS
    select employee_id, week_day, sales  -- week_id ����
    from sales_data;
select * 
from sales_data_view  -- ��
PIVOT
(
  sum(sales)
  FOR week_day IN('SALES_MON' as sales_mon, 
                  'SALES_TUE' as sales_tue,
                  'SALES_WED' as sales_wed,
                  'SALES_THU' as sales_thu,
                  'SALES_FRI' as sales_fri)
)
order by employee_id;
-- �ε���(e.g. week_id) �Ϻ� �����ϰ� �����Ϸ��� 1) WITH �� ���
WITH temp AS (
    select employee_id, week_day, sales  -- week_id ����
    from sales_data 
)
select * 
from temp  -- temp ���̺�
PIVOT
(
  sum(sales)
  FOR week_day IN('SALES_MON' as sales_mon, 
                  'SALES_TUE' as sales_tue,
                  'SALES_WED' as sales_wed,
                  'SALES_THU' as sales_thu,
                  'SALES_FRI' as sales_fri)
)
order by employee_id;

-- UNPIVOT
select employee_id, week_id, week_day, sales
from sales
UNPIVOT 
(
  sales
  FOR week_day
  IN(sales_mon, sales_tue, sales_wed, sales_thu, sales_fri)
);





    






