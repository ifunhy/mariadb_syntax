-- 사용자 관리
-- 사용자 목록 조회
select * from mysql.user;

-- 사용자 생성
create user 'jiki1007'@'localhost' identified by '4321';
-- 원격 접속 (도커로 접속시)
create user 'jiki1007'@'%' identified by '4321';

-- 사용자에게 권한 부여
grant select on board.author to 'jiki1009'@'%';
-- select, insert만 권한 주고 싶을 때
grant select, insert on board.* to 'jiki1009'@'%';
-- 모든 권한 다 주고 싶을 때
grant all privileges on board.* to 'jiki1009'@'%';

-- 사용자 권한 회수
revoke select on board.author from 'jiki1009'@'%';
-- 사용자 권한 조회
show grants for 'jiki1009'@'%';
-- 사용자 계정 삭제
drop user 'jiki1009'@'%';