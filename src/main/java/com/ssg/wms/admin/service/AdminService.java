package com.ssg.wms.admin.service;

import com.ssg.wms.admin.domain.AdminDTO;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.login.LoginResult;
import com.ssg.wms.user.domain.UserDTO;
 import com.ssg.wms.global.Enum.EnumStatus;

import java.util.List;
import java.util.Optional;

public interface AdminService {

    /* -------------------- Admin (관리자) -------------------- */

    java.util.List<UserDTO> getList(Criteria criteria);

    int getTotal(Criteria criteria);

    java.util.List<UserDTO> getList();

    List<AdminDTO> getAdminList(Criteria criteria);
    int getAdminTotal(Criteria criteria);

    /**
     * 관리자 등록 (비밀번호 인코딩 포함 권장)
     * @param adminDTO adminId, adminName, raw adminPw 등 채워서 전달
     * @return 생성된 관리자 PK (auto_increment) 또는 null
     */
    Long register(AdminDTO adminDTO);

    /**
     * 관리자 단건 조회 (ID 기준)
     */
    Optional<AdminDTO> getByAdminId(String adminId);

    /**
     * 관리자 정보 수정 (이름/역할/전화/상태 등)
     * 비밀번호 변경은 changePassword 사용 권장
     */
    boolean update(AdminDTO adminDTO);

    /**
     * 관리자 삭제 (ID 기준)
     */
    boolean deleteByAdminId(String adminId);

    /**
     * 총관리자(마스터)에 의한 관리자 상태 변경
     * 문자열 버전 (DB가 한글 ENUM일 때 간단히 사용 가능: 'APPROVED','PENDING','REJECTED')
     */
    boolean updateAdminStatus(String adminId, EnumStatus status);

    /**
     * 관리자 ID 찾기 (이름+전화번호)
     */
    String findAdminId(String name, String adminPhone);

    /**
     * 로그인 검증 (raw 비밀번호를 받아 해시 매칭)
     */
    LoginResult authenticate(String adminId, String rawPassword);

    /**
     * 관리자 비밀번호 변경 (raw → encode 후 저장)
     */
    boolean changePassword(String adminId, String rawNewPassword);

    /**
     * 관리자 역할 변경 (문자열 버전: '마스터' / '관리자')
     */
    boolean updateAdminRole(String adminId, EnumStatus status);


    /* -------------------- User (회원) - 관리자 기능 -------------------- */

    /**
     * 회원 상태 변경 (관리자 APPROVED/PENDING/REJECTED)
     */
    boolean updateUserStatus(String userId, EnumStatus status);

    /**
     * 상태별 회원 목록 조회
     */
    List<UserDTO> findUsersByStatus(EnumStatus status);

}
