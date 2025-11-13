-- 1. 공지사항 테이블 (announcement)
CREATE TABLE IF NOT EXISTS announcement
(
    notice_index INT AUTO_INCREMENT PRIMARY KEY COMMENT '공지 번호',
    n_title      VARCHAR(100) NOT NULL COMMENT '공지 제목',
    n_content    TEXT         NOT NULL COMMENT '공지 내용',
    n_createAt   DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    n_updateAt   DATETIME              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    n_priority   INT                   DEFAULT 0 COMMENT '중요도 (0: 일반, 1: 중요)',
    admin_index  BIGINT       NOT NULL COMMENT '관리자번호',
    INDEX idx_priority (n_priority),
    INDEX idx_createAt (n_createAt)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='공지사항 테이블';

-- 2. 1:1 문의 테이블 (one_to_one_request)
CREATE TABLE IF NOT EXISTS one_to_one_request
(
    request_index INT AUTO_INCREMENT PRIMARY KEY COMMENT '1:1 문의 번호',
    r_title       VARCHAR(100) NOT NULL COMMENT '문의 제목',
    r_content     TEXT         NOT NULL COMMENT '문의 내용',
    r_createAt    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    r_updateAt    DATETIME              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    r_status      VARCHAR(20)  NOT NULL DEFAULT 'PENDING' COMMENT '답변 상태 (PENDING, ANSWERED)',
    r_type        VARCHAR(50)  NOT NULL COMMENT '문의 유형',
    r_response    TEXT COMMENT '관리자 답변',
    user_index    BIGINT       NOT NULL COMMENT '유저번호',
    admin_index   BIGINT COMMENT '답변한 관리자번호',
    INDEX idx_user (user_index),
    INDEX idx_status (r_status),
    INDEX idx_createAt (r_createAt)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='1:1 문의 테이블';

-- 3. 문의 게시판 테이블 (board_request)
CREATE TABLE IF NOT EXISTS board_request
(
    board_index INT AUTO_INCREMENT PRIMARY KEY COMMENT '게시글 번호',
    b_title     VARCHAR(100) NOT NULL COMMENT '게시글 제목',
    b_content   TEXT         NOT NULL COMMENT '게시글 내용',
    b_createAt  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    b_updateAt  DATETIME              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    b_type      VARCHAR(50)  NOT NULL COMMENT '문의 유형',
    b_views     INT                   DEFAULT 0 COMMENT '조회수',
    user_index  BIGINT       NOT NULL COMMENT '작성자번호',
    INDEX idx_user (user_index),
    INDEX idx_createAt (b_createAt),
    INDEX idx_type (b_type)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='문의 게시판 테이블';

-- 4. 문의 게시판 댓글 테이블 (board_comment)
CREATE TABLE IF NOT EXISTS board_comment
(
    comment_index INT AUTO_INCREMENT PRIMARY KEY COMMENT '댓글 번호',
    board_index   INT      NOT NULL COMMENT '게시글 번호',
    c_content     TEXT     NOT NULL COMMENT '댓글 내용',
    c_createAt    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '작성일',
    user_index    BIGINT COMMENT '작성자번호 (사용자)',
    admin_index   BIGINT COMMENT '작성자번호 (관리자)',
    INDEX idx_board (board_index),
    INDEX idx_createAt (c_createAt),
    FOREIGN KEY (board_index) REFERENCES board_request (board_index) ON DELETE CASCADE
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT ='문의 게시판 댓글 테이블';
