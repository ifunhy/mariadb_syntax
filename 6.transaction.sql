-- 트랜잭션 테스트
alter table author add column post_count int default 0;

-- post에 글 쓴 후, author 테이블의 post_count 컬럼에 +1을 시키는 트랜잭션 테스트
start transaction;
update author set post_count=post_count+1 where id = 3;
insert into post(title, content, author_id) values("hello", "hello ...", 3);
commit; -- 또는 rollback;

-- 위 트랜잭션은 실패시 자동으로 rollback이 어려움
-- stored 프로시저를 활용하여 성공시 commit, 실패시 rollback 등 다이나믹한 프로그래밍 가능
DELIMITER //
create procedure transaction_test()
begin
    declare exit handler for SQLEXCEPTION   -- sqlexception이 발생하면 
    begin   -- rollback 실행함
        rollback;
    end;
    start transaction;
    update author set post_count=post_count+1 where id = 3;
    insert into post(title, content, author_id) values("hello", "hello ...", 3);
    commit;
end //
DELIMITER ;

-- 프로시저 호출
call transaction_test(); 

-- 사용자에게 입력받는 프로시저 생성
DELIMITER //
create procedure transaction_test2(in titleInput varchar(255), in contentInput varchar(255), in idInput bigint)
begin
    declare exit handler for SQLEXCEPTION 
    begin
        rollback;
    end;
    start transaction;
    update author set post_count=post_count+1 where id = idInput;
    insert into post(title, content, author_id) values(titleInput, contentInput, idInput);
    commit;
end //
DELIMITER ;

-- 실패하면 모든 트랜잭션 취소
-- 성공하면 모든 트랜잭션 실행