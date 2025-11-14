package com.ssg.wms.warehouse.controller;

import com.ssg.wms.warehouse.domain.WarehouseSaveDTO;
import com.ssg.wms.warehouse.domain.WarehouseUpdateDTO;
import com.ssg.wms.warehouse.service.WarehouseService;
import lombok.RequiredArgsConstructor;
import lombok.extern.log4j.Log4j2;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;

@RestController
@RequiredArgsConstructor
@Log4j2
@RequestMapping("/api/warehouse")
public class WarehouseRestController {
    private final WarehouseService warehouseService;

    // admin 체크
    private boolean isAdmin(String role) {
        return "ADMIN".equals(role);
    }

    // 창고 등록
    @PostMapping(produces = "text/plain; charset=UTF-8")
    public ResponseEntity<String> registerWarehouse(@SessionAttribute(value = "loginAdminRole", required = false) String role,
                                                    @RequestBody WarehouseSaveDTO warehouseSaveDTO) {
        log.info("warehouseSaveDTO : " + warehouseSaveDTO);

        if (!isAdmin(role)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body("권한이 없습니다. (총관리자만 창고 등록 가능)");
        }

        try {
            boolean result = warehouseService.registerWarehouse(warehouseSaveDTO);
            return result
                    ? ResponseEntity.ok("창고 등록 완료")
                    : ResponseEntity.status(HttpStatus.BAD_REQUEST).body("창고 등록 실패");
        } catch (IllegalArgumentException e) {
            // 중복 검사
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(e.getMessage());
        } catch (Exception e) {
            // 서버 내부 예외
            log.error("창고 등록 중 오류 발생", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("서버 오류 발생");
        }
    }


    // 창고 수정
    @PutMapping(value = "/{id}", produces = "text/plain; charset=UTF-8")
    public ResponseEntity<String> updateWarehouse(@PathVariable Long id,
                                                  @RequestBody WarehouseUpdateDTO warehouseUpdateDTO,
                                                  @SessionAttribute(value = "loginAdminRole", required = false) String role) {

        if (!isAdmin(role)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body("권한이 없습니다.");
        }

        warehouseUpdateDTO.setWIndex(id);
        String address = warehouseUpdateDTO.getWAddress();
        String location = address.substring(0, address.indexOf(" "));
        warehouseUpdateDTO.setWLocation(location);
        boolean result = warehouseService.modifyWarehouse(warehouseUpdateDTO);
        return result ? ResponseEntity.ok("창고 수정 완료")
                : ResponseEntity.status(HttpStatus.BAD_REQUEST).body("창고 수정 실패");
    }

    // 창고 삭제(논리적 폐쇄)
    @DeleteMapping(value = "/{id}", produces = "text/plain; charset=UTF-8")
    public ResponseEntity<String> deleteWarehouse(@PathVariable Long id,
                                                  @SessionAttribute(value = "loginAdminRole", required = false) String role) {
        if (!isAdmin(role)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN)
                    .body("권한이 없습니다.");
        }

        boolean result = warehouseService.removeWarehouse(id);
        return result ? ResponseEntity.ok("창고 폐쇄 완료")
                      : ResponseEntity.status(HttpStatus.BAD_REQUEST).body("창고 폐쇄 실패");
    }
}
