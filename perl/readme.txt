tar zxvf perl-5.18.0.tar.gz

cd perl-5.18.0

./Configure -des -Dprefix=/usr/local/perl

make

make install

mv /usr/bin/perl /usr/bin/perl.bak

ln -s /usr/local/perl/bin/perl /usr/bin/perl


#添加模块

perl -MCPAN -e shell

cpan> install xxx
