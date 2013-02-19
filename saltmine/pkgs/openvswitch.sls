#!mako|yaml

<%
openvswitch_release='1.7.3'
openvswitch_release_full='openvswitch-'+openvswitch_release
openvswitch_source_directory='/root/rpmbuild/SOURCES'
openvswitch_filename='openvswitch-'+openvswitch_release+'.tar.gz'
openvswitch_temp_directory='/root/openvswitch-'+openvswitch_release
%>
#http://openvswitch.org/download/

openvswitch-deps-pkg:
  pkg.installed:
    - names: 
      - gcc
      - make
      - python-devel
      - openssl-devel
      - kernel-devel
      - kernel-debug-devel
      - rpm-build
      - redhat-rpm-config
      - crash-devel
      - crash
    - require: 
      - pkg: epel-repo

#http://www.cyberciti.biz/faq/bash-csh-sh-check-and-file-file-size/
openvswitch-download-temp-tarball:
  cmd.run:
    - name: curl http://openvswitch.org/releases/openvswitch_filename > ~/${openvswitch_filename}
    - unless: "[[ `stat -c %s ${openvswitch_source_directory}${openvswitch_filename}` -eq 2153664 ]] && echo 'equals'"
    - require:
      - pkg: openvswitch-deps-pkg

openvswitch-download-source-tarball:
  cmd.run:
    - name: curl http://openvswitch.org/releases/openvswitch_filename > ${openvswitch_source_directory}/${openvswitch_filename}
    - unless: "[[ `stat -c %s ${openvswitch_source_directory}${openvswitch_filename}` -eq 2153664 ]] && echo 'equals'"
    - require:
      - pkg: openvswitch-deps-pkg

openvswitch-unzip-tarball:
  cmd.wait:
    - name: tar -xvf ~/${openvswitch_filename}
    - cwd: ~/
    - watch:
      - cmd: openvswitch-download-tarball

#http://networkstatic.net/open-vswitch-red-hat-installation/
#http://stackoverflow.com/questions/1825905/comment-out-n-lines-with-sed-awk
openvswitch-fix1:
  cmd.wait:
    - name: "awk --posix '/static inline struct page \*skb_frag_page\(const skb_frag_t \*frag\)/, c++ == 3 {$0 = \"//\" $0} { print }' ./skbuff.h > ./skbuff.h_bak; cp -f skbuff.h_bak skbuff.h; diff skbuff.h_bak skbuff.h"
    - cwd: ${openvswitch_temp_directory}/datapath/linux/compat/include/linux/
    - watch:
      - cmd: openvswitch-unzip-tarball

openvswitch-fix2:
  cmd.wait:
    - name: "gunzip openvswitch-1.7.3.tar.gz; tar -rf openvswitch-1.7.3.tar ${openvswitch_temp_directory}/datapath/linux/compat/include/linux/skbuff.h; gzip openvswitch-1.7.3.tar"
    - cwd: ${openvswitch_source_directory}
    - watch:
      - cmd: openvswitch-fix1

openvswitch-fix3:
  cmd.wait:
    - name: 'rpmbuild -bb -D 'kversion 2.6.32-279.el6.x86_64' -D 'kflavors default' rhel/openvswitch-kmod-rhel6.spec'
    - cwd: ${openvswitch_temp_directory}
    - watch:
      - cmd: openvswitch-fix2

openvswitch-pkg:
  pkg.installed:
    - name: kmod-openvswitch
    - sources:
      - kmod-openvswitch: '/root/rpmbuild/RPMS/x86_64/kmod-openvswitch-1.7.3-1.el6.x86_64.rpm'

# curl http://openvswitch.org/releases/openvswitch-1.7.3.tar.gz > /root/openvswitch-1.7.3.tar.gz
# curl http://openvswitch.org/releases/openvswitch-1.7.3.tar.gz > /root/rpmbuild/SOURCES/openvswitch-1.7.3.tar.gz

# gunzip rpmbuild/SOURCES/openvswitch-1.7.3.tar.gz
# tar -rf openvswitch-1.7.3.tar skbuff.h
# gzip openvswitch-1.7.3.tar

# less ~/openvswitch-1.7.3/datapath/linux/compat/include/linux/skbuff.h
# awk --posix '/static inline struct page \*skb_frag_page\(const skb_frag_t \*frag\)/, c++ == 3 {$0 = "//" $0} { print }' ~/openvswitch-1.7.3/datapath/linux/compat/include/linux/skbuff.h > ~/openvswitch-1.7.3/datapath/linux/compat/include/linux/skbuff.h_bak
# mv -f openvswitch-1.7.3/datapath/linux/compat/include/linux/skbuff.h_bak openvswitch-1.7.3/datapath/linux/compat/include/linux/skbuff.h
# tar -rf openvswitch-1.7.3.tar openvswitch-1.7.3/datapath/linux/compat/include/linux/skbuff.h
# gzip openvswitch-1.7.3.tar
# mv openvswitch-1.7.3.tar.gz /root/rpmbuild/SOURCES/

# rpm -ivh /root/rpmbuild/RPMS/x86_64/kmod-openvswitch-1.7.3-1.el6.x86_64.rpm


# /root/rpmbuild/BUILD/openvswitch-1.7.3/datapath/linux/compat/include/linux
# awk --posix '/static inline struct page \*skb_frag_page\(const skb_frag_t \*frag\)/, c++ == 3 {$0 = "//" $0} { print }' ./skbuff.h > temp.h
# rpmbuild -bb -D 'kversion 2.6.32-279.el6.x86_64' -D 'kflavors default' rhel/openvswitch-kmod-rhel6.spec

# openvswitch-configure:
#   cmd.wait:
#     - name: './configure --with-linux=/lib/modules/`uname -r`/build'
#     - cwd: ${openvswitch_source_directory}
#     - watch:
#       - cmd: openvswitch-unzip-tarball

# openvswitch-module-install:
#   cmd.wait:
#     - name: "insmod ./datapath/linux/openvswitch.ko; touch /usr/local/etc/ovs-vswitchd.conf; mkdir -p /usr/local/etc/openvswitch; ./ovsdb/ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema; ./ovsdb/ovsdb-server /usr/local/etc/openvswitch/conf.db --remote=punix:/usr/local/var/run/openvswitch/db.sock --remote=db:Open_vSwitch,manager_options --private-key=db:SSL,private_key --certificate=db:SSL,certificate --bootstrap-ca-cert=db:SSL,ca_cert --pidfile --detach --log-file; ovs-vsctl --no-wait init; ovs-vswitchd --pidfile --detach; ovs-vsctl show;"
#     - cwd: ${openvswitch_source_directory}
#     - watch:
#       - cmd: openvswitch-fix
