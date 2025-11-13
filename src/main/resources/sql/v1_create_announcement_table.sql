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


=

-- 1. 공지사항 등록
DELIMITER //
CREATE PROCEDURE sp_insert_notice(
    IN p_n_title VARCHAR(100),
    IN p_n_content TEXT,
    IN p_n_priority INT,
    IN p_admin_index BIGINT,
    OUT p_notice_index INT
)
BEGIN
    INSERT INTO announcement (n_title,
                              n_content,
                              n_priority,
                              admin_index)
    VALUES (p_n_title,
            p_n_content,
            p_n_priority,
            p_admin_index);

    SET p_notice_index = LAST_INSERT_ID();
END //
DELIMITER ;

-- 2. 공지사항 목록 조회
DELIMITER //
CREATE PROCEDURE sp_select_notices(
    IN p_keyword VARCHAR(100)
)
BEGIN
    SELECT *
    FROM announcement
    WHERE p_keyword IS NULL
       OR n_title LIKE CONCAT('%', p_keyword, '%')
       OR n_content LIKE CONCAT('%', p_keyword, '%')
    ORDER BY n_priority DESC, n_createAt DESC;
END //
DELIMITER ;

-- 3. 공지사항 상세 조회
DELIMITER //
CREATE PROCEDURE sp_select_notice_detail(
    IN p_notice_index INT
)
BEGIN
    SELECT *
    FROM announcement
    WHERE notice_index = p_notice_index;
END //
DELIMITER ;

-- 4. 공지사항 수정
DELIMITER //
CREATE PROCEDURE sp_update_notice(
    IN p_notice_index INT,
    IN p_n_title VARCHAR(100),
    IN p_n_content TEXT,
    IN p_n_priority INT
)
BEGIN
    UPDATE announcement
    SET n_title    = p_n_title,
        n_content  = p_n_content,
        n_priority = p_n_priority,
        n_updateAt = NOW()
    WHERE notice_index = p_notice_index;
END //
DELIMITER ;

-- 5. 공지사항 삭제
DELIMITER //
CREATE PROCEDURE sp_delete_notice(
    IN p_notice_index INT
)
BEGIN
    DELETE
    FROM announcement
    WHERE notice_index = p_notice_index;
END //
DELIMITER ;


-- ============================================
-- 1:1 문의 관련 프로시저
-- ============================================

-- 6. 1:1 문의 등록
DELIMITER //
CREATE PROCEDURE sp_insert_one_to_one_request(
    IN p_r_title VARCHAR(100),
    IN p_r_content TEXT,
    IN p_r_type VARCHAR(50),
    IN p_user_index BIGINT,
    OUT p_request_index INT
)
BEGIN
    INSERT INTO one_to_one_request (r_title,
                                    r_content,
                                    r_type,
                                    r_status,
                                    user_index)
    VALUES (p_r_title,
            p_r_content,
            p_r_type,
            'PENDING',
            p_user_index);

    SET p_request_index = LAST_INSERT_ID();
END //
DELIMITER ;

-- 7. 사용자 본인의 1:1 문의 목록 조회
DELIMITER //
CREATE PROCEDURE sp_select_my_one_to_one_requests(
    IN p_user_index BIGINT,
    IN p_keyword VARCHAR(100)
)
BEGIN
    SELECT *
    FROM one_to_one_request
    WHERE user_index = p_user_index
      AND (p_keyword IS NULL
        OR r_title LIKE CONCAT('%', p_keyword, '%')
        OR r_content LIKE CONCAT('%', p_keyword, '%'))
    ORDER BY r_createAt DESC;
END //
DELIMITER ;

-- 8. 관리자용 1:1 문의 목록 조회
DELIMITER //
CREATE PROCEDURE sp_select_one_to_one_requests(
    IN p_keyword VARCHAR(100),
    IN p_status VARCHAR(20)
)
BEGIN
    SELECT *
    FROM one_to_one_request
    WHERE 1 = 1
      AND (p_keyword IS NULL
        OR r_title LIKE CONCAT('%', p_keyword, '%')
        OR r_content LIKE CONCAT('%', p_keyword, '%'))
      AND (p_status IS NULL OR r_status = p_status)
    ORDER BY r_createAt DESC;
END //
DELIMITER ;

-- 9. 1:1 문의 상세 조회
DELIMITER //
CREATE PROCEDURE sp_select_one_to_one_request_detail(
    IN p_request_index INT
)
BEGIN
    SELECT *
    FROM one_to_one_request
    WHERE request_index = p_request_index;
END //
DELIMITER ;

-- 10. 1:1 문의 수정 (답변 전에만)
DELIMITER //
CREATE PROCEDURE sp_update_one_to_one_request(
    IN p_request_index INT,
    IN p_r_title VARCHAR(100),
    IN p_r_content TEXT,
    IN p_r_type VARCHAR(50)
)
BEGIN
    UPDATE one_to_one_request
    SET r_title    = p_r_title,
        r_content  = p_r_content,
        r_type     = p_r_type,
        r_updateAt = NOW()
    WHERE request_index = p_request_index
      AND r_status = 'PENDING';
END //
DELIMITER ;

-- 11. 1:1 문의 답변 등록/수정 (관리자)
DELIMITER //
CREATE PROCEDURE sp_update_one_to_one_answer(
    IN p_request_index INT,
    IN p_r_response TEXT,
    IN p_admin_index BIGINT
)
BEGIN
    UPDATE one_to_one_request
    SET r_response  = p_r_response,
        r_status    = 'ANSWERED',
        admin_index = p_admin_index,
        r_updateAt  = NOW()
    WHERE request_index = p_request_index;
END //
DELIMITER ;

-- 12. 1:1 문의 삭제
DELIMITER //
CREATE PROCEDURE sp_delete_one_to_one_request(
    IN p_request_index INT
)
BEGIN
    DELETE
    FROM one_to_one_request
    WHERE request_index = p_request_index;
END //
DELIMITER ;


-- ============================================
-- 문의 게시판 관련 프로시저
-- ============================================

-- 13. 게시글 등록
DELIMITER //
CREATE PROCEDURE sp_insert_board_request(
    IN p_b_title VARCHAR(100),
    IN p_b_content TEXT,
    IN p_b_type VARCHAR(50),
    IN p_user_index BIGINT,
    OUT p_board_index INT
)
BEGIN
    INSERT INTO board_request (b_title,
                               b_content,
                               b_type,
                               user_index)
    VALUES (p_b_title,
            p_b_content,
            p_b_type,
            p_user_index);

    SET p_board_index = LAST_INSERT_ID();
END //
DELIMITER ;

-- 14. 게시글 목록 조회
DELIMITER //
CREATE PROCEDURE sp_select_board_requests(
    IN p_keyword VARCHAR(100),
    IN p_type VARCHAR(50)
)
BEGIN
    SELECT *
    FROM board_request
    WHERE 1 = 1
      AND (p_keyword IS NULL
        OR b_title LIKE CONCAT('%', p_keyword, '%')
        OR b_content LIKE CONCAT('%', p_keyword, '%'))
      AND (p_type IS NULL OR b_type = p_type)
    ORDER BY b_createAt DESC;
END //
DELIMITER ;

-- 15. 게시글 상세 조회
DELIMITER //
CREATE PROCEDURE sp_select_board_request_detail(
    IN p_board_index INT
)
BEGIN
    SELECT *
    FROM board_request
    WHERE board_index = p_board_index;
END //
DELIMITER ;

-- 16. 게시글 조회수 증가
DELIMITER //
CREATE PROCEDURE sp_increase_board_views(
    IN p_board_index INT
)
BEGIN
    UPDATE board_request
    SET b_views = b_views + 1
    WHERE board_index = p_board_index;
END //
DELIMITER ;

-- 17. 게시글 수정
DELIMITER //
CREATE PROCEDURE sp_update_board_request(
    IN p_board_index INT,
    IN p_b_title VARCHAR(100),
    IN p_b_content TEXT,
    IN p_b_type VARCHAR(50)
)
BEGIN
    UPDATE board_request
    SET b_title    = p_b_title,
        b_content  = p_b_content,
        b_type     = p_b_type,
        b_updateAt = NOW()
    WHERE board_index = p_board_index;
END //
DELIMITER ;

-- 18. 게시글 삭제
DELIMITER //
CREATE PROCEDURE sp_delete_board_request(
    IN p_board_index INT
)
BEGIN
    DELETE
    FROM board_request
    WHERE board_index = p_board_index;
END //
DELIMITER ;


-- ============================================
-- 게시판 댓글 관련 프로시저
-- ============================================

-- 19. 댓글 등록
DELIMITER //
CREATE PROCEDURE sp_insert_board_comment(
    IN p_board_index INT,
    IN p_c_content TEXT,
    IN p_user_index BIGINT,
    IN p_admin_index BIGINT,
    OUT p_comment_index INT
)
BEGIN
    INSERT INTO board_comment (board_index,
                               c_content,
                               user_index,
                               admin_index)
    VALUES (p_board_index,
            p_c_content,
            p_user_index,
            p_admin_index);

    SET p_comment_index = LAST_INSERT_ID();
END //
DELIMITER ;

-- 20. 게시글의 댓글 목록 조회
DELIMITER //
CREATE PROCEDURE sp_select_board_comments(
    IN p_board_index INT
)
BEGIN
    SELECT *
    FROM board_comment
    WHERE board_index = p_board_index
    ORDER BY c_createAt ASC;
END //
DELIMITER ;

-- 21. 댓글 삭제
DELIMITER //
CREATE PROCEDURE sp_delete_board_comment(
    IN p_comment_index INT
)
BEGIN
    DELETE
    FROM board_comment
    WHERE comment_index = p_comment_index;
END //
DELIMITER ;