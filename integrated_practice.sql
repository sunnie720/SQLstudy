/* 2. SELECT */
--1. 
SELECT employee_id, first_name, last_name, hire_date, salary
FROM employees;
--2.
SELECT first_name||' '||last_name AS name
FROM employees;
--3.
select * from employees
where department_id=50;
--4. 
select first_name, department_id, job_id
from employees
where department_id=50;
-- 50번부서 직무명 확인
select e.first_name, e.department_id, e.job_id, j.job_title
from employees e
left join jobs j on e.job_id=j.job_id
where department_id=50;
select e.first_name, e.department_id, e.job_id, j.job_title
from employees e , jobs j
where department_id=50
and e.job_id=j.job_id(+);
--5.
select first_name, salary, salary+300
from employees;
--6. 
select first_name, salary
from employees
where salary>10000;
--7.
select first_name, job_id, commission_pct
from employees
where commission_pct is not null;
--8. (between)
select first_name, hire_date, salary
from employees
where hire_date BETWEEN '03/01/01' and '03/12/31';
--9. (like)
select first_name, hire_date, salary
from employees
where hire_date LIKE '03%';
--10. 
select first_name, salary
from employees
order by salary desc;
--11. 
select first_name, salary
from employees
where department_id=60
order by salary desc;
--12.
select first_name, job_id
from employees
where job_id in ('IT_PROG', 'SA_MAN');
--13. 
select first_name||' '||last_name||' 사원의 급여는 '||salary||'달러입니다' as info
from employees
where first_name='Steven' and last_name='King';
--14.
select first_name, job_id
from employees
where job_id LIKE '%/_MAN' ESCAPE '/';
--15. 
select first_name, job_id
from employees
where job_id LIKE '%/_MAN' ESCAPE '/'
order by job_id;

/* 3. 함수 */
--1.
select * from employees
where lower(email) LIKE '%lee%';
--2. 
select first_name, salary, job_id
from employees
where manager_id=103;
--3. 
select * from employees
where (department_id=80 and job_id='SA_MAN')
or (department_id=20 and manager_id=100);
--4. ★★★
select first_name, REPLACE(phone_number, '.', '-')  phone
from employees;
--5. ★★★
select RPAD(first_name||' '||last_name,20,'*') as "Full Name",
        to_char(COALESCE(salary*(1+commission_pct),salary), '$099,999.99') 급여지급액, 
        to_char(hire_date, 'RRRR-MM-DD') as 입사일,
        round(sysdate-hire_date) as 근무일수
from employees
where job_id='IT_PROG'
and salary>=5000
order by 1;
--6.
select RPAD(first_name||' '||last_name,20,'*') as "Full Name",
       to_char(COALESCE(salary*(1+commission_pct),salary), '$099,999.99') salary,
       to_char(hire_date, 'RRRR"년" MM"월" DD"일"') hire_date,
       trunc(months_between(sysdate,hire_date)) month
from employees
where department_id=30
order by salary desc;
--7.
select RPAD(first_name||' '||last_name,17,'*') 이름,
       to_char(coalesce(salary*(1+commission_pct),salary),'$09,999.99') 급여
from employees
where department_id=80 and salary>10000
order by 급여 desc;
--8. ★★★
select first_name 이름,
       decode(trunc(trunc((months_between(sysdate,hire_date)/12)/2)), 
       6, '12년차',
       7, '14년차',
       8, '16년차',
       '기타') as 근무년차
from employees
where department_id=60;
--9.
select first_name, hire_date+1000
from employees
where lower(first_name)='lex';
--10. ★
select first_name, hire_date
from employees
where to_char(hire_date,'MM')='05'; 
--11.
select first_name,
       to_char(hire_date,'RRRR"년 입사"') year,
       to_char(hire_date, 'day') day,
       to_char(decode(trunc(to_number(to_char(hire_date,'RR'))/5),
                      1, salary*1.05,
                      salary),
                '$999,999') increasing_salary
from employees;
--12.
select first_name,
       to_char(hire_date,'RRRR"년 입사"') year,
       case when to_char(hire_date,'RR')='05' then salary*1.05
            when to_char(hire_date,'RR')='10' then salary*1.1
            else salary
       end as increasing_salary2
from employees;
--13.
select * from locations;
select country_id,
       coalesce(state_province, country_id) state
from locations;

/* 4. 그룹함수 */
--1. 
select job_id, avg(salary)
from employees
group by job_id;
--2. 
select department_id, count(*)
from employees
group by department_id;
--3.
select department_id, job_id, count(*)
from employees
group by department_id, job_id;
--4.
select department_id, round(stddev(salary),2)
from employees
group by department_id;
--5.
select department_id, count(*)
from employees
group by department_id 
having count(*)>=4;
--6. 
select job_id, count(*)
from employees
where department_id=50
group by job_id;
--7.
select job_id, count(*)
from employees
where department_id=50
group by job_id
having count(*)<=10;
--8.
select to_char(hire_date,'RRRR') 입사년도,
       round(avg(salary),0) 급여평균, 
       count(*) 사원수
from employees
group by to_char(hire_date,'RRRR')
order by 입사년도;
--9.
select to_char(hire_date,'RRRR') 입사년도,
       to_char(hire_date,'MM') 입사월,
       round(avg(salary),0) 급여평균, 
       count(*) 사원수
from employees
group by ROLLUP(to_char(hire_date,'RRRR'), to_char(hire_date,'MM'))
order by 입사년도, 입사월;
--10.
select 
    DECODE(grouping_id(to_char(hire_date,'RRRR'),to_char(hire_date,'MM')),
           2,'합계',3,'합계',to_char(hire_date,'RRRR')) as 입사년도,
    DECODE(grouping_id(to_char(hire_date,'RRRR'),to_char(hire_date,'MM')),
           1,'소계',3,'합계',to_char(hire_date,'MM')) as 입사월,
    round(avg(salary),0) 급여평균, 
    count(*) 사원수
from employees
group by CUBE(to_char(hire_date,'RRRR'), to_char(hire_date,'MM'))
order by 입사년도, 입사월;
--11.
select 
    DECODE(grouping_id(to_char(hire_date,'RRRR'),to_char(hire_date,'MM')),
           2,'합계',3,'합계',to_char(hire_date,'RRRR')) as 입사년도,
    DECODE(grouping_id(to_char(hire_date,'RRRR'),to_char(hire_date,'MM')),
           1,'소계',3,'소계',to_char(hire_date,'MM')) as 입사월,
    grouping_id(to_char(hire_date,'RRRR'),to_char(hire_date,'MM')) GID,
    round(avg(salary),0) 급여평균, 
    count(*) 사원수
from employees
group by cube(to_char(hire_date,'RRRR'), to_char(hire_date,'MM'))
order by 입사년도, 입사월;

/* 5. 분석함수 */
--1. ★★★★
select department_id, first_name, salary, 
       rank() over 
        (partition by department_id order by salary desc) sal_rank,
       lag(salary,1,0) over 
        (partition by department_id order by salary desc) prev_sal1,
       first_value(salary) over 
        (partition by department_id order by salary desc
         rows 1 preceding) as prev_sal2
from employees;
--2. ★★★★★
select first_name
from employees
where employee_id=
      (select prev_id
       from (select employee_id, 
                    LAG(employee_id,1,0) over (order by employee_id) 
                    as prev_id
             from employees)
       where employee_id=170);
--3.
select employee_id, 
       department_id,
       min(salary) over (partition by department_id order by salary) as lower_sal,
       salary my_sal,
       (max(salary) over (partition by department_id order by salary)) - salary as dif_sal
from employees;

/* 6. Join */
--3. ★★★
--- Oracle join
select e.employee_id, e.first_name, e.salary, 
       m.first_name, m.salary,
       d.department_name
from employees e, employees m, departments d
where e.department_id=90
and e.manager_id=m.employee_id(+)
and m.department_id=d.department_id(+);
--- ANSI join
select e.employee_id, e.first_name, e.salary, 
       m.first_name, m.salary,
       d.department_name
from employees e
left join employees m ON e.manager_id=m.employee_id
left join departments d ON m.department_id=d.department_id
where e.department_id=90;
--5. 
select l.city, j.job_title
from employees e
join departments d ON e.department_id=d.department_id
join locations l ON d.location_id=l.location_id
join employees m ON e.manager_id=m.employee_id
join jobs j ON m.job_id=j.job_id
where e.employee_id=103;
--6.
select * from employees;
select e.employee_id, e.first_name, e.last_name, e.email, e.phone_number, 
       e.hire_date, j.job_title, e.commission_pct, 
       m.first_name as manager_first_name, m.last_name as manager_last_name,
       d.department_name
from employees e
left join jobs j ON e.job_id=j.job_id
left join employees m ON e.manager_id=m.employee_id
left join departments d ON e.department_id=d.department_id;

/* 7. subquery */
--1. 
select * 
from employees
where manager_id in (select distinct manager_id from employees
                     where department_id=20);
--2.
select first_name
from employees 
where salary=(select max(salary) from employees);
--3.★★★
select first_name, salary
from (select first_name, salary, rownum rnum
      from (select first_name, salary from employees
            order by salary desc)
      )
where rnum between 3 and 5;
--4. ★★★★★
select department_id, first_name, salary, 
       (select round(avg(salary)) 
       from employees b
       where b.department_id=a.department_id) avg_sal
from employees a
where salary >= (select avg(salary)
                 from employees c
                 where c.department_id=a.department_id)
order by department_id;