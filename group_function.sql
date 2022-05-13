/* 그룹함수 */
/* 그룹함수,GROUP BY,HAVING,GROUPING SETS,ROLLUP,CUBE,GROUPING,GROUPING_ID */
-- 단일행 함수와 달리 그룹 당 하나의 결과를 주도록 행의 그룹에 대해 연산
-- COUNT(*)를 제외한 모든 그룹 함수는 열에 있는 Null 값을 연산에서 제외

-- AVG, SUM, MIN, MAX 함수
--모든 판매원에 대해서 급여의 평균, 최고액, 최저액, 합계
select avg(salary), max(salary), min(salary), sum(salary)
from employees
where job_id like 'SA%'; -- SA_MAN, SA_REP
--MIN, MAX는 날짜, 문자, 숫자 모두 가능
--가장 먼저 입사한 사원의 입사일과 가장 나중에 입사한 사원의 입사일
select min(hire_date), max(hire_date) from employees;
select first_name, hire_date
from employees
where hire_date=(select min(hire_date) from employees)
    OR hire_date=(select max(hire_date) from employees);
--알파벳순으로 제일 빠른 사원의 이름과 제일 늦은 사원
select min(first_name), max(last_name)
from employees;
--가장 큰 급여액
select max(salary) from employees;
select first_name, salary from employees
where salary = (select max(salary) from employees);

-- COUNT(*): 전체 테이블 행의 수 (중복, Null 포함)
-- COUNT(expr): 특정 열에서 Null이 아닌 행의 수
--모든 사원의 수
select count(*) from employees;  --107
-- 커미션을 받는 사원의 수
select count(commission_pct) from employees;  --35

-- STDDEV(STDDEV_SAMP): Null 값을 제외한 표본표준편차 (모표준편차 STDDEV_POP)
-- VARIANCE(VAR_SAMP): Null 값을 제외한 표본분산 (모분산 VAR_POP)
--사원들의 급여의 총합, 평균과 표준편차, 그리고 분산을 소수점 이하 두 번째 자리까지만 출력
select sum(salary) 합계, 
    round(avg(salary),2) 평균, 
    round(stddev(salary),2) 표준편차, 
    round(variance(salary),2) 분산
from employees;

-- 그룹함수와 NULL 값
-- COUNT(*)를 제외한 모든 그룹 함수는 열에 있는 Null 값을 연산에서 제외
select round(avg(salary*commission_pct),2) as avg_bonus
from employees; --평균은 보너스를 받는 사원의 수인 35로 나누어 계산
select 
    round(sum(salary*commission_pct),2) as sum_bonus,
    count(*) as count,
    round(avg(salary*commission_pct),2) as avg_bonus1,
    -- avg_bonus1 은 위와 동일 (null행 제외하고 계산)
    round(sum(salary*commission_pct)/count(*),2) as avg_bonus2
    -- AVG_BONUS2는 보너스의 합(sum_bonus)을 모든 사원의 수(count)로 나눈 결과
from employees; 
-- NVL 함수 사용하면 null일 때 0 반환해서 null행 개수도 포함할 수 있음
select round(avg(NVL(salary*commission_pct,0)),2) as avg_bonus2
from employees;

-- GROUP BY
-- SELECT 절에서 그룹 함수에 포함되지 않는 열은 반드시 GROUP BY 절에 포함되어야 함
select department_id, avg(salary)
from employees
GROUP BY department_id;
-- 각 부서 내의 직무별 급여 합계
select department_id, job_id, sum(salary)
from employees
GROUP BY department_id, job_id
order by department_id;

-- HAVING
-- 그룹을 제한하기 위해서는 HAVING 절 사용 (예. 부서별 급여평균이 8000 초과)
select department_id, round(avg(salary),2) as avg_sal
from employees
group by department_id
HAVING avg(salary)>8000
order by avg_sal desc;
-- 직무별 급여평균이 8000 초과 & Sales 직무를 담당하는 사원은 제외
select job_id, round(avg(salary),2) as avg_sal
from employees
where job_id NOT LIKE 'SA%'
group by job_id
HAVING avg(salary)>8000
order by avg_sal desc;

-- GROUPING SETS
-- GROUP BY 절과 UNION ALL 연산자의 결합된 형태의 기능 (간결, 성능향상)
-- GROUP BY 절 안에 그룹화할 열들의 집합 나열: GROUP BY GROUPING SETS (열1, 열2,..)
-- 부서별 급여의 평균과 직무별 급여의 평균 출력 (GROUP BY + UNION ALL)
select to_char(department_id), round(avg(salary),2) avg_sal -- job_id과 형일치
    from employees
    GROUP BY department_id
UNION ALL
select job_id, round(avg(salary),2)
    from employees
    GROUP BY job_id
order by 1;
-- (부서별 급여평균)과 (직무별 급여평균)을 출력 (GROUPING SETS)
select department_id, job_id, round(avg(salary),2)
from employees
group by GROUPING SETS (department_id, job_id)
order by 1,2;                                                                      -- department_id, job_id 둘 다 NULL은 뭐지?
-- 2개 이상의 열 그룹화도 가능
-- (부서별, 직무별 평균 급여)와 (직무별 매니저별 평균 급여) 출력
select department_id, job_id, manager_id,
        round(avg(salary),2) as avg_sal
from employees
GROUP BY
    GROUPING SETS ((department_id, job_id), -- 부서별, 직무별
                    (job_id, manager_id)) -- 직무별, 매니저별
order by department_id, job_id, manager_id;                                         -- job_id 'SA_REP', manager_id (null) 없는데 뭐지?

-- ROLLUP, CUBE
-- 부분합 또는 교차표를 만들 때 사용
-- 기본: 부서별, 직무별 급여의 평균과 사원의 수
select department_id, job_id, round(avg(salary),2), count(*)
from employees
GROUP BY department_id, job_id
order by department_id, job_id;
-- ROLLUP: 기본 + 각 부서별 (평균과 사원수) + 전체 (평균과 사원수) 
select department_id, job_id, round(avg(salary),2), count(*)
from employees
GROUP BY ROLLUP(department_id, job_id)
order by department_id, job_id;
-- CUBE: ROLLUP + 각 직무별 (평균과 사원수) --첫번째 열 뿐만 아니라 가능한 모든 조합!
select department_id, job_id, round(avg(salary),2), count(*)
from employees
GROUP BY CUBE(department_id, job_id)
order by department_id, job_id;                                               -- kimberley 부서 null OK인데 왜 직무는 SA_REP이 아니라 null로?

-- GROUPING
-- 1 또는 0을 반환
-- 1 반환: GROUPING SETS, ROLLUP, CUBE에서 '소계'를 표현하기 위해 고의로 생성된 (null)
-- 0 반환: 데이터가 값을 가지고 있거나 (null) 자체로 저장된 경우
-- DECODE함수와 함께 사용하여 집계되는 부분에 '소계' 문자를 출력
select 
    DECODE(GROUPING(department_id),1,'소계',to_char(department_id)) as 부서,
    DECODE(GROUPING(job_id),1,'소계',job_id) as 직무,
    round(avg(salary),2) as 평균,
    count(*) as 사원의수
from employees
GROUP BY CUBE(department_id, job_id)
order by 부서, 직무;

-- GROUPING_ID
-- 그룹화 수준을 식별하고 싶을 때 사용
-- GROUPING_ID를 사용하면 여러 GROUPING 함수가 필요 없고 
-- 그룹화 수준별 숫자를 반환하므로 DECODE를 이용해 쉽게 구분하여 표기 가능
select 
    DECODE(GROUPING_ID(department_id, job_id), 
            2, '소계', 3, '합계', department_id) as 부서번호,
    DECODE(GROUPING_ID(department_id, job_id),
            1, '소계', 3, '합계', job_id) as 직무,
    GROUPING_ID(department_id, job_id) as GID, 
    round(avg(salary),2) as 평균,
    count(*) as 사원의수
from employees
GROUP BY CUBE(department_id, job_id)
order by 부서번호, 직무;


                        





