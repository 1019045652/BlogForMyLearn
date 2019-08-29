# shiro整合springboot

## 1、securityManager爆红的问题

引入该类则解决，但是后来不见该错误，先记录。

## 2、realm 文件中无法注入service的错误

再shiroConfig文件中不可以直接new realm 需要先用@bean来注入，再使用（很多帖子中都是错误的，需注意）

代码如下：

### **-ShiroConfig.java**

```java

import java.util.HashMap;
import java.util.Map;

import org.apache.shiro.spring.web.ShiroFilterFactoryBean;
import org.apache.shiro.web.mgt.DefaultWebSecurityManager;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ShiroConfig {
        //创建ShiroFilterFactoryBean
     @Bean(name="shiroFilterFactoryBean")
     public ShiroFilterFactoryBean getShiroFilterFactoryBean(@Qualifier("defaultWebSecurityManager")DefaultWebSecurityManager defaultWebSecurityManager){
            ShiroFilterFactoryBean shiroFilterFactoryBean = new ShiroFilterFactoryBean();
            //设置安全管理器
            shiroFilterFactoryBean.setSecurityManager(defaultWebSecurityManager);

            //添加shiro内置过滤器
        /*
         * anon:表示可以匿名使用。
           authc:表示需要认证(登录)才能使用，没有参数
           roles：参数可以写多个，多个时必须加上引号，并且参数之间用逗号分割，当有多个参数时，例如admins/user/**=roles["admin,guest"],每个参数通过才算通过，相当于hasAllRoles()方法。
           perms：参数可以写多个，多个时必须加上引号，并且参数之间用逗号分割，例如/admins/user/**=perms["user:add:*,user:modify:*"]，当有多个参数时必须每个参数都通过才通过，想当于isPermitedAll()方法。
           rest：根据请求的方法，相当于/admins/user/**=perms[user:method] ,其中method为post，get，delete等。
           port：当请求的url的端口不是8081是跳转到schemal://serverName:8081?queryString,其中schmal是协议http或https等，serverName是你访问的host,8081是url配置里port的端口，queryString是你访问的url里的？后面的参数。
           authcBasic：没有参数表示httpBasic认证
           ssl:表示安全的url请求，协议为https
           user:当登入操作时不做检查
         */
            Map<String, String> fMap = new HashMap<String, String>();
            //拦截页面
            fMap.put("/one", "authc");
            fMap.put("/two", "authc");


            //拦截未授权
            fMap.put("/one", "perms[user:one]");
            fMap.put("/two", "perms[user:two]");
            //被拦截返回登录页面
            shiroFilterFactoryBean.setLoginUrl("/login");
            //授权拦截返回页面
            shiroFilterFactoryBean.setUnauthorizedUrl("/permission");
            shiroFilterFactoryBean.setFilterChainDefinitionMap(fMap);
            return shiroFilterFactoryBean;

        }
        @Bean(name="defaultWebSecurityManager")
        //创建DefaultWebSecurityManager
        public DefaultWebSecurityManager getDefaultWebSecurityManager(@Qualifier("userRealm")UserRealm userRealm){
            DefaultWebSecurityManager defaultWebSecurityManager = new DefaultWebSecurityManager();
            defaultWebSecurityManager.setRealm(userRealm);
            return defaultWebSecurityManager;

        }

        //创建Realm(注意，这里的realm 需要自己注入导spring容器中 ，不可以直接new使用)
        @Bean(name="userRealm")
        public UserRealm getUserRealm(){
            return new UserRealm();
        }


    }

```

### **-UserRealm.java**

```java
import com.an.an_be.service.UserService;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.SimpleAuthenticationInfo;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.subject.PrincipalCollection;
import com.an.an_be.entity.User;
import org.springframework.beans.factory.annotation.Autowired;

/**
     * @Description: shiro的自定义realm
     * Realm：域，Shiro从从Realm获取安全数据（如用户、角色、权限），就是说SecurityManager要验证用户身份，那么它需要从Realm获取相应的用户进行比较以确定用户身份是否合法；也需要从Realm得到用户相应的角色/权限进行验证用户是否能进行操作；可以把Realm看成DataSource，即安全数据源。
     * @Author 张小黑的猫
     * @data 2019-05-22 17:51
     */
 public class UserRealm extends AuthorizingRealm {

        @Autowired
        private UserService userService;
        /**
         * 认证
         */
        protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) {
            //1.获取用户输入的账号
            String username = (String)token.getPrincipal();
            //2.通过username从数据库中查找到user实体
            User userCustom = new User();
            userCustom.setUserName(username);
            User user = userService.findUser(userCustom);
            System.out.println(user);
            if(user == null){
                return null;
            }
            //3.通过SimpleAuthenticationInfo做身份处理
            SimpleAuthenticationInfo simpleAuthenticationInfo =
                    new SimpleAuthenticationInfo(user,user.getPassword(),getName());
            //4.用户账号状态验证等其他业务操作
//            if(!user.getAvailable()){
//                throw new AuthenticationException("该账号已经被禁用");
//            }
            //5.返回身份处理对象
            return simpleAuthenticationInfo;
        }

        @Override
        /**
         * 授权
         */
        protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principal) {
            return null;
        }
        
    }

```

### **-LoginController.java**

```java
import com.an.an_be.entity.Result;
import com.an.an_be.entity.User;
import com.an.an_be.mapper.UserMapper;
import com.an.an_be.service.UserService;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.UsernamePasswordToken;
import org.apache.shiro.subject.Subject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@RestController
@CrossOrigin
public class LoginController {
    @Autowired
    private UserService userService;

    @PostMapping("/login")
    public Result login(HttpServletRequest request, HttpServletResponse response, @RequestBody User user) {
        //解决跨域问题
//        response.addHeader("Access-Control-Allow-Origin", "*");
//        response.addHeader("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
//        response.addHeader("Access-Control-Allow-Headers",
//                "Content-Type,X-Requested-With,accept,Origin,Access-Control-Request-Method,Access-Control-Request-Headers,token");
//        User userTest = userService.findUser(user);
//        System.out.println(userTest);
//        return new Result(200,true);
        UsernamePasswordToken token = new UsernamePasswordToken(user.getUserName(),user.getPassword());
        Subject currentUser = SecurityUtils.getSubject();
        Result result = new Result();
        try {
            //主体提交登录请求到SecurityManager
            currentUser.login(token);
        }catch (IncorrectCredentialsException ice){
            System.out.println("密码不正确");
        }catch(UnknownAccountException uae){
            System.out.println("账号不存在");
        }catch(AuthenticationException ae){
            System.out.println("状态不正常");
        }
        if(currentUser.isAuthenticated()){
            System.out.println("认证成功");
            result.setCode(200);
            result.setSuccess(true);
            return result;
        }else{
            token.clear();
            result.setCode(403);
            return result;
        }
    }
}

```

