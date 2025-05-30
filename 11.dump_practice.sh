# 덤프파일 생성
mysqldump -u root -p 스키마명 > 덤프파일명.sql
mysqldump -u root -p board > mydumpfile.sql


# 덤프파일 적용(복원)
mysqldump u root -p 스키마명 < 덤프파일명.sql
mysqldump -u root -p board < mydumpfile.sql


# 도커로 실행시
docker ps
# 덤프파일 생성성
docker exec -it c8a20898e512 mariadb-dump -u root -p board > mydumpfile.sql
# 위 코드로 안될 시
docker exec -i 컨테이너ID mariadb -u root -p1234 board < mydumpfile.sql
# 복원
docker exec -i c8a20898e512 mariadb -u root -p1234 board < mydumpfile.sql


# 강사님 코드
# 덤프파일 생성
mysqldump -u root -p 스키마명 > 덤프파일명
mysqldump -u root -p board > mydumpfile.sql
docker exec -it 컨테이너ID mariadb-dump -u root -p1234 board > mydumpfile.sql

# 덤프파일 적용(복원)
mysql -u root -p 스키마명 < 덤프파일명
mysql -u root -p board < mydumpfile.sql
docker exec -i 컨테이너ID mariadb -u root -p1234 board < mydumpfile.sql