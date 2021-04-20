# 实体完整性验证
# 指组成主码的所有属性均不可取空值

# insert into book value(NULL,'test1','HYX',89,0);
# insert into borrow value('b4',NULL,'2021-03-20',NULL);
# insert into borrow value(NULL,'r3','2021-03-20',NULL);
# insert into borrow value(NULL,NULL,'2021-03-20',NULL);
# insert into reader value(NULL,'czx','22','West Campus');

# 参照完整性
# 参照关系R的任一个外码值必须
# 等于被参照关系S中所参照的候选码的某个值
# 或者为空

# insert into borrow value('b13','r1','2020-04-01','2021-09-01');
# insert into borrow value('b12','r17','2020-04-01','2021-09-01');
# insert into borrow value('b13','r17','2020-04-01','2021-09-01');

# 用户自定义完整性
# 针对某一具体数据的约束条件，反映某一具体应用所涉及的数据必须满足的特殊语义
# 由应用环境决定

# 本次实验中的用户自定义完整性为：书名不能为空
# insert into book value('b30',NULL,'HYX',89,0);