# 1、SpringBoot的日常
### 1、用idea搭建 springBoot  +  mybatis  环境
1、整合mybatis的配置文件开发
首先：启动类上要有@mapperScan("com.mapper")注解来扫面mapper接口
然后：在yml配置文件中需要配置mybatis的mapper.xml的location，注意，这里新建文件一定要是xml，因为idea的xml是有后缀的，而java文件是没有后缀的（ idea 的小坑）。

2、springBoot的热部署，在pom中依赖devTools：

​     <dependency>
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

###2、springboot 的日志

```
//yml文件中设置的logging的输出位置和输出的级别，和可以使用logback.xml 的配置文件来设置
logging:
  file: C:\\Users\\安邦兴国\\Desktop\practise_log.log
  level:
    ROOT: WARN
    com.hengbao: DEBUG
```



# 2、redis笔记

安装地址：<https://redis.io/download> 

### 一般用法

-解压 下载下来的压缩包 tar zxvf redis...

-进入解压好的目录，运行make，编译文件

-进入 src目录，运行 redis-server 

-运行redis-cli

基本环境搭建完毕，redis启动完毕

### （1）基本数据结构

```java
存key-value：
set name "key"
get name 

存一个key-value(哈希):
hmset demo key  "value" //存入键值
hget  demo key  //取出指定的键值
    
存一个list集合：
lpush listdemo "hello" //左插入
rpush listdemo "hi"  //右插入
lrange listdemo 1 10   //输出下标范围的数据
1) "hello"
2) "hi"

存一个set集合(不重复的无序集合)：
sadd setdemo "hello"
smembers setdemo
1)"hello"
    

```

###（2）发布订阅模式

```java
首先 新建频道：
> subscribe redisChat //在一个客户端新建频道
> publish redisChat "coco is dashabi" //在另一个客户端发布消息
```

###（3）设置redis的访问密码

```java
//查看密码
> config get requirepass
//设置密码
> config set requirepass "123456"
//登录redis
> auth "123456"
```

###（4）java集成redis

```java
//springboot集成
//引入redis的依赖
 <!--reids-->
<dependency>
   <groupId>org.springframework.boot</groupId>
   <artifactId>spring-boot-starter-data-redis</artifactId>
</dependency>
//yml配置文件里的配置
  #redis的配置
  spring:
      redis:
        database: 0
        host: 192.168.247.128
        port: 6379
        password: 123456
        jedis:
          pool:
            max-active: 200
//入口文件上添加注释
@SpringBootApplication
@MapperScan("com.anbaba.sbdemo.mapper")
@EnableCaching //开启redis缓存
public class SbdemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(SbdemoApplication.class, args);
    }
//service上添加注释
@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    @Cacheable(value="common")//遍历出的内容加入redis缓存
//    @CacheEvict(value="common")
    public List<User> queryAllUser() {
        return userMapper.queryAllUser();
    }

    @Override
    public int addUser(User user) {
        return userMapper.addUser(user);
    }
}
}

//编写springboot的测试类
@RunWith(SpringRunner.class)
@SpringBootTest
public class TestRedis {
    @Autowired
    private UserService userService;

    @Test
    public  void test(){
        List<User> userList = new ArrayList<User>();
        userList = userService.queryAllUser();
        for (User user:userList) {
            System.out.println(user.getUserName());
        }
    }
}
```

# 3、oracle笔记

### 1）基本的使用

```java
//安装完成后可以找到sql plus来进行操作数据库
//默认登录的用户名是system
//其中有一个scott用户，里面有四张表可以练习
如何解锁：
sql> conn system/root as sysdba  //账户名/密码以管理员登录
sql> alter user scott account lock //解锁账户
sql> alter user scott identified by root //修改密码为root
```

###2）










​    
