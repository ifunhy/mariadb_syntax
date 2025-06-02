# windows에서는 기본 설치 불가능 -> 도커를 통한 redis 설치
docker run --name redis-container -d -p 6379:6379 redis

# redis 접속 명령어
redis-cli

# docker redis 접속 명령어
docker exec -it 컨테이너ID redis-cli

# redis는 0 ~ 15번까지의 db로 구성 (default는 0번 db)
# db번호 선택
select db번호

# db내 모든 키 조회
keys *

# key를 통해 value get
get user1
# 특정 key 삭제
del user1

# 가장 일반적인 String 자료구조

# set을 통해 key:value 세팅
set user1 hong1@naver.com
set user:email:1 hong1@naver.com     # user:email:1 -> key
set user:email:2 hong2@naver.com
# 기존 key:value 존재할 경우 덮어쓰기
set user:email:1 hong3@naver.com
# key값이 이미 존재하면 pass, 없으면 set : nx 옵션
set user:email:1 hong4@naver.com nx     # 이미 존재하여 pass
set user:email:4 hong4@naver.com nx     # 존재하지 않아 set
# 만료시간(ttl) 설정(초단위) : ex 옵션
set user:email:5 hong5@naver.com ex 10  # 10초 뒤 사라짐
# redis 실전 활용 : token 등 사용자 인증 정보 저장 -> 빠른 성능 활용
set user:1:refresh_token abcdef1234 ex 1800  # 30분 후 정보 사라짐
# 현재 DB내 모든 key값 삭제
flushdb
# redis 실전 활용 : 좋아요 기능 구현 -> 동시성 이슈 해결
set likes:posting:1 0   # redis는 기본적으로 모든 key:value가 문자열. 내부적으로는 "0"으로 저장
incr likes:posting:1    # 특정 key값의 value를 1만큼 증가
decr likes:posting:1    # 특정 key값의 value를 1만큼 감소
# redis 실전 활용 : 재고 관리 구현 -> 동시성 이슈 해결
set stocks:product:1 100
decr stocks:product:1
incr stocks:product:1

# redis 실전 활용 : 캐싱 기능 구현
# 1번 회원 정보 조회 : select name, email, age from member where id=1;
# 위 데이터의 결과값을 spring 서버를 통해 json으로 변형하여 redis에 캐싱
# 최종적인 데이터 형식 : {"name":"hong", "email":"hong@daum.net", "age":30}
set member:info:1 "{\"name\":\"hong\", \"email\":\"hong@daum.net\", \"age\":30}" ex 1000

# list 자료구조
# redis의 list는 deque와 같은 자료구조. 즉 double-ended queue구조
# lpush : 데이터를 list 자료구조에 왼쪽부터 삽입
# rpush : 데이터를 list 자료구조에 오른쪽부터 삽입
lpush hongs hong1   # leftpush
lpush hongs hong2   # hong:{hong2, hong1}
rpush hongs hong3   # hong:{hong2, hong1, hong3}
# list 조회 : 0은 리스트의 시작 인덱스. -1은 리스트의 마지막 인덱스
lrange hongs 0 -1   # 전체 조회
lrange hongs -1 -1   # 마지막 값 조회
lrange hongs 0 0    # 0번째 값 조회
lrange hongs -2 -1   # 마지막 2번째부터 마지막까지의 값 조회
lrange hongs 0 2    # 0번째부터 2번째까지의 값 조회
# list 값 꺼내기. 꺼내면서 삭제
rpop hongs
lpop hongs
# A리스트에서 rpop하여 B리스트에서 lpush
rpoplpush A리스트 B리스트
# list의 데이터 개수 조회
llen hongs
# ttl 적용
expire hongs 20     # 20초의 만료시간 설정
# ttl 조회
ttl hongs
# redis 실전 활용 : 최근 조회한 상품 목록
rpush user:1:recent:product apple
rpush user:1:recent:product banana
rpush user:1:recent:product orange
rpush user:1:recent:product melon
rpush user:1:recent:product mango   # 가장 최근 조회한 상품
# 최근 본 상품 3개 조회
lrange user:1:recent:product -3 -1

# set 자료구조 : 중복 없음, 순서 없음
sadd memberlist m1
sadd memberlist m2
sadd memberlist m3
# set 조회
smembers memberlist
# set 멤버 개수 조회
scard memberlist
# 특정 멤버가 set 안에 있는 존재 여부 확인
sismember memberlist m2

# redis 실전 활용 : 좋아요 구현
# 게시글 상세 보기에 들어가면
scard posting:likes:1   # set 멤버 개수 조회 : 좋아요 몇 개인지 표시
sismember posting:likes:1 a1@naver.com   # 존재 여부 확인 : 사용자의 좋아요 여부 확인 후 없다면 좋아요
# 게시글에 좋아요를 하면
sadd posting:likes:1 a1@naver.com   # set 자료구조 : 좋아요 기록 추가
# 좋아요 한 사람을 클릭하면
smembers posting:likes:1   # set 조회 : 좋아요 조회

# zset : sorted set