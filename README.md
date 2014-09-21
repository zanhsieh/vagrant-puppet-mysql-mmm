vagrant-puppet-mysql-mmm
=================================

Creates 2 mysql nodes with a master-master configuration, based on this:

1. [MySQL Master-Master Replication](http://www.rackspace.com/knowledge_center/article/mysql-master-master-replication)

Steps:

    vagrant up
    ./init_sync.sh your_database_name
