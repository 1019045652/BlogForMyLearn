# springBoot整合hibernate

## 1、整合开始

导入的是JPA  的jar包，所以这里使用的就不是sessionFactory ，而是entityManager ，代码如下：

```java
@PersistenceContext
private EntityManager entityManager;
//执行语句，执行的是原生的sql语句（查询）
Query query= entityManager.createNativeQuery(sql);
return query.getResultList();

//增删改的方式， 这里用了占位符，根据set方法来设置占位符
Query query = entityManager.createNativeQuery(sql);
        for (int i = 0; i < params.size(); i++){
            query.setParameter(i+1, params.get(i));
        }
return query.executeUpdate();
```



## 2、entityManager 的小坑

注意这里的query 的setParameters 中的下标是从一开始的，而sessionFactory 的是从0开始的



