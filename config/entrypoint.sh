#!/bin/sh

cd /opt/opendaylight/

sed -i "s/member\-1/member\-$CLUSTER_INDEX/" configuration/initial/akka.conf
sed -i "s/\"172.28.1.2\"/\"172.28.1.$CLUSTER_INDEX\"/g" configuration/initial/akka.conf

export KARAF_FEATURES_BOOT=odl-restconf-all,odl-openflowplugin-flow-services-rest,odl-openflowplugin-app-table-miss-enforcer,odl-openflowplugin-nxm-extensions,odl-mdsal-clustering

exec $HOME/bin/karaf run

