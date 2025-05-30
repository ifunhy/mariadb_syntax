alter database shopping default character set = utf8mb4;
show variables like 'charater_set_server';


-- 사용자 테이블 생성
create table user(
id bigint not null primary key auto_increment, 
name varchar(50) not null, 
email varchar(50) not null, 
password varchar(50) not null, 
role enum('user', 'seller') not null);


-- 상품 테이블 생성
create table product(
id bigint not null primary key auto_increment, 
seller_id bigint not null, 
name varchar(255) not null, 
price int not null, 
stock int not null, 
CONSTRAINT fk_product_seller
    FOREIGN KEY (seller_id)
    REFERENCES `user` (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);


-- 상품상세 테이블 생성
create table product_details(
id bigint not null primary key auto_increment, 
product_id bigint not null, 
manufacture_date datetime not null, 
weight varchar(20) not null, 
telephone_number varchar(20), 
CONSTRAINT fk_pd_p_id
    FOREIGN KEY (product_id)
    REFERENCES `product` (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);
    
    
-- 장바구니 테이블 생성
create table cart(
id bigint not null primary key default (uuid()), 
user_id bigint not null, 
CONSTRAINT fk_card_u_id
    FOREIGN KEY (user_id)
    REFERENCES `user` (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE);
    

-- 장바구니상세 테이블 생성
CREATE TABLE cart_details (
  id bigint not null primary key auto_increment, 
  cart_id bigint not null,
  product_id bigint not null,
  quantity int not null,
  -- 1: 장바구니 FK
  CONSTRAINT fk_cd_c_id
    FOREIGN KEY (cart_id)
    REFERENCES cart (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  -- 2: 상품 FK
  CONSTRAINT fk_cd_p_id
    FOREIGN KEY (product_id)
    REFERENCES product (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
);


-- 주문 테이블 생성
create table ordered (
id bigint not null primary key auto_increment, 
user_id bigint not null, 
order_date datetime not null, 
status varchar(255) not null, 
CONSTRAINT fk_ordered_u_id
    FOREIGN KEY (user_id)
    REFERENCES `user` (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    );
    
    
-- 주문상세 테이블 생성
create table ordered_ (
id bigint not null primary key auto_increment, 
order_id bigint not null, 
product_id bigint not null, 
quantity int not null,
price_at_order datetime not null,
order_price int not null, 
  -- 1: 주문 FK
  CONSTRAINT fk_od_o_id
    FOREIGN KEY (order_id)
    REFERENCES ordered (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  -- 2: 상품 FK
  CONSTRAINT fk_od_p_id
    FOREIGN KEY (product_id)
    REFERENCES product (id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
    );
