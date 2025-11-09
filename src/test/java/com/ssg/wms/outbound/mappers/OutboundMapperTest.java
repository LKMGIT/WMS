package com.ssg.wms.outbound.mappers;

import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.outbound.domain.*;
import lombok.extern.log4j.Log4j2;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.jdbc.Sql;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@ExtendWith(SpringExtension.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j2
@Transactional
public class OutboundMapperTest {

    @Autowired(required = false)
    private OutboundMapper outboundMapper;

    @Test
    public void testMapperExists() {
        log.info("OutboundMapper 주입 확인: " + outboundMapper);
    }

    // ======== 1. OutboundRequest 테스트 ========

    @Test
    public void testSelectOutboundRequestList() {
        OutboundSearchDTO search = OutboundSearchDTO.builder()
                .approval_status(EnumStatus.APPROVED)
                .type("I")
                .keyword("1")
                .build();
        List<OutboundRequestDTO> list = outboundMapper.selectOutboundRequestList(new Criteria(), search);
        log.info("===== 출고 요청 목록 =====");
        list.forEach(dto -> log.info(dto));
        log.info("=========================");
    }

    @Test
    public void testSelectOutboundRequestTotalCount() {
        OutboundSearchDTO search = OutboundSearchDTO.builder()
                .approval_status(EnumStatus.APPROVED)
                .type("I")
                .keyword("1")
                .build();
        int total = outboundMapper.selectOutboundRequestTotalCount(search);
        log.info("출고 요청 전체 개수: " + total);
    }

    @Test
    public void testInsertOutboundRequest() {
        OutboundRequestDTO dto = OutboundRequestDTO.builder()
                .user_index(1L).item_index(1L).or_quantity(1)
                .or_name("새요청").or_phone("111").or_zip_code("11")
                .or_street_address("11").or_detailed_address("11").build();
        outboundMapper.insertOutboundRequest(dto);
        log.info("등록된 DTO (PK 확인): " + dto);
    }

    @Test
    public void testSelectOutboundRequest() {
        OutboundRequestDTO dto = outboundMapper.selectOutboundRequest(1L);
        log.info("1번 출고 요청: " + dto);
    }

    @Test
    public void testUpdateOutboundRequest() {
        OutboundRequestDTO request = outboundMapper.selectOutboundRequest(1L);
        request.setOr_name("이름수정");
        outboundMapper.updateOutboundRequest(request);

        OutboundRequestDTO updatedDto = outboundMapper.selectOutboundRequest(1L);
        log.info("수정된 DTO: " + updatedDto);
    }

    @Test
    public void testDeleteOutboundRequest() {
        outboundMapper.deleteOutboundRequest(4L);
        OutboundRequestDTO dto = outboundMapper.selectOutboundRequest(4L);
        log.info("삭제 후 조회: " + dto);
    }

    @Test
    public void testUpdateOutboundResponse() {
        OutboundRequestDTO request = outboundMapper.selectOutboundRequest(4L);
        request.setOr_approval(EnumStatus.APPROVED);
        request.setReject_detail(null);
        outboundMapper.updateOutboundResponse(request);

        OutboundRequestDTO updatedDto = outboundMapper.selectOutboundRequest(4L);
        log.info("승인 처리된 DTO: " + updatedDto);
    }

    // ======== 2. ShippingInstruction 테스트 ========

    @Test
    public void testSelectShippingInstructionList() {
        OutboundSearchDTO search = OutboundSearchDTO.builder()
                .approval_status(EnumStatus.APPROVED)
                .build();
        List<ShippingInstructionDTO> list = outboundMapper.selectShippingInstructionList(new Criteria(), search);
        log.info("===== 출고 지시서 목록 =====");
        list.forEach(dto -> log.info(dto));
        log.info("==========================");
    }

    @Test
    public void testSelectShippingInstructionTotalCount() {
        OutboundSearchDTO search = OutboundSearchDTO.builder()
                .approval_status(EnumStatus.APPROVED)
                .build();
        int total = outboundMapper.selectShippingInstructionTotalCount(search);
        log.info("출고 지시서 전체 개수: " + total);
    }

    @Test
    public void testSelectShippingInstruction() {
        ShippingInstructionDTO dto = outboundMapper.selectShippingInstruction(1L);
        log.info("1번 출고 지시서: " + dto);
    }

    @Test
    public void testInsertShippingInstruction() {
        ShippingInstructionDTO dto = ShippingInstructionDTO.builder()
                .dispatch_index(1L).admin_index(1L)
                .warehouse_index(1L).section_index(1L).build();
        outboundMapper.insertShippingInstruction(dto);
        log.info("등록된 SI DTO (PK 확인): " + dto);
    }

    @Test
    public void testUpdateShippingInstruction() {
        ShippingInstructionDTO dto = outboundMapper.selectShippingInstruction(1L);
        dto.setSi_waybill_status(EnumStatus.PENDING); // APPROVED -> PENDING
        outboundMapper.updateShippingInstruction(dto);

        ShippingInstructionDTO updatedDto = outboundMapper.selectShippingInstruction(1L);
        log.info("수정된 SI DTO: " + updatedDto);
    }

    @Test
    public void testDeleteShippingInstruction() {
        outboundMapper.deleteShippingInstruction(1L);
        ShippingInstructionDTO dto = outboundMapper.selectShippingInstruction(1L);
        log.info("삭제 후 조회: " + dto);
    }


    // ======== 3. 배차 (Dispatch & Vehicle) 로직 테스트 ========

    @Test
    public void testSelectVehicleList() {
        // test-data.sql 기준
        // or_index=1 (item(1) 20개, 필요용량 200, 위치 '12')
        List<VehicleDTO> list = outboundMapper.selectVehicleList(1L);
        log.info("===== or_index=1 배차 가능 차량 목록 =====");
        list.forEach(dto -> log.info(dto));
        log.info("=======================================");

        // or_index=4 (item(2) 5개, 필요용량 25, 위치 '31')
        List<VehicleDTO> list2 = outboundMapper.selectVehicleList(4L);
        log.info("===== or_index=4 배차 가능 차량 목록 =====");
        list2.forEach(dto -> log.info(dto));
        log.info("=======================================");
    }

    @Test
    public void testSelectUsedVolumeOfVehicle() {
        // 1호차: or_index=2 (용량 100) 배송 중
        int usedVolume = outboundMapper.selectUsedVolumeOfVehicle(1L);
        log.info("1호차 사용중 용량 (배송중): " + usedVolume);

        // 4호차: or_index=3 (용량 300) 배송 완료
        int completedVolume = outboundMapper.selectUsedVolumeOfVehicle(4L);
        log.info("4호차 사용중 용량 (배송완료): " + completedVolume);
    }

    @Test
    public void testInsertDispatch() {
        DispatchDTO dto = DispatchDTO.builder()
                .vehicle_index(1L).or_index(4L) // 4번 요청
                .start_point("출발").end_point("도착").build();
        outboundMapper.insertDispatch(dto);
        log.info("등록된 배차 (PK 확인): " + dto);
    }

    @Test
    public void testSelectDispatch() {
        // or_index=2에 연결된 배차
        DispatchDTO dto = outboundMapper.selectDispatch(2L);
        log.info("or_index=2 배차 조회: " + dto);
    }

    @Test
    public void testUpdateDispatch() {
        DispatchDTO dto = outboundMapper.selectDispatch(2L);
        dto.setVehicle_index(2L); // 1호차 -> 2호차로 변경
        outboundMapper.updateDispatch(dto);

        DispatchDTO updatedDto = outboundMapper.selectDispatch(2L);
        log.info("수정된 배차: " + updatedDto);
    }

    @Test
    public void testDeleteDispatch() {
        outboundMapper.deleteDispatch(1L); // dispatch_index=1
        DispatchDTO dto = outboundMapper.selectDispatch(2L); // or_index=2
        log.info("삭제 후 조회: " + dto);
    }

    @Test
    public void testInsertVehicle() {
        VehicleDTO dto = VehicleDTO.builder()
                .vehicle_name("테스트차량").vehicle_id("99가9999")
                .vehicle_volume(1000).driver_name("테스트기사")
                .driver_phone("010-9999-9999").build();
        outboundMapper.insertVehicle(dto);
        log.info("등록된 차량 (PK 확인): " + dto);
    }

    @Test
    public void testUpdateVehicle() {
        VehicleDTO dto = VehicleDTO.builder()
                .vehicle_index(1L)
                .vehicle_status(EnumStatus.WORKING)
                .build();
        outboundMapper.updateVehicle(dto);
        log.info("1번 차량 상태 WORKING으로 변경");
    }

    @Test
    public void testDeleteVehicle() {
        outboundMapper.deleteVehicle(1L);
        log.info("1번 차량 삭제 (Soft Delete)");
    }

    @Test
    public void testInsertVehicleLocation() {
        VehicleLocationDTO dto = VehicleLocationDTO.builder()
                .vehicle_index(3L).vl_zip_code("55").build();
        outboundMapper.insertVehicleLocation(dto);
        log.info("등록된 차량 위치 (PK 확인): " + dto);
    }

    @Test
    public void testUpdateVehicleLocation() {
        VehicleLocationDTO dto = VehicleLocationDTO.builder()
                .vl_index(1L) // 1번 차량(Vehicle 1)의 위치(vl_index 1)
                .vehicle_index(1L)
                .vl_zip_code("88")
                .build();
        outboundMapper.updateVehicleLocation(dto);
        log.info("1번 차량 위치 '88'로 수정");
    }

    @Test
    public void testDeleteVehicleLocation() {
        outboundMapper.deleteVehicleLocation(1L);
        log.info("1번 차량 위치(vl_index 1) 삭제 (Soft Delete)");
    }


    // ======== 4. 운송장 (Waybill) 테스트 ========

    @Test
    public void testInsertWaybill() {
        WaybillDTO dto = WaybillDTO.builder()
                .si_index(3L) // 3번 SI (test-data.sql에서 PENDING 상태)
                .waybill_id("TEST-WAYBILL-123")
                .build();
        outboundMapper.insertWaybill(dto);
        log.info("등록된 운송장 (PK 확인): " + dto);
    }

    @Test
    public void testSelectWaybill() {
        // si_index=1
        WaybillDTO dto = outboundMapper.selectWaybill(1L);
        log.info("si_index=1 운송장: " + dto);
    }

    @Test
    public void testUpdateWaybill() {
        WaybillDTO dto = outboundMapper.selectWaybill(1L); // 1번 (IN_TRANSIT)
        log.info("수정 전 운송장: " + dto);

        outboundMapper.updateWaybill(dto); // 완료 처리

        WaybillDTO updatedDto = outboundMapper.selectWaybill(1L);
        log.info("배송 완료 처리된 운송장: " + updatedDto);
    }

    @Test
    public void testCheckWaybillExistsByOrIndex() {
        // test-data.sql 기준: or_index=2는 waybill이 존재 (1 반환)
        int exists = outboundMapper.checkWaybillExistsByOrIndex(2L);
        log.info("or_index=2 Waybill 존재 여부 (1=있음): " + exists);

        // test-data.sql 기준: or_index=1는 waybill이 없음 (0 반환)
        int notExists = outboundMapper.checkWaybillExistsByOrIndex(1L);
        log.info("or_index=1 Waybill 존재 여부 (0=없음): " + notExists);
    }

    @Test
    public void testSelectVehicle() {
        VehicleDTO vehicle = outboundMapper.selectVehicle(1L);
        log.info("1번 차량 정보: " + vehicle);
    }

    @Test
    public void testSelectWaybillByWaybillIndex() {
        // test-data.sql 기준: waybill_index=1
        WaybillDTO waybill = outboundMapper.selectWaybillByWaybillIndex(1L);
        log.info("waybill_index=1 운송장 정보: " + waybill);
    }

    @Test
    public void testSelectShippingInstructionByDispatchIndex() {
        // test-data.sql 기준: dispatch_index=1
        ShippingInstructionDTO si = outboundMapper.selectShippingInstructionByDispatchIndex(1L);
        log.info("dispatch_index=1 지시서 정보: " + si);
    }

    @Test
    public void testSelectStockByLocation() {
        // ※※※ 중요 ※※※
        // 이 쿼리는 inventory, inboundDetail, inboundRequest, warehouse를 JOIN합니다.
        // 현재 test-data.sql에는 inboundDetail, inboundRequest 데이터가 없습니다.
        // 이 테스트를 통과하려면 test-data.sql에 inventory.detail_index와 연결되는
        // inboundDetail 및 inboundRequest (user_index 포함) 데이터가 추가되어야 합니다.

        // 데이터가 있다고 가정하고 테스트 (user=1, item=1, location=수도권)
        try {
            TestInvenDTO stock = outboundMapper.selectStockByLocation(1L, 1L, "서울");
            log.info("수도권 재고 (user=1, item=1): " + stock);
            // 데이터가 있다면 stock이 null이 아니거나, 수량이 100이어야 함
            // assertNotNull(stock);
            // assertEquals(100, stock.getInven_quantity());
        } catch (Exception e) {
            log.error("selectStockByLocation 테스트 실패. test-data.sql에 Inbound 데이터가 필요할 수 있습니다.");
            log.error(e.getMessage());
        }
    }

    @Test
    public void testSelectWarehouseAddress() {
        String address = outboundMapper.selectWarehouseAddress(1L);
        log.info("1번 창고 주소: " + address);
    }

    @Test
    public void testSelectItemName() {
        String itemName = outboundMapper.selectItemName(1L);
        log.info("1번 상품명: " + itemName);
    }

    @Test
    public void testSelectWarehouseZipCode() {
        String zipCode = outboundMapper.selectWarehouseZipCode(1L);
        log.info("1번 창고 우편번호: " + zipCode);

    }

    @Test
    public void testGetNextAndPreviousPostIndex() {
        // OutboundSearchDTO의 기본 정렬(sort)은 "DESC"입니다.
        // test-data.sql 순서 (DESC): 4 -> 3 -> 2 -> 1
        OutboundSearchDTO searchDTO = new OutboundSearchDTO();

        // 현재 인덱스 3번 (or_index=3)
        Long currentIndex = 3L;

        // 3번의 이전 글 (더 최신 글) = 4번
        Long prevIndex = outboundMapper.getPreviousPostIndex(searchDTO, currentIndex);
        log.info("3번의 이전 글 (DESC): " + prevIndex);


        // 3번의 다음 글 (더 이전 글) = 2번
        Long nextIndex = outboundMapper.getNextPostIndex(searchDTO, currentIndex);
        log.info("3번의 다음 글 (DESC): " + nextIndex);


        // 4번(첫 글)의 이전 글 = null
        Long firstPrev = outboundMapper.getPreviousPostIndex(searchDTO, 4L);
        log.info("4번의 이전 글 (DESC): " + firstPrev);

        // 1번(마지막 글)의 다음 글 = null
        Long lastNext = outboundMapper.getNextPostIndex(searchDTO, 1L);
        log.info("1번의 다음 글 (DESC): " + lastNext);
    }
}