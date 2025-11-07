package com.ssg.wms.admin.mappers;

import com.ssg.wms.admin.domain.AdminDTO;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.user.domain.UserDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface AdminMapper {

    /* ---------- Admin ---------- */


    java.util.List<UserDTO> getList();

    java.util.List<UserDTO> getPage(Criteria criteria);

    int getTotal(Criteria criteria);

    /** 관리자 정보 DB 저장 (useGeneratedKeys 로 adminIndex 세팅 가정) */
    int insertAdmin(AdminDTO adminDTO);

    /** 관리자 정보 ID로 찾기 */
    AdminDTO findAdminById(@Param("adminId") String adminId);

    /** 관리자 DB 정보 업데이트 (null 필드는 미변경: XML에서 <if>로 처리) */
    int updateAdmin(AdminDTO adminDTO);

    /** 관리자 DB 정보 삭제 */
    int deleteAdmin(@Param("adminId") String adminId);

    /** 총관리자의 관리자 APPROVED/상태 변경 */
    int updateAdminStatus(AdminDTO adminDTO);

    /** 이름+전화번호로 관리자 ID 찾기 */
    String findAdminId(@Param("name") String name,
                       @Param("adminPhone") String adminPhone);

    /** 관리자 ID의 비밀번호 해시 값 조회 */
    String getPasswordHashByAdminId(@Param("adminId") String adminId);


    /* ---------- Users (by Admin) ---------- */

    /** 관리자에 의한 회원 상태 변경 */
    int updateUserStatus(UserDTO userDTO);
    // 필요하면 파라미터 분리형 버전도 추가 가능:
    // int updateUserStatus2(@Param("userId") String userId, @Param("status") String status);

    /** 상태별 회원 조회 */
    List<UserDTO> findUserByStatus(@Param("status") String status);

    /** 전체 회원 조회 */
    List<UserDTO> findAllUsers();
}
