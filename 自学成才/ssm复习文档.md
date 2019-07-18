# 复习ssm

## 1、框架的搭建

暂时略过...

## 2、起步

###2.1、idea的热更新/热加载

--在tomcat中设置explore的artifact（文件目录发布）
--ctrl+shift+a 搜索registy...修改when running...为选中，debug启动服务器
--如果热加载不好用，可以点击右上角的启动按钮，选择redeploy重新发布，时间较短。

### 2.2、bootStrap的引入

引入静态文件夹，在页面引入js文件和jquery文件即可

## 3、springmvc的前后数据交互

### 3.1、controller跳转到非设定前后缀的页面

用redirect或者foward：

```java
 @RequestMapping("/findAllUser")
    public String findAllUser() {
        return "redirect:/login.jsp";
    }
```

### 3.2、数据传递

```java
 //传递到页面
@RequestMapping("/testUser")
    public String testUser(Model model, User user) {
        System.out.println(userService.addUser(user));
 model.addAttribute("userList",userService.findAllUser());
        return "testUser";
    }
//页面获取（遍历获取）
<c:forEach items="${userList}" var="a">
    ${a.userId} ${a.userName} ${a.userPassword}<br>
</c:forEach>
```

### 3.3、前后数据传递乱码处理

首先：springMVC提供了字符编码过滤器，可以解决post乱码问题

```java
<filter>
    <filter-name>CharacterEncodingFilter</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
      <param-name>encoding</param-name>
      <param-value>utf-8</param-value>
    </init-param>
    <init-param>
      <param-name>forceRequestEncoding</param-name>
      <param-value>true</param-value>
    </init-param>
    <init-param>
      <param-name>forceResponseEncoding</param-name>
      <param-value>true</param-value>
    </init-param>
  </filter>
  <filter-mapping>
    <filter-name>CharacterEncodingFilter</filter-name>
    <url-pattern>/*</url-pattern>
  </filter-mapping>
```



如果是get乱码：需要去tomcat中设置字符编码格式

### 3.4、刷新页面重复提交表单问题

在session中存储一个令牌，前后端同时校验，一致则为第一次提交表单，执行操作后清空session，重复提交则不一致，避免重复提交表单。

