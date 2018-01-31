3 系统{

    wall        　  　           # 给其它用户发消息
    whereis ls                  # 查找命令的目录
    which                       # 查看当前要执行的命令所在的路径
    clear                       # 清空整个屏幕
    reset                       # 重新初始化屏幕
    cal                         # 显示月历
    echo -n 123456 | md5sum     # md5加密
    mkpasswd                    # 随机生成密码   -l位数 -C大小 -c小写 -d数字 -s特殊字符
    netstat -ntupl | grep port  # 是否打开了某个端口
    ntpdate cn.pool.ntp.org     # 同步时间, pool.ntp.org: public ntp time server for everyone(http://www.pool.ntp.org/zh/)
    tzselect                    # 选择时区 #+8=(5 9 1 1) # (TZ='Asia/Shanghai'; export TZ)括号内写入 /etc/profile
    /sbin/hwclock -w            # 时间保存到硬件
    /etc/shadow                 # 账户影子文件
    LANG=en                     # 修改语言
    vim /etc/sysconfig/i18n     # 修改编码  LANG="en_US.UTF-8"
    export LC_ALL=C             # 强制字符集
    vi /etc/hosts               # 查询静态主机名
    alias                       # 别名
    watch uptime                # 监测命令动态刷新 监视
    ipcs -a                     # 查看Linux系统当前单个共享内存段的最大值
    ldconfig                    # 动态链接库管理命令
    ldd `which cmd`             # 查看命令的依赖库
    dist-upgrade                # 会改变配置文件,改变旧的依赖关系，改变系统版本
    /boot/grub/grub.conf        # grub启动项配置
    ps -mfL <PID>               # 查看指定进程启动的线程 线程数受 max user processes 限制
    ps uxm |wc -l               # 查看当前用户占用的进程数 [包括线程]  max user processes
    top -p  PID -H              # 查看指定PID进程及线程
    lsof |wc -l                 # 查看当前文件句柄数使用数量  open files
    lsof |grep /lib             # 查看加载库文件
    sysctl -a                   # 查看当前所有系统内核参数
    sysctl -p                   # 修改内核参数/etc/sysctl.conf，让/etc/rc.d/rc.sysinit读取生效
    strace -p pid               # 跟踪系统调用
    ps -eo "%p %C  %z  %a"|sort -k3 -n            # 把进程按内存使用大小排序
    strace uptime 2>&1|grep open                  # 查看命令打开的相关文件
    grep Hugepagesize /proc/meminfo               # 内存分页大小
    mkpasswd -l 8  -C 2 -c 2 -d 4 -s 0            # 随机生成指定类型密码
    echo 1 > /proc/sys/net/ipv4/tcp_syncookies    # 使TCP SYN Cookie 保护生效  # "SYN Attack"是一种拒绝服务的攻击方式
    grep Swap  /proc/25151/smaps |awk '{a+=$2}END{print a}'    # 查询某pid使用的swap大小
    redir --lport=33060 --caddr=10.10.10.78 --cport=3306       # 端口映射 yum安装 用supervisor守护

    开机启动脚本顺序{

        /etc/profile
        /etc/profile.d/*.sh
        ~/bash_profile
        ~/.bashrc
        /etc/bashrc

    }

    进程管理{

        ps -eaf               # 查看所有进程
        kill -9 PID           # 强制终止某个PID进程
        kill -15 PID          # 安全退出 需程序内部处理信号
        cmd &                 # 命令后台运行
        nohup cmd &           # 后台运行不受shell退出影响
        ctrl+z                # 将前台放入后台(暂停)
        jobs                  # 查看后台运行程序
        bg 2                  # 启动后台暂停进程
        fg 2                  # 调回后台进程
        pstree                # 进程树
        vmstat 1 9            # 每隔一秒报告系统性能信息9次
        sar                   # 查看cpu等状态
        lsof file             # 显示打开指定文件的所有进程
        lsof -i:32768         # 查看端口的进程
        renice +1 180         # 把180号进程的优先级加1

        ps{

            ps aux |grep -v USER | sort -nk +4 | tail       # 显示消耗内存最多的10个运行中的进程，以内存使用量排序.cpu +3
            # USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
            %CPU     # 进程的cpu占用率
            %MEM     # 进程的内存占用率
            VSZ      # 进程虚拟大小,单位K(即总占用内存大小,包括真实内存和虚拟内存)
            RSS      # 进程使用的驻留集大小即实际物理内存大小
            START    # 进程启动时间和日期
            占用的虚拟内存大小 = VSZ - RSS

            ps -eo pid,lstart,etime,args         # 查看进程启动时间

        }

        top{

            前五行是系统整体的统计信息。
            第一行: 任务队列信息，同 uptime 命令的执行结果。内容如下：
                01:06:48 当前时间
                up 1:22 系统运行时间，格式为时:分
                1 user 当前登录用户数
                load average: 0.06, 0.60, 0.48 系统负载，即任务队列的平均长度。
                三个数值分别为 1分钟、5分钟、15分钟前到现在的平均值。

            第二、三行:为进程和CPU的信息。当有多个CPU时，这些内容可能会超过两行。内容如下：
                Tasks: 29 total 进程总数
                1 running 正在运行的进程数
                28 sleeping 睡眠的进程数
                0 stopped 停止的进程数
                0 zombie 僵尸进程数
                Cpu(s): 0.3% us 用户空间占用CPU百分比
                1.0% sy 内核空间占用CPU百分比
                0.0% ni 用户进程空间内改变过优先级的进程占用CPU百分比
                98.7% id 空闲CPU百分比
                0.0% wa 等待输入输出的CPU时间百分比
                0.0% hi
                0.0% si

            第四、五行:为内存信息。内容如下：
                Mem: 191272k total 物理内存总量
                173656k used 使用的物理内存总量
                17616k free 空闲内存总量
                22052k buffers 用作内核缓存的内存量
                Swap: 192772k total 交换区总量
                0k used 使用的交换区总量
                192772k free 空闲交换区总量
                123988k cached 缓冲的交换区总量。
                内存中的内容被换出到交换区，而后又被换入到内存，但使用过的交换区尚未被覆盖，
                该数值即为这些内容已存在于内存中的交换区的大小。
                相应的内存再次被换出时可不必再对交换区写入。

            进程信息区,各列的含义如下:  # 显示各个进程的详细信息

            序号 列名    含义
            a   PID      进程id
            b   PPID     父进程id
            c   RUSER    Real user name
            d   UID      进程所有者的用户id
            e   USER     进程所有者的用户名
            f   GROUP    进程所有者的组名
            g   TTY      启动进程的终端名。不是从终端启动的进程则显示为 ?
            h   PR       优先级
            i   NI       nice值。负值表示高优先级，正值表示低优先级
            j   P        最后使用的CPU，仅在多CPU环境下有意义
            k   %CPU     上次更新到现在的CPU时间占用百分比
            l   TIME     进程使用的CPU时间总计，单位秒
            m   TIME+    进程使用的CPU时间总计，单位1/100秒
            n   %MEM     进程使用的物理内存百分比
            o   VIRT     进程使用的虚拟内存总量，单位kb。VIRT=SWAP+RES
            p   SWAP     进程使用的虚拟内存中，被换出的大小，单位kb。
            q   RES      进程使用的、未被换出的物理内存大小，单位kb。RES=CODE+DATA
            r   CODE     可执行代码占用的物理内存大小，单位kb
            s   DATA     可执行代码以外的部分(数据段+栈)占用的物理内存大小，单位kb
            t   SHR      共享内存大小，单位kb
            u   nFLT     页面错误次数
            v   nDRT     最后一次写入到现在，被修改过的页面数。
            w   S        进程状态。
                D=不可中断的睡眠状态
                R=运行
                S=睡眠
                T=跟踪/停止
                Z=僵尸进程 父进程在但并不等待子进程
            x   COMMAND  命令名/命令行
            y   WCHAN    若该进程在睡眠，则显示睡眠中的系统函数名
            z   Flags    任务标志，参考 sched.h

        }

        列出正在占用swap的进程{

            #!/bin/bash
            echo -e "PID\t\tSwap\t\tProc_Name"
            # 拿出/proc目录下所有以数字为名的目录（进程名是数字才是进程，其他如sys,net等存放的是其他信息）
            for pid in `ls -l /proc | grep ^d | awk '{ print $9 }'| grep -v [^0-9]`
            do
                # 让进程释放swap的方法只有一个：就是重启该进程。或者等其自动释放。放
                # 如果进程会自动释放，那么我们就不会写脚本来找他了，找他都是因为他没有自动释放。
                # 所以我们要列出占用swap并需要重启的进程，但是init这个进程是系统里所有进程的祖先进程
                # 重启init进程意味着重启系统，这是万万不可以的，所以就不必检测他了，以免对系统造成影响。
                if [ $pid -eq 1 ];then continue;fi
                grep -q "Swap" /proc/$pid/smaps 2>/dev/null
                if [ $? -eq 0 ];then
                    swap=$(grep Swap /proc/$pid/smaps \
                        | gawk '{ sum+=$2;} END{ print sum }')
                    proc_name=$(ps aux | grep -w "$pid" | grep -v grep \
                        | awk '{ for(i=11;i<=NF;i++){ printf("%s ",$i); }}')
                    if [ $swap -gt 0 ];then
                        echo -e "${pid}\t${swap}\t${proc_name}"
                    fi
                fi
            done | sort -k2 -n | awk -F'\t' '{
                pid[NR]=$1;
                size[NR]=$2;
                name[NR]=$3;
            }
            END{
                for(id=1;id<=length(pid);id++)
                {
                    if(size[id]<1024)
                        printf("%-10s\t%15sKB\t%s\n",pid[id],size[id],name[id]);
                    else if(size[id]<1048576)
                        printf("%-10s\t%15.2fMB\t%s\n",pid[id],size[id]/1024,name[id]);
                    else
                        printf("%-10s\t%15.2fGB\t%s\n",pid[id],size[id]/1048576,name[id]);
                }
            }'

        }

        linux操作系统提供的信号{

            kill -l                    # 查看linux提供的信号
            trap "echo aaa"  2 3 15    # shell使用 trap 捕捉退出信号

            # 发送信号一般有两种原因:
            #   1(被动式)  内核检测到一个系统事件.例如子进程退出会像父进程发送SIGCHLD信号.键盘按下control+c会发送SIGINT信号
            #   2(主动式)  通过系统调用kill来向指定进程发送信号
            # 进程结束信号 SIGTERM 和 SIGKILL 的区别:  SIGTERM 比较友好，进程能捕捉这个信号，根据您的需要来关闭程序。在关闭程序之前，您可以结束打开的记录文件和完成正在做的任务。在某些情况下，假如进程正在进行作业而且不能中断，那么进程可以忽略这个SIGTERM信号。
            # 如果一个进程收到一个SIGUSR1信号，然后执行信号绑定函数，第二个SIGUSR2信号又来了，第一个信号没有被处理完毕的话，第二个信号就会丢弃。

            SIGHUP  1          A     # 终端挂起或者控制进程终止
            SIGINT  2          A     # 键盘终端进程(如control+c)
            SIGQUIT 3          C     # 键盘的退出键被按下
            SIGILL  4          C     # 非法指令
            SIGABRT 6          C     # 由abort(3)发出的退出指令
            SIGFPE  8          C     # 浮点异常
            SIGKILL 9          AEF   # Kill信号  立刻停止
            SIGSEGV 11         C     # 无效的内存引用
            SIGPIPE 13         A     # 管道破裂: 写一个没有读端口的管道
            SIGALRM 14         A     # 闹钟信号 由alarm(2)发出的信号
            SIGTERM 15         A     # 终止信号,可让程序安全退出 kill -15
            SIGUSR1 30,10,16   A     # 用户自定义信号1
            SIGUSR2 31,12,17   A     # 用户自定义信号2
            SIGCHLD 20,17,18   B     # 子进程结束自动向父进程发送SIGCHLD信号
            SIGCONT 19,18,25         # 进程继续（曾被停止的进程）
            SIGSTOP 17,19,23   DEF   # 终止进程
            SIGTSTP 18,20,24   D     # 控制终端（tty）上按下停止键
            SIGTTIN 21,21,26   D     # 后台进程企图从控制终端读
            SIGTTOU 22,22,27   D     # 后台进程企图从控制终端写

            缺省处理动作一项中的字母含义如下:
                A  缺省的动作是终止进程
                B  缺省的动作是忽略此信号，将该信号丢弃，不做处理
                C  缺省的动作是终止进程并进行内核映像转储(dump core),内核映像转储是指将进程数据在内存的映像和进程在内核结构中的部分内容以一定格式转储到文件系统，并且进程退出执行，这样做的好处是为程序员提供了方便，使得他们可以得到进程当时执行时的数据值，允许他们确定转储的原因，并且可以调试他们的程序。
                D  缺省的动作是停止进程，进入停止状况以后还能重新进行下去，一般是在调试的过程中（例如ptrace系统调用）
                E  信号不能被捕获
                F  信号不能被忽略
        }

        系统性能状态{

            vmstat 1 9

            r      # 等待执行的任务数。当这个值超过了cpu线程数，就会出现cpu瓶颈。
            b      # 等待IO的进程数量,表示阻塞的进程。
            swpd   # 虚拟内存已使用的大小，如大于0，表示机器物理内存不足，如不是程序内存泄露，那么该升级内存。
            free   # 空闲的物理内存的大小
            buff   # 已用的buff大小，对块设备的读写进行缓冲
            cache  # cache直接用来记忆我们打开的文件,给文件做缓冲，(把空闲的物理内存的一部分拿来做文件和目录的缓存，是为了提高 程序执行的性能，当程序使用内存时，buffer/cached会很快地被使用。)
            inact  # 非活跃内存大小，即被标明可回收的内存，区别于free和active -a选项时显示
            active # 活跃的内存大小 -a选项时显示
            si   # 每秒从磁盘读入虚拟内存的大小，如果这个值大于0，表示物理内存不够用或者内存泄露，要查找耗内存进程解决掉。
            so   # 每秒虚拟内存写入磁盘的大小，如果这个值大于0，同上。
            bi   # 块设备每秒接收的块数量，这里的块设备是指系统上所有的磁盘和其他块设备，默认块大小是1024byte
            bo   # 块设备每秒发送的块数量，例如读取文件，bo就要大于0。bi和bo一般都要接近0，不然就是IO过于频繁，需要调整。
            in   # 每秒CPU的中断次数，包括时间中断。in和cs这两个值越大，会看到由内核消耗的cpu时间会越多
            cs   # 每秒上下文切换次数，例如我们调用系统函数，就要进行上下文切换，线程的切换，也要进程上下文切换，这个值要越小越好，太大了，要考虑调低线程或者进程的数目,例如在apache和nginx这种web服务器中，我们一般做性能测试时会进行几千并发甚至几万并发的测试，选择web服务器的进程可以由进程或者线程的峰值一直下调，压测，直到cs到一个比较小的值，这个进程和线程数就是比较合适的值了。系统调用也是，每次调用系统函数，我们的代码就会进入内核空间，导致上下文切换，这个是很耗资源，也要尽量避免频繁调用系统函数。上下文切换次数过多表示你的CPU大部分浪费在上下文切换，导致CPU干正经事的时间少了，CPU没有充分利用。
            us   # 用户进程执行消耗cpu时间(user time)  us的值比较高时，说明用户进程消耗的cpu时间多，但是如果长期超过50%的使用，那么我们就该考虑优化程序算法或其他措施
            sy   # 系统CPU时间，如果太高，表示系统调用时间长，例如是IO操作频繁。
            id   # 空闲 CPU时间，一般来说，id + us + sy = 100,一般认为id是空闲CPU使用率，us是用户CPU使用率，sy是系统CPU使用率。
            wt   # 等待IOCPU时间。Wa过高时，说明io等待比较严重，这可能是由于磁盘大量随机访问造成的，也有可能是磁盘的带宽出现瓶颈。

            如果 r 经常大于4，且id经常少于40，表示cpu的负荷很重。
            如果 pi po 长期不等于0，表示内存不足。
            如果 b 队列经常大于3，表示io性能不好。

        }

    }

    日志管理{

        history                      # 历时命令默认1000条
        HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "   # 让history命令显示具体时间
        history  -c                  # 清除记录命令
        cat $HOME/.bash_history      # 历史命令记录文件
        lastb -a                     # 列出登录系统失败的用户相关信息  清空二进制日志记录文件 echo > /var/log/btmp
        last                         # 查看登陆过的用户信息  清空二进制日志记录文件 echo > /var/log/wtmp   默认打开乱码
        who /var/log/wtmp            # 查看登陆过的用户信息
        lastlog                      # 用户最后登录的时间
        tail -f /var/log/messages    # 系统日志
        tail -f /var/log/secure      # ssh日志

    }

    selinux{

        sestatus -v                    # 查看selinux状态
        getenforce                     # 查看selinux模式
        setenforce 0                   # 设置selinux为宽容模式(可避免阻止一些操作)
        semanage port -l               # 查看selinux端口限制规则
        semanage port -a -t http_port_t -p tcp 8000  # 在selinux中注册端口类型
        vi /etc/selinux/config         # selinux配置文件
        SELINUX=enfoceing              # 关闭selinux 把其修改为  SELINUX=disabled

    }

    查看剩余内存{

        free -m
        #-/+ buffers/cache:       6458       1649
        #6458M为真实使用内存  1649M为真实剩余内存(剩余内存+缓存+缓冲器)
        #linux会利用所有的剩余内存作为缓存，所以要保证linux运行速度，就需要保证内存的缓存大小

    }

    系统信息{

        uname -a              # 查看Linux内核版本信息
        cat /proc/version     # 查看内核版本
        cat /etc/issue        # 查看系统版本
        lsb_release -a        # 查看系统版本  需安装 centos-release
        locale -a             # 列出所有语系
        locale                # 当前环境变量中所有编码
        hwclock               # 查看时间
        who                   # 当前在线用户
        w                     # 当前在线用户
        whoami                # 查看当前用户名
        logname               # 查看初始登陆用户名
        uptime                # 查看服务器启动时间
        sar -n DEV 1 10       # 查看网卡网速流量
        dmesg                 # 显示开机信息
        lsmod                 # 查看内核模块

    }

    硬件信息{

        more /proc/cpuinfo                                       # 查看cpu信息
        lscpu                                                    # 查看cpu信息
        cat /proc/cpuinfo | grep name | cut -f2 -d: | uniq -c    # 查看cpu型号和逻辑核心数
        getconf LONG_BIT                                         # cpu运行的位数
        cat /proc/cpuinfo | grep 'physical id' |sort| uniq -c    # 物理cpu个数
        cat /proc/cpuinfo | grep flags | grep ' lm ' | wc -l     # 结果大于0支持64位
        cat /proc/cpuinfo|grep flags                             # 查看cpu是否支持虚拟化   pae支持半虚拟化  IntelVT 支持全虚拟化
        more /proc/meminfo                                       # 查看内存信息
        dmidecode                                                # 查看全面硬件信息
        dmidecode | grep "Product Name"                          # 查看服务器型号
        dmidecode | grep -P -A5 "Memory\s+Device" | grep Size | grep -v Range       # 查看内存插槽
        cat /proc/mdstat                                         # 查看软raid信息
        cat /proc/scsi/scsi                                      # 查看Dell硬raid信息(IBM、HP需要官方检测工具)
        lspci                                                    # 查看硬件信息
        lspci|grep RAID                                          # 查看是否支持raid
        lspci -vvv |grep Ethernet                                # 查看网卡型号
        lspci -vvv |grep Kernel|grep driver                      # 查看驱动模块
        modinfo tg2                                              # 查看驱动版本(驱动模块)
        ethtool -i em1                                           # 查看网卡驱动版本
        ethtool em1                                              # 查看网卡带宽

    }

    终端快捷键{

        Ctrl+A        　    # 行前
        Ctrl+E        　    # 行尾
        Ctrl+S        　    # 终端锁屏
        Ctrl+Q        　　  # 解锁屏
        Ctrl+D      　　    # 退出

    }

    开机启动模式{

        vi /etc/inittab
        id:3:initdefault:    # 3为多用户命令
        #ca::ctrlaltdel:/sbin/shutdown -t3 -r now   # 注释此行 禁止 ctrl+alt+del 关闭计算机

    }

    终端提示显示{

        echo $PS1                   # 环境变量控制提示显示
        PS1='[\u@ \H \w \A \@#]\$'
        PS1='[\u@\h \W]\$'
        export PS1='[\[\e[32m\]\[\e[31m\]\u@\[\e[36m\]\h \w\[\e[m\]]\$ '     # 高亮显示终端

    }

    定时任务{

        at 5pm + 3 days /bin/ls  # 单次定时任务 指定三天后下午5:00执行/bin/ls

        crontab -e               # 编辑周期任务
        #分钟  小时    天  月  星期   命令或脚本
        1,30  1-3/2    *   *   *      命令或脚本  >> file.log 2>&1
        echo "40 7 * * 2 /root/sh">>/var/spool/cron/root    # 直接将命令写入周期任务
        crontab -l                                          # 查看自动周期性任务
        crontab -r                                          # 删除自动周期性任务
        cron.deny和cron.allow                               # 禁止或允许用户使用周期任务
        service crond start|stop|restart                    # 启动自动周期性服务
        * * * * *  echo "d" >>d$(date +\%Y\%m\%d).log       # 让定时任务直接生成带日期的log  需要转义%

    }

    date{

        星期日[SUN] 星期一[MON] 星期二[TUE] 星期三[WED] 星期四[THU] 星期五[FRI] 星期六[SAT]
        一月[JAN] 二月[FEB] 三月[MAR] 四月[APR] 五月[MAY] 六月[JUN] 七月[JUL] 八月[AUG] 九月[SEP] 十月[OCT] 十一月[NOV] 十二月[DEC]

        date -s 20091112                     # 设日期
        date -s 18:30:50                     # 设时间
        date -d "7 days ago" +%Y%m%d         # 7天前日期
        date -d "5 minute ago" +%H:%M        # 5分钟前时间
        date -d "1 month ago" +%Y%m%d        # 一个月前
        date -d '1 days' +%Y-%m-%d           # 一天后
        date -d '1 hours' +%H:%M:%S          # 一小时后
        date +%Y-%m-%d -d '20110902'         # 日期格式转换
        date +%Y-%m-%d_%X                    # 日期和时间
        date +%N                             # 纳秒
        date -d "2012-08-13 14:00:23" +%s    # 换算成秒计算(1970年至今的秒数)
        date -d "@1363867952" +%Y-%m-%d-%T   # 将时间戳换算成日期
        date -d "1970-01-01 UTC 1363867952 seconds" +%Y-%m-%d-%T  # 将时间戳换算成日期
        date -d "`awk -F. '{print $1}' /proc/uptime` second ago" +"%Y-%m-%d %H:%M:%S"    # 格式化系统启动时间(多少秒前)

    }

    limits.conf{

        ulimit -SHn 65535  # 临时设置文件描述符大小 进程最大打开文件柄数 还有socket最大连接数, 等同配置 nofile
        ulimit -SHu 65535  # 临时设置用户最大进程数
        ulimit -a          # 查看

        /etc/security/limits.conf

        # 文件描述符大小  open files
        # lsof |wc -l   查看当前文件句柄数使用数量
        * soft nofile 16384         # 设置太大，进程使用过多会把机器拖死
        * hard nofile 32768

        # 用户最大进程数  max user processes
        # echo $((`ps uxm |wc -l`-`ps ux |wc -l`))  查看当前用户占用的进程数 [包括线程]
        user soft nproc 16384
        user hard nproc 32768

        # 如果/etc/security/limits.d/有配置文件，将会覆盖/etc/security/limits.conf里的配置
        # 即/etc/security/limits.d/的配置文件里就不要有同样的参量设置
        /etc/security/limits.d/90-nproc.conf    # centos6.3的默认这个文件会覆盖 limits.conf
        user soft nproc 16384
        user hard nproc 32768

        sysctl -p    # 修改配置文件后让系统生效

    }

    随机分配端口范围{

        # 本机连其它端口用的
        echo "10000 65535" > /proc/sys/net/ipv4/ip_local_port_range

    }

    百万长链接设置{

        # 内存消耗需要较大
        vim /root/.bash_profile
        # 添加如下2行,退出bash重新登陆
        # 一个进程不能使用超过NR_OPEN文件描述符
        echo 20000500 > /proc/sys/fs/nr_open
        # 当前用户最大文件数
        ulimit -n 10000000

    }

    libc.so故障修复{

        # 由于升级glibc导致libc.so不稳定,突然报错,幸好还有未退出的终端
        grep: error while loading shared libraries: /lib64/libc.so.6: ELF file OS ABI invalid

        # 看看当前系统有多少版本 libc.so
        ls /lib64/libc-[tab]

        # 更改环境变量指向其他 libc.so 文件测试
        export LD_PRELOAD=/lib64/libc-2.7.so    # 如果不改变LD_PRELOAD变量,ln不能用,需要使用 /sbin/sln 命令做链接

        # 当前如果好使了，在执行下面强制替换软链接。如不好使，测试其他版本的libc.so文件
        ln -f -s /lib64/libc-2.7.so /lib64/libc.so.6

    }

    sudo{

        echo myPassword | sudo -S ls /tmp  # 直接输入sudo的密码非交互,从标准输入读取密码而不是终端设备
        visudo                             # sudo命令权限添加  /etc/sudoers
        用户  别名(可用all)=NOPASSWD:命令1,命令2
        user  ALL=NOPASSWD:/bin/su         # 免root密码切换root身份
        wangming linuxfan=NOPASSWD:/sbin/apache start,/sbin/apache restart
        UserName ALL=(ALL) ALL
        UserName ALL=(ALL) NOPASSWD: ALL
        peterli        ALL=(ALL)       NOPASSWD:/sbin/service
        Defaults requiretty                # sudo不允许后台运行,注释此行既允许
        Defaults !visiblepw                # sudo不允许远程,去掉!既允许

    }

    grub开机启动项添加{

        vim /etc/grub.conf
        title ms-dos
        rootnoverify (hd0,0)
        chainloader +1

    }

    stty{

        #stty时一个用来改变并打印终端行设置的常用命令

        stty iuclc          # 在命令行下禁止输出大写
        stty -iuclc         # 恢复输出大写
        stty olcuc          # 在命令行下禁止输出小写
        stty -olcuc         # 恢复输出小写
        stty size           # 打印出终端的行数和列数
        stty eof "string"   # 改变系统默认ctrl+D来表示文件的结束
        stty -echo          # 禁止回显
        stty echo           # 打开回显
        stty -echo;read;stty echo;read  # 测试禁止回显
        stty igncr          # 忽略回车符
        stty -igncr         # 恢复回车符
        stty erase '#'      # 将#设置为退格字符
        stty erase '^?'     # 恢复退格字符

        定时输入{

            timeout_read(){
                timeout=$1
                old_stty_settings=`stty -g`　　# save current settings
                stty -icanon min 0 time 100　　# set 10seconds,not 100seconds
                eval read varname　　          # =read $varname
                stty "$old_stty_settings"　　  # recover settings
            }

            read -t 10 varname    # 更简单的方法就是利用read命令的-t选项

        }

        检测用户按键{

            #!/bin/bash
            old_tty_settings=$(stty -g)   # 保存老的设置(为什么?).
            stty -icanon
            Keypress=$(head -c1)          # 或者使用$(dd bs=1 count=1 2> /dev/null)
            echo "Key pressed was \""$Keypress"\"."
            stty "$old_tty_settings"      # 恢复老的设置.
            exit 0

        }

    }

    iptables{

        内建三个表：nat mangle 和 filter
        filter预设规则表，有INPUT、FORWARD 和 OUTPUT 三个规则链
        vi /etc/sysconfig/iptables    # 配置文件
        INPUT    # 进入
        FORWARD  # 转发
        OUTPUT   # 出去
        ACCEPT   # 将封包放行
        REJECT   # 拦阻该封包
        DROP     # 丢弃封包不予处理
        -A       # 在所选择的链(INPUT等)末添加一条或更多规则
        -D       # 删除一条
        -E       # 修改
        -p       # tcp、udp、icmp    0相当于所有all    !取反
        -P       # 设置缺省策略(与所有链都不匹配强制使用此策略)
        -s       # IP/掩码    (IP/24)    主机名、网络名和清楚的IP地址 !取反
        -j       # 目标跳转，立即决定包的命运的专用内建目标
        -i       # 进入的（网络）接口 [名称] eth0
        -o       # 输出接口[名称]
        -m       # 模块
        --sport  # 源端口
        --dport  # 目标端口

        iptables -F                        # 将防火墙中的规则条目清除掉  # 注意: iptables -P INPUT ACCEPT
        iptables-restore < 规则文件        # 导入防火墙规则
        /etc/init.d/iptables save          # 保存防火墙设置
        /etc/init.d/iptables restart       # 重启防火墙服务
        iptables -L -n                     # 查看规则
        iptables -t nat -nL                # 查看转发

        iptables实例{

            iptables -L INPUT                   # 列出某规则链中的所有规则
            iptables -X allowed                 # 删除某个规则链 ,不加规则链，清除所有非内建的
            iptables -Z INPUT                   # 将封包计数器归零
            iptables -N allowed                 # 定义新的规则链
            iptables -P INPUT DROP              # 定义过滤政策
            iptables -A INPUT -s 192.168.1.1    # 比对封包的来源IP   # ! 192.168.0.0/24  ! 反向对比
            iptables -A INPUT -d 192.168.1.1    # 比对封包的目的地IP
            iptables -A INPUT -i eth0           # 比对封包是从哪片网卡进入
            iptables -A FORWARD -o eth0         # 比对封包要从哪片网卡送出 eth+表示所有的网卡
            iptables -A INPUT -p tcp            # -p ! tcp 排除tcp以外的udp、icmp。-p all所有类型
            iptables -D INPUT 8                 # 从某个规则链中删除一条规则
            iptables -D INPUT --dport 80 -j DROP         # 从某个规则链中删除一条规则
            iptables -R INPUT 8 -s 192.168.0.1 -j DROP   # 取代现行规则
            iptables -I INPUT 8 --dport 80 -j ACCEPT     # 插入一条规则
            iptables -A INPUT -i eth0 -j DROP            # 其它情况不允许
            iptables -A INPUT -p tcp -s IP -j DROP       # 禁止指定IP访问
            iptables -A INPUT -p tcp -s IP --dport port -j DROP               # 禁止指定IP访问端口
            iptables -A INPUT -s IP -p tcp --dport port -j ACCEPT             # 允许在IP访问指定端口
            iptables -A INPUT -p tcp --dport 22 -j DROP                       # 禁止使用某端口
            iptables -A INPUT -i eth0 -p icmp -m icmp --icmp-type 8 -j DROP   # 禁止icmp端口
            iptables -A INPUT -i eth0 -p icmp -j DROP                         # 禁止icmp端口
            iptables -t filter -A INPUT -i eth0 -p tcp --syn -j DROP                  # 阻止所有没有经过你系统授权的TCP连接
            iptables -A INPUT -f -m limit --limit 100/s --limit-burst 100 -j ACCEPT   # IP包流量限制
            iptables -A INPUT -i eth0 -s 192.168.62.1/32 -p icmp -m icmp --icmp-type 8 -j ACCEPT  # 除192.168.62.1外，禁止其它人ping我的主机
            iptables -A INPUT -p tcp -m tcp --dport 80 -m state --state NEW -m recent --update --seconds 5 --hitcount 20 --rttl --name WEB --rsource -j DROP  # 可防御cc攻击(未测试)

        }

        iptables配置实例文件{

            # Generated by iptables-save v1.2.11 on Fri Feb  9 12:10:37 2007
            *filter
            :INPUT ACCEPT [637:58967]
            :FORWARD DROP [0:0]
            :OUTPUT ACCEPT [5091:1301533]
            # 允许的IP或IP段访问 建议多个
            -A INPUT -s 127.0.0.1 -p tcp -j ACCEPT
            -A INPUT -s 192.168.0.0/255.255.0.0 -p tcp -j ACCEPT
            # 开放对外开放端口
            -A INPUT -p tcp --dport 80 -j ACCEPT
            # 指定某端口针对IP开放
            -A INPUT -s 192.168.10.37 -p tcp --dport 22 -j ACCEPT
            # 拒绝所有协议(INPUT允许)
            -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,URG RST -j DROP
            # 允许已建立的或相关连的通行
            -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
            # 拒绝ping
            -A INPUT -p tcp -m tcp -j REJECT --reject-with icmp-port-unreachable
            COMMIT
            # Completed on Fri Feb  9 12:10:37 2007

        }

        iptables配置实例{

            # 允许某段IP访问任何端口
            iptables -A INPUT -s 192.168.0.3/24 -p tcp -j ACCEPT
            # 设定预设规则 (拒绝所有的数据包，再允许需要的,如只做WEB服务器.还是推荐三个链都是DROP)
            iptables -P INPUT DROP
            iptables -P FORWARD DROP
            iptables -P OUTPUT ACCEPT
            # 注意: 直接设置这三条会掉线
            # 开启22端口
            iptables -A INPUT -p tcp --dport 22 -j ACCEPT
            # 如果OUTPUT 设置成DROP的，要写上下面一条
            iptables -A OUTPUT -p tcp --sport 22 -j ACCEPT
            # 注:不写导致无法SSH.其他的端口一样,OUTPUT设置成DROP的话,也要添加一条链
            # 如果开启了web服务器,OUTPUT设置成DROP的话,同样也要添加一条链
            iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
            # 做WEB服务器,开启80端口 ,其他同理
            iptables -A INPUT -p tcp --dport 80 -j ACCEPT
            # 做邮件服务器,开启25,110端口
            iptables -A INPUT -p tcp --dport 110 -j ACCEPT
            iptables -A INPUT -p tcp --dport 25 -j ACCEPT
            # 允许icmp包通过,允许ping
            iptables -A OUTPUT -p icmp -j ACCEPT (OUTPUT设置成DROP的话)
            iptables -A INPUT -p icmp -j ACCEPT  (INPUT设置成DROP的话)
            # 允许loopback!(不然会导致DNS无法正常关闭等问题)
            IPTABLES -A INPUT -i lo -p all -j ACCEPT (如果是INPUT DROP)
            IPTABLES -A OUTPUT -o lo -p all -j ACCEPT(如果是OUTPUT DROP)

        }

        centos6的iptables基本配置{
            *filter
            :INPUT ACCEPT [0:0]
            :FORWARD ACCEPT [0:0]
            :OUTPUT ACCEPT [0:0]
            -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
            -A INPUT -p icmp -j ACCEPT
            -A INPUT -i lo -j ACCEPT
            -A INPUT -s 222.186.135.61 -p tcp -j ACCEPT
            -A INPUT -p tcp  --dport 80 -j ACCEPT
            -A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT
            -A INPUT -j REJECT --reject-with icmp-host-prohibited
            -A INPUT -p tcp -m tcp --tcp-flags FIN,SYN,RST,PSH,URG RST -j DROP
            -A FORWARD -j REJECT --reject-with icmp-host-prohibited
            COMMIT
        }

        添加网段转发{

            # 例如通过vpn上网
            echo 1 > /proc/sys/net/ipv4/ip_forward       # 在内核里打开ip转发功能
            iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -j MASQUERADE  # 添加网段转发
            iptables -t nat -A POSTROUTING -s 10.0.0.0/255.0.0.0 -o eth0 -j SNAT --to 192.168.10.158  # 原IP网段经过哪个网卡IP出去
            iptables -t nat -nL                # 查看转发

        }

        端口映射{

            # 内网通过有外网IP的机器映射端口
            # 内网主机添加路由
            route add -net 10.10.20.0 netmask 255.255.255.0 gw 10.10.20.111     # 内网需要添加默认网关，并且网关开启转发
            # 网关主机
            echo 1 > /proc/sys/net/ipv4/ip_forward       # 在内核里打开ip转发功能
            iptables -t nat -A PREROUTING -d 外网IP  -p tcp --dport 9999 -j DNAT --to 10.10.20.55:22    # 进入
            iptables -t nat -A POSTROUTING -s 10.10.20.0/24 -j SNAT --to 外网IP                         # 转发回去
            iptables -t nat -nL                # 查看转发

        }

    }

}
