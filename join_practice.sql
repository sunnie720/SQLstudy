/* 조인 */
--1. John 사원의 이름과 부서이름, 부서위치(city)
-- 오라클 조인
select e.first_name, d.department_name, l.city
from employees e, departments d, locations l
WHERE first_name='John'
AND e.department_id=d.department_id
AND d.location_id=l.location_id;
-- 안시 조인
select e.first_name, d.department_name, l.city
from employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
WHERE first_name='John';

--2. 103번 사원의 사원번호, 이름, 급여, 매니저이름, 매니저 부서이름 (안시조인)
select e.employee_id, e.first_name, e.salary, m.first_name, d.department_name
from employees e
JOIN employees m ON e.manager_id=m.employee_id
JOIN departments d ON m.department_id=d.department_id
WHERE e.employee_id=103;

--3. 90번부서 사원들의 사번, 이름, 급여, 매니저이름, 매니저급여, 매니저부서이름
-- 오라클 조인
select e.employee_id, e.first_name, e.salary, 
    m.first_name, m.salary, d.department_name
from employees e, employees m, departments d
where e.manager_id=m.employee_id(+)
and m.department_id=d.department_id(+)
and e.department_id=90;
-- 안시 조인
select e.employee_id, e.first_name, e.salary, 
    m.first_name, m.salary, d.department_name
from employees e
LEFT JOIN employees m ON e.manager_id=m.employee_id
LEFT JOIN departments d ON m.department_id=d.department_id
where e.department_id=90;

--4. 103번사원이 근무하는 도시 (안시조인)
select e.employee_id, l.city
from employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
where e.employee_id=103;

--5. 사원번호가 103인사원의 부서위치(city)와 매니저의 직무이름(job_title) (안시조인)
select l.city "Department Location", j.job_title "Manager's Job"
from employees e
JOIN departments d ON e.department_id=d.department_id
JOIN locations l ON d.location_id=l.location_id
JOIN employees m ON e.manager_id=m.employee_id
JOIN jobs j ON m.job_id=j.job_id
where e.employee_id=103;

--6. 사원의 모든 정보를 조회하는 쿼리문
-- 사원의 부서번호는 부서이름으로, 직무아이디는 직무이름으로, 매니저아이디는 매니저이름으로
select e.employee_id, e.first_name, e.last_name, e.email, e.phone_number, 
    e.hire_date, j.job_title, e.salary, e.commission_pct, 
    m.first_name as manager_first_name, m.last_name as manager_last_name,
    d.department_name
from employees e
LEFT JOIN departments d on e.department_id=d.department_id
JOIN jobs j ON e.job_id=j.job_id
LEFT JOIN employees m ON e.manager_id=m.employee_id;

--7. 열별칭을 부여할 경우, 테이블 이름을 select절에 사용할 수 없음









