package com.ssg.wms.user.service;

import com.ssg.wms.user.domain.UserDTO;
import com.ssg.wms.user.mappers.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements UserService {

    private final UserMapper usermapper;

    @Override
    @Transactional
    public int updateUser(String userId, UserDTO userDTO) {
        return usermapper.updateUserSelective(userId, userDTO);
    }

    @Override
    @Transactional
    public int deleteUser(String userId) {
        // 하드 삭제 (필요 시 소프트 삭제로 변경)
        return usermapper.deleteUserById(userId);
    }

}
