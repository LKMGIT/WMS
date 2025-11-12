package com.ssg.wms.global.domain;

import com.ssg.wms.global.Enum.EnumStatus;
import lombok.Data;

@Data
public class Criteria {

  private int pageNum = 1;
  private int amount = 20;

  //null, T, C, W, TC, TW, TCW
  private String[] types;
  private String keyword;

  // ★ 검색용 추가
  private String userId;          // 부분일치
  private EnumStatus status;
  private Integer company_code;
  private EnumStatus role;

  private String category;      // 아이템 카테고리
  private Long warehouseIndex;  // 창고 필터
  private Long sectionIndex;       // 구역 필터
  private String itemName;      // 품명 부분검색

  private Long invenIndex;     // 특정 재고(inventory)만 보고 싶을 때
  private String fromDate;     // "YYYY-MM-DD"
  private String toDate;       // "YYYY-MM-DD"

  private String typeStr;

  public void setTypes(String[] types){
    this.types = types;

    if(types != null && types.length > 0){
      typeStr = String.join("", types);
    }
  }


  public void setPageNum(int pageNum) {

    if(pageNum <= 0){
      this.pageNum = 1;
      return;
    }
    this.pageNum = pageNum;
  }

  public void setAmount(int amount) {

    if(amount <= 1 || amount > 100) {
      this.amount = 20;
      return;
    }
    this.amount = amount;
  }

  public int getSkip(){

    return (this.pageNum - 1) * this.amount;

  }


}
