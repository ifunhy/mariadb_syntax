-- view : 실제 데이터를 참조만 하는 가상의 테이블. SELECT만 가능
-- 사용목적 : 1) 복잡한 쿼리를 사전 생성    2) 권한 분리

-- view 생성
create view author_for_view as select name, email from author;

-- view 조회
select * from author_for_view;

-- view 권한 부여
grant select on board.author_for_view to '계정명'@'%';

-- view 삭제
drop view author_for_view;


-- 프로시저
delimiter //
create procedure hello_procedure()  -- 프로시저명 정의
begin   -- 본문
    select "hello world";
end
// delimiter ;


-- 프로시저 호출
call hello_procedure();


-- 프로시저 삭제
drop procedure hello_procedure;


-- 회원 목록 조회 : 한글명 프로시저 가능
delimiter //
create procedure 회원목록조회()  -- 프로시저명 정의
begin   -- 본문
    select * from author;
end
// delimiter ;


-- 회원 상세 조회 : 매개변수 input값 사용 가능
delimiter //
create procedure 회원상세조회(in emailInput varchar(255))   -- 자료형의 크기를 넉넉하게
begin
    select * from author where email = emailInput;  -- where 조건절에 넣어서 변수로 사용 가능
end
// delimiter ;


-- 글쓰기
delimiter //
create procedure 글쓰기(in titleInput varchar(255), in contentsInput varchar(255), in emailInput varchar(255))   -- 자료형의 크기를 넉넉하게
begin
    -- declare는 begin 밑에 위치
    declare authorIdInput bigint;   -- id값 선언
    declare postIdInput bigint;
    declare exit handler for SQLEXCEPTION   -- sqlexception이 발생하면 (예외적인 상황이 발생하면)
    begin   -- rollback 실행
        rollback; 
    end;
    start transaction;  -- 트랜잭션 시작 (하나라도 에러시 롤백)
        select id into authorIdInput from author where email = emailInput;  -- id값 할당, where 조건절에 넣어서 변수로 사용 가능
        insert into post(title, contents) values(titleInput, contentsInput);    -- 할당된 id값에 값을 insert
        select id into postIdInput from post order by id desc limit 1;   -- id값을 내림차순을 조회하여 값을 가져옴옴
        insert into author_post(author_id, post_id) values(authorIdInput, postIdInput);
    commit; -- 트랜잭션 커밋
end
// delimiter ;


-- 여러 명이 편집 가능한 글에서 글 삭제 (분기처리)
delimiter //
create procedure 글삭제(in postIdInput bigint, in emailInput varchar(255))  -- 어떤 글을 삭제할 것인지, 이메일도 넣음음
begin
    declare authorId bigint;
    declare authorPostCount bigint;
    select count(*) into authorPostCount from author_post where post_id = postIdInput;
    select id into authorId from author where email = emailInput;
    -- 글쓴이가 본인밖에 없는 경우 : author_post 삭제, post까지 삭제 가능
    if authorPostCount=1 then
        delete from author_post where author_id = authorId and post_id = postIdInput; -- author_post 삭제
        delete from post where id = postIdInput;
--  elseif도 사용 가능
    else    -- 글쓴이가 본인 이외에 다른 사람도 있는 경우 : author_post만 삭제 (참여자로서 본인만 삭제)
        delete from author_post where author_id = and post_id = authorId and post_id = postIdInput;
    end if;
end
// delimiter ;

-- 강사님코드
-- 여러명이 편집가능한 글에서 글삭제
delimiter //
create procedure 글삭제(in postIdInput bigint, in emailInput varchar(255))
begin
    declare authorId bigint;
    declare authorPostCount bigint;
    select count(*) into authorPostCount from author_post where post_id = postIdInput;
    select id into authorId from author where email = emailInput;
    -- 글쓴이가 나밖에 없는경우: author_post삭제, post까지 삭제
    -- 글쓴이가 나 이외에 다른사람도 있는경우 : author_post만 삭제
    if authorPostCount=1 then
--  elseif도 사용 가능
        delete from author_post where author_id = authorId and post_id = postIdInput;
        delete from post where id=postIdInput;
    else
        delete from author_post where author_id = authorId and post_id = postIdInput;
    end if;
end
// delimiter ;


-- 반복문을 통한 post 대량 생성
delimiter //
create procedure 대량글쓰기(in countInput bigint, in emailInput varchar(255))   -- 자료형의 크기를 넉넉하게
begin
    -- declare는 begin 밑에 위치
    declare authorIdInput bigint;   -- id값 선언
    declare postIdInput bigint;
    declare countValue bigint default 0;  -- while 조건식을 다루기 위한 변수 선언 후 값 초기화
    while countValue < countInput do     -- while 조건식이 참인 경우(do) 반복
        select id into authorIdInput from author where email = emailInput;  -- id값 할당, where 조건절에 넣어서 변수로 사용 가능
        insert into post(title) values("안녕하세요");    -- 할당된 id값에 값을 insert
        select id into postIdInput from post order by id desc limit 1;   -- id값을 내림차순을 조회하여 값을 가져옴옴
        insert into author_post(author_id, post_id) values(authorIdInput, postIdInput);
        set countValue = countValue+1;  -- 값변경 명령어 set으로 ++ 조건 추가
    end while;
end
// delimiter ;
