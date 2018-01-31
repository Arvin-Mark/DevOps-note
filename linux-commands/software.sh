2 软件{

    rpm{

        rpm -ivh lynx          # rpm安装
        rpm -e lynx            # 卸载包
        rpm -e lynx --nodeps   # 强制卸载
        rpm -qa                # 查看所有安装的rpm包
        rpm -qa | grep lynx    # 查找包是否安装
        rpm -ql                # 软件包路径
        rpm -Uvh               # 升级包
        rpm --test lynx        # 测试
        rpm -qc                # 软件包配置文档
        rpm --import  /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6     # 导入rpm的签名信息
        rpm --initdb           # 初始化rpm 数据库
        rpm --rebuilddb        # 重建rpm数据库  在rpm和yum无响应的情况使用 先 rm -f /var/lib/rpm/__db.00* 在重建

    }

    yum{

        yum list                 # 所有软件列表
        yum install 包名          # 安装包和依赖包
        yum -y update            # 升级所有包版本,依赖关系，系统版本内核都升级
        yum -y update 软件包名    # 升级指定的软件包
        yum -y upgrade           # 不改变软件设置更新软件，系统版本升级，内核不改变
        yum search mail          # yum搜索相关包
        yum grouplist            # 软件包组
        yum -y groupinstall "Virtualization"   # 安装软件包组
        repoquery -ql gstreamer  # 不安装软件查看包含文件
        yum clean all            # 清除var下缓存

    }

    yum使用epel源{

        # 包下载地址: http://download.fedoraproject.org/pub/epel   # 选择版本5\6\7
        rpm -Uvh  http://mirrors.hustunique.com/epel//6/x86_64/epel-release-6-8.noarch.rpm

        # 自适配版本
        yum install epel-release

    }

    自定义yum源{

        find /etc/yum.repos.d -name "*.repo" -exec mv {} {}.bak \;

        vim /etc/yum.repos.d/yum.repo
        [yum]
        #http
        baseurl=http://10.0.0.1/centos5.5
        #挂载iso
        #mount -o loop CentOS-5.8-x86_64-bin-DVD-1of2.iso /data/iso/
        #本地
        #baseurl=file:///data/iso/
        enable=1

        #导入key
        rpm --import  /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-5

    }

    编译{

        源码安装{

            ./configure --help                   # 查看所有编译参数
            ./configure  --prefix=/usr/local/    # 配置参数
            make                                 # 编译
            # make -j 8                          # 多线程编译,速度较快,但有些软件不支持
            make install                         # 安装包
            make clean                           # 清除编译结果

        }

        perl程序编译{

            perl Makefile.PL
            make
            make test
            make install

        }

        python程序编译{

            python file.py

            # 源码包编译安装
            python setup.py build
            python setup.py install

        }

        编译c程序{

            gcc -g hello.c -o hello

        }

    }

}
