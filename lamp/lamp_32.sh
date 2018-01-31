###linux内核，网络参数优化###
#禁用ip包转发
net.ipv4.ip_forward = 0
net.ipv4.conf.all.forwarding = 0

#对直接连接的网络进行反向路径过滤
net.ipv4.conf.all.rp_filter = 1
net.ipv4.conf.default.rp_filter = 1

#不允许接受含有源路由信息的ip包
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0

#打开TCP SYN cookies保护，一定程度预防SYN攻击
net.ipv4.tcp_syncookies = 1

#SYN队列的长度，适当增大该值，有助于抵挡SYN攻击
net.ipv4.tcp_max_syn_backlog = 3072
#SYN的重试次数，适当降低该值，有助于防范SYN攻击
net.ipv4.tcp_synack_retries = 3
net.ipv4.tcp_syn_retries = 3


#关闭Linux kernel的路由重定向功能
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

#不允许ip重定向信息
net.ipv4.conf.all.accept_redirects = 0

#取消安全重定向
net.ipv4.conf.all.secure_redirects = 0

#预防ICMP探测
net.ipv4.icmp_echo_ignore_broadcasts = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1

#进程快速回收，避免系统中存在大量TIME_WAIT进程
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 30

#端口重用，一般不开启
#net.ipv4.tcp_tw_reuse = 1

#临时端口范围
net.ipv4.ip_local_port_range = 1024 65535
