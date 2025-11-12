package com.ssg.wms.user.mappers;

import com.ssg.wms.user.domain.UserDTO;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserMapper {
    int updateUserSelective(@Param("userId") String userId,
                            @Param("req") UserDTO userDTO);

    int deleteUserById(@Param("userId") String userId);
}
