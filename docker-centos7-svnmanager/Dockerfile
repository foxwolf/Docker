#FROM centos:latest
#MAINTAINER Jijeesh <silentheartbeat@gmail.com>
FROM centos:7
MAINTAINER FoxWolf

#DOMAIN INFORMATION
ENV servn sdwl.com
ENV cname svn
ENV dir /var/www/
ENV user apache
ENV listen *
ENV repos /data/svn
ENV svnmg sdwl_svn_manager

#Virtual hosting
RUN yum install -y httpd epel-release wget
RUN wget http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN rpm -Uvh remi-release-7*.rpm
#COPY remi-release-7*.rpm /tmp
#RUN yum localinstall -y /tmp/remi-release-7*.rpm
RUN yum --enablerepo=remi-php56 install -y --skip-broken php php-devel php-mysqlnd php-common php-pdo php-mbstring php-xml php-imap php-curl
RUN yum --enablerepo=remi-php56 install -y --skip-broken subversion mod_dav_svn php-pear bzip2
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

#RUN timedatectl set-timezone Asia/Tokyo
RUN mkdir -p $dir${cname}_$servn
RUN chown -R ${user}:${user}  $dir${cname}_$servn
RUN chmod -R 755  $dir${cname}_$servn
RUN mkdir /var/log/${cname}_$servn
RUN mkdir /etc/httpd/sites-available
RUN mkdir /etc/httpd/sites-enabled
RUN mkdir -p ${dir}${cname}_${servn}/logs
RUN mkdir -p ${dir}${cname}_${servn}/public_html
RUN printf "IncludeOptional sites-enabled/${cname}_$servn.conf" >> /etc/httpd/conf/httpd.conf

####
#VOLUME ${repos}
RUN /usr/sbin/groupadd subversion
RUN /usr/sbin/useradd -g subversion -s /sbin/nologin subversion
RUN /usr/sbin/usermod -a -G subversion apache
#RUN chown -R apache:subversion ${repos}

RUN ln -s /etc/httpd/sites-available/${cname}_$servn.conf /etc/httpd/sites-enabled/${cname}_$servn.conf

#RUN cd /tmp && curl -L http://sourceforge.net/projects/svnmanager/files/svnmanager/1.10/svnmanager-1.10.tar.bz2/download -o svnmanager-1.10.tar.bz2 && pear install VersionControl_SVN-0.5.1 && tar xf svnmanager-1.10.tar.bz2 && mv svnmanager-1.10 ${dir}${cname}_${servn}/public_html/svnmanager && rm svnmanager-1.10.tar.bz2
COPY file/svnmanager-1.10.tar.bz2 /tmp/svnmanager-1.10.tar.bz2
RUN cd /tmp && pear install --alldeps VersionControl_SVN-0.5.2 && tar xf svnmanager-1.10.tar.bz2 && mv svnmanager-1.10 ${dir}${cname}_${servn}/public_html/${svnmg} && rm svnmanager-1.10.tar.bz2
RUN cp ${dir}${cname}_${servn}/public_html/${svnmg}/config.php.linux ${dir}${cname}_${servn}/public_html/${svnmg}/config.php
RUN ls -l ${dir}${cname}_${servn}/public_html/${svnmg}/config.php

RUN cp /usr/share/pear/VersionControl/SVN/Command.php /usr/share/pear/VersionControl/SVN/Command.php.bk
COPY ["file/Command.php", "/usr/share/pear/VersionControl/SVN/Command.php"]

RUN printf "#### $cname $servn \n\
<VirtualHost ${listen}:80> \n\
ServerName ${cname}.${servn} \n\
ServerAlias ${cname} \n\
DocumentRoot ${dir}${cname}_${servn}/public_html \n\
ErrorLog ${dir}${cname}_${servn}/logs/error.log \n\
CustomLog ${dir}${cname}_${servn}/logs/requests.log combined \n\
<Directory ${dir}${cname}_${servn}/public_html> \n\

#Options Indexes FollowSymLinks MultiViews \n\
Options FollowSymLinks \n\
Options -Indexes \n\
AllowOverride All \n\
Order allow,deny \n\
#Allow from all \n\
Allow from 222.35.42.189 \n\
Allow from 192.168.14.0/24 \n\
Allow from 192.168.12.0/24 \n\
Allow from 172.23.0.0/16 \n\
#Allow from 192.168.50.0/24 \n\
Require all granted \n\
</Directory> \n\
</VirtualHost>\n\
<Location /svn/> \n\
        DAV svn \n\
        SVNParentPath ${repos}/repos \n\
        AuthzSVNAccessFile ${repos}/svn.access \n\
        Satisfy All \n\
        Require valid-user \n\
        AuthType Basic \n\
        AuthName 'Subversion Repository' \n\
        AuthUserFile ${repos}/svn.passwd \n\
        Order allow,deny \n\
	Allow from 222.35.42.189 \n\
	Allow from 192.168.14.0/24 \n\
	Allow from 192.168.12.0/24 \n\
	Allow from 172.23.0.0/16 \n\
	#Allow from 192.168.50.0/24 \n\
        #Allow from 192.168.11.0/24 \n\
        #Allow from 127 \n\
        #Allow from All \n\
        #Deny from All \n\
</Location> \n" \
 > /etc/httpd/sites-available/${cname}_$servn.conf

RUN sed -i \
	-e 's,.*$svn_config_dir.*,$svn_config_dir="'"$repos"'/svnroot";,' \
	-e 's,.*$svn_repos_loc.*,$svn_repos_loc="'"$repos"'/repos";,' \
	-e 's,.*$svn_passwd_file.*,$svn_passwd_file="'"$repos"'/svn.passwd";,' \
	-e 's,.*$svn_access_file.*,$svn_access_file="'"$repos"'/svn.access";,' \
	-e 's,.*$dsn.*,$dsn = "mysqli://svnuser:svnpassword@172.17.0.2/svn_manager";,' \
	-e 's,.*$svn_trash_loc.*,$svn_trash_loc = "'"$repos"'/trash";,' \
	${dir}${cname}_${servn}/public_html/${svnmg}/config.php

RUN sed -i \
        -e 's/^expose_php = .*/expose_php = Off/' \
        -e 's/^display_errors = .*/display_errors = On/' \
        -e 's/^log_errors = .*/log_errors = Off/' \
        -e 's/^short_open_tag = .*/short_open_tag = On/' \
        -e 's/^error_reporting = .*/error_reporting = E_WARNING \& ~E_NOTICE \& ~E_DEPRECATED/' \
        -e 's/^memory_limit = .*/memory_limit = 1024M/' \
        -e 's/^max_execution_time = .*/max_execution_time = 0/' \
        -e 's#^;error_log = syslog#;error_log = syslog\nerror_log = /data/php/log/scripts-error.log#' \
        -e 's/^file_uploads = .*/file_uploads = On/' \
        -e 's/^upload_max_filesize = .*/upload_max_filesize = 50M/' \
        -e 's/^allow_url_fopen = .*/allow_url_fopen = Off/' \
        -e 's/^allow_url_include = .*/allow_url_include  = Off/' \
        -e 's/^sql.safe_mode = .*/sql.safe_mode = On/' \
        -e 's/^post_max_size = .*/post_max_size = 100M/' \
        -e 's/^session.name = .*/session.name = PSID/' \
        -e 's#^;session.save_path = .*#session.save_path = /data/php/session#' \
        -e 's/^session.cookie_httponly.*/session.cookie_httponly = On/' \
        -e 's#^;upload_tmp_dir.*#upload_tmp_dir = /data/php/tmp#' \
        -e 's#^;date.timezone.*#date.timezone = Asia\/Tokyo#' \
        /etc/php.ini

ADD config_svn.sh /usr/bin/config_svn.sh
RUN chmod +x /usr/bin/config_svn.sh

ADD multiple.sh /usr/bin/multiple.sh
RUN chmod +x /usr/bin/multiple.sh

EXPOSE 80
EXPOSE 443

#CMD /bin/bash /usr/bin/config_svn.sh
#CMD ["/usr/bin/config_svn.sh"]
RUN rm -rf /run/httpd/* /tmp/httpd*
#CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
#CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
CMD ["/usr/bin/multiple.sh"]

