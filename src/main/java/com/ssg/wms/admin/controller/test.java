package com.ssg.wms.admin.controller;

import lombok.extern.log4j.Log4j2;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Controller
@RequestMapping("/test")
@Log4j2
public class test {

    @GetMapping("/test")
    public String test(Model model) {
        log.info("test");

        return "admin/test";
    }
}
