/* �Լ� */
-- �Լ�, �����Լ�, ����ǥ�����Լ�, �����Լ�, ��¥�Լ�, ��ȯ�Լ�, ���տ�����
-- �������Լ�: �����࿡���� ���� ����, �ະ�� �ϳ��� ��� ��ȯ (����, ����, ��¥, ��ȯ)
-- �������Լ�: ������ �� ����, �� �׷�� �ϳ��� ��� ��ȯ
-- ���ڿ� �Լ�
SELECT * FROM NLS_DATABASE_PARAMETERS; -- ���ڵ� Ȯ��(NLS_CHARACTERSET)
select * from dual; -- ����Ŭ 1��1�� ǥ�����̺�. �Ͻ����� ���/��¥ ������ ���� �ַ� ���
select ltrim('JavaScript', 'Jav') from dual;  -- Script
select replace('JavaSpecialist', 'Java', 'BigData') from dual; --BigDataSpecialist
select translate('javaspecialist', 'abc', 'xyz') from dual; --jxvxspezixlist
--��������
select RPAD(substr(first_name,1,3),length(first_name),'*') as name, 
        LPAD(salary, 10, '*') as salary
from employees
where lower(job_id)='it_prog';

-- ����ǥ���� �Լ�
-- ����ǥ����: ��ġ�ϴ� �ؽ�Ʈ�� "����"�� ǥ���ϱ� ���� ǥ��ȭ�� �ؽ�Ʈ ���� ������ ����

-- REGEXP_LIKE: ����ǥ�� ������ ����� �˻�
create table test_regexp (col1 varchar2(10)); --���� ���̺� ����
insert into test_regexp values('ABCED01234');
insert into test_regexp values('01234ABCDE');
insert into test_regexp values('abcde01234');
insert into test_regexp values('01234abcde');
insert into test_regexp values('1-234-5678');
insert into test_regexp values('234-567890');
--���ڷ� ����, ���ҹ��ڷ� ��
select * 
from test_regexp
where REGEXP_LIKE(col1, '[0-9][a-z]'); 
--XXX-XXXX�������� ������ ��
select * 
from test_regexp
where REGEXP_LIKE(col1, '[0-9]{3}-[0-9]{4}$'); 
select *
from test_regexp
where REGEXP_LIKE(col1, '[[:digit:]]{3}-[[:digit:]]{4}$');
--XXX-XXXX������ �����ϴ� ��
select *
from test_regexp
where REGEXP_LIKE(col1, '[[:digit:]]{3}-[[:digit:]]{4}');

-- REGEXP_INSTR: ������ ������ �����ϴ� �κ��� ���� ��ġ ��ȯ
insert into test_regexp values('@!=)(9&%$#');
insert into test_regexp values('�ڹ�3');
--Ư�� ���ڿ��� ��ġ ���
select col1,
    REGEXP_INSTR(col1, '[0-9]') as data1,
    REGEXP_INSTR(col1, '%') as data2
from test_regexp;

-- REGEXP_SUBSTR: ������ ������ �����ϴ� �κ��� ���ڿ� ��ȯ
--C���� Z���� ���ĺ� �̾Ƴ���
select col1, REGEXP_SUBSTR(col1, '[C-Z]+')
from test_regexp;

-- REGEXP_REPLACE: ������ ������ �����ϴ� �κ��� ������ �ٸ� ���ڿ��� ġȯ 
--0���� 2������ ������ ���ڸ� *�� ��ȯ
select col1, REGEXP_REPLACE(col1, '[0-2]+', '*')
from test_regexp;

--��������: XXX.XXX.XXXX���� ��ȭ��ȣ ���
select first_name, phone_number
from employees
where REGEXP_LIKE(phone_number, '^[0-9]{3}.[0-9]{3}.[0-9]{4}$');
select first_name, phone_number
from employees
where REGEXP_LIKE(phone_number, '^[[:digit:]]{3}.[[:digit:]]{3}.[[:digit:]]{4}$');
--��������: XXX.XXX.XXXX���� ��ȭ��ȣ �ǵ� 4�ڸ� *�� ����ŷ, 4�ڸ� ���� ���� ���
select first_name, 
    concat(SUBSTR(phone_number, 1,8), '****') phone, 
    SUBSTR(phone_number, 9, 12) phone2
from employees;
select first_name, 
    REGEXP_REPLACE(phone_number, '[[:digit:]]{4}$', '****') phone,
    REGEXP_SUBSTR(phone_number, '[[:digit:]]{4}$') as phone2
from employees
where REGEXP_LIKE(phone_number, '^[0-9]{3}.[0-9]{3}.[0-9]{4}$');

-- �����Լ� 
-- ���ڸ� �Է� �ް� ���ڰ��� ��ȯ�� 
select ROUND(1234.1234, -1) from dual; --1230
select CEIL(123.45) from dual;  --124
select FLOOR(123.45) from dual;  --123
select SIGN(123) from dual;  --1
select SIGN(-123) from dual;  -- -1
select MOD(4,3) from dual; --1 (4%3; m�� n���� ���� ������)
select REMAINDER(4,3) from dual; --MOD�� ���� but BINARY_DOUBLE Ÿ�Ե� ����

-- ��¥����
select SYSDATE from dual; --���糯¥
select SYSTIMESTAMP from dual; --���糯¥+�ð�����
--�μ� 60�� ���ϴ� ��� ����� ���ؼ� �̸��� ������� �ٹ��� �� week ���
select first_name, (SYSDATE - hire_date)/7 as week 
from employees
where department_id=60;

-- ��¥�Լ�
--��� ��¥�Լ��� DATE Ÿ�� ��ȯ (��, MONTHS_BETWEEN�� ���ڰ� ��ȯ)
--�ٹ��� ���� �� 
select first_name, SYSDATE, hire_date, 
    TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) workmonth --�� ���� ������ �� ��(����) 
from employees;
--Diana ����� �Ի��ϰ� �Ի� �� 100���� �� �Ǵ� ��¥
select first_name, hire_date, ADD_MONTHS(hire_date, 100)
from employees
where first_name='Diana';
--������ ȭ����
select SYSDATE, NEXT_DAY(SYSDATE, 'ȭ') from dual;
--���� ������ ��¥
select SYSDATE, LAST_DAY(SYSDATE) from dual;
--���� ������ �ݿø�(round)/����(trunc)
select TRUNC(SYSDATE, 'Year') from dual; --22/01/01
select ROUND(SYSDATE, 'Month') from dual; --22/05/01
select TRUNC(SYSDATE, 'Day') from dual; --�Ͽ��� ��¥ ��ȯ
select ROUND(SYSDATE) from dual; --�ð�(HH)�������� �ݿø�

-- ��ȯ�Լ�
select employee_id, first_name, hire_date
from employees
-- �Ͻ��� ����ȯ
where hire_date='03/06/17'; --��¥<=>����
-- ����� ����ȯ
-- TO_CHAR: ��¥ �Ǵ� ���ڸ� ����������
select first_name, TO_CHAR(hire_date, 'MM/YY') as HiredMonth
from employees
where first_name='Steven'; --��¥=>����
--��� ����� �̸��� �Ի��� (�Ի����� ��2003�� 06�� 17�ϡ� ����)
select first_name, TO_CHAR(hire_date, 'YYYY"��" MM"��" DD"��"') hiredate
from employees;
select first_name, TO_CHAR(hire_date, 'fmYYYY"��" MM"��" DD"��"') hiredate
from employees; --fm:��,�Ͽ� 0 ����
-- �Ի��� ��Seventeenth of June 2003 12:00:00 AM�� ����
select first_name, 
    TO_CHAR(hire_date, 'fmDdspth "of" Month YYYY fmHH:MI:SS AM', 
    'NLS_DATE_LANGUAGE=english') hiredate 
from employees; 
--fm:������ ���� ����/�ð�,��,���� ����0 ���� (hire_date�� �ð����� ��� 12:00:00�� ǥ��
--���ڸ� "$999,999" ���� ��������
select first_name, last_name, TO_CHAR(salary, '$999,999') salary
from employees
where first_name='David';
select first_name, last_name, salary*0.123456 as salary1,
    TO_CHAR(salary*0.123456, '$999,999.99') as salary2  --�ڵ� �ݿø�
from employees
where first_name='David';
-- TO_NUMBER: ���ڸ� ����������
select TO_NUMBER('$5,500.00', '$999,999.99') - 4000 from dual;
-- TO_DATE: ���ڸ� ��¥������
SELECT first_name, hire_date
FROM employees
WHERE hire_date=TO_DATE('2003/06/17', 'YYYY/MM/DD');
SELECT first_name, hire_date
FROM employees
WHERE hire_date=TO_DATE('2003��06��17��','YYYY"��"MM"��"DD"��"');

-- Null ġȯ�Լ�: NVL, NVL2, COALESCE
--NVL
select first_name, 
    salary + salary*NVL(commission_pct, 0) bonus_sal --���ʽ��� ������ ���, ������0
from employees;
--NVL2
select first_name,
    NVL2(commission_pct, salary+salary*commission_pct, salary) bonus_sal
from employees;
--COALESCE
select first_name,
    COALESCE(salary+salary*commission_pct, salary) bonus_sal
from employees;  --ù��° ǥ������ Null�ƴϸ� ��ȯ, Null�̸� �ι�° ǥ���� ��ȯ
--�� ����ó ������ �߿� �ϳ��� ��� �� 
select COALESCE(cellphone, home, office, '����ó ����')
from customer; --���� ���̺� ����

-- ��Ÿ ��ȯ �Լ�
--LNNVL: �����̸� True, ���̸� False ��ȯ
--���ʽ� 650 �̸��� ���
select first_name, COALESCE(salary*commission_pct, 0) bonus
from employees
where LNNVL(salary*commission_pct >= 650);
select first_name, COALESCE(salary*commission_pct, 0) bonus
from employees
where salary*commission_pct < 650
UNION ALL
select first_name, COALESCE(salary*commission_pct, 0) bonus
from employees
where salary*commission_pct is null;

-- DECODE �Լ�: IF-THEN-ELSE ������ ����
select job_id, salary, 
    DECODE(job_id, 'IT_PROG',   salary*1.10,
                    'FI_MGR',   salary*1.15,
                    'FI_ACCOUNT',salary*1.20,
                                salary) 
    as revised_salary
from employees;

-- CASE~WHEN~THEN: IF-ELSE ������ ����
-- CASE �ڿ� ǥ������ ������ WHEN ������ ��, CASE �ڿ� �����̸� WHEN ���� ���ǽ�
select job_id, salary,
    CASE job_id WHEN 'IT_PROG' THEN salary*1.10
                WHEN 'FI_MGR' THEN salary*1.15
                WHEN 'FI_ACCOUNT' THEN salary*1.20
        ELSE salary
    END AS REVISED_SALARY
from employees;
select employee_id, salary,
    CASE WHEN salary < 5000 THEN salary*1.2
        WHEN salary < 10000 THEN salary*1.10
        WHEN salary < 15000 THEN salary*1.05
        ELSE salary
    END AS revised_salary
FROM employees;

-- ���� ������
--2�� �̻��� SQL���� ����� �̿��� ������ ����� ������
--ù ��° SELECT���� �� ��° SELECT���� ���� ������ �� ������ Ÿ���� �ݵ�� ��ġ�ؾ���

-- UNION(�ߺ�����), UNION ALL(�ߺ����): ������
--04�⿡ �Ի��Ͽ��ų� �μ���ȣ�� 20�� ���
--- UNION(�ߺ�����)
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%' 
UNION
select employee_id, first_name, hire_date, department_id
from employees
where department_id=20; 
----UNION�� �Ʒ� OR �����ڿ� ����
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%' 
    OR department_id=20;
--- UNION ALL(�ߺ����) 
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%' 
UNION ALL
select employee_id, first_name, hire_date, department_id
from employees
where department_id=20; -- Michael �� �� �ߺ�

-- INTERSECT: ������
--ù ��° ������ �� ��° �������� �ߺ��� �ุ ���
--04�⿡ �Ի��Ͽ��� �μ���ȣ�� 20�� ���
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%' 
INTERSECT
select employee_id, first_name, hire_date, department_id
from employees
where department_id=20;
----INTERSECT�� �Ʒ� AND �����ڿ� ����
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%'
    AND department_id=20;
    
-- MINUS: ������
--ù ��° �������� �ְ� �� ��° �������� ���� ������
--04�⿡ �Ի��Ͽ�����, �μ���ȣ�� 20�� �ƴ� ���
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%' 
MINUS
select employee_id, first_name, hire_date, department_id
from employees
where department_id=20;
-- �Ʒ��� ����
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%' 
    and department_id not in (20);
------------------------------------------------------------------------------

/* �������� */
--1. �̸��Ͽ� lee�� �����ϴ� ����� ��� ������ ����ϼ���.
select * from employees
where lower(email) like '%lee%';

--2. �Ŵ��� ���̵� 103�� ������� �̸��� �޿�, �������̵� ����ϼ���.
select first_name, salary, job_id
from employees
where manager_id=103;

--3. 80�� �μ��� �ٹ��ϸ鼭 ������ SA_MAN�� ����� ������ 20�� �μ��� �ٹ��ϸ鼭 
--�Ŵ��� ���̵� 100�λ���� ������ ����ϼ���. ������ �ϳ��� ����ؾ� �մϴ�.
select * from employees
where (department_id=80 and job_id='SA_MAN') 
    OR (department_id=20 and manager_id=100);

--4. ��� ����� ��ȭ��ȣ�� ###-###-#### �������� ����ϼ���.
select first_name, REPLACE(phone_number, '.', '-')  phone
from employees;

--5. ������ IT_PROG�� ����� �߿��� �޿��� 5000 �̻��� ������� �̸�(Full Name), 
--�޿� ���޾�, �Ի���(2005-02-15����), �ٹ��� �ϼ��� ����ϼ���. 
--�̸������� �����ϸ�, �̸��� �ִ� 20�ڸ�, ���� �ڸ��� *�� ä��� 
--�޿� ���޾��� �Ҽ��� 2�ڸ��� ������ �ִ� 8�ڸ�, $ǥ��, ���� �ڸ��� 0���� ä�� ����ϼ���.
select RPAD(first_name||' '||last_name, 20, '*') as "Full Name", 
    TO_CHAR(salary, '$099,999.99') sal,
    TO_CHAR(hire_date, 'YYYY-MM-DD') HiredDate,
    round(SYSDATE - hire_date) WorkedDays
from employees
where job_id='IT_PROG' and salary>=5000
order by 1;
--����) �޿� ���޾��� ����(salary)�� ���ʽ��� ���� �ݾ�!!
select RPAD(first_name||' '||last_name, 20, '*') as "Full Name", 
    TO_CHAR(coalesce(salary+salary*commission_pct, salary), '$099,999.99') pay,
    TO_CHAR(hire_date, 'YYYY-MM-DD') HiredDate,
    round(SYSDATE - hire_date) WorkedDays
from employees
where upper(job_id)='IT_PROG' and salary>=5000
order by 1;

--6. 30�� �μ� ����� �̸�(full name)�� �޿�, �Ի���, ������� �ٹ� ���� ���� ����ϼ���. 
--�̸��� �ִ� 20�ڷ� ����ϰ� �̸� �����ʿ� ���� ������ *�� ����ϼ���. 
--�޿��� �󿩱��� �����ϰ� �Ҽ��� 2�ڸ��� ������ �� 8�ڸ��� ����ϰ� ���� �ڸ��� 0���� 
--ä��� ���ڸ����� ,(�޸�) ���б�ȣ�� �����ϰ�, �ݾ� �տ� $�� �����ϵ��� ����ϼ���.
--�Ի����� 2005��03��15�� �������� ����ϼ���. �ٹ� ���� ���� �Ҽ��� ���ϴ� ������
--����ϼ���. �޿��� ū ������� ���� ������ ����ϼ���.
select 
    RPAD(first_name||' '||last_name, 20, '*') as "Full Name",
    TO_CHAR(coalesce(salary+salary*commission_pct, salary), 
        '$099,999.99') as pay,
    TO_CHAR(hire_date, 'YYYY"��"MM"��"DD"��"') HiredDate,
    TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) WorkedMonths
from employees
where department_id=30
order by pay desc;

--7. 80�� �μ��� �ٹ��ϸ鼭 salary�� 10000���� ū ������� �̸��� 
--�޿� ���޾�(salary + salary * commission_pct)�� ����ϼ���. �̸��� Full Name���� 
--����ϸ� 17�ڸ��� ����ϼ���. ���� �ڸ��� *�� ä�켼��. �޿��� �Ҽ��� 2�ڸ��� ������ 
--�� 7�ڸ��� ����ϸ�, ���� �ڸ��� 0���� ä�켼��. $ ǥ�ø� �ϸ� �޿� ������ �����ϼ���.
select 
    RPAD(first_name||' '||last_name, 17, '*') as "Full Name",
    TO_CHAR(coalesce(salary+salary*commission_pct, salary), 
        '$09,999.99') as pay
from employees
where department_id=80 and salary>10000
order by pay desc;

--8. 60���μ� ����� �̸��� ���� ���ڸ� �������� ������� �ٹ��� �ٹ������� 5����, 10����, 
--15������ ǥ���ϼ���. 5��~ 9�� �ٹ��� ����� 5������ ǥ���մϴ�. �������� ��Ÿ�� ǥ���մϴ�. 
--�ٹ������� �ٹ�������/12�� ����մϴ�.
select first_name �̸�, 
    case when (months_between(sysdate, hire_date)/12)<5 then '��Ÿ'
        when (months_between(sysdate, hire_date)/12)<10 then '5����'
        when (months_between(sysdate, hire_date)/12)<15 then '10����' 
        when (months_between(sysdate, hire_date)/12)<20 then '15����'
        when (months_between(sysdate, hire_date)/12)>=20 then '��Ÿ'
    end as �ٹ�����
from employees
where department_id=60;
--����) �ٹ�������/12/5�� ������ ���� ���� ������ ����
select first_name as �̸�,
    decode(trunc(trunc(months_between(SYSDATE, hire_date)/12)/5),
        1, '5����',
        2, '10����',
        3, '15����',
        '��Ÿ')
    as �ٹ����
from employees
where department_id=60;

--9. Lex�� �Ի����� 1000��° �Ǵ� ����?
select first_name, hire_date+1000
from employees
where first_name='Lex';

--10. 5���� �Ի��� ����� �̸��� �Ի����� ����ϼ���.
select first_name, hire_date
from employees
where to_char(hire_date, 'MM')='05';

--11. ������ �� �̸��� �޿��� ����ϼ���.
--����1)�Ի��� ������ ����� ���� �����, ���̸��� ��year��, ������ ��(�Ի�⵵)�� �Ի硱
--����2)�Ի��� ������ ����� ���� �����, ���̸��� ��day��, ������ �����ϡ�
--����3)�Ի����� 2010�� ������ ����� �޿��� 10%, 2005�� ������ ����� �޿��� 5% �λ�
--�� ���� �̸��� ��INCREASING_SALARY���Դϴ�.
--����4)INCREASING_SALARY ���� ������ �տ� ��$����ȣ�� �ٰ�, �� �ڸ����� �޸�(,)
select first_name, salary,
    to_char(hire_date, 'YYYY"�� �Ի�"') as year,   --'RRRR"�� �Ի�"'
    to_char(hire_date, 'Day') as day,
    case when to_number(to_char(hire_date, 'YYYY'))>=2010 
            then to_char(salary*1.1, '$999,999')
         when to_number(to_char(hire_date, 'YYYY'))>2005
            then to_char(salary*1.05, '$999,999')
         else to_char(salary, '$999,999')
    end as increasing_salary
from employees;

--12. ����� �̸�, �޿�, �Ի�⵵, �λ�� �޿��� ����ϼ���.
--����1) �Ի��� ������ ����ϼ���. �� ���� �̸��� ��year���̰�, ��(�Ի�⵵)�� �Ի硱����
--����2) �Ի����� 2010���� ����� �޿��� 10%, 2005���� ����� �޿��� 5%�� �λ�. 
--���� �̸��� ��INCREASING_SALARY2���Դϴ�.
select first_name, salary, 
    to_char(hire_date, 'YYYY"�� �Ի�"') as year,   --'RRRR"�� �Ի�"'
    case when to_char(hire_date, 'YY')='10' then salary*1.1
         when to_char(hire_date, 'YY')='05' then salary*1.05
         else salary
    end as increasing_salary2
from employees;
--����) DECODE �Լ��� ��� ����
select first_name, salary, 
    to_char(hire_date, 'YYYY"�� �Ի�"') as year,   --'RRRR"�� �Ի�"'
    decode(to_char(hire_date, 'YY'), 
            '10', salary*1.1,
            '05', salary*1.05,
                  salary)
    as increasing_salary2
from employees;

--13. ��ġ��� �� ��(state) ���� ���� null�̶�� �������̵� ����ϼ���.
select * from locations;
select country_id, NVL(state_province, country_id) state
from locations;

