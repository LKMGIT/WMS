# 바름생각 WMS (Warehouse Management System)

🧴 **바름생각** - 화장품 창고 관리 시스템

입출고, 재고 관리, 견적, 배차 등을 통합 관리하는 웹 애플리케이션

## 📋 프로젝트 개요

WMS는 물류 창고의 전반적인 운영을 지원하는 시스템입니다.

### 🎯 프로젝트 목적

본 프로젝트는 **바름생각 화장품 물류 창고 관리 효율화**를 목표로 개발되었습니다.

- **물류 프로세스 디지털화**: 수기 또는 분산된 시스템으로 관리되던 화장품 입출고/재고 관리를 하나의 웹 시스템으로 통합
- **실시간 재고 파악**: 창고별, 구역별 재고 현황을 실시간으로 모니터링하여 재고 부족/과잉 방지
- **업무 효율성 증대**: 입고 요청부터 출고 배송까지의 전 과정을 체계적으로 관리
- **의사결정 지원**: 대시보드를 통한 물류 현황 시각화 및 데이터 기반 운영 지원
- **고객 서비스 향상**: 견적/문의 시스템을 통한 원활한 고객 커뮤니케이션

### 📦 주요 기능
- **입고 관리**: 입고 요청, 승인, 실물 입고 처리
- **출고 관리**: 출고 요청, 승인, 배차, 운송장 발행
- **재고 관리**: 실시간 재고 현황, 재고 실사
- **창고/구역 관리**: 다중 창고, 구역별 관리
- **견적 관리**: 견적 요청/답변, 견적 코멘트
- **사용자/관리자 관리**: 권한별 기능 분리
- **공지사항/문의 게시판**: 1:1 문의, 게시판

---

## 🛠️ 기술 스택

| 구분 | 기술 |
|------|------|
| **Language** | Java 8 |
| **Framework** | Spring MVC 5.3.27 |
| **ORM** | MyBatis 3.5.7 |
| **Database** | MySQL 8.0 |
| **Connection Pool** | HikariCP 5.0.0 |
| **Build Tool** | Gradle |
| **View** | JSP, JSTL |
| **Security** | Spring Security Crypto |
| **Logging** | Log4j2 |
| **Utility** | Lombok, ModelMapper, Jackson |

---

## 📁 프로젝트 구조

```
WMS/
├── src/main/
│   ├── java/com/ssg/wms/
│   │   ├── admin/          # 관리자 관리
│   │   ├── announcement/   # 공지사항, 1:1 문의, 게시판
│   │   ├── config/         # Spring 설정
│   │   ├── dashboard/      # 대시보드
│   │   ├── global/         # 공통 컴포넌트
│   │   ├── inbound/        # 입고 관리
│   │   ├── inventory/      # 재고 관리
│   │   ├── login/          # 로그인/인증
│   │   ├── outbound/       # 출고/배차/운송장
│   │   ├── quotation/      # 견적 관리
│   │   ├── user/           # 사용자 관리
│   │   └── warehouse/      # 창고/구역 관리
│   │
│   ├── resources/
│   │   ├── mappers/        # MyBatis XML Mapper
│   │   ├── sql/            # DDL 스크립트
│   │   ├── seed/           # 초기 데이터
│   │   ├── static/         # 정적 리소스 (CSS, JS, 이미지)
│   │   ├── mybatis-config.xml
│   │   └── log4j2.xml
│   │
│   └── webapp/
│       ├── WEB-INF/
│       │   ├── spring/     # Spring 설정 파일
│       │   ├── views/      # JSP 뷰 템플릿
│       │   └── web.xml
│       └── index.jsp
│
├── build.gradle
└── settings.gradle
```

---

## 🗄️ 데이터베이스 스키마

### 핵심 테이블

| 테이블 | 설명 |
|--------|------|
| `admin` | 관리자 정보 (MASTER/ADMIN 권한) |
| `users` | 사용자 정보 |
| `warehouse` | 창고 정보 |
| `section` | 창고 내 구역 정보 |
| `items` | 상품 정보 |
| `inventory` | 재고 현황 |
| `inven_count` | 재고 실사 기록 |
| `inbound_request` | 입고 요청 |
| `inbound_detail` | 입고 상세 |
| `OutboundRequest` | 출고 요청 |
| `Dispatch` | 배차 정보 |
| `Vehicle` | 차량 정보 |
| `ShippingInstruction` | 출하 지시 |
| `Waybill` | 운송장 |
| `QuotationRequest` | 견적 요청 |
| `QuotationResponse` | 견적 답변 |
| `announcement` | 공지사항 |
| `one_to_one_request` | 1:1 문의 |
| `board_request` | 게시판 |

---

## 🚀 시작하기

### 1. 데이터베이스 설정

```sql
-- MySQL에서 실행
source src/main/resources/sql/v1_create_all_table.sql
```

### 2. 데이터베이스 연결 설정

`src/main/webapp/WEB-INF/spring/` 디렉토리에서 데이터베이스 연결 정보를 설정합니다.

### 3. 빌드 및 실행

```bash
# 빌드
./gradlew build

# WAR 파일 생성
./gradlew war
```

### 4. 서버 배포

생성된 WAR 파일을 Tomcat 등의 WAS에 배포합니다.

---

## 👥 사용자 권한

### 관리자 (Admin)
- **MASTER**: 전체 시스템 관리
- **ADMIN**: 일반 관리자

### 사용자 (User)
- 입고/출고 요청
- 재고 조회
- 견적 요청
- 문의 등록

---

## 📄 라이선스

This project is for educational purposes.

---

## 🤝 기여

바름생각 WMS Team