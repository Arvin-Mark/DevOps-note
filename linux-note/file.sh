
1 文件{

    ls -rtl                 # 按时间倒叙列出所有目录和文件 ll -rt
    touch file              # 创建空白文件
    rm -rf 目录名            # 不提示删除非空目录(-r:递归删除 -f强制)
    dos2unix                # windows文本转linux文本
    unix2dos                # linux文本转windows文本
    enca filename           # 查看编码  安装 yum install -y enca
    md5sum                  # 查看md5值
    ln 源文件 目标文件         # 硬链接
    ln -s 源文件 目标文件      # 符号连接
    readlink -f /data       # 查看连接真实目录
    cat file | nl |less     # 查看上下翻页且显示行号  q退出
    head                    # 查看文件开头内容
    head -c 10m             # 截取文件中10M内容
    split -C 10M            # 将文件切割大小为10M -C按行
    tail -f file            # 查看结尾 监视日志文件
    tail -F file            # 监视日志并重试, 针对文件被mv的情况可以持续读取
    file                    # 检查文件类型
    umask                   # 更改默认权限
    uniq                    # 删除重复的行
    uniq -c                 # 重复的行出现次数
    uniq -u                 # 只显示不重复行
    paste a b               # 将两个文件合并用tab键分隔开
    paste -d'+' a b         # 将两个文件合并指定'+'符号隔开
    paste -s a              # 将多行数据合并到一行用tab键隔开
    chattr +i /etc/passwd   # 不得任意改变文件或目录 -i去掉锁 -R递归
    more                    # 向下分面器
    locate 字符串            # 搜索
    wc -l file              # 查看行数
    cp filename{,.bak}      # 快速备份一个文件
    \cp a b                 # 拷贝不提示 既不使用别名 cp -i
    rev                     # 将行中的字符逆序排列
    comm -12 2 3            # 行和行比较匹配
    echo "10.45aa" |cksum                   # 字符串转数字编码，可做校验，也可用于文件校验
    iconv -f gbk -t utf8 原.txt > 新.txt     # 转换编码
    xxd /boot/grub/stage1                   # 16进制查看
    hexdump -C /boot/grub/stage1            # 16进制查看
    rename 原模式 目标模式 文件                 # 重命名 可正则
    watch -d -n 1 'df; ls -FlAt /path'      # 实时某个目录下查看最新改动过的文件
    cp -v  /dev/dvd  /rhel4.6.iso9660       # 制作镜像
    diff suzu.c suzu2.c  > sz.patch         # 制作补丁
    patch suzu.c < sz.patch                 # 安装补丁

    sort排序{

        -t  # 指定排序时所用的栏位分隔字符
        -n  # 依照数值的大小排序
        -r  # 以相反的顺序来排序
        -f  # 排序时，将小写字母视为大写字母
        -d  # 排序时，处理英文字母、数字及空格字符外，忽略其他的字符
        -c  # 检查文件是否已经按照顺序排序
        -b  # 忽略每行前面开始处的空格字符
        -M  # 前面3个字母依照月份的缩写进行排序
        -k  # 指定域
        -m  # 将几个排序好的文件进行合并
        -T  # 指定临时文件目录,默认在/tmp
        +<起始栏位>-<结束栏位>   # 以指定的栏位来排序，范围由起始栏位到结束栏位的前一栏位。
        -o  # 将排序后的结果存入指定的文

        sort -n               # 按数字排序
        sort -nr              # 按数字倒叙
        sort -u               # 过滤重复行
        sort -m a.txt c.txt   # 将两个文件内容整合到一起
        sort -n -t' ' -k 2 -k 3 a.txt     # 第二域相同，将从第三域进行升降处理
        sort -n -t':' -k 3r a.txt         # 以:为分割域的第三域进行倒叙排列
        sort -k 1.3 a.txt                 # 从第三个字母起进行排序
        sort -t" " -k 2n -u  a.txt        # 以第二域进行排序，如果遇到重复的，就删除

    }

    find查找{

        # linux文件无创建时间
        # Access 使用时间
        # Modify 内容修改时间
        # Change 状态改变时间(权限、属主)
        # 时间默认以24小时为单位,当前时间到向前24小时为0天,向前48-72小时为2天
        # -and 且 匹配两个条件 参数可以确定时间范围 -mtime +2 -and -mtime -4
        # -or 或 匹配任意一个条件

        find /etc -name "*http*"     # 按文件名查找
        find . -type f               # 查找某一类型文件
        find / -perm                 # 按照文件权限查找
        find / -user                 # 按照文件属主查找
        find / -group                # 按照文件所属的组来查找文件
        find / -atime -n             # 文件使用时间在N天以内
        find / -atime +n             # 文件使用时间在N天以前
        find / -mtime +n             # 文件内容改变时间在N天以前
        find / -ctime +n             # 文件状态改变时间在N天前
        find / -mmin +30             # 按分钟查找内容改变
        find / -size +1000000c -print                           # 查找文件长度大于1M字节的文件
        find /etc -name "*passwd*" -exec grep "xuesong" {} \;   # 按名字查找文件传递给-exec后命令
        find . -name 't*' -exec basename {} \;                  # 查找文件名,不取路径
        find . -type f -name "err*" -exec  rename err ERR {} \; # 批量改名(查找err 替换为 ERR {}文件
        find 路径 -name *name1* -or -name *name2*               # 查找任意一个关键字

    }

    vim编辑器{

        gconf-editor           # 配置编辑器
        /etc/vimrc             # 配置文件路径
        vim +24 file           # 打开文件定位到指定行
        vim file1 file2        # 打开多个文件
        vim -O2 file1 file2    # 垂直分屏
        vim -on file1 file2    # 水平分屏
        Ctrl+ U                # 向前翻页
        Ctrl+ D                # 向后翻页
        Ctrl+ww                # 在窗口间切换
        Ctrl+w +or-or=         # 增减高度
        :sp filename           # 上下分割打开新文件
        :vs filename           # 左右分割打开新文件
        :set nu                # 打开行号
        :set nonu              # 取消行号
        :nohl                  # 取消高亮
        :set paste             # 取消缩进
        :set autoindent        # 设置自动缩进
        :set ff                # 查看文本格式
        :set binary            # 改为unix格式
        :%s/字符1/字符2/g       # 全部替换
        :200                   # 跳转到200  1 文件头
        G                      # 跳到行尾
        dd                     # 删除当前行 并复制 可直接p粘贴
        11111dd                # 删除11111行，可用来清空文件
        r                      # 替换单个字符
        R                      # 替换多个字符
        u                      # 撤销上次操作
        *                      # 全文匹配当前光标所在字符串
        $                      # 行尾
        0                      # 行首
        X                      # 文档加密
        v =                    # 自动格式化代码
        Ctrl+v                 # 可视模式
        Ctrl+v I ESC           # 多行操作
        Ctrl+v s ESC           # 批量取消注释

    }

    归档解压缩{

        tar zxvpf gz.tar.gz -C 放到指定目录 包中的目录       # 解包tar.gz 不指定目录则全解压
        tar zcvpf /$path/gz.tar.gz * # 打包gz 注意*最好用相对路径
        tar zcf /$path/gz.tar.gz *   # 打包正确不提示
        tar ztvpf gz.tar.gz          # 查看gz
        tar xvf 1.tar -C 目录         # 解包tar
        tar -cvf 1.tar *             # 打包tar
        tar tvf 1.tar                # 查看tar
        tar -rvf 1.tar 文件名         # 给tar追加文件
        tar --exclude=/home/dmtsai --exclude=*.tar -zcvf myfile.tar.gz /home/* /etc      # 打包/home, /etc ，但排除 /home/dmtsai
        tar -N "2005/06/01" -zcvf home.tar.gz /home      # 在 /home 当中，比 2005/06/01 新的文件才备份
        tar -zcvfh home.tar.gz /home                     # 打包目录中包括连接目录
        tar zcf - ./ | ssh root@IP "tar zxf - -C /xxxx"  # 一边压缩一边解压
        zgrep 字符 1.gz               # 查看压缩包中文件字符行
        bzip2  -dv 1.tar.bz2         # 解压bzip2
        bzip2 -v 1.tar               # bzip2压缩
        bzcat                        # 查看bzip2
        gzip A                       # 直接压缩文件 # 压缩后源文件消失
        gunzip A.gz                  # 直接解压文件 # 解压后源文件消失
        gzip -dv 1.tar.gz            # 解压gzip到tar
        gzip -v 1.tar                # 压缩tar到gz
        unzip zip.zip                # 解压zip
        zip zip.zip *                # 压缩zip
        # rar3.6下载:  http://www.rarsoft.com/rar/rarlinux-3.6.0.tar.gz
        rar a rar.rar *.jpg          # 压缩文件为rar包
        unrar x rar.rar              # 解压rar包
        7z a 7z.7z *                 # 7z压缩
        7z e 7z.7z                   # 7z解压

    }

    文件ACL权限控制{

        getfacl 1.test                      # 查看文件ACL权限
        setfacl -R -m u:xuesong:rw- 1.test  # 对文件增加用户的读写权限 -R 递归

    }

    svn更新代码{

        --force # 强制覆盖
        /usr/bin/svn --username user --password passwd co  $Code  ${SvnPath}src/                 # 检出整个项目
        /usr/bin/svn --username user --password passwd up  $Code  ${SvnPath}src/                 # 更新项目
        /usr/bin/svn --username user --password passwd export  $Code$File ${SvnPath}src/$File    # 导出个别文件
        /usr/bin/svn --username user --password passwd export -r 版本号 svn路径 本地路径 --force # 导出指定版本

    }

    git{

        # 编译安装git-1.8.4.4
        ./configure --with-curl --with-expat
        make
        make install

        git clone git@10.10.10.10:gittest.git  ./gittest/  # 克隆项目到指定目录
        git status                                         # Show the working tree(工作树) status
        git log -n 1 --stat                                # 查看最后一次日志文件
        git branch -a                                      # 列出远程跟踪分支(remote-tracking branches)和本地分支
        git checkout developing                            # 切换到developing分支
        git checkout -b release                            # 切换分支没有从当前分支创建
        git checkout -b release origin/master              # 从远程分支创建本地镜像分支
        git push origin --delete release                   # 从远端删除分区，服务端有可能设置保护不允许删除
        git push origin release                            # 把本地分支提交到远程
        git pull                                           # 更新项目 需要cd到项目目录中
        git fetch                                          # 抓取远端代码但不合并到当前
        git reset --hard origin/master                     # 和远端同步分支
        git add .                                          # 更新所有文件
        git commit -m "gittest up"                         # 提交操作并添加备注
        git push                                           # 正式提交到远程git服务器
        git push [-u origin master]                        # 正式提交到远程git服务器(master分支)
        git tag [-a] dev-v-0.11.54 [-m 'fix #67']          # 创建tag,名为dev-v-0.11.54,备注fix #67
        git tag -l dev-v-0.11.54                           # 查看tag(dev-v-0.11.5)
        git push origin --tags                             # 提交tag
        git reset --hard                                   # 本地恢复整个项目
        git rm -r -n --cached  ./img                       # -n执行命令时,不会删除任何文件,而是展示此命令要删除的文件列表预览
        git rm -r --cached  ./img                          # 执行删除命令 需要commit和push让远程生效
        git init --bare smc-content-check.git              # 初始化新git项目  需要手动创建此目录并给git用户权限 chown -R git:git smc-content-check.git
        git config --global credential.helper store        # 记住密码
        git config [--global] user.name "your name"        # 设置你的用户名, 希望在一个特定的项目中使用不同的用户或e-mail地址, 不要--global选项
        git config [--global] user.email "your email"      # 设置你的e-mail地址, 每次Git提交都会使用该信息
        git config [--global] user.name                    # 查看用户名
        git config [--global] user.email                   # 查看用户e-mail
        git config --global --edit                         # 编辑~/.gitconfig(User-specific)配置文件, 值优先级高于/etc/gitconfig(System-wide)
        git config --edit                                  # 编辑.git/config(Repository specific)配置文件, 值优先级高于~/.gitconfig
        git cherry-pick  <commit id>                       # 用于把另一个本地分支的commit修改应用到当前分支 需要push到远程
        git log --pretty=format:'%h: %s' 9378b62..HEAD     # 查看指定范围更新操作 commit id

        从远端拉一份新的{
            # You have not concluded your merge (MERGE_HEAD exists)  git拉取失败
            git fetch --hard origin/master
            git reset --hard origin/master
        }

    }

    恢复rm删除的文件{

        # debugfs针对 ext2   # ext3grep针对 ext3   # extundelete针对 ext4
        df -T   # 首先查看磁盘分区格式
        umount /data/     # 卸载挂载,数据丢失请首先卸载挂载,或重新挂载只读
        ext3grep /dev/sdb1 --ls --inode 2         # 记录信息继续查找目录下文件inode信息
        ext3grep /dev/sdb1 --ls --inode 131081    # 此处是inode
        ext3grep /dev/sdb1 --restore-inode 49153  # 记录下inode信息开始恢复目录

    }

    openssl{

        openssl rand 15 -base64            # 口令生成
        openssl sha1 filename              # 哈希算法校验文件
        openssl md5 filename               # MD5校验文件
        openssl base64   filename.txt      # base64编码/解码文件(发送邮件附件之类功能会可以使用)
        openssl base64 -d   filename.bin   # base64编码/解码二进制文件
        openssl enc -aes-128-cbc   filename.aes-128-cbc                  # 加密文档
        # 推荐使用的加密算法是bf(Blowfish)和-aes-128-cbc(运行在CBC模式的128位密匙AES加密算法)，加密强度有保障
        openssl enc -d -aes-128-cbc -in filename.aes-128-cbc > filename  # 解密文档

    }

}
