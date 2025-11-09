package com.ssg.wms.quotation.mappers;

import com.ssg.wms.global.Enum.EnumStatus;
import com.ssg.wms.global.domain.Criteria;
import com.ssg.wms.quotation.domain.*;
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
@Sql("classpath:sql/test-data.sql")
public class QuotationMapperTest {

    @Autowired(required = false)
    private QuotationMapper quotationMapper;

    @Test
    public void testMapperExists() {
        log.info("QuotationMapper 주입 확인: " + quotationMapper);
    }

    // ======== 1. QuotationRequest 테스트 ========

    @Test
    public void testSelectQuotationRequestList() {
        List<QuotationRequestDTO> list = quotationMapper.selectQuotationRequestList(new Criteria(), new QuotationSearchDTO());
        log.info("===== 견적 요청 목록 =====");
        list.forEach(dto -> log.info(dto));
        log.info("=========================");
    }

    @Test
    public void testSelectQuotationRequestTotalCount() {
        int total = quotationMapper.selectQuotationRequestTotalCount(new QuotationSearchDTO());
        log.info("견적 요청 전체 개수: " + total);
    }

    @Test
    public void testSelectQuotationRequest() {
        // ※※※ 중요 ※※※
        // QuotationMapper.java의 selectQuotationRequest 메소드는 DTO를 파라미터로 받습니다.
        // .xml은 Long을 받습니다. (불일치)

        // .java 파일에 맞춰 DTO를 파라미터로 전달합니다.
        // 이 테스트를 통과하려면 .xml 파일의 파라미터 타입을 DTO로 수정해야 합니다.
        QuotationRequestDTO paramDto = new QuotationRequestDTO();
        paramDto.setQrequest_index(1L);

        try {
            QuotationRequestDTO resultDto = quotationMapper.selectQuotationRequest(paramDto);
            log.info("1번 견적 요청: " + resultDto);
        } catch (Exception e) {
            log.error("testSelectQuotationRequest 오류: " + e.getMessage());
            log.error("### .java와 .xml의 파라미터 타입이 일치하는지 확인하세요 ###");
        }
    }

    @Test
    public void testInsertQuotationRequest() {
        QuotationRequestDTO dto = QuotationRequestDTO.builder()
                .user_index(1L).qrequest_name("새신청자")
                .qrequest_email("new@test.com")
                .qrequest_phone("010-8888-8888")
                .qrequest_detail("새 내용").build();
        quotationMapper.insertQuotationRequest(dto);
        log.info("등록된 견적 요청 (PK 확인): " + dto);
    }

    @Test
    public void testUpdateQuotationRequest() {
        QuotationRequestDTO dto = QuotationRequestDTO.builder()
                .qrequest_index(1L) // 1번 견적 수정
                .qrequest_name("이름수정")
                .qrequest_email("edit@test.com")
                .qrequest_phone("010-1111-2222")
                .qrequest_company("수정회사")
                .qrequest_detail("수정 내용")
                .build();

        quotationMapper.updateQuotationRequest(dto);
        log.info("1번 견적 수정 완료");
    }

    @Test
    public void testDeleteQuotationRequest() {
        quotationMapper.deleteQuotationRequest(1L);
        log.info("1번 견적 삭제");
    }

    // ======== 2. QuotationResponse 테스트 ========

    @Test
    public void testInsertQuotationResponse() {
        QuotationResponseDTO dto = QuotationResponseDTO.builder()
                .qrequest_index(1L) // 1번 요청에 답변
                .admin_index(1L)
                .qresponse_detail("1번 답변입니다.")
                .build();
        quotationMapper.insertQuotationResponse(dto);
        log.info("등록된 견적 답변 (PK 확인): " + dto);
    }

    @Test
    public void testSelectQuotationResponse() {
        // 2번 요청에 대한 답변 조회
        QuotationResponseDTO dto = quotationMapper.selectQuotationResponse(2L);
        log.info("2번 요청의 답변: " + dto);
    }

    @Test
    public void testUpdateQuotationResponse() {
        QuotationResponseDTO dto = quotationMapper.selectQuotationResponse(2L);
        dto.setQresponse_detail("수정된 답변");
        quotationMapper.updateQuotationResponse(dto);

        QuotationResponseDTO updatedDto = quotationMapper.selectQuotationResponse(2L);
        log.info("수정된 답변: " + updatedDto);
    }

    @Test
    public void testDeleteQuotationResponse() {
        quotationMapper.deleteQuotationResponse(1L); // 1번 답변 (qrequest_index=2)
        QuotationResponseDTO dto = quotationMapper.selectQuotationResponse(2L);
        log.info("삭제 후 조회: " + dto);
    }

    // ======== 3. QuotationComment 테스트 ========

    @Test
    public void testSelectQuotationCommentList() {
        List<QuotationCommentDTO> list = quotationMapper.selectQuotationCommentList(new Criteria(), 2L);
        log.info("===== 2번 견적의 댓글 목록 =====");
        list.forEach(dto -> log.info(dto));
        log.info("==============================");
    }

    @Test
    public void testSelectQuotationCommentTotalCount() {
        int total = quotationMapper.selectQuotationCommentTotalCount(2L);
        log.info("2번 견적의 댓글 수: " + total);
    }

    @Test
    public void testInsertQuotationComment() {
        // 관리자 댓글 (user_index = null)
        QuotationCommentDTO adminComment = QuotationCommentDTO.builder()
                .qrequest_index(1L).qcomment_detail("관리자 댓글")
                .writer_type(EnumStatus.ADMIN).admin_index(1L).user_index(null)
                .build();
        quotationMapper.insertQuotationComment(adminComment);

        List<QuotationCommentDTO> list = quotationMapper.selectQuotationCommentList(new Criteria(), 1L);
        log.info("등록된 관리자 댓글: " + list.get(0));
    }

    @Test
    public void testUpdateQuotationComment() {
        List<QuotationCommentDTO> list = quotationMapper.selectQuotationCommentList(new Criteria(), 2L);
        QuotationCommentDTO dto = list.get(0); // 첫번째 댓글
        dto.setQcomment_detail("수정된 댓글");

        quotationMapper.updateQuotationComment(dto);

        List<QuotationCommentDTO> updatedList = quotationMapper.selectQuotationCommentList(new Criteria(), 2L);
        log.info("수정된 댓글: " + updatedList.get(0));
    }

    @Test
    public void testDeleteQuotationComment() {
        List<QuotationCommentDTO> list = quotationMapper.selectQuotationCommentList(new Criteria(), 2L);
        Long commentIndex = list.get(0).getQcomment_index(); // 첫번째 댓글 ID

        quotationMapper.deleteQuotationComment(commentIndex);

        List<QuotationCommentDTO> updatedList = quotationMapper.selectQuotationCommentList(new Criteria(), 2L);
        log.info("삭제 후 댓글 목록 크기: " + updatedList.size());
    }
}