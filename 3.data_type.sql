-- tinyint : -128 ~ 127 까지 표현
-- author 테이블에 age 컬럼 변경
alter table author modify column age tinyint unsigned;
insert into author(id, email, age) values(6, 'abc@naver.com', 300); -- 300은 255범위를 벗어나기 때문에 에러, 200으로 수정


-- int : 4바이트(대략, 40억 범위) -2147483648 ~ 2147483647

-- bigint : 8바이트
-- author, post 테이블의 id 값 bigint 변경
alter table author modify colmn id bigint;

-- decimal(총자리수, 소수부자리수)
alter table post add column price decimal(10,3);
-- decimal 소수점 초과시 잘림 현상 발생
insert into post(id, title, price, author_id) values(7, 'hello python', 10.33412, 3);

-- 문자 타입 : 고정 길이(char), 가변 길이(varchar, text)
alter table author add column gender char(10);  -- 낭비 발생
alter table author modify column gender char(1);	-- char 값 수정
alter table author add column self_introduction text;   -- text 타입의 컬럼 추가

-- blob(바이너리데이터) 타입 실습
-- 일반적으로 blob으로 저장하기 보다, vatchar로 설계하고 이미지경로만을 저장함함
alter table author add column profile_image longblob;   -- longblob 타입의 profile_image 컬럼 추가
insert into author(id, email profile_image) values(8, 'aaa@naver.com', LOAD_FILE('C:\\pupleheart.png'));


-- enum : 삽입될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role 컬럼 추가
alter table author add column role enum('admin', 'user');
insert into author values(id, email, role) values(11, 'bbb@naver.com', 'hello');    -- 'hello'는 role 타입에 지정되어 있지 않아 오류
insert into author values(id, email, role) values(11, 'bbb@naver.com', 'admin');
-- not null default 'user' : role 미입력시 디폴트값 입력
alter table author add column role enum('admin', 'user') not null default 'user';
insert into author values(id, email) values(11, 'bbb@naver.com');

-- testcase
alter table author add column role enum('admin', 'user') not null default 'user';
--- enum에 지정된 값이 아닌 경우
insert into author(id, email, role) values(11, 'bbb@naver.com', 'admin2');
--- role을 지정 안 한 경우
insert into author(id, email) values(12, 'bbb@naver.com');
--- enum에 지정된 값인 경우
insert into author(id, email, role) values(13, 'bbb@naver.com', 'admin');

-- date와 datetime
-- 날짜타입의 입력, 수정, 조회시에 문자열 형식을 사용(진짜 문자열 X)
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post(id, title, author_id, created_time) values(7, 'hello', 3, '2025-05-23 14:36:30');
alter table post modify column created_time datetime default current_timestamp; 
insert into post(id, title, author_id) values(10, 'hello', 3);

-- 비교연산자
select * from author where id >= 2 and id <= 4;
select * from author where id between 2 and 4;    -- 위 구문과 같은 구문
select * from author where id in(2,3,4);    -- 위 구문과 같은 구문
select * from author where id not in(2,3,4);    -- 2,3,4 제외

-- like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like 'h%'; 
select * from post where title like '%h'; 
select * from post where title like '%h%'; 

--regexp : 정규표현식을 활용한 조회
select * from post where title regexp '[a-z]';  -- 하나라도 알파벳 소문자가 들어있으면
select * from post where title regexp '[가-힣]';    -- 하나라도 한글이 들어있으면

-- 숫자 -> 날짜
select cast(20250523 as date);  -- 숫자를 2025-05-23 날짜 형식으로 변환
-- 문자 -> 날짜
select cast('20250523' as date);    -- 문자를 2025-05-23 날짜 형식으로 변환
-- 문자 -> 숫자
select cast('12' as unsigned);  -- 문자를 12 숫자 형식으로 변환

-- 날짜 조회 방법 : 2025-05-23 14:30:25
-- like 패턴, 부등호 활용, date_format
select * from post where created_time like '2025-05%'   -- 문자열처럼 조회
-- 5/1 ~ 5/20 까지 조회, 날짜만 입력시 시간 부분은 00:00:00이 자동으로 붙음
-- 0501 11:20은 조회 가능, 0521 01:12는 불가능(시간 자리까지 문자열 비교)
select * from post where created_time >= '2025-05-01' and created_time <= '2025-05-21';

-- date_format 활용
select date_format(created_time, '%Y-%m-%d') from post; -- 날짜로 조회
select date_format(created_time, '%H:%i:%s') from post; -- 시간으로 조회
select * from post where date_format(created_time, '%m') = '05';    -- %m 으로 찾고자 하는 월만 출력

select * from post where date_format(created_time, '%m')=5; -- 원래 안 되어야 하는데 왜 되지?
-- 문자 -> 숫자 형변환하여 값 출력
select * from post where cast(date_format(created_time, '%m') as unsigned)=5;   -- 이게 정답임




-------- 실습 내용 ---------
SELECT * FROM board.author;
describe author;
describe post;
select * from information_schema.key_column_usage where table_name='post';

alter table author add column age int;
alter table author modify column age tinyint unsigned;
insert into author(id, email, age) values(6, 'abc@naver.com', 200);
alter table post drop constraint post_ibfk_1; -- 키 삭제 (타입 변경 후 키 재등록 위해)
alter table author modify column id bigint; -- author id값을 bigint로 변경
alter table post modify column id bigint;	-- post id값을 bigint로 변경
alter table post modify column author_id bigint;	-- post의 author_id값을 bigint로 변경(외래키 연결 이슈)
alter table post add constraint post_ibfk_1 foreign key(author_id) references author(id);	-- 외래키 재 등록