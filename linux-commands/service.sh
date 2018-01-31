4 服务{

    /etc/init.d/sendmail start                   # 启动服务
    /etc/init.d/sendmail stop                    # 关闭服务
    /etc/init.d/sendmail status                  # 查看服务当前状态
    /date/mysql/bin/mysqld_safe --user=mysql &   # 启动mysql后台运行
    /bin/systemctl restart  mysqld.service       # centos7启动服务
    vi /etc/rc.d/rc.local                        # 开机启动执行  可用于开机启动脚本
    /etc/rc.d/rc3.d/S55sshd                      # 开机启动和关机关闭服务连接    # S开机start  K关机stop  55级别 后跟服务名
    ln -s -f /date/httpd/bin/apachectl /etc/rc.d/rc3.d/S15httpd   # 将启动程序脚本连接到开机启动目录
    ipvsadm -ln                                  # lvs查看后端负载机并发
    ipvsadm -C                                   # lvs清除规则
    xm list                                      # 查看xen虚拟主机列表
    virsh                                        # 虚拟化(xen\kvm)管理工具  yum groupinstall Virtual*
    ./bin/httpd -M                               # 查看httpd加载模块
    httpd -t -D DUMP_MODULES                     # rpm包httpd查看加载模块
    echo 内容| /bin/mail -s "标题" 收件箱 -f 发件人       # 发送邮件
    "`echo "内容"|iconv -f utf8 -t gbk`" | /bin/mail -s "`echo "标题"|iconv -f utf8 -t gbk`" 收件箱     # 解决邮件乱码
    /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg   # 检测nagios配置文件

    chkconfig{

        chkconfig 服务名 on|off|set              # 设置非独立服务启状态
        chkconfig --level 35   httpd   off       # 让服务不自动启动
        chkconfig --level 35   httpd   on        # 让服务自动启动 35指的是运行级别
        chkconfig --list                         # 查看所有服务的启动状态
        chkconfig --list |grep httpd             # 查看某个服务的启动状态
        chkconfig –-list [服务名称]              # 查看服务的状态

    }

    nginx{

        yum install -y make gcc  openssl-devel pcre-devel  bzip2-devel libxml2 libxml2-devel curl-devel libmcrypt-devel libjpeg libjpeg-devel libpng libpng-devel openssl

        groupadd nginx
        useradd nginx -g nginx -M -s /sbin/nologin

        mkdir -p /opt/nginx-tmp

        wget http://labs.frickle.com/files/ngx_cache_purge-1.6.tar.gz
        tar fxz ngx_cache_purge-1.6.tar.gz
        # ngx_cache_purge 清除指定url缓存
        # 假设一个URL为 http://192.168.12.133/test.txt
        # 通过访问      http://192.168.12.133/purge/test.txt  就可以清除该URL的缓存。

        tar zxvpf nginx-1.4.4.tar.gz
        cd nginx-1.4.4

        # ./configure --help
        # --with                 # 默认不加载 需指定编译此参数才使用
        # --without              # 默认加载，可用此参数禁用
        # --add-module=path      # 添加模块的路径
        # --add-module=/opt/ngx_module_upstream_check \         # nginx 代理状态页面
        # ngx_module_upstream_check  编译前需要打对应版本补丁 patch -p1 < /opt/nginx_upstream_check_module/check_1.2.6+.patch
        # --add-module=/opt/ngx_module_memc \                   # 将请求页面数据存放在 memcached中
        # --add-module=/opt/ngx_module_lua \                    # 支持lua脚本 yum install lua-devel lua

        ./configure \
        --user=nginx \
        --group=nginx \
        --prefix=/usr/local/nginx \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_gzip_static_module \
        --with-http_stub_status_module \
        --add-module=/opt/ngx_cache_purge-1.6 \
        --http-client-body-temp-path=/opt/nginx-tmp/client \
        --http-proxy-temp-path=/opt/nginx-tmp/proxy \
        --http-fastcgi-temp-path=/opt/nginx-tmp/fastcgi \
        --http-uwsgi-temp-path=/opt/nginx-tmp/uwsgi \
        --http-scgi-temp-path=/opt/nginx-tmp/scgi

        make && make install

        /usr/local/nginx/sbin/nginx –t             # 检查Nginx配置文件 但并不执行
        /usr/local/nginx/sbin/nginx -t -c /opt/nginx/conf/nginx.conf  # 检查Nginx配置文件
        /usr/local/nginx/sbin/nginx                # 启动nginx
        /usr/local/nginx/sbin/nginx -s reload      # 重载配置
        /usr/local/nginx/sbin/nginx -s stop        # 关闭nginx服务

    }

    httpd{

        编译参数{

            # so模块用来提供DSO支持的apache核心模块
            # 如果编译中包含任何DSO模块，则mod_so会被自动包含进核心。
            # 如果希望核心能够装载DSO，但不实际编译任何DSO模块，则需明确指定"--enable-so=static"

            ./configure --prefix=/usr/local/apache --enable-so --enable-mods-shared=most --enable-rewrite --enable-forward  # 实例编译

            --with-mpm=worker         # 已worker方式运行
            --with-apxs=/usr/local/apache/bin/apxs  # 制作apache的动态模块DSO rpm包 httpd-devel  #编译模块 apxs -i -a -c mod_foo.c
            --enable-so               # 让Apache可以支持DSO模式
            --enable-mods-shared=most # 告诉编译器将所有标准模块都动态编译为DSO模块
            --enable-rewrite          # 支持地址重写功能
            --enable-module=most      # 用most可以将一些不常用的，不在缺省常用模块中的模块编译进来
            --enable-mods-shared=all  # 意思是动态加载所有模块，如果去掉-shared话，是静态加载所有模块
            --enable-expires          # 可以添加文件过期的限制，有效减轻服务器压力，缓存在用户端，有效期内不会再次访问服务器，除非按f5刷新，但也导致文件更新不及时
            --enable-deflate          # 压缩功能，网页可以达到40%的压缩，节省带宽成本，但会对cpu压力有一点提高
            --enable-headers          # 文件头信息改写，压缩功能需要
            --disable-MODULE          # 禁用MODULE模块(仅用于基本模块)
            --enable-MODULE=shared    # 将MODULE编译为DSO(可用于所有模块)
            --enable-mods-shared=MODULE-LIST   # 将MODULE-LIST中的所有模块都编译成DSO(可用于所有模块)
            --enable-modules=MODULE-LIST       # 将MODULE-LIST静态连接进核心(可用于所有模块)

            # 上述 MODULE-LIST 可以是:
            1、用引号界定并且用空格分隔的模块名列表  --enable-mods-shared='headers rewrite dav'
            2、"most"(大多数模块)  --enable-mods-shared=most
            3、"all"(所有模块)

        }

        转发{

            #针对非80端口的请求处理
            RewriteCond %{SERVER_PORT} !^80$
            RewriteRule ^/(.*)         http://fully.qualified.domain.name:%{SERVER_PORT}/$1 [L,R]

            RewriteCond %{HTTP_HOST} ^ss.aa.com [NC]
            RewriteRule  ^(.*)  http://www.aa.com/so/$1/0/p0?  [L,R=301]
            #RewriteRule 只对?前处理，所以会把?后的都保留下来
            #在转发后地址后加?即可取消RewriteRule保留的字符
            #R的含义是redirect，即重定向，该请求不会再被apache交给后端处理，而是直接返回给浏览器进行重定向跳转。301是返回的http状态码，具体可以参考http rfc文档，跳转都是3XX。
            #L是last，即最后一个rewrite规则，如果请求被此规则命中，将不会继续再向下匹配其他规则。

        }

    }

    mysql源码安装{

        groupadd mysql
        useradd mysql -g mysql -M -s /bin/false
        tar zxvf mysql-5.0.22.tar.gz
        cd mysql-5.0.22
        ./configure  --prefix=/usr/local/mysql \
        --with-client-ldflags=-all-static \
        --with-mysqld-ldflags=-all-static \
        --with-mysqld-user=mysql \
        --with-extra-charsets=all \
        --with-unix-socket-path=/var/tmp/mysql.sock
        make  &&   make  install
        # 生成mysql用户数据库和表文件，在安装包中输入
        scripts/mysql_install_db  --user=mysql
        vi ~/.bashrc
        export PATH="$PATH: /usr/local/mysql/bin"
        # 配置文件,有large,medium,small三个，根据机器性能选择
        cp support-files/my-medium.cnf /etc/my.cnf
        cp support-files/mysql.server /etc/init.d/mysqld
        chmod 700 /etc/init.d/mysqld
        cd /usr/local
        chmod 750 mysql -R
        chgrp mysql mysql -R
        chown mysql mysql/var -R
        cp  /usr/local/mysql/libexec/mysqld mysqld.old
        ln -s /usr/local/mysql/bin/mysql /sbin/mysql
        ln -s /usr/local/mysql/bin/mysqladmin /sbin/mysqladmin
        ln -s -f /usr/local/mysql/bin/mysqld_safe /etc/rc.d/rc3.d/S15mysql5
        ln -s -f /usr/local/mysql/bin/mysqld_safe /etc/rc.d/rc0.d/K15mysql5

    }

    mysql常用命令{

        ./mysql/bin/mysqld_safe --user=mysql &   # 启动mysql服务
        ./mysql/bin/mysqladmin -uroot -p -S ./mysql/data/mysql.sock shutdown    # 停止mysql服务
        mysqlcheck -uroot -p -S mysql.sock --optimize --databases account       # 检查、修复、优化MyISAM表
        mysqlbinlog slave-relay-bin.000001              # 查看二进制日志(报错加绝对路径)
        mysqladmin -h myhost -u root -p create dbname   # 创建数据库

        flush privileges;             # 刷新
        show databases;               # 显示所有数据库
        use dbname;                   # 打开数据库
        show tables;                  # 显示选中数据库中所有的表
        desc tables;                  # 查看表结构
        drop database name;           # 删除数据库
        drop table name;              # 删除表
        create database name;         # 创建数据库
        select 列名称 from 表名称;      # 查询
        show processlist;             # 查看mysql进程
        show full processlist;        # 显示进程全的语句
        select user();                # 查看所有用户
        show slave status\G;          # 查看主从状态
        show variables;               # 查看所有参数变量
        show status;                  # 运行状态
        show table status             # 查看表的引擎状态
        show grants for dbbackup@'localhost';           # 查看用户权限
        drop table if exists user                       # 表存在就删除
        create table if not exists user                 # 表不存在就创建
        select host,user,password from user;            # 查询用户权限 先use mysql
        create table ka(ka_id varchar(6),qianshu int);  # 创建表
        show variables like 'character_set_%';          # 查看系统的字符集和排序方式的设定
        show variables like '%timeout%';                # 查看超时(wait_timeout)
        delete from user where user='';                 # 删除空用户
        delete from user where user='sss' and host='localhost' ;    # 删除用户
        drop user 'sss'@'localhost';                                # 使用此方法删除用户更为靠谱
        ALTER TABLE mytable ENGINE = MyISAM ;                       # 改变现有的表使用的存储引擎
        SHOW TABLE STATUS from  库名  where Name='表名';              # 查询表引擎
        mysql -uroot -p -A -ss -h10.10.10.5 -e "show databases;"    # shell中获取数据不带表格 -ss参数
        CREATE TABLE innodb (id int, title char(20)) ENGINE = INNODB                     # 创建表指定存储引擎的类型(MyISAM或INNODB)
        grant replication slave on *.* to '用户'@'%' identified by '密码';               # 创建主从复制用户
        ALTER TABLE player ADD INDEX weekcredit_faction_index (weekcredit, faction);     # 添加索引
        alter table name add column accountid(列名)  int(11) NOT NULL(字段不为空);          # 插入字段
        update host set monitor_state='Y',hostname='xuesong' where ip='192.168.1.1';     # 更新数据

        自增表{

            create table xuesong  (id INTEGER  PRIMARY KEY AUTO_INCREMENT, name CHAR(30) NOT NULL, age integer , sex CHAR(15) );  # 创建自增表
            insert into xuesong(name,age,sex) values(%s,%s,%s)  # 自增插入数据

        }

        登录mysql的命令{

            # 格式： mysql -h 主机地址 -u 用户名 -p 用户密码
            mysql -h110.110.110.110 -P3306 -uroot -p
            mysql -uroot -p -S /data1/mysql5/data/mysql.sock -A  --default-character-set=GBK

        }

        shell执行mysql命令{

            mysql -u root -p'123' xuesong < file.sql   # 针对指定库执行sql文件中的语句,好处不需要转义特殊符号,一条语句可以换行.不指定库执行时语句中需要先use
            mysql -u$username -p$passwd -h$dbhost -P$dbport -A -e "
            use $dbname;
            delete from data where date=('$date1');
            "    # 执行多条mysql命令
            mysql -uroot -p -S mysql.sock -e "use db;alter table gift add column accountid  int(11) NOT NULL;flush privileges;"    # 不登陆mysql插入字段

        }

        备份数据库{

            mysqldump -h host -u root -p --default-character-set=utf8 dbname >dbname_backup.sql               # 不包括库名，还原需先创建库，在use
            mysqldump -h host -u root -p --database --default-character-set=utf8 dbname >dbname_backup.sql    # 包括库名，还原不需要创建库
            /bin/mysqlhotcopy -u root -p    # mysqlhotcopy只能备份MyISAM引擎
            mysqldump -u root -p -S mysql.sock --default-character-set=utf8 dbname table1 table2  > /data/db.sql    # 备份表
            mysqldump -uroot -p123  -d database > database.sql    # 备份数据库结构

            # 最小权限备份
            grant select on db_name.* to dbbackup@"localhost" Identified by "passwd";
            # --single-transaction  InnoDB有时间戳 只备份开始那一刻的数据,备份过程中的数据不会备份
            mysqldump -hlocalhost -P 3306 -u dbbackup --single-transaction  -p"passwd" --database dbname >dbname.sql

            # xtrabackup备份需单独安装软件 优点: 速度快,压力小,可直接恢复主从复制
            innobackupex --user=root --password="" --defaults-file=/data/mysql5/data/my_3306.cnf --socket=/data/mysql5/data/mysql.sock --slave-info --stream=tar --tmpdir=/data/dbbackup/temp /data/dbbackup/ 2>/data/dbbackup/dbbackup.log | gzip 1>/data/dbbackup/db50.tar.gz

        }

        还原数据库{

            mysql -h host -u root -p dbname < dbname_backup.sql
            source 路径.sql   # 登陆mysql后还原sql文件

        }

        赋权限{

            # 指定IP: $IP  本机: localhost   所有IP地址: %   # 通常指定多条
            grant all on zabbix.* to user@"$IP";             # 对现有账号赋予权限
            grant select on database.* to user@"%" Identified by "passwd";     # 赋予查询权限(没有用户，直接创建)
            grant all privileges on database.* to user@"$IP" identified by 'passwd';         # 赋予指定IP指定用户所有权限(不允许对当前库给其他用户赋权限)
            grant all privileges on database.* to user@"localhost" identified by 'passwd' with grant option;   # 赋予本机指定用户所有权限(允许对当前库给其他用户赋权限)
            grant select, insert, update, delete on database.* to user@'ip'identified by "passwd";   # 开放管理操作指令
            revoke all on *.* from user@localhost;     # 回收权限
            GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, EXECUTE, CREATE ROUTINE, ALTER ROUTINE ON `storemisc_dev`.* TO 'user'@'192.168.%'

        }

        更改密码{

            update user set password=password('passwd') where user='root'
            mysqladmin -u root password 'xuesong'

        }

        mysql忘记密码后重置{

            cd /data/mysql5
            /data/mysql5/bin/mysqld_safe --user=mysql --skip-grant-tables --skip-networking &
            use mysql;
            update user set password=password('123123') where user='root';

        }

        mysql主从复制失败恢复{

            slave stop;
            reset slave;
            change master to master_host='10.10.10.110',master_port=3306,master_user='repl',master_password='repl',master_log_file='master-bin.000010',master_log_pos=107,master_connect_retry=60;
            slave start;

        }

        sql语句使用变量{

            use xuesong;
            set @a=concat('my',weekday(curdate()));    # 组合时间变量
            set @sql := concat('CREATE TABLE IF NOT EXISTS ',@a,'( id INT(11) NOT NULL )');   # 组合sql语句
            select @sql;                    # 查看语句
            prepare create_tb from @sql;    # 准备
            execute create_tb;              # 执行

        }

        检测mysql主从复制延迟{

            1、在从库定时执行更新主库中的一个timeout数值
            2、同时取出从库中的timeout值对比判断从库与主库的延迟

        }

        mysql慢查询{

            select * from information_schema.processlist where command in ('Query') and time >5\G      # 查询操作大于5S的进程

            开启慢查询日志{

                # 配置文件 /etc/my.conf
                [mysqld]
                log-slow-queries=/var/lib/mysql/slowquery.log         # 指定日志文件存放位置，可以为空，系统会给一个缺省的文件host_name-slow.log
                long_query_time=5                                     # 记录超过的时间，默认为10s
                log-queries-not-using-indexes                         # log下来没有使用索引的query,可以根据情况决定是否开启  可不加
                log-long-format                                       # 如果设置了，所有没有使用索引的查询也将被记录    可不加
                # 直接修改生效
                show variables like "%slow%";                         # 查看慢查询状态
                set global slow_query_log='ON';                       # 开启慢查询日志 变量可能不同，看上句查询出来的变量

            }

            mysqldumpslow慢查询日志查看{

                -s  # 是order的顺序，包括看了代码，主要有 c,t,l,r和ac,at,al,ar，分别是按照query次数，时间，lock的时间和返回的记录数来排序，前面加了a的时倒序
                -t  # 是top n的意思，即为返回前面多少条的数据
                -g  # 后边可以写一个正则匹配模式，大小写不敏感的

                mysqldumpslow -s c -t 20 host-slow.log                # 访问次数最多的20个sql语句
                mysqldumpslow -s r -t 20 host-slow.log                # 返回记录集最多的20个sql
                mysqldumpslow -t 10 -s t -g "left join" host-slow.log # 按照时间返回前10条里面含有左连接的sql语句

                show global status like '%slow%';                     # 查看现在这个session有多少个慢查询
                show variables like '%slow%';                         # 查看慢查询日志是否开启，如果slow_query_log和log_slow_queries显示为on，说明服务器的慢查询日志已经开启
                show variables like '%long%';                         # 查看超时阀值
                desc select * from wei where text='xishizhaohua'\G;   # 扫描整张表 tepe:ALL  没有使用索引 key:NULL
                create index text_index on wei(text);                 # 创建索引

            }

        }

        mysql操作次数查询{

            select * from information_schema.global_status;

            com_select
            com_delete
            com_insert
            com_update

        }

    }

    mongodb{

        一、启动{

            # 不启动认证
            ./mongod --port 27017 --fork --logpath=/opt/mongodb/mongodb.log --logappend --dbpath=/opt/mongodb/data/
            # 启动认证
            ./mongod --port 27017 --fork --logpath=/opt/mongodb/mongodb.log --logappend --dbpath=/opt/mongodb/data/ --auth

            # 配置文件方式启动
            cat /opt/mongodb/mongodb.conf
              port=27017                       # 端口号
              fork=true                        # 以守护进程的方式运行，创建服务器进程
              auth=true                        # 开启用户认证
              logappend=true                   # 日志采用追加方式
              logpath=/opt/mongodb/mongodb.log # 日志输出文件路径
              dbpath=/opt/mongodb/data/        # 数据库路径
              shardsvr=true                    # 设置是否分片
              maxConns=600                     # 数据库的最大连接数
            ./mongod -f /opt/mongodb/mongodb.conf

            # 其他参数
            bind_ip         # 绑定IP  使用mongo登录需要指定对应IP
            journal         # 开启日志功能,降低单机故障的恢复时间,取代dur参数
            syncdelay       # 系统同步刷新磁盘的时间,默认60秒
            directoryperdb  # 每个db单独存放目录,建议设置.与mysql独立表空间类似
            repairpath      # 执行repair时的临时目录.如果没开启journal,出现异常重启,必须执行repair操作
            # mongodb没有参数设置内存大小.使用os mmap机制缓存数据文件,在数据量不超过内存的情况下,效率非常高.数据量超过系统可用内存会影响写入性能

        }

        二、关闭{

            # 方法一:登录mongodb
            ./mongo
            use admin
            db.shutdownServer()

            # 方法:kill传递信号  两种皆可
            kill -2 pid
            kill -15 pid

        }

        三、开启认证与用户管理{

            ./mongo                      # 先登录
            use admin                    # 切换到admin库
            db.addUser("root","123456")                     # 创建用户
            db.addUser('zhansan','pass',true)               # 如果用户的readOnly为true那么这个用户只能读取数据，添加一个readOnly用户zhansan
            ./mongo 127.0.0.1:27017/mydb -uroot -p123456    # 再次登录,只能针对用户所在库登录
            #虽然是超级管理员，但是admin不能直接登录其他数据库，否则报错
            #Fri Nov 22 15:03:21.886 Error: 18 { code: 18, ok: 0.0, errmsg: "auth fails" } at src/mongo/shell/db.js:228
            show collections                                # 查看链接状态 再次登录使用如下命令,显示错误未经授权
            db.system.users.find();                         # 查看创建用户信息
            db.system.users.remove({user:"zhansan"})        # 删除用户

            #恢复密码只需要重启mongodb 不加--auth参数

        }

        四、登录{

            192.168.1.5:28017      # http登录后可查看状态
            ./mongo                # 默认登录后打开 test 库
            ./mongo 192.168.1.5:27017/databaseName      # 直接连接某个库 不存在则创建  启动认证需要指定对应库才可登录

        }

        五、查看状态{

            #登录后执行命令查看状态
            db.runCommand({"serverStatus":1})
                globalLock         # 表示全局写入锁占用了服务器多少时间(微秒)
                mem                # 包含服务器内存映射了多少数据,服务器进程的虚拟内存和常驻内存的占用情况(MB)
                indexCounters      # 表示B树在磁盘检索(misses)和内存检索(hits)的次数.如果这两个比值开始上升,就要考虑添加内存了
                backgroudFlushing  # 表示后台做了多少次fsync以及用了多少时间
                opcounters         # 包含每种主要擦撞的次数
                asserts            # 统计了断言的次数

            #状态信息从服务器启动开始计算,如果过大就会复位,发送复位，所有计数都会复位,asserts中的roolovers值增加

            #mongodb自带的命令
            ./mongostat
                insert     #每秒插入量
                query      #每秒查询量
                update     #每秒更新量
                delete     #每秒删除量
                locked     #锁定量
                qr|qw      #客户端查询排队长度(读|写)
                ar|aw      #活跃客户端量(读|写)
                conn       #连接数
                time       #当前时间

        }

        六、常用命令{

            db.listCommands()     # 当前MongoDB支持的所有命令（同样可通过运行命令db.runCommand({"listCommands" : `1})来查询所有命令）

            db.runCommand({"buildInfo" : 1})                # 返回MongoDB服务器的版本号和服务器OS的相关信息。
            db.runCommand({"collStats" : 集合名})           # 返回该集合的统计信息，包括数据大小，已分配存储空间大小，索引的大小等。
            db.runCommand({"distinct" : 集合名, "key" : 键, "query" : 查询文档})     # 返回特定文档所有符合查询文档指定条件的文档的指定键的所有不同的值。
            db.runCommand({"dropDatabase" : 1})             # 清空当前数据库的信息，包括删除所有的集合和索引。
            db.runCommand({"isMaster" : 1})                 # 检查本服务器是主服务器还是从服务器。
            db.runCommand({"ping" : 1})                     # 检查服务器链接是否正常。即便服务器上锁，该命令也会立即返回。
            db.runCommand({"repaireDatabase" : 1})          # 对当前数据库进行修复并压缩，如果数据库特别大，这个命令会非常耗时。
            db.runCommand({"serverStatus" : 1})             # 查看这台服务器的管理统计信息。
            # 某些命令必须在admin数据库下运行，如下两个命令：
            db.runCommand({"renameCollection" : 集合名, "to"：集合名})     # 对集合重命名，注意两个集合名都要是完整的集合命名空间，如foo.bar, 表示数据库foo下的集合bar。
            db.runCommand({"listDatabases" : 1})                           # 列出服务器上所有的数据库

        }

        七、进程控制{

            db.currentOp()                  # 查看活动进程
            db.$cmd.sys.inprog.findOne()    # 查看活动进程 与上面一样
                opid   # 操作进程号
                op     # 操作类型(查询\更新)
                ns     # 命名空间,指操作的是哪个对象
                query  # 如果操作类型是查询,这里将显示具体的查询内容
                lockType  # 锁的类型,指明是读锁还是写锁

            db.killOp(opid值)                         # 结束进程
            db.$cmd.sys.killop.findOne({op:opid值})   # 结束进程

        }

        八、备份还原{

            ./mongoexport -d test -c t1 -o t1.dat                 # 导出JSON格式
                -c         # 指明导出集合
                -d         # 使用库
            ./mongoexport -d test -c t1 -csv -f num -o t1.dat     # 导出csv格式
                -csv       # 指明导出csv格式
                -f         # 指明需要导出那些例

            db.t1.drop()                    # 登录后删除数据
            ./mongoimport -d test -c t1 -file t1.dat                           # mongoimport还原JSON格式
            ./mongoimport -d test -c t1 -type csv --headerline -file t1.dat    # mongoimport还原csv格式数据
                --headerline                # 指明不导入第一行 因为第一行是列名

            ./mongodump -d test -o /bak/mongodump                # mongodump数据备份
            ./mongorestore -d test --drop /bak/mongodump/*       # mongorestore恢复
                --drop      #恢复前先删除
            db.t1.find()    #查看

            # mongodump 虽然能不停机备份,但市区了获取实时数据视图的能力,使用fsync命令能在运行时复制数据目录并且不会损坏数据
            # fsync会强制服务器将所有缓冲区的数据写入磁盘.配合lock还阻止对数据库的进一步写入,知道释放锁为止
            # 备份在从库上备份，不耽误读写还能保证实时快照备份
            db.runCommand({"fsync":1,"lock":1})   # 执行强制更新与写入锁
            db.$cmd.sys.unlock.findOne()          # 解锁
            db.currentOp()                        # 查看解锁是否正常

        }

        九、修复{

            # 当停电或其他故障引起不正常关闭时,会造成部分数据损坏丢失
            ./mongod --repair      # 修复操作:启动时候加上 --repair
            # 修复过程:将所有文档导出,然后马上导入,忽略无效文档.完成后重建索引。时间较长,会丢弃损坏文档
            # 修复数据还能起到压缩数据库的作用
            db.repairDatabase()    # 运行中的mongodb可使用 repairDatabase 修复当前使用的数据库
            {"repairDatabase":1}   # 通过驱动程序

        }

        十、python使用mongodb{

            原文: http://blog.nosqlfan.com/html/2989.html

            easy_install pymongo      # 安装(python2.7+)
            import pymongo
            connection=pymongo.Connection('localhost',27017)   # 创建连接
            db = connection.test_database                      # 切换数据库
            collection = db.test_collection                    # 获取collection
            # db和collection都是延时创建的，在添加Document时才真正创建

            文档添加, _id自动创建
                import datetime
                post = {"author": "Mike",
                    "text": "My first blog post!",
                    "tags": ["mongodb", "python", "pymongo"],
                    "date": datetime.datetime.utcnow()}
                posts = db.posts
                posts.insert(post)
                ObjectId('...')

            批量插入
                new_posts = [{"author": "Mike",
                    "text": "Another post!",
                    "tags": ["bulk", "insert"],
                    "date": datetime.datetime(2009, 11, 12, 11, 14)},
                    {"author": "Eliot",
                    "title": "MongoDB is fun",
                    "text": "and pretty easy too!",
                    "date": datetime.datetime(2009, 11, 10, 10, 45)}]
                posts.insert(new_posts)
                [ObjectId('...'), ObjectId('...')]

            获取所有collection
                db.collection_names()    # 相当于SQL的show tables

            获取单个文档
                posts.find_one()

            查询多个文档
                for post in posts.find():
                    post

            加条件的查询
                posts.find_one({"author": "Mike"})

            高级查询
                posts.find({"date": {"$lt": "d"}}).sort("author")

            统计数量
                posts.count()

            加索引
                from pymongo import ASCENDING, DESCENDING
                posts.create_index([("date", DESCENDING), ("author", ASCENDING)])

            查看查询语句的性能
                posts.find({"date": {"$lt": "d"}}).sort("author").explain()["cursor"]
                posts.find({"date": {"$lt": "d"}}).sort("author").explain()["nscanned"]

        }

    }

    JDK安装{

        chmod 744 jdk-1.7.0_79-linux-i586.bin
        ./jdk-1.7.0_79-linux-i586.bin
        vi /etc/profile   # 添加环境变量
        JAVA_HOME=/usr/java/jdk1.7.0_79
        CLASSPATH=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/tools.jar
        PATH=$JAVA_HOME/bin:$PATH
        export JAVA_HOME PATH CLASSPATH

        . /etc/profile    # 加载新的环境变量
        jps -ml           # 查看java进程
    }

    redis动态加内存{

        ./redis-cli -h 10.10.10.11 -p 6401
        save                                # 保存当前快照
        config get *                        # 列出所有当前配置
        config get maxmemory                # 查看指定配置
        config set maxmemory  15360000000   # 动态修改最大内存配置参数

    }

    nfs{

        # 依赖rpc服务通信 portmap[centos5] 或 rpcbind[centos6]
        yum install nfs-utils portmap    # centos5安装
        yum install nfs-utils rpcbind    # centos6安装

        vim /etc/exports                 # 配置文件
        # sync                           # 同步写入
        # async                          # 暂存并非直接写入
        # no_root_squash                 # 开放用户端使用root身份操作
        # root_squash                    # 使用者身份为root则被压缩成匿名使用,即nobody,相对安全
        # all_squash                     # 所有NFS的使用者身份都被压缩为匿名
        /data/images 10.10.10.0/24(rw,sync,no_root_squash)

        service  portmap restart         # 重启centos5的nfs依赖的rpc服务
        service  rpcbind restart         # 重启centos6的nfs依赖的rpc服务
        service  nfs restart             # 重启nfs服务  确保依赖 portmap 或 rpcbind 服务已启动
        service  nfs reload              # 重载NFS服务配置文件
        showmount -e                     # 服务端查看自己共享的服务
        showmount -a                     # 显示已经与客户端连接上的目录信息
        showmount -e 10.10.10.3          # 列出服务端可供使用的NFS共享  客户端测试能否访问nfs服务
        mount -t nfs 10.10.10.3:/data/images/  /data/img   # 挂载nfs  如果延迟影响大加参数 noac

        # 服务端的 portmap 或 rpcbind 被停止后，nfs仍然工作正常，但是umout财会提示： not found / mounted or server not reachable  重启服务器的portmap 或 rpcbind 也无济于事。 nfs也要跟着重启，否则nfs工作仍然是不正常的。
        # 同时已挂载会造成NFS客户端df卡住和挂载目录无法访问。请先用 mount 查看当前挂载情况，记录挂载信息，在强制卸载挂载目录，重新挂载
        umount -f /data/img/             # 强制卸载挂载目录  如还不可以  umount -l /data/img/

        nfsstat -c                       # 客户机发送和拒绝的RPC和NFS调用数目的信息
        nfsstat -cn                      # 显示和打印与客户机NFS调用相关的信息
        nfsstat -r                       # 显示和打印客户机和服务器的与RPC调用相关的信息
        nfsstat –s                       # 显示关于服务器接收和拒绝的RPC和NFS调用数目的信息

    }

    hdfs{
        hdfs --help                  # 所有参数

        hdfs dfs -help               # 运行文件系统命令在Hadoop文件系统
        hdfs dfs -ls /logs           # 查看
        hdfs dfs -ls /user/          # 查看用户
        hdfs dfs -cat
        hdfs dfs -df
        hdfs dfs -du
        hdfs dfs -rm
        hdfs dfs -tail
        hdfs dfs –put localSrc dest  # 上传文件

        hdfs dfsadmin -help          # hdfs集群节点管理
        hdfs dfsadmin -report        # 基本的文件系统统计信息
    }

}
