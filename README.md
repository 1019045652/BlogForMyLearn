# SpringBoot的日常
### 用idea搭建环境
1、整合mybatis的配置文件开发
首先：启动类上要有@mapperScan("com.mapper")注解来扫面mapper接口
然后：在yml配置文件中需要配置mybatis的mapper.xml的location，注意，这里新建文件一定要是xml，因为idea的xml是有后缀的，而java文件是没有后缀的。
2、springBoot的热部署，在pom中依赖devTools：
     <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-devtools</artifactId>
            <optional>true</optional>
      </dependency>
在yml中配置：
    spring:
      thymeleaf:
        suffix: .html
        check-template: true
        encoding: utf-8
        cache: false
      datasource:
        driver-class-name: com.mysql.cj.jdbc.Driver
        url: jdbc:mysql://localhost:3306/sbDemo?characterEncoding=utf-8&serverTimezone=GMT%2B8
        username: root
        password: root
      resources:
        static-locations: classpath:/META-INF/resources/,classpath:/resources/,classpath:/static/,classpath:/public/,classpath:/templates/
      devtools:
        restart:
          additional-paths: src/main/java
          enabled: true
    mybatis:
      type-aliases-package: com.anbaba.sbdemo.Entity
      mapper-locations: classpath:/mapper/*.xml
      configuration:
        map-underscore-to-camel-case: true


    
