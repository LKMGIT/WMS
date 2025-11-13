-- 공지사항 샘플 데이터
INSERT INTO announcement (n_title, n_content, n_priority, admin_index)
VALUES ('[중요] 시스템 점검 안내', '11월 15일 오전 2시부터 4시까지 시스템 점검이 예정되어 있습니다.', 1, 1),
       ('배송 지연 안내', '기상 악화로 인해 일부 지역 배송이 지연될 수 있습니다.', 0, 1),
       ('[공지] 고객센터 운영시간 변경', '12월부터 고객센터 운영시간이 평일 09:00~18:00로 변경됩니다.', 1, 1);

-- 1:1 문의 샘플 데이터
INSERT INTO one_to_one_request (r_title, r_content, r_type, r_status, user_index)
VALUES ('입고 일정 문의', '입고 예정일을 변경할 수 있나요?', '입고관련', 'PENDING', 1),
       ('배송 문의', '주문한 상품의 배송 현황을 알고 싶습니다.', '배송관련', 'ANSWERED', 2),
       ('계정 문의', '비밀번호를 잊어버렸습니다.', '계정', 'ANSWERED', 3);

-- 1:1 문의 답변
UPDATE one_to_one_request
SET r_response  = '고객센터(1234-5678)로 문의 주시면 신속히 확인해 드리겠습니다.',
    admin_index = 1,
    r_status    = 'ANSWERED'
WHERE request_index = 2;

UPDATE one_to_one_request
SET r_response  = '비밀번호 재설정 링크를 이메일로 발송해 드렸습니다.',
    admin_index = 1,
    r_status    = 'ANSWERED'
WHERE request_index = 3;

-- 문의 게시판 샘플 데이터
INSERT INTO board_request (b_title, b_content, b_type, user_index)
VALUES ('입고 시 주의사항이 있나요?', '처음 입고를 하는데 주의해야 할 점이 있을까요?', '입고관련', 1),
       ('QR코드 스캔이 안돼요', 'QR코드 스캔 시 오류가 발생합니다.', '시스템', 2),
       ('배송 소요시간 문의', '일반적으로 배송은 얼마나 걸리나요?', '배송관련', 3);

-- 게시판 댓글 샘플 데이터
INSERT INTO board_comment (board_index, c_content, admin_index)
VALUES (1, '입고 시에는 상품 상태를 꼼꼼히 확인하시고, 수량을 정확히 체크해주세요.', 1);

INSERT INTO board_comment (board_index, c_content, user_index)
VALUES (1, '감사합니다! 도움이 되었어요.', 1);

select * from board_request;