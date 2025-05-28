-- post 테이블의 author_id 값을 nullable 하게 변경
alter table post modify column author_id bigint;

-- inner join
-- 두 테이블 사이에 지정된 조건에 맞는 레코드만을 반환. on 조건을 통해 교집합 찾기
-- 즉, post 테이블에 글 쓴 적이 있는 author와 글쓴이가 author에 있는 post 데이터를 결합하여 출력
select * from author inner join post on author.id=post.author_id;
select * from author a inner join post p on a.id=p.author_id;
-- 출력 순서만 달라질 뿐 위 쿼리와 아래 쿼리는 동일
select * from post p inner join author a on a.id=p.author_id;
-- 만약 같게 하고 싶다면 
select a.*, p.* from post p inner join author a on a.id=p.author_id;

-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력하시오.
-- post의 글쓴이가 없는 데이터는 제외. 글쓴이 중 글 쓴 적 없는 사람도 제외.
select p.*, a.email from post p inner join author a on p.author_id=a.id;
select p.*, a.email from post p inner join author a on a.id=p.author_id;    -- on 뒤 순서 상관x
-- 글쓴이가 있는 글의 제목, 내용, 그리고 글쓴이의 이름만 출력하시오.
select p.title, p.content, a.name from post p inner join author a on a.id=p.author_id;

-- A left join B : A테이블의 데이터는 모두 조회하고, 관련있는(ON 조건) B데이터도 출력
-- 글쓴이는 모두 출력하되, 글을 쓴 적 있다면 관련글도 같이 출력
select * from author a left join post p on a.id=p.author_id;

-- 모든 글 목록을 출력하고, 만약 저자가 있다면 이메일 정보를 출력
select p.*, a.email from post p left join author a on a.id=p.author_id;

-- 모든 글 목록을 출력하고, 관련된 저자 정보 출력(author_id가 not null이라면)
-- 아래 두 쿼리는 동일
select * from post p left join author a on p.author_id=a.id;
select * from post p inner join author a on p.author_id=a.id;

-- 실습) 글쓴이가 있는 글 중에서 글의 title과 저자의 email을 출력하되, 저자의 나이가 30세 이상인 글만 출력
select p.title, a.email from post p inner join author a on p.author_id=a.id where a.age >= 30;

-- 전체 글 목록을 조회하되, 글의 저자의 이름이 비어져 있지 않은 글 목록만을 출력
select p.* from post p inner join author a on a.id=p.author_id where a.name is not null;

--  조건에 맞는 도서와 저자 리스트 출력
SELECT 
        b.BOOK_ID, a.AUTHOR_NAME, DATE_FORMAT(b.PUBLISHED_DATE, '%Y-%m-%d') AS PUBLISHED_DATE
FROM BOOK b
LEFT JOIN AUTHOR a ON b.AUTHOR_ID = a.AUTHOR_ID
WHERE b.CATEGORY = '경제'
ORDER BY b.PUBLISHED_DATE ASC;

-- 없어진 기록 찾기
-- left join
SELECT o.ANIMAL_ID, o.NAME FROM ANIMAL_OUTS o
LEFT JOIN ANIMAL_INS i ON i.ANIMAL_ID=o.ANIMAL_ID
WHERE i.ANIMAL_ID is NULL
ORDER BY o.ANIMAL_ID ASC;
-- 서브쿼리
SELECT o.animal_id, o.name from animal_outs o 
where o.animal_id not in (select animal_id from animal_ins);


-- union : 두 테이블의 select 결과를 횡으로 결합 (기본적으로 distinct 적용)
-- union 시킬 때 컬럼의 개수와 컬럼의 타입이 같아야 함
select name, email from author union select title, content from post;
-- union all : 중복까지 모두 포함하여 결합
select name, email from author union all select title, content from post;

-- 서브쿼리 : select문 안에 또 다른 select문을 서브쿼리라 함
select 컬럼 from 테이블 where 조건      -- 컬럼, 테이블, 조건 자리에 다 들어갈 수 있음

-- where절 안에 서브쿼리
-- 한번이라도 글을 쓴 author 목록 조회
select distinct a.* from author a inner join post p on a.id=p.author_id;
-- null 값은 in 조건절에서 자동으로 제외
select * from author where id in(select author_id from post);

-- 컬럼 위치에 서브쿼리
-- author의 email과 author별로 본인의 쓴 글의 개수를 출력
select email, (select count(*) from post p where p.author_id=a.id) from author a;

-- from절 위치에 서브쿼리
select from (서브쿼리)
select a.* from (select * from author where id>5) as a;

-- group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화하여, 하나의 행(row)처럼 취급
select author_id from post group by author_id;
-- 보통 아래와 같이 집계함수와 같이 많이 사용용
select author_id, count(*) from post group by author_id;

-- 집계함수
-- null은 count에서 제외됨
select count(*) from author;
select sum(price) from post;
select avg(price) from post;
-- 소수점 3번째 자리에서 반올림
select round(avg(price), 3) from post;

-- group by와 집계함수
select author_id, count(*), sum(price) from post group by author_id;

-- where와 group by (where절은 테이블 옆에 나옴. 전체 데이터에 대한 필터링)
-- 연도별 post 글의 개수 출력(날짜값이 null은 제외)
select date_format(created_time, '%Y-%m-%d') as day, count(*) 
from post where created_time is not null group by day;

-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기
SELECT CAR_TYPE, COUNT(CAR_TYPE) AS CARS 
FROM CAR_RENTAL_COMPANY_CAR 
WHERE OPTIONS LIKE '%통풍시트%' OR OPTIONS LIKE '%열선시트%' OR OPTIONS LIKE '%가죽시트%' 
GROUP BY CAR_TYPE
ORDER BY CAR_TYPE ASC;

-- 입양 시각 구하기(1)
SELECT HOUR(DATETIME) AS HOUR, COUNT(DATETIME) AS COUNT
FROM ANIMAL_OUTS
WHERE HOUR(DATETIME) >= 9 AND HOUR(DATETIME) <= 19
GROUP BY HOUR
ORDER BY HOUR;
--
SELECT HOUR(DATETIME) AS HOUR, COUNT(DATETIME) AS COUNT
FROM ANIMAL_OUTS AO WHERE DATE_FORMAT(AO.DATETIME, '%H') >= '09' AND DATE_FORMAT(AO.DATETIME, '%H') < '20'
GROUP BY DATE_FORMAT(AO.DATETIME, '%H')
ORDER BY HOUR;

-- group by와 having
-- having은 group by를 통해 나온 집계값에 대한 조건
-- 글을 2번 이상 쓴 사람 ID 찾기
select author_id from post group by author_id having count(*) >= 2;

-- 동명 동물 수 찾기
SELECT NAME, COUNT(*) AS COUNT
FROM ANIMAL_INS
GROUP BY NAME
HAVING COUNT(NAME) >= 2
ORDER BY NAME ASC;

-- 카테고리별 도서 판매량 집계하기
SELECT B.CATEGORY, SUM(BS.SALES) AS TOTAL_SALES
FROM BOOK B
INNER JOIN BOOK_SALES BS
ON B.BOOK_ID=BS.BOOK_ID
WHERE BS.SALES_DATE LIKE '2022-01%'
GROUP BY B.CATEGORY
ORDER BY B.CATEGORY;

-- 조건에 맞는 사용자와 총 거래금액 조회하기
SELECT U.USER_ID, U.NICKNAME, SUM(B.PRICE) AS TOTAL_SALES
FROM USED_GOODS_BOARD B
INNER JOIN USED_GOODS_USER U
ON B.WRITER_ID=U.USER_ID
WHERE B.STATUS='DONE'
GROUP BY U.USER_ID
HAVING SUM(B.PRICE) >= 700000
ORDER BY SUM(B.PRICE);

-- 다중열 group by
-- group by 첫번째컬럼, 두번째컬럼 : 첫번째컬럼으로 먼저 grouping 이후에 두번째컬럼으로 grouping
-- post 테이블에서 작성자별로 만든 제목의 개수를 출력하시오
select author_id, title, count(*) from post group by author_id , title;

-- 재구매가 일어난 상품과 회원 리스트 구하기
SELECT USER_ID, PRODUCT_ID 
FROM ONLINE_SALE
GROUP BY USER_ID, PRODUCT_ID
HAVING COUNT(*) >= 2
ORDER BY USER_ID, PRODUCT_ID DESC;


-- 암기법 : 셀프조인온왜글해요
select, from, join, on, where, group by, having, order by