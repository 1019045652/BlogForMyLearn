# 微耕门禁移植

## 1、数据库方面

### （1）日期的转换

oracle中的 to_char（）在mysql 中是 dataformat（）

oracle中是：to_char('2019-10-10 12:12:12', ‘YYMMDD’)

mysql中是：dataformat('2019-10-10 12:12:12', ‘%Y%m%d’)

还有一种是：	DATE_FORMAT(HMA.APPLY_TIME , '%Y-%m-%d %H:%i:%s') 

还有数据库的字符串拼接：concat()函数可以完成 

oracle可以 使用 || 来完成拼接

