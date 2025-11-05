package com.ssg.wms.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@EnableWebMvc
public class WebMvcConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // /** 로 들어온 요청을 클래스패스의 해당 패키지로 매핑
        registry.addResourceHandler("/**")
                .addResourceLocations("classpath:/static/");
        // 필요하면 캐시/버전 체인 추가
        // .setCachePeriod(3600)
        // .resourceChain(true)
        // .addResolver(new VersionResourceResolver().addContentVersionStrategy("/**"));
    }
}
