package com.ssg.wms.user.service;

import com.ssg.wms.user.domain.UserDTO;

public interface UserService {

    int updateUser(String userId, UserDTO userDTO);
    int deleteUser(String userId);
}
