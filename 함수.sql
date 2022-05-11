/* 함수 */
-- 함수, 문자함수, 정규표현식함수, 숫자함수, 날짜함수, 변환함수, 집합연산자
-- 단일행함수: 단일행에서만 적용 가능, 행별로 하나의 결과 반환 (문자, 숫자, 날짜, 변환)
-- 다중행함수: 복수의 행 조작, 행 그룹당 하나의 결과 반환
-- 문자열 함수
SELECT * FROM NLS_DATABASE_PARAMETERS; -- 인코딩 확인(NLS_CHARACTERSET)
select * from dual; -- 오라클 1행1열 표준테이블. 일시적인 산술/날짜 연산을 위해 주로 사용
select ltrim('JavaScript', 'Jav') from dual;  -- Script
select replace('JavaSpecialist', 'Java', 'BigData') from dual; --BigDataSpecialist
select translate('javaspecialist', 'abc', 'xyz') from dual; --jxvxspezixlist
--실전문제
select RPAD(substr(first_name,1,3),length(first_name),'*') as name, 
        LPAD(salary, 10, '*') as salary
from employees
where lower(job_id)='it_prog';

-- 정규표현식 함수
-- 정규표현식: 일치하는 텍스트의 "패턴"을 표현하기 위한 표준화된 텍스트 패턴 구문을 정의

-- REGEXP_LIKE: 정규표현 조건을 사용해 검색
create table test_regexp (col1 varchar2(10)); --예제 테이블 생성
insert into test_regexp values('ABCED01234');
insert into test_regexp values('01234ABCDE');
insert into test_regexp values('abcde01234');
insert into test_regexp values('01234abcde');
insert into test_regexp values('1-234-5678');
insert into test_regexp values('234-567890');
--숫자로 시작, 영소문자로 끝
select * 
from test_regexp
where REGEXP_LIKE(col1, '[0-9][a-z]'); 
--XXX-XXXX형식으로 끝나는 행
select * 
from test_regexp
where REGEXP_LIKE(col1, '[0-9]{3}-[0-9]{4}$'); 
select *
from test_regexp
where REGEXP_LIKE(col1, '[[:digit:]]{3}-[[:digit:]]{4}$');
--XXX-XXXX형식을 포함하는 행
select *
from test_regexp
where REGEXP_LIKE(col1, '[[:digit:]]{3}-[[:digit:]]{4}');

-- REGEXP_INSTR: 지정한 패턴을 만족하는 부분의 최초 위치 반환
insert into test_regexp values('@!=)(9&%$#');
insert into test_regexp values('자바3');
--특정 문자열의 위치 출력
select col1,
    REGEXP_INSTR(col1, '[0-9]') as data1,
    REGEXP_INSTR(col1, '%') as data2
from test_regexp;

-- REGEXP_SUBSTR: 지정한 패턴을 만족하는 부분의 문자열 반환
--C에서 Z까지 알파벳 뽑아내기
select col1, REGEXP_SUBSTR(col1, '[C-Z]+')
from test_regexp;

-- REGEXP_REPLACE: 지정한 패턴을 만족하는 부분을 지정한 다른 문자열로 치환 
--0부터 2까지의 숫자형 문자를 *로 변환
select col1, REGEXP_REPLACE(col1, '[0-2]+', '*')
from test_regexp;

--실전문제: XXX.XXX.XXXX형식 전화번호 출력
select first_name, phone_number
from employees
where REGEXP_LIKE(phone_number, '^[0-9]{3}.[0-9]{3}.[0-9]{4}$');
select first_name, phone_number
from employees
where REGEXP_LIKE(phone_number, '^[[:digit:]]{3}.[[:digit:]]{3}.[[:digit:]]{4}$');
--실전문제: XXX.XXX.XXXX형식 전화번호 맨뒤 4자리 *로 마스킹, 4자리 별도 열로 출력
select first_name, 
    concat(SUBSTR(phone_number, 1,8), '****') phone, 
    SUBSTR(phone_number, 9, 12) phone2
from employees;
select first_name, 
    REGEXP_REPLACE(phone_number, '[[:digit:]]{4}$', '****') phone,
    REGEXP_SUBSTR(phone_number, '[[:digit:]]{4}$') as phone2
from employees
where REGEXP_LIKE(phone_number, '^[0-9]{3}.[0-9]{3}.[0-9]{4}$');

-- 숫자함수 
-- 숫자를 입력 받고 숫자값을 반환함 
select ROUND(1234.1234, -1) from dual; --1230
select CEIL(123.45) from dual;  --124
select FLOOR(123.45) from dual;  --123
select SIGN(123) from dual;  --1
select SIGN(-123) from dual;  -- -1
select MOD(4,3) from dual; --1 (4%3; m을 n으로 나눈 나머지)
select REMAINDER(4,3) from dual; --MOD와 동일 but BINARY_DOUBLE 타입도 가능

-- 날짜연산
select SYSDATE from dual; --현재날짜
select SYSTIMESTAMP from dual; --현재날짜+시간정보
--부서 60에 속하는 모든 사원에 대해서 이름과 현재까지 근무한 총 week 출력
select first_name, (SYSDATE - hire_date)/7 as week 
from employees
where department_id=60;

-- 날짜함수
--모든 날짜함수는 DATE 타입 반환 (단, MONTHS_BETWEEN은 숫자값 반환)
--근무한 개월 수 
select first_name, SYSDATE, hire_date, 
    TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) workmonth --두 인자 사이의 월 수(숫자) 
from employees;
--Diana 사원의 입사일과 입사 후 100개월 때 되는 날짜
select first_name, hire_date, ADD_MONTHS(hire_date, 100)
from employees
where first_name='Diana';
--다음주 화요일
select SYSDATE, NEXT_DAY(SYSDATE, '화') from dual;
--월의 마지막 날짜
select SYSDATE, LAST_DAY(SYSDATE) from dual;
--지정 단위로 반올림(round)/절삭(trunc)
select TRUNC(SYSDATE, 'Year') from dual; --22/01/01
select ROUND(SYSDATE, 'Month') from dual; --22/05/01
select TRUNC(SYSDATE, 'Day') from dual; --일요일 날짜 반환
select ROUND(SYSDATE) from dual; --시간(HH)단위에서 반올림

-- 변환함수
select employee_id, first_name, hire_date
from employees
-- 암시적 형변환
where hire_date='03/06/17'; --날짜<=>문자
-- 명시적 형변환
-- TO_CHAR: 날짜 또는 숫자를 문자형으로
select first_name, TO_CHAR(hire_date, 'MM/YY') as HiredMonth
from employees
where first_name='Steven'; --날짜=>문자
--모든 사원의 이름과 입사일 (입사일은 “2003년 06월 17일” 형식)
select first_name, TO_CHAR(hire_date, 'YYYY"년" MM"월" DD"일"') hiredate
from employees;
select first_name, TO_CHAR(hire_date, 'fmYYYY"년" MM"월" DD"일"') hiredate
from employees; --fm:월,일에 0 제거
-- 입사일 “Seventeenth of June 2003 12:00:00 AM” 형식
select first_name, 
    TO_CHAR(hire_date, 'fmDdspth "of" Month YYYY fmHH:MI:SS AM', 
    'NLS_DATE_LANGUAGE=english') hiredate 
from employees; 
--fm:영문월 공백 제거/시간,분,초의 선행0 제거 (hire_date에 시간정보 없어서 12:00:00로 표시
--숫자를 "$999,999" 문자 형식으로
select first_name, last_name, TO_CHAR(salary, '$999,999') salary
from employees
where first_name='David';
select first_name, last_name, salary*0.123456 as salary1,
    TO_CHAR(salary*0.123456, '$999,999.99') as salary2  --자동 반올림
from employees
where first_name='David';
-- TO_NUMBER: 문자를 숫자형으로
select TO_NUMBER('$5,500.00', '$999,999.99') - 4000 from dual;
-- TO_DATE: 문자를 날짜형으로
SELECT first_name, hire_date
FROM employees
WHERE hire_date=TO_DATE('2003/06/17', 'YYYY/MM/DD');
SELECT first_name, hire_date
FROM employees
WHERE hire_date=TO_DATE('2003년06월17일','YYYY"년"MM"월"DD"일"');

-- Null 치환함수: NVL, NVL2, COALESCE
--NVL
select first_name, 
    salary + salary*NVL(commission_pct, 0) bonus_sal --보너스율 있으면 사용, 없으면0
from employees;
--NVL2
select first_name,
    NVL2(commission_pct, salary+salary*commission_pct, salary) bonus_sal
from employees;
--COALESCE
select first_name,
    COALESCE(salary+salary*commission_pct, salary) bonus_sal
from employees;  --첫번째 표현식이 Null아니면 반환, Null이면 두번째 표현식 반환
--고객 연락처 여러개 중에 하나만 출력 시 
select COALESCE(cellphone, home, office, '연락처 없음')
from customer; --없는 테이블 예시

-- 기타 변환 함수
--LNNVL: 거짓이면 True, 참이면 False 반환
--보너스 650 미만인 사원
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

-- DECODE 함수: IF-THEN-ELSE 구문과 유사
select job_id, salary, 
    DECODE(job_id, 'IT_PROG',   salary*1.10,
                    'FI_MGR',   salary*1.15,
                    'FI_ACCOUNT',salary*1.20,
                                salary) 
    as revised_salary
from employees;

-- CASE~WHEN~THEN: IF-ELSE 구문과 유사
-- CASE 뒤에 표현식이 있으면 WHEN 절에는 값, CASE 뒤에 공란이면 WHEN 절에 조건식
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

-- 집합 연산자
--2개 이상의 SQL문의 결과를 이용해 집합을 만드는 연산자
--첫 번째 SELECT문과 두 번째 SELECT문의 열의 개수와 각 데이터 타입이 반드시 일치해야함

-- UNION(중복없음), UNION ALL(중복허용): 합집합
--04년에 입사하였거나 부서번호가 20인 사람
--- UNION(중복없음)
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%' 
UNION
select employee_id, first_name, hire_date, department_id
from employees
where department_id=20; 
----UNION은 아래 OR 연산자와 같음
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%' 
    OR department_id=20;
--- UNION ALL(중복허용) 
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%' 
UNION ALL
select employee_id, first_name, hire_date, department_id
from employees
where department_id=20; -- Michael 두 번 중복

-- INTERSECT: 교집합
--첫 번째 쿼리와 두 번째 쿼리에서 중복된 행만 출력
--04년에 입사하였고 부서번호가 20인 사람
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%' 
INTERSECT
select employee_id, first_name, hire_date, department_id
from employees
where department_id=20;
----INTERSECT은 아래 AND 연산자와 같음
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%'
    AND department_id=20;
    
-- MINUS: 차집합
--첫 번째 쿼리에만 있고 두 번째 쿼리에는 없는 데이터
--04년에 입사하였지만, 부서번호가 20이 아닌 사람
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%' 
MINUS
select employee_id, first_name, hire_date, department_id
from employees
where department_id=20;
-- 아래와 동일
select employee_id, first_name, hire_date, department_id
from employees
where hire_date like '04%' 
    and department_id not in (20);
------------------------------------------------------------------------------

/* 연습문제 */
--1. 이메일에 lee를 포함하는 사원의 모든 정보를 출력하세요.
select * from employees
where lower(email) like '%lee%';

--2. 매니저 아이디가 103인 사원들의 이름과 급여, 직무아이디를 출력하세요.
select first_name, salary, job_id
from employees
where manager_id=103;

--3. 80번 부서에 근무하면서 직무가 SA_MAN인 사원의 정보와 20번 부서에 근무하면서 
--매니저 아이디가 100인사원의 정보를 출력하세요. 쿼리문 하나로 출력해야 합니다.
select * from employees
where (department_id=80 and job_id='SA_MAN') 
    OR (department_id=20 and manager_id=100);

--4. 모든 사원의 전화번호를 ###-###-#### 형식으로 출력하세요.
select first_name, REPLACE(phone_number, '.', '-')  phone
from employees;

--5. 직무가 IT_PROG인 사원들 중에서 급여가 5000 이상인 사원들의 이름(Full Name), 
--급여 지급액, 입사일(2005-02-15형식), 근무한 일수를 출력하세요. 
--이름순으로 정렬하며, 이름은 최대 20자리, 남는 자리는 *로 채우고 
--급여 지급액은 소수점 2자리를 포함한 최대 8자리, $표시, 남는 자리는 0으로 채워 출력하세요.
select RPAD(first_name||' '||last_name, 20, '*') as "Full Name", 
    TO_CHAR(salary, '$099,999.99') sal,
    TO_CHAR(hire_date, 'YYYY-MM-DD') HiredDate,
    round(SYSDATE - hire_date) WorkedDays
from employees
where job_id='IT_PROG' and salary>=5000
order by 1;
--정답) 급여 지급액은 연봉(salary)에 보너스를 더한 금액!!
select RPAD(first_name||' '||last_name, 20, '*') as "Full Name", 
    TO_CHAR(coalesce(salary+salary*commission_pct, salary), '$099,999.99') pay,
    TO_CHAR(hire_date, 'YYYY-MM-DD') HiredDate,
    round(SYSDATE - hire_date) WorkedDays
from employees
where upper(job_id)='IT_PROG' and salary>=5000
order by 1;

--6. 30번 부서 사원의 이름(full name)과 급여, 입사일, 현재까지 근무 개월 수를 출력하세요. 
--이름은 최대 20자로 출력하고 이름 오른쪽에 남는 공백을 *로 출력하세요. 
--급여는 상여금을 포함하고 소수점 2자리를 포함한 총 8자리로 출력하고 남은 자리는 0으로 
--채우며 세자리마다 ,(콤마) 구분기호를 포함하고, 금액 앞에 $를 포함하도록 출력하세요.
--입사일은 2005년03월15일 형식으로 출력하세요. 근무 개월 수는 소수점 이하는 버리고
--출력하세요. 급여가 큰 사원부터 작은 순서로 출력하세요.
select 
    RPAD(first_name||' '||last_name, 20, '*') as "Full Name",
    TO_CHAR(coalesce(salary+salary*commission_pct, salary), 
        '$099,999.99') as pay,
    TO_CHAR(hire_date, 'YYYY"년"MM"월"DD"일"') HiredDate,
    TRUNC(MONTHS_BETWEEN(SYSDATE, hire_date)) WorkedMonths
from employees
where department_id=30
order by pay desc;

--7. 80번 부서에 근무하면서 salary가 10000보다 큰 사원들의 이름과 
--급여 지급액(salary + salary * commission_pct)을 출력하세요. 이름은 Full Name으로 
--출력하며 17자리로 출력하세요. 남은 자리는 *로 채우세요. 급여는 소수점 2자리를 포함한 
--총 7자리로 출력하며, 남는 자리는 0으로 채우세요. $ 표시를 하며 급여 순으로 정렬하세요.
select 
    RPAD(first_name||' '||last_name, 17, '*') as "Full Name",
    TO_CHAR(coalesce(salary+salary*commission_pct, salary), 
        '$09,999.99') as pay
from employees
where department_id=80 and salary>10000
order by pay desc;

--8. 60번부서 사원의 이름과 현재 일자를 기준으로 현재까지 근무한 근무년차를 5년차, 10년차, 
--15년차로 표시하세요. 5년~ 9년 근무한 사원은 5년차로 표시합니다. 나머지는 기타로 표시합니다. 
--근무년차는 근무개월수/12로 계산합니다.
select first_name 이름, 
    case when (months_between(sysdate, hire_date)/12)<5 then '기타'
        when (months_between(sysdate, hire_date)/12)<10 then '5년차'
        when (months_between(sysdate, hire_date)/12)<15 then '10년차' 
        when (months_between(sysdate, hire_date)/12)<20 then '15년차'
        when (months_between(sysdate, hire_date)/12)>=20 then '기타'
    end as 근무년차
from employees
where department_id=60;
--정답) 근무개월수/12/5의 몫으로 년차 기준 잡으면 편함
select first_name as 이름,
    decode(trunc(trunc(months_between(SYSDATE, hire_date)/12)/5),
        1, '5년차',
        2, '10년차',
        3, '15년차',
        '기타')
    as 근무년수
from employees
where department_id=60;

--9. Lex가 입사한지 1000일째 되는 날은?
select first_name, hire_date+1000
from employees
where first_name='Lex';

--10. 5월에 입사한 사원의 이름과 입사일을 출력하세요.
select first_name, hire_date
from employees
where to_char(hire_date, 'MM')='05';

--11. 사원목록 중 이름과 급여를 출력하세요.
--조건1)입사한 연도를 출력한 열을 만들고, 열이름은 ‘year’, 형식은 “(입사년도)년 입사”
--조건2)입사한 요일을 출력한 열을 만들고, 열이름은 ‘day’, 형식은 “요일”
--조건3)입사일이 2010년 이후인 사원은 급여를 10%, 2005년 이후인 사원은 급여를 5% 인상
--이 열의 이름은 ‘INCREASING_SALARY’입니다.
--조건4)INCREASING_SALARY 열의 형식은 앞에 ‘$’기호가 붙고, 세 자리마다 콤마(,)
select first_name, salary,
    to_char(hire_date, 'YYYY"년 입사"') as year,   --'RRRR"년 입사"'
    to_char(hire_date, 'Day') as day,
    case when to_number(to_char(hire_date, 'YYYY'))>=2010 
            then to_char(salary*1.1, '$999,999')
         when to_number(to_char(hire_date, 'YYYY'))>2005
            then to_char(salary*1.05, '$999,999')
         else to_char(salary, '$999,999')
    end as increasing_salary
from employees;

--12. 사원의 이름, 급여, 입사년도, 인상된 급여를 출력하세요.
--조건1) 입사한 연도를 출력하세요. 이 열의 이름은 ‘year’이고, “(입사년도)년 입사”형식
--조건2) 입사일이 2010년인 사원은 급여를 10%, 2005년인 사원은 급여를 5%를 인상. 
--열의 이름은 ‘INCREASING_SALARY2’입니다.
select first_name, salary, 
    to_char(hire_date, 'YYYY"년 입사"') as year,   --'RRRR"년 입사"'
    case when to_char(hire_date, 'YY')='10' then salary*1.1
         when to_char(hire_date, 'YY')='05' then salary*1.05
         else salary
    end as increasing_salary2
from employees;
--정답) DECODE 함수도 사용 가능
select first_name, salary, 
    to_char(hire_date, 'YYYY"년 입사"') as year,   --'RRRR"년 입사"'
    decode(to_char(hire_date, 'YY'), 
            '10', salary*1.1,
            '05', salary*1.05,
                  salary)
    as increasing_salary2
from employees;

--13. 위치목록 중 주(state) 열에 값이 null이라면 국가아이디를 출력하세요.
select * from locations;
select country_id, NVL(state_province, country_id) state
from locations;

