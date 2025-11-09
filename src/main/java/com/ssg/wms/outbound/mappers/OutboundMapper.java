package com.ssg.wms.outbound.mappers;

import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.outbound.domain.*;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OutboundMapper {
    int	insertOutboundRequest ( OutboundRequestDTO outboundRequestDTO );
    int updateOutboundRequest ( OutboundRequestDTO outboundRequestDTO );
    int	deleteOutboundRequest ( Long or_index );
    OutboundRequestDTO selectOutboundRequest ( Long or_index );
    int updateOutboundResponse ( OutboundRequestDTO outboundRequestDTO );
    List<OutboundRequestDTO>	selectOutbountRequestList ( @Param("cri") Criteria criteria, @Param("search") OutboundSearchDTO outboundSearchDTO );
    int selectOutboundRequestTotalCount( @Param("search") OutboundSearchDTO outboundSearchDTO );


    List<ShippingInstructionDTO> selectShippingInstructionList (@Param("cri") Criteria criteria, @Param("search") OutboundSearchDTO outboundSearchDTO );
    int selectShippingInstructionTotalCount( @Param("search") OutboundSearchDTO outboundSearchDTO );
    ShippingInstructionDTO selectShippingInstruction ( Long si_index );
    int insertShippingInstruction ( ShippingInstructionDTO shippingInstructionDTO );
    int updateShippingInstruction ( ShippingInstructionDTO shippingInstructionDTO );
    int deleteShippingInstruction ( Long si_index );


    //List<VehicleDTO> selectVehicleList (OutboundRequestDTO outboundRequestDTO );
    List<VehicleDTO> selectVehicleList(Long or_index);
    int selectUsedVolumeOfVehicle(Long vehicle_index);


    int insertDispatch ( DispatchDTO dispatchDTO );
    DispatchDTO	selectDispatch ( Long or_index );
    int updateDispatch ( DispatchDTO dispatchDTO );
    int deleteDispatch ( Long dispatch_index );


    int	insertWaybill ( WaybillDTO waybillDTO );
    int	updateWaybill ( WaybillDTO waybillDTO );
    WaybillDTO selectWaybill ( Long si_index );


    int insertVehicle ( VehicleDTO vehicleDTO );
    int updateVehicle ( VehicleDTO vehicleDTO );
    int deleteVehicle( Long vehicle_index );


    int insertVehicleLocation ( VehicleLocationDTO vehicleLocationDTO );
    int updateVehicleLocation ( VehicleLocationDTO vehicleLocationDTO );
    int deleteVehicleLocation( Long vl_index );


    int checkWaybillExistsByOrIndex( Long or_index );
    VehicleDTO selectVehicle(Long vehicle_index);
    WaybillDTO selectWaybillByWaybillIndex(Long waybill_index);
    ShippingInstructionDTO selectShippingInstructionByDispatchIndex(Long dispatch_index);
    /*
    * 타 기능에서 필요한 mapper 들
    *
    * Inventory Mapper
    *
    * int selectTotalStockByUserAndItem(@Param("user_index") Long user_index, @Param("item_index") Long item_index);
    *
    * */


    /**
     * [출고지시서 생성용] 특정 창고 위치(예: "충남")에서 해당 아이템의 재고 위치(창고, 섹션)를 조회
     *
     * @param user_index 사용자 ID
     * @param item_index 아이템 ID
     * @param location_name 창고 위치명 (예: "서울", "충남")
     * @return 재고 위치 정보 (warehouse_index, section_id 포함)
     */
    TestInvenDTO selectStockByLocation(
            @Param("user_index") Long user_index,
            @Param("item_index") Long item_index,
            @Param("location_name") String location_name
    );

    String selectWarehouseAddress( Long warehouse_index );

    String selectItemName ( Long item_index );

    String selectWarehouseZipCode( Long warehouse_index );

    /**
     * 현재 검색 조건에서 '이전 글' (더 최신 글)의 or_index를 조회
     */
    Long getPreviousPostIndex(
            @Param("search") OutboundSearchDTO searchDTO,
            @Param("current_index") Long current_index
    );

    /**
     * 현재 검색 조건에서 '다음 글' (더 오래된 글)의 or_index를 조회
     */
    Long getNextPostIndex(
            @Param("search") OutboundSearchDTO searchDTO,
            @Param("current_index") Long current_index
    );

}
