9 实例{

    从1叠加到100{

        echo $[$(echo +{1..100})]
        echo $[(100+1)*(100/2)]
        seq -s '+' 100 |bc

    }

    判断参数是否为空-空退出并打印null{

        #!/bin/sh
        echo $1
        name=${1:?"null"}
        echo $name

    }

    循环数组{

        for ((i=0;i<${#o[*]};i++))
        do
            echo ${o[$i]}
        done

    }

    判断路径{

        if [ -d /root/Desktop/text/123 ];then
            echo "找到了123"
            if [ -d /root/Desktop/text ]
            then echo "找到了text"
            else echo "没找到text"
            fi
        else echo "没找到123文件夹"
        fi

    }

    找出出现次数最多{

        awk '{print $1}' file|sort |uniq -c|sort -k1r

    }

    判断脚本参数是否正确{

        ./test.sh  -p 123 -P 3306 -h 127.0.0.1 -u root
        #!/bin/sh
        if [ $# -ne 8 ];then
            echo "USAGE: $0 -u user -p passwd -P port -h host"
            exit 1
        fi

        while getopts :u:p:P:h: name
        do
            case $name in
            u)
                mysql_user=$OPTARG
            ;;
            p)
                mysql_passwd=$OPTARG
            ;;
            P)
                mysql_port=$OPTARG
            ;;
            h)
                mysql_host=$OPTARG
            ;;
            *)
                echo "USAGE: $0 -u user -p passwd -P port -h host"
                exit 1
            ;;
            esac
        done

        if [ -z $mysql_user ] || [ -z $mysql_passwd ] || [ -z $mysql_port ] || [ -z $mysql_host ]
        then
            echo "USAGE: $0 -u user -p passwd -P port -h host"
            exit 1
        fi

        echo $mysql_user $mysql_passwd $mysql_port  $mysql_host
        #结果 root 123 3306 127.0.0.1

    }

    正则匹配邮箱{

        ^[_a-z0-9-]+(\.[_a-z0-9-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,4})$

    }

    打印表格{

        #!/bin/sh
        clear
        awk 'BEGIN{
        print "+--------------------+--------------------+";
        printf "|%-20s|%-20s|\n","Name","Number";
        print "+--------------------+--------------------+";
        }'
        a=`grep "^[A-Z]" a.txt |sort +1 -n |awk '{print $1":"$2}'`
        #cat a.txt |sort +1 -n |while read list
        for list in $a
        do
            name=`echo $list |awk -F: '{print $1}'`
            number=`echo $list |awk -F: '{print $2}'`
            awk 'BEGIN{printf "|%-20s|%-20s|\n","'"$name"'","'"$number"'";
            print "+--------------------+--------------------+";
            }'
        done
        awk 'BEGIN{
        print "              *** The End ***              "
        print "                                           "
        }'

    }

    判断日期是否合法{

        #!/bin/sh
        while read a
        do
          if echo $a | grep -q "-" && date -d $a +%Y%m%d > /dev/null 2>&1
          then
            if echo $a | grep -e '^[0-9]\{4\}-[01][0-9]-[0-3][0-9]$'
            then
                break
            else
                echo "您输入的日期不合法，请从新输入！"
            fi
          else
            echo "您输入的日期不合法，请从新输入！"
          fi
        done
        echo "日期为$a"

    }

    打印日期段所有日期{

        #!/bin/bash
        qsrq=20010101
        jsrq=20010227
        n=0
        >tmp
        while :;do
        current=$(date +%Y%m%d -d"$n day $qsrq")
        if [[ $current == $jsrq ]];then
            echo $current >>tmp;break
        else
            echo $current >>tmp
            ((n++))
        fi
        done
        rq=`awk 'NR==1{print}' tmp`

    }

    打印提示{

        cat <<EOF
        #内容
EOF

        }

    登陆远程执行命令{

        # 特殊符号需要 \ 转义
        ssh root@ip << EOF
        #执行命令
EOF

        }

    数学计算的小算法{

        #!/bin/sh
        A=1
        B=1
        while [ $A -le 10 ]
        do
            SUM=`expr $A \* $B`
            echo "$SUM"
            if [ $A = 10 ]
            then
                B=`expr $B + 1`
                A=1
            fi
            A=`expr $A + 1`
        done

    }

    多行合并{

        sed '{N;s/\n//}' file                   # 将两行合并一行(去掉换行符)
        awk '{printf(NR%2!=0)?$0" ":$0" \n"}'   # 将两行合并一行
        awk '{printf"%s ",$0}'                  # 将所有行合并
        awk '{if (NR%4==0){print $0} else {printf"%s ",$0}}' file    # 将4行合并为一行(可扩展)

    }

    横竖转换{

        cat a.txt | xargs           # 列转行
        cat a.txt | xargs -n1       # 行转列

    }

    竖行转横行{

        cat file|tr '\n' ' '
        echo $(cat file)

        #!/bin/sh
        for i in `cat file`
        do
              a=${a}" "${i}
        done
        echo $a

    }

    取用户的根目录{

        #! /bin/bash
        while read name pass uid gid gecos home shell
        do
            echo $home
        done < /etc/passwd

    }

    远程打包{

        ssh -n $ip 'find '$path' /data /opt -type f  -name "*.sh" -or -name "*.py" -or -name "*.pl" |xargs tar zcvpf /tmp/data_backup.tar.gz'

    }

    把汉字转成encode格式{

        echo 论坛 | tr -d "\n" | xxd -i | sed -e "s/ 0x/%/g" | tr -d " ,\n"
        %c2%db%cc%b3
        echo 论坛 | tr -d "\n" | xxd -i | sed -e "s/ 0x/%/g" | tr -d " ,\n" | tr "[a-f]" "[A-F]"  # 大写的
        %C2%DB%CC%B3

    }

    把目录带有大写字母的文件名改为全部小写{

        #!/bin/bash
        for f in *;do
            mv $f `echo $f |tr "[A-Z]" "[a-z]"`
        done

    }

    查找连续多行，在不连续的行前插入{

        #/bin/bash
        lastrow=null
        i=0
        cat incl|while read line
        do
        i=`expr $i + 1`
        if echo "$lastrow" | grep "#include <[A-Z].h>"
        then
            if echo "$line" | grep -v  "#include <[A-Z].h>"
            then
                sed -i ''$i'i\\/\/All header files are include' incl
                i=`expr $i + 1`
            fi
        fi
        lastrow="$line"
        done

    }

    查询数据库其它引擎{

        #/bin/bash
        path1=/data/mysql/data/
        dbpasswd=db123
        #MyISAM或InnoDB
        engine=InnoDB

        if [ -d $path1 ];then

        dir=`ls -p $path1 |awk '/\/$/'|awk -F'/' '{print $1}'`
            for db in $dir
            do
            number=`mysql -uroot -p$dbpasswd -A -S "$path1"mysql.sock -e "use ${db};show table status;" |grep -c $engine`
                if [ $number -ne 0 ];then
                echo "${db}"
                fi
            done
        fi

    }

    批量修改数据库引擎{

        #/bin/bash
        for db in test test1 test3
        do
            tables=`mysql -uroot -pdb123 -A -S /data/mysql/data/mysql.sock -e "use $db;show tables;" |awk 'NR != 1{print}'`

            for table in $tables
            do
                mysql -uroot -pdb123 -A -S /data/mysql/data/mysql.sock -e "use $db;alter table $table engine=MyISAM;"
            done
        done

    }

    将shell取到的数据插入mysql数据库{

        mysql -u$username -p$passwd -h$dbhost -P$dbport -A -e "
        use $dbname;
        insert into data values ('','$ip','$date','$time','$data')
        "

    }

    两日期间隔天数{

        D1=`date -d '20070409' +"%s"`
        D2=`date -d '20070304 ' +"%s"`
        D3=$(($D1 - $D2))
        echo $(($D3/60/60/24))

    }

    while执行ssh只循环一次{

        cat -    # 让cat读连接文件stdin的信息
        seq 10 | while read line; do ssh localhost "cat -"; done        # 显示的9次是被ssh吃掉的
        seq 10 | while read line; do ssh -n localhost "cat -"; done     # ssh加上-n参数可避免只循环一次

    }

    ssh批量执行命令{

        #版本1
        #!/bin/bash
        while read line
        do
        Ip=`echo $line|awk '{print $1}'`
        Passwd=`echo $line|awk '{print $2}'`
        ssh -n localhost "cat -"
        sshpass -p "$Passwd" ssh -n -t -o StrictHostKeyChecking=no root@$Ip "id"
        done<iplist.txt

        #版本2
        #!/bin/bash
        Iplist=`awk '{print $1}' iplist.txt`
        for Ip in $Iplist
        do
        Passwd=`awk '/'$Ip'/{print $2}' iplist.txt`
        sshpass -p "$Passwd" ssh -n -t -o StrictHostKeyChecking=no root@$Ip "id"
        done

    }

    在同一位置打印字符{

        #!/bin/bash
        echo -ne "\t"
        for i in `seq -w 100 -1 1`
        do
            echo -ne "$i\b\b\b";      # 关键\b退格
            sleep 1;
        done

    }

    多进程后台并发简易控制{

        #!/bin/bash
        test () {
            echo $a
            sleep 5
        }
        for a in `seq 1 30`
        do
            test &
            echo $!
            ((num++))
            if [ $num -eq 6 ];then
            echo "wait..."
            wait
            num=0
            fi
        done
        wait

    }

    shell并发{

        #!/bin/bash
        tmpfile=$$.fifo   # 创建管道名称
        mkfifo $tmpfile   # 创建管道
        exec 4<>$tmpfile  # 创建文件标示4，以读写方式操作管道$tmpfile
        rm $tmpfile       # 将创建的管道文件清除
        thred=4           # 指定并发个数
        seq=(1 2 3 4 5 6 7 8 9 21 22 23 24 25 31 32 33 34 35) # 创建任务列表

        # 为并发线程创建相应个数的占位
        {
        for (( i = 1;i<=${thred};i++ ))
        do
            echo;  # 因为read命令一次读取一行，一个echo默认输出一个换行符，所以为每个线程输出一个占位换行
        done
        } >&4      # 将占位信息写入管道

        for id in ${seq}  # 从任务列表 seq 中按次序获取每一个任务
        do
          read  # 读取一行，即fd4中的一个占位符
          (./ur_command ${id};echo >&4 ) &   # 在后台执行任务ur_command 并将任务 ${id} 赋给当前任务；任务执行完后在fd4种写入一个占位符
        done <&4    # 指定fd4为整个for的标准输入
        wait        # 等待所有在此shell脚本中启动的后台任务完成
        exec 4>&-   # 关闭管道

        #!/bin/bash

        FifoFile="$$.fifo"
        mkfifo $FifoFile
        exec 6<>$FifoFile
        rm $FifoFile
        for ((i=0;i<=20;i++));do echo;done >&6

        for u in `seq 1 $1`
        do
            read -u6
            {
                curl -s http://ch.com >>/dev/null
                [ $? -eq 0 ] && echo "${u} 次成功" || echo "${u} 次失败"
                echo >&6
            } &
        done
        wait
        exec 6>&-

    }

    shell并发函数{

        function ConCurrentCmd()
        {
            #进程数
            Thread=30

            #列表文件
            CurFileName=iplist.txt

            #定义fifo文件
            FifoFile="$$.fifo"

            #新建一个fifo类型的文件
            mkfifo $FifoFile

            #将fd6与此fifo类型文件以读写的方式连接起来
            exec 6<>$FifoFile
            rm $FifoFile

            #事实上就是在文件描述符6中放置了$Thread个回车符
            for ((i=0;i<=$Thread;i++));do echo;done >&6

            #此后标准输入将来自fd5
            exec 5<$CurFileName

            #开始循环读取文件列表中的行
            Count=0
            while read -u5 line
            do
                read -u6
                let Count+=1
                # 此处定义一个子进程放到后台执行
                # 一个read -u6命令执行一次,就从fd6中减去一个回车符，然后向下执行
                # fd6中没有回车符的时候,就停在这了,从而实现了进程数量控制
                {
                    echo $Count

                    #这段代码框就是执行具体的操作了
                    function

                    echo >&6
                    #当进程结束以后,再向fd6中追加一个回车符,即补上了read -u6减去的那个
                } &
            done

            #等待所有后台子进程结束
            wait

            #关闭fd6
            exec 6>&-

            #关闭fd5
            exec 5>&-
        }

        并发例子{

            #!/bin/bash

            FifoFile="$$.fifo"
            mkfifo $FifoFile
            exec 6<>$FifoFile
            rm $FifoFile
            for ((i=0;i<=20;i++));do echo;done >&6

            for u in `seq 1 $1`
            do
                read -u6
                {
                    curl -s http://m.chinanews.com/?tt_from=shownews >>/dev/null
                    [ $? -eq 0 ] && echo "${u} 次成功" || echo "${u} 次失败"
                    echo >&6
                } &
            done
            wait
            exec 6>&-

        }
    }

    函数{

        ip(){
            echo "a 1"|awk '$1=="'"$1"'"{print $2}'
        }
        web=a
        ip $web

    }

    检测软件包是否存在{

        rpm -q dialog >/dev/null
        if [ "$?" -ge 1 ];then
            echo "install dialog,Please wait..."
            yum -y install dialog
            rpm -q dialog >/dev/null
            [ $? -ge 1 ] && echo "dialog installation failure,exit" && exit
            echo "dialog done"
            read
        fi

    }

    游戏维护菜单-修改配置文件{

        #!/bin/bash

        conf=serverlist.xml
        AreaList=`awk -F '"' '/<s/{print $2}' $conf`

        select area in $AreaList 全部 退出
        do
            echo ""
            echo $area
            case $area in
            退出)
                exit
            ;;
            *)
                select operate in "修改版本号" "添加维护中" "删除维护中" "返回菜单"
                do
                    echo ""
                    echo $operate
                    case $operate in
                    修改版本号)
                        echo 请输入版本号
                        while read version
                        do
                            if echo $version | grep -w 10[12][0-9][0-9][0-9][0-9][0-9][0-9]
                            then
                                break
                            fi
                            echo 请从新输入正确的版本号
                        done
                        case $area in
                        全部)
                            case $version in
                            101*)
                                echo "请确认操作对 $area 体验区 $operate"
                                read
                                sed -i 's/101[0-9][0-9][0-9][0-9][0-9][0-9]/'$version'/' $conf
                            ;;
                            102*)
                                echo "请确认操作对 $area 正式区 $operate"
                                read
                                sed -i 's/102[0-9][0-9][0-9][0-9][0-9][0-9]/'$version'/' $conf
                            ;;
                            esac
                        ;;
                        *)
                            type=`awk -F '"' '/'$area'/{print $14}' $conf |cut -c1-3`
                            readtype=`echo $version |cut -c1-3`
                            if [ $type != $readtype ]
                            then
                                echo "版本号不对应，请从新操作"
                                continue
                            fi

                            echo "请确认操作对 $area 区 $operate"
                            read

                            awk -F '"' '/'$area'/{print $12}' $conf |xargs -i sed -i '/'{}'/s/10[12][0-9][0-9][0-9][0-9][0-9][0-9]/'$version'/' $conf
                        ;;
                        esac
                    ;;
                    添加维护中)
                        case $area in
                        全部)
                            echo "请确认操作对 $area 区 $operate"
                            read
                            awk -F '"' '/<s/{print $2}' $conf |xargs -i sed -i 's/'{}'/&维护中/' $conf
                        ;;
                        *)
                            echo "请确认操作对 $area 区 $operate"
                            read
                            sed -i 's/'$area'/&维护中/' $conf
                        ;;
                        esac
                    ;;
                    删除维护中)
                        case $area in
                        全部)
                            echo "请确认操作对 $area 区 $operate"
                            read
                            sed -i 's/维护中//' $conf
                        ;;
                        *)
                            echo "请确认操作对 $area 区 $operate"
                            read
                            sed -i '/'$area'/s/维护中//' $conf
                        ;;
                        esac
                    ;;
                    返回菜单)
                        break
                    ;;
                    esac
                done
            ;;
            esac
            echo "回车重新选择区"
        done

    }

    keepalive剔除后端服务{

        #!/bin/bash
        #行数请自定义,默认8行
        if [ X$2 == X ];then
            echo "error: IP null"
            read
            exit
        fi
        case $1 in
        del)
            sed -i '/real_server.*'$2'.*8888/,+8 s/^/#/' /etc/keepalived/keepalived.conf
            /etc/init.d/keepalived reload
        ;;
        add)
            sed -i '/real_server.*'$2'.*8888/,+8 s/^#//' /etc/keepalived/keepalived.conf
            /etc/init.d/keepalived reload
        ;;
        *)
            echo "Parameter error"
        ;;
        esac

    }

    申诉中国反垃圾邮件联盟黑名单{

        #!/bin/bash

        IpList=`awk '$1!~"^#"&&$1!=""{print $1}' host.list`

        QueryAdd='http://www.anti-spam.org.cn/Rbl/Query/Result'
        ComplaintAdd='http://www.anti-spam.org.cn/Rbl/Getout/Submit'

        CONTENT='我们是一家正规的XXX。xxxxxxx。恳请将我们的发送服务器IP移出黑名单。谢谢！
        处理措施：
        1.XXXX。
        2.XXXX。'
        CORP='abc.com'
        WWW='www.abc.cm'
        NAME='def'
        MAIL='def@163.com.cn'
        TEL='010-50000000'
        LEVEL='0'

        for Ip in $IpList
        do
            Status=`curl -d "IP=$Ip" $QueryAdd |grep 'Getout/ShowForm?IP=' |grep -wc '申诉脱离'`
            if [ $Status -ge 1 ];then
                IpStatus="黑名单中"
                results=`curl -d "IP=${Ip}&CONTENT=${CONTENT}&CORP=${CORP}&WWW=${WWW}&NAME=${NAME}&MAIL=${MAIL}&TEL=${TEL}&LEVEL=${LEVEL}" $ComplaintAdd |grep -E '您的黑名单脱离申请已提交|该IP的脱离申请已被他人提交|申请由于近期内有被拒绝的记录'`
                echo $results
                if echo $results | grep '您的黑名单脱离申请已提交'  > /dev/null 2>&1
                then
                    complaint='申诉成功'
                elif echo $results | grep '该IP的脱离申请已被他人提交'  > /dev/null 2>&1
                then
                    complaint='申诉重复'
                elif echo $results | grep '申请由于近期内有被拒绝的记录'  > /dev/null 2>&1
                then
                    complaint='申诉拒绝'
                else
                    complaint='异常'
                fi
            else
                IpStatus='正常'
                complaint='无需申诉'
            fi
            echo "$Ip    $IpStatus    $complaint" >> $(date +%Y%m%d_%H%M%S).log
        done

}

    Web Server in Awk{

        #gawk -f file
        BEGIN {
          x        = 1                         # script exits if x < 1
          port     = 8080                      # port number
          host     = "/inet/tcp/" port "/0/0"  # host string
          url      = "http://localhost:" port  # server url
          status   = 200                       # 200 == OK
          reason   = "OK"                      # server response
          RS = ORS = "\r\n"                    # header line terminators
          doc      = Setup()                   # html document
          len      = length(doc) + length(ORS) # length of document
          while (x) {
             if ($1 == "GET") RunApp(substr($2, 2))
             if (! x) break
             print "HTTP/1.0", status, reason |& host
             print "Connection: Close"        |& host
             print "Pragma: no-cache"         |& host
             print "Content-length:", len     |& host
             print ORS doc                    |& host
             close(host)     # close client connection
             host |& getline # wait for new client request
          }
          # server terminated...
          doc = Bye()
          len = length(doc) + length(ORS)
          print "HTTP/1.0", status, reason |& host
          print "Connection: Close"        |& host
          print "Pragma: no-cache"         |& host
          print "Content-length:", len     |& host
          print ORS doc                    |& host
          close(host)
        }

        function Setup() {
          tmp = "<html>\
          <head><title>Simple gawk server</title></head>\
          <body>\
          <p><a href=" url "/xterm>xterm</a>\
          <p><a href=" url "/xcalc>xcalc</a>\
          <p><a href=" url "/xload>xload</a>\
          <p><a href=" url "/exit>terminate script</a>\
          </body>\
          </html>"
          return tmp
        }

        function Bye() {
          tmp = "<html>\
          <head><title>Simple gawk server</title></head>\
          <body><p>Script Terminated...</body>\
          </html>"
          return tmp
        }

        function RunApp(app) {
          if (app == "xterm")  {system("xterm&"); return}
          if (app == "xcalc" ) {system("xcalc&"); return}
          if (app == "xload" ) {system("xload&"); return}
          if (app == "exit")   {x = 0}
        }

    }

}
