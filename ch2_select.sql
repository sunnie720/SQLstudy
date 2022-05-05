/* 2장. SELECT를 이용한 데이터 조회 */

-- 열별칭(alias) 
-- 별칭이 공백, 특수문자(#,$등), 대소문자를 포함하면 이중인용부호("")로 둘러싸야함
select first_name as 이름, salary 급여
from employees;
select first_name "Employee Name",
        salary*12 "Annual Salary"
from employees;

-- 리터럴(literal): select 절에 포함된 문자,표현식,숫자
-- 열과 똑같이 취급. 날짜, 문자 리터럴은 단일 인용부호('') 사용 (숫자는 x)
select first_name||' '||last_name||'''s salary is $'||salary 
from employees; --단일 인용부호('') 사이에 's 표시하기 위해서 '를 하나 더 

-- DISTINCT: SELECT 절에서 DISTINCT 키워드 사용하여 중복되는 행 제거
select department_id
from employees;
select distinct department_id
from employees;

-- ROWID, ROWNUM 의사열
-- 의사열(Pseudo column)은 실제 테이블에는 없지만 SELECT 절에 열처럼 사용되는 가상의 열
-- ROWID: 데이터베이스에서 행의 고유한 주소값 반환
-- ROWNUM: SELECT문 쿼리에 의해서 반환되는 행의 번호를 순서대로 출력
select ROWID, ROWNUM, employee_id, first_name
from employees;

/* Selection: 원하는 행을 선택적으로 조회 (where절) */
-- 대소문자 구분. 문자와 날짜는 단일 인용부호('') 
select first_name, job_id, department_id
from employees
where job_id='IT_PROG'; -- 'IT_PROG'는 JOB_ID 열과 일치되도록 대문자로 입력
-- 입사일이 ‘2004년 1월 30일’인 사원의 정보
select first_name, salary, hire_date
from employees
where hire_date='04/01/30'; --(날짜형식 RR/MM/DD)
-- 급여가 $10,000 에서 $12,000 사이에 있는 사원
select first_name, salary
from employees
where salary between 10000 and 12000; --(between: 상한값, 하한값 모두 포함)
-- 이름이 A또는 B로 시작하는 사원의 이름, 급여, 입사일
select first_name, salary, hire_date
from employees
where first_name between 'A' and 'Bzzzzzzzz';
-- 관리자의 사원번호가 101, 102, 또는 103인 모든 사원 정보
select employee_id, first_name, salary, manager_id
from employees
where manager_id in (101, 102, 103); --(in: 명시된 목록의 있는 값들 테스트)
-- 와일드카드(wildcard) 검색: 문자 패턴 일치 연산 (LIKE 연산자 사용)
-- %(퍼센트)는 문자가 없거나 하나 이상 문자들 대신
-- _ (밑줄문자)는 임의의 한 문자 대신
select first_name, last_name, job_id, department_id
from employees
where job_id LIKE  'IT%'; -- 문자열 그대로 검색! ('it%'로 검색하면 반환되는 값x)
-- 2005년에 입사한, job_id가 "SA_M"을 포함하는 사원의 이름과 직무아이디 출력
select first_name, job_id, hire_date
from employees
where job_id LIKE 'SA/_M%' ESCAPE '/'  --검색할 문자에 "_","%"가 포함될 경우 ESCAPE
     and hire_date LIKE '05%';
-- 논리 연산자 우선순위: 비교연산자 > NOT > AND > OR

/* 데이터 정렬 */
-- ORDER BY 절은 행을 정렬하는데 사용. SELECT 문장의 맨 뒤에 위치
-- ASC: 오름차순, DESC: 내림차순
select first_name, hire_date
from employees
ORDER BY hire_date, first_name;
-- ORDER BY 절에 열별칭 또는 select문에 나열된 번호순서 사용
select first_name, salary*12 annual
from employees
ORDER BY annual DESC;
select first_name, salary*12 annual
from employees
ORDER BY 2 DESC; -- 동일한 결과

/* 연습문제 */
--1. 모든 사원의 사원번호, 이름, 입사일, 급여를 출력하세요.
select employee_id, first_name, hire_date, salary
from employees;

--2. 모든 사원의 이름과 성을 붙여 출력하세요. 열 별칭은 name으로 하세요.
select first_name||' '||last_name name
from employees;

--3. 50번 부서 사원의 모든 정보를 출력하세요.
select * from employees
where department_id=50;

--4. 50번 부서 사원의 이름, 부서번호, 직무아이디를 출력하세요.
select first_name, department_id, job_id
from employees
where department_id=50;

--5. 모든 사원의 이름, 급여 그리고 300달러 인상된 급여를 출력하세요.
select first_name, salary, salary+300 
from employees;

--6. 급여가 10000보다 큰 사원의 이름과 급여를 출력하세요.
select first_name, salary
from employees
where salary>10000;

--7. 보너스를 받는 사원의 이름과 직무, 보너스율을 출력하세요.
select first_name, job_id, commission_pct
from employees
where commission_pct is not null;

--8. 2003년도 입사한 사원의 이름과 입사일 그리고 급여를 출력하세요. (BETWEEN 연산자 사용)
select first_name, hire_date, salary
from employees
where hire_date between '03/01/01' and '03/12/31';

--9. 2003년도 입사한 사원의 이름과 입사일 그리고 급여를 출력하세요. (LIKE 연산자 사용)
select first_name, hire_date, salary
from employees
where hire_date like '03%';

--10. 모든 사원의 이름과 급여를 급여가 많은 사원부터 적은 사원 순으로 출력하세요.
select first_name, salary
from employees 
order by salary desc;

--11. 위 질의를 60번 부서의 사원에 대해서만 질의하세요.
select first_name, salary
from employees 
where department_id=60
order by salary desc;

--12. 직무아이디가 IT_PROG 이거나, SA_MAN인 사원의 이름과 직무아이디를 출력하세요.
select first_name, job_id
from employees
where job_id in ('IT_PROG', 'SA_MAN');

--13. Steven King 사원의 정보를 "Steven King 사원의 급여는 24000달러입니다" 형식으로
select first_name||' '||last_name||' 사원의 급여는 '||salary||'달러입니다' info
from employees
where first_name='Steven' and last_name='King';

--14. 매니저(MAN) 직무에 해당하는 사원의 이름과 직무아이디를 출력하세요.
select first_name, job_id
from employees
where job_id like '%MAN';

--15. 매니저(MAN) 직무에 해당하는 사원의 이름과 직무아이디를 직무아이디 순서대로 출력하세요.
select first_name, job_id
from employees
where job_id like '%MAN'
order by job_id;

