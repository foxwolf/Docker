# docker-centos7-svnmanager

v1.1
vnmanager连中文目录都无法显示，主要是在权限分配时。但svnmanager-1.10已经支持显示中文目录了，但也仅仅是能在下拉列表中显示而已，当你想进一步查看该中文目录下的子目录时，就会报类似如下的错误：

InternalError
VersionControl_SVN_Exception: Execution of command failed returning: 1
svn: E000022: Can't convert string from native encoding to 'UTF-8':
svn: E000022: file:///data/svn/repos/test///?\228?\184?\173?\230?\150?\1351
#0 /var/www/svn_example.com/public_html/svnmanager/svnmanager/RepositoryModule/UserPrivilegesEditPage.php(261): VersionControl_SVN_Command->run(Array, Array)
#1 /var/www/svn_example.com/public_html/svnmanager/prado-2.0.3/framework/Web/UI/TControl.php(419): UserPrivilegesEditPage->onLoad(Object(TEventParameter))
#2 /var/www/svn_example.com/public_html/svnmanager/prado-2.0.3/framework/Web/UI/TPage.php(1079): TControl->onLoadRecursive(Object(TEventParameter))
#3 /var/www/svn_example.com/public_html/svnmanager/prado-2.0.3/framework/Web/UI/TPage.php(947): TPage->onLoadRecursive(Object(TEventParameter))
#4 /var/www/svn_example.com/public_html/svnmanager/prado-2.0.3/framework/TApplication.php(483): TPage->execute()
#5 /var/www/svn_example.com/public_html/svnmanager/index.php(5): TApplication->run()
#6 {main}
解决方法：
修改/usr/share/pear/VersionControl/SVN/Command.php

if(!$this->passthru) {
exec("{$this->prependCmd}$cmd 2>&1", $out, $returnVar);
} else{
passthru("{$this->prependCmd}$cmd 2>&1", $returnVar);
}
改为
if(!$this->passthru) { 
exec("export LC_CTYPE=en_US.UTF-8 && {$this->prependCmd}$cmd 2>&1", $out, $returnVar);
} else{
passthru("export LC_CTYPE=en_US.UTF-8 && {$this->prependCmd}$cmd 2>&1", $returnVar);
}

v1.0
# fork: https://github.com/jijeesh/docker-centos7-svnmanager.git
login to mysql

create database svn_manager;

GRANT ALL PRIVILEGES ON `svn_manager`.* TO 'svnsqluser'@'172.%' IDENTIFIED BY 'svnsqlpassword' WITH GRANT OPTION;


if any problem find 
just login into the cotainer and run the command name config_svn.sh
