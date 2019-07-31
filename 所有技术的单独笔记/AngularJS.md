# --------angularJS--------

## 1、创建    angularJs -- cli    项目

1、node.js 环境

2、安装angular/cli ，快速构建开发环境：npm i -g @angular/cli@latest

3、可以先卸载旧的 cli ：

```cmd
# npm uninstall -g @angular/cli // 卸载旧版本cli。
# npm cache clean // 清除缓存，确保卸载干净
```

4、在项目创建新的模块：ng g component  user

ng serve --open

## 2、创建 1.x 的angularJS程序

1、下载他的依赖包

2、引入angular.min.js

3、引入angular.route.js

4、创建基本完成

## **3、笔记（初步的功能实现）：**



1、首先在 html标签里或者 boddy 标签里加上：ng-app = "demo"表示这是一个总体的容器

2、新建一个js文件，其中是对这个模块的声明，表达式为：angular.module('routingDemoApp', ['ngRoute']) ；		

​	第一个参数是 ng-app的值，第二个参数是引入路由依赖。

3、$$ scope的应用（作用域），app.controller('myCtrl', function($scope) { $scope.carname = "Volvo"; }); 

​	这行代码的意思就：将一个 ng-controller="myCtrl" 的模块里初始化了一个常量。

4、路由的配置：

```javascript
angular.module('routingDemoApp', ['ngRoute'])
    .config(['$routeProvider', function($routeProvider) {
        $routeProvider
            .when('/', { templateUrl: 'user.html' })
            .when('/computers', { template: '这是电脑分类页面' })
            .when('/printers', { template: '这是打印机页面' })
            .otherwise({ redirectTo: '/' });
    }]);
//路由的访问：<li>< a href="#!/printers">打印机</a></li> 

//函数的定义：
var app = angular.module('routingDemoApp', ['ngRoute'])
    .config(['$routeProvider', function($routeProvider) {
        $routeProvider
            .when('/computers', { template: '这是电脑分类页面' })
            .when('/printers', { template: '这是打印机页面' })
            .otherwise({ redirectTo: '/' });
    }]);

app.controller('test', function($scope) {
        $scope.test = 1111;
        $scope.hello = function() {
            alert("你是大傻蛋")
        };
    })

//调用函数用ng-click 指令完成
```

