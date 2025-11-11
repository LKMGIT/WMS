package com.ssg.wms.user.controller;


import com.ssg.wms.admin.domain.AdminDTO;
import com.ssg.wms.user.domain.UserDTO;
import com.ssg.wms.user.service.UserService;
import lombok.Data;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/users")
@RequiredArgsConstructor
@Log4j2
public class UserController {

    private final UserService userService;

    // PATCH /admin/api/users/{userId}
    @PatchMapping("/{userId}")
    public ResponseEntity<Void> updateUser(
            @PathVariable("userId") String userId,
            @Validated @RequestBody UserDTO userDTO) {

        int updated = userService.updateUser(userId, userDTO);
        if (updated == 0) return ResponseEntity.notFound().build();

        log.error("[400] Validation error");
        return ResponseEntity.noContent().build(); // 204

    }

    // DELETE /admin/api/users/{userId}
    @DeleteMapping("/{userId}")
    public ResponseEntity<Void> deleteUser(@PathVariable("userId") String userId) {
        int deleted = userService.deleteUser(userId);
        if (deleted == 0) return ResponseEntity.notFound().build();
        return ResponseEntity.noContent().build();
    }
}
