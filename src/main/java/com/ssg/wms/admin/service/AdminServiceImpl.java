package com.ssg.wms.admin.service;

import com.ssg.wms.admin.domain.AdminDTO;
import com.ssg.wms.admin.mappers.AdminMapper;
import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.user.domain.UserDTO;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.EnumSet;
import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
@Log4j2
@Transactional(readOnly = true)
public class AdminServiceImpl implements AdminService {

    private final AdminMapper adminMapper;
    private final PasswordEncoder passwordEncoder;

    // ----- 허용값 세트 (통합 EnumStatus를 쓰므로 도메인별로 허용값을 제한해서 타입 안전성 보완) -----
    private static final EnumSet<EnumStatus> STATUS_APPROVAL_SET =
            EnumSet.of(EnumStatus.APPROVED, EnumStatus.PENDING, EnumStatus.REJECTED);

    private static final EnumSet<EnumStatus> ROLE_SET =
            EnumSet.of(EnumStatus.ADMIN , EnumStatus.MASTER );

    @Override
    public List<UserDTO> getList(Criteria criteria) {
        return adminMapper.getPage(criteria);
    }

    @Override
    public List<UserDTO> getList() {
        return adminMapper.getList();
    }

    public int getTotal(Criteria criteria){

        return adminMapper.getTotal(criteria);
    }

    @Override
    @Transactional
    public Long register(AdminDTO adminDTO) {
        // 비밀번호 인코딩
        if (adminDTO.getAdminPw() == null || adminDTO.getAdminPw().isBlank()) {
            throw new IllegalArgumentException("raw password required");
        }
        String encoded = passwordEncoder.encode(adminDTO.getAdminPw());
        adminDTO.setAdminPw(encoded);

        // 기본 상태/역할 보정 (없으면 DB default로 맡겨도 되지만, 서비스단에서 명시 권장)
        if (adminDTO.getAdminStatus() == null) {
            adminDTO.setAdminStatus(String.valueOf(EnumStatus.PENDING)); // 'PENDING'
        } else {
            requireAllowed("adminStatus", EnumStatus.valueOf(adminDTO.getAdminStatus()), STATUS_APPROVAL_SET);
        }
        if (adminDTO.getAdminRole() != null) {
            requireAllowed("adminRole", EnumStatus.valueOf(adminDTO.getAdminRole()), ROLE_SET);
        }

        // Mapper: int insertAdmin(AdminDTO dto) + useGeneratedKeys 로 PK 세팅 가정
        int rows = adminMapper.insertAdmin(adminDTO);
        if (rows != 1) throw new IllegalStateException("Failed to insert admin");

        // insert 시 useGeneratedKeys 로 adminIndex 가 DTO에 세팅된다고 가정
        return adminDTO.getAdminIndex();
    }

    @Override
    public Optional<AdminDTO> getByAdminId(String adminId) {
        // Mapper: AdminDTO findAdminById(String adminId)
        return Optional.ofNullable(adminMapper.findAdminById(adminId));
    }

    @Override
    @Transactional
    public boolean update(AdminDTO adminDTO) {
        // 역할/상태 값 검증
        if (adminDTO.getAdminRole() != null) {
            requireAllowed("adminRole", EnumStatus.valueOf(adminDTO.getAdminRole()), ROLE_SET);
        }
        if (adminDTO.getAdminStatus() != null) {
            requireAllowed("adminStatus", EnumStatus.valueOf(adminDTO.getAdminStatus()), STATUS_APPROVAL_SET);
        }
        // 비밀번호가 raw 로 들어온 경우 인코딩해서 저장
        if (adminDTO.getAdminPw() != null && !adminDTO.getAdminPw().isBlank()) {
            adminDTO.setAdminPw(passwordEncoder.encode(adminDTO.getAdminPw()));
        }

        // Mapper: int updateAdmin(AdminDTO dto) (admin_updateAt = CURRENT_TIMESTAMP)
        return adminMapper.updateAdmin(adminDTO) == 1;
    }

    @Override
    @Transactional
    public boolean deleteByAdminId(String adminId) {
        // Mapper: int deleteAdmin(String adminId)
        return adminMapper.deleteAdmin(adminId) == 1;
    }

    @Override
    @Transactional
    public boolean updateAdminStatus(String adminId, EnumStatus status) {
        requireAllowed("adminStatus", status, STATUS_APPROVAL_SET);

        AdminDTO dto = new AdminDTO();
        dto.setAdminId(adminId);
        dto.setAdminStatus(String.valueOf(status));

        // Mapper: int updateAdminStatus(AdminDTO dto)
        return adminMapper.updateAdminStatus(dto) == 1;
    }

    @Override
    public Optional<String> findAdminId(String name, String adminPhone) {
        // Mapper: String findAdminId(@Param("name"), @Param("adminPhone"))
        return Optional.ofNullable(adminMapper.findAdminId(name, adminPhone));
    }

    @Override
    public boolean authenticate(String adminId, String rawPassword) {
        // Mapper: String getPasswordHashByAdminId(String adminId)
        String encoded = adminMapper.getPasswordHashByAdminId(adminId);
        if (encoded == null) return false;
        return passwordEncoder.matches(rawPassword, encoded);
    }

    @Override
    @Transactional
    public boolean changePassword(String adminId, String rawNewPassword) {
        String encoded = passwordEncoder.encode(rawNewPassword);

        // Mapper에 전용 메서드가 없으면 updateAdmin 재사용
        AdminDTO dto = new AdminDTO();
        dto.setAdminId(adminId);
        dto.setAdminPw(encoded);

        return adminMapper.updateAdmin(dto) == 1;
    }

    @Override
    @Transactional
    public boolean updateAdminRole(String adminId, EnumStatus status) {
        requireAllowed("adminRole", status, ROLE_SET);

        AdminDTO dto = new AdminDTO();
        dto.setAdminId(adminId);
        dto.setAdminRole(String.valueOf(status));

        // Mapper: int updateAdmin(AdminDTO dto) or 별도 updateAdminRole(adminId, role)
        return adminMapper.updateAdmin(dto) == 1;
    }

    /* ========================== Users (by Admin) ========================== */

    @Override
    @Transactional
    public boolean updateUserStatus(String userId, EnumStatus status) {
        requireAllowed("userStatus", status, STATUS_APPROVAL_SET);

        // Mapper: int updateUserStatus(UserDTO dto) 또는 (userId, status)
        UserDTO dto = new UserDTO();
        dto.setUserId(userId);
        dto.setUserStatus(String.valueOf(status));

        return adminMapper.updateUserStatus(dto) == 1;
    }

    @Override
    public List<UserDTO> findUsersByStatus(EnumStatus status) {
        requireAllowed("userStatus", status, STATUS_APPROVAL_SET);
        // Mapper: List<UserDTO> findUserByStatus(String status)
        return adminMapper.findUserByStatus(status.getDBValue());
    }

    /* ========================== helpers ========================== */

    private static void requireAllowed(String field, EnumStatus value, EnumSet<EnumStatus> allowed) {
        if (value == null || !allowed.contains(value)) {
            throw new IllegalArgumentException(
                    "Invalid " + field + ": " + value + " / allowed=" + allowed);
        }
    }
}
