/* ���� */
--1. John ����� �̸��� �μ��̸�, �μ���ġ(city)
-- ����Ŭ ����
select e.first_name, d.department_name, l.city
from employees e, departments d, locations l
WHERE first_name='John'
AND e.department_id=d.department_id
AND d.location_id=l.location_id;
-- �Ƚ� ����
select e.first_name, d.department_name, l.city
from employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
WHERE first_name='John';

--2. 103�� ����� �����ȣ, �̸�, �޿�, �Ŵ����̸�, �Ŵ��� �μ��̸� (�Ƚ�����)
select e.employee_id, e.first_name, e.salary, m.first_name, d.department_name
from employees e
JOIN employees m ON e.manager_id=m.employee_id
JOIN departments d ON m.department_id=d.department_id
WHERE e.employee_id=103;

--3. 90���μ� ������� ���, �̸�, �޿�, �Ŵ����̸�, �Ŵ����޿�, �Ŵ����μ��̸�
-- ����Ŭ ����
select e.employee_id, e.first_name, e.salary, 
    m.first_name, m.salary, d.department_name
from employees e, employees m, departments d
where e.manager_id=m.employee_id(+)
and m.department_id=d.department_id(+)
and e.department_id=90;
-- �Ƚ� ����
select e.employee_id, e.first_name, e.salary, 
    m.first_name, m.salary, d.department_name
from employees e
LEFT JOIN employees m ON e.manager_id=m.employee_id
LEFT JOIN departments d ON m.department_id=d.department_id
where e.department_id=90;

--4. 103������� �ٹ��ϴ� ���� (�Ƚ�����)
select e.employee_id, l.city
from employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
where e.employee_id=103;

--5. �����ȣ�� 103�λ���� �μ���ġ(city)�� �Ŵ����� �����̸�(job_title) (�Ƚ�����)
select l.city "Department Location", j.job_title "Manager's Job"
from employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
JOIN employees m ON e.manager_id=m.employee_id
JOIN jobs j ON m.job_id=j.job_id
where e.employee_id=103;

--6. ����� ��� ������ ��ȸ�ϴ� ������
-- ����� �μ���ȣ�� �μ��̸�����, �������̵�� �����̸�����, �Ŵ������̵�� �Ŵ����̸�����
select e.employee_id, e.first_name, e.last_name, e.email, e.phone_number, 
    e.hire_date, j.job_title, e.salary, e.commission_pct, 
    m.first_name as manager_first_name, m.last_name as manager_last_name,
    d.department_name
from employees e
LEFT JOIN departments d on e.department_id=d.department_id
JOIN jobs j ON e.job_id=j.job_id
LEFT JOIN employees m ON e.manager_id=m.employee_id;

--7. ����Ī�� �ο��� ���, ���̺� �̸��� select���� ����� �� ����









