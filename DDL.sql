DROP TABLE IF EXISTS user

DROP VIEW IF EXISTS board_list_view;
DROP TABLE IF EXISTS COMMENT;

CREATE TABLE board
(
  board_number   INT         NOT NULL AUTO_INCREMENT COMMENT '게시물 번호',
  title          TEXT        NOT NULL COMMENT '게시물 제목',
  content        TEXT        NOT NULL COMMENT '게시물 내용',
  write_datetime DATETIME    NOT NULL COMMENT '게시물 작성 날짜 및 시간',
  participation_count INT         NOT NULL DEFAULT 0 COMMENT '참여 인원 수',
  comment_count  INT         NOT NULL DEFAULT 0 COMMENT '게시물 댓글수',
  view_count     INT         NOT NULL DEFAULT 0 COMMENT '게시물 조회',
  writer_id    VARCHAR(50) NOT NULL COMMENT '게시물 작성자 아이디',
  PRIMARY KEY (board_number)
) COMMENT '게시물 테이블';

CREATE TABLE comment
(
  comment_number INT         NOT NULL AUTO_INCREMENT COMMENT '댓글 번호',
  content        TEXT        NOT NULL COMMENT '댓글 내용',
  user_id     VARCHAR(50) NOT NULL COMMENT '사용자 아이디',
  board_number   INT         NOT NULL COMMENT '게시물 번호',
  write_datetime DATETIME    NOT NULL COMMENT '작성날짜 및 시간',
  PRIMARY KEY (comment_number)
) COMMENT '댓글테이블';

CREATE TABLE user
(
    user_id VARCHAR(30)NOT NULL COMMENT '사용자아이디',
    password VARCHAR(100)NOT NULL COMMENT '사용자비밀번호',
    real_name VARCHAR(20)NOT NULL COMMENT '사용자실명',
    tel_number VARCHAR(15)NOT NULL COMMENT '사용자 휴대전화번호',
    profile_image TEXT NULL COMMENT '상용자 프로필 사진URL',
    agreed_personal TINYINT(1)NOT NULL COMMENT '개인정보제공 동의',
    PRIMARY KEY(user_id)
)COMMENT '사용자 테이블';


-- 실명 참여하기 데이터에 이용되는 real_name은 테이블 간 join을 통해 얻는다. 
CREATE TABLE participation
(
  user_id   VARCHAR(50) NOT NULL COMMENT '사용자 아이디',
  board_number INT         NOT NULL COMMENT '게시물 번호',
  PRIMARY KEY (user_id, board_number)
) COMMENT '참여테이블';

CREATE TABLE image
(
  board_number INT  NOT NULL COMMENT '게시물번호',
  image        TEXT NOT NULL COMMENT '게시물 이미지 URL'
) COMMENT '게시물 이미지 테이블';


ALTER TABLE image
  ADD CONSTRAINT FK_board_TO_image
    FOREIGN KEY (board_number)
    REFERENCES board (board_number);

ALTER TABLE board
  ADD CONSTRAINT FK_user_TO_board
    FOREIGN KEY (writer_id)
    REFERENCES user (user_id);

ALTER TABLE participation
  ADD CONSTRAINT FK_user_TO_participation
    FOREIGN KEY (user_id)
    REFERENCES user (user_id);

ALTER TABLE participation
  ADD CONSTRAINT FK_board_TO_participation
    FOREIGN KEY (board_number)
    REFERENCES board (board_number);

ALTER TABLE comment
  ADD CONSTRAINT FK_user_TO_comment
    FOREIGN KEY (user_id)
    REFERENCES user (user_id);

ALTER TABLE comment
  ADD CONSTRAINT FK_board_TO_comment
    FOREIGN KEY (board_number)
    REFERENCES board (board_number);

ALTER TABLE `board` AUTO_INCREMENT = 1;      

CREATE USER 'developer'@'%' IDENTIFIED BY 'P!ssw0rd';



-- 4종류의 게시물 불러오기인 최신 게시물 리스트, 검색어 리스트, 주간 상위3 게시물 리스트, 특정유저 게시물 리스트 불러오기
--  모두가 on구문 까지는 똑같다. 따라서 이렇게 중복하지 않고 VIEW를 사용하여 중복을 제거할 수 있다. DDL에 VIEW를 작성해 준다.

CREATE VIEW board_list_view AS
SELECT 
B.board_number AS board_number,
B.title AS title,
B.content AS content,
I.image as titleImage,
B.participation_count AS participation_count,
B.comment_count AS comment_count,
B.view_count AS view_count,
B.write_datetime AS write_datetime,
B.writer_id as writer_id,
U.real_name AS real_name,
U.profile_image AS writer_profile_image
FROM board AS B INNER JOIN user AS U -- board테이블이 기준이 되어 나머지 2개의 테이블과 조인됨
ON U.user_id=B.writer_id
LEFT OUTER JOIN (SELECT board_number, ANY_VALUE(image) AS image FROM image GROUP BY board_number)AS I
ON B.board_number=I.board_number

ALTER TABLE `image` ADD COLUMN `sequence` INT PRIMARY KEY AUTO_INCREMENT COMMENT '이비지 번호';



CREATE TABLE wod
(
  day   INT NOT NULL COMMENT '요일',
  title VARCHAR(80) NOT NULL COMMENT '제목',
  PRIMARY KEY (day)
) COMMENT '와드 테이블';

CREATE TABLE wod_content
(
  sequence INT     NOT NULL COMMENT '운동번호',
  day     INT   NOT NULL COMMENT '요일',
  content VARCHAR(500)   NOT NULL COMMENT '운동이름',
  PRIMARY KEY (sequence) 
) COMMENT '운동이름';

ALTER TABLE wod_content
  ADD CONSTRAINT FK_wod_TO_wod_content
    FOREIGN KEY (day)
    REFERENCES wod (day);


