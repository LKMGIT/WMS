package com.ssg.wms.user.domain;


import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserDTO {
    private Long userIndex;
    private String userName;
    private String userId;
    private String userEmail;
    private String userPhone;
    private java.time.LocalDateTime userCreatedAt;
    private java.time.LocalDateTime userUpdateAt;
    private String userStatus;
}
