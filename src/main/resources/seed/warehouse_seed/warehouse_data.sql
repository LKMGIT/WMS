-- 웹에서 창고 등록 시, 섹션 생성 로직이 서비스단에서 자동으로 생성된 후 DTO를 통해 DB에 입력되기 때문에 목데이터는 일일이 입력했습니다.
use wms;

insert into warehouse(warehouse_code, warehouse_name, warehouse_size, warehouse_createdAt, warehouse_updatedAt,
                      warehouse_location, warehouse_address, warehouse_zipcode, warehouse_status)
values (1,'강남창고', 1000, NOW(), NOW(),
        '서울특별시', '서울 강남구 삼성로 534', '06166', 'NORMAL'),
       (2, '구로창고', 2000, NOW(), NOW(),
        '서울특별시', '서울 구로구 디지털로26길 72', '08393', 'NORMAL'),
       (3, '수원창고', 3000, NOW(), NOW(),
        '경기도', '경기 수원시 영통구 광교중앙로 145', '16509', 'NORMAL'),
       (4, '천안창고', 1800, NOW(), NOW(),
        '충남', '충남 천안시 동남구 목천읍 천안대로 2-10', '31226', 'NORMAL');

insert into section
(section_code, section_name, section_capacity, warehouse_index)
values
-- 강남창고 (WIndex = 1, WCode = 1)
(101, 'S-1', 333, 1),
(102, 'S-2', 333, 1),
(103, 'S-3', 334, 1),

-- 구로창고 (WIndex = 2, WCode = 2)
(201, 'S-1', 500, 2),
(202, 'S-2', 500, 2),
(203, 'S-3', 500, 2),
(204, 'S-4', 500, 2),

-- 수원창고 (WIndex = 3, WCode = 3)
(301, 'S-1', 600, 3),
(302, 'S-2', 600, 3),
(303, 'S-3', 600, 3),
(304, 'S-4', 600, 3),
(305, 'S-5', 600, 3),

-- 천안창고 (WIndex = 4, WCode = 4)
(401, 'S-1', 450, 4),
(402, 'S-2', 450, 4),
(403, 'S-3', 450, 4),
(404, 'S-4', 450, 4);
