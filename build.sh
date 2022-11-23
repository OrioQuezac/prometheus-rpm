#!/bin/bash -eux

build_prometheus() {
  cp ${HOME}/workspace/prometheus/prometheus.spec ${HOME}/rpmbuild/SPECS
  cp ${HOME}/workspace/prometheus/prometheus.service ${HOME}/rpmbuild/SOURCES
  spectool -g -R ${HOME}/rpmbuild/SPECS/prometheus.spec

  rpmbuild \
  	--clean \
  	-ba ${HOME}/rpmbuild/SPECS/prometheus.spec

  cp ${HOME}/rpmbuild/RPMS/x86_64/*.rpm ${HOME}/workspace/build/
}

build_alertmanager() {
  cp ${HOME}/workspace/alertmanager/prometheus-alertmanager.spec ${HOME}/rpmbuild/SPECS
  cp ${HOME}/workspace/alertmanager/prometheus-alertmanager.service ${HOME}/rpmbuild/SOURCES
  spectool -g -R ${HOME}/rpmbuild/SPECS/prometheus-alertmanager.spec

  rpmbuild \
  	--clean \
  	-ba ${HOME}/rpmbuild/SPECS/prometheus-alertmanager.spec

  cp ${HOME}/rpmbuild/RPMS/x86_64/*.rpm ${HOME}/workspace/build/
}

build_postgres_exporter() {
  cp ${HOME}/workspace/exporters/prometheus-postgres-exporter.spec ${HOME}/rpmbuild/SPECS
  cp ${HOME}/workspace/exporters/* ${HOME}/rpmbuild/SOURCES
  spectool -g -R ${HOME}/rpmbuild/SPECS/prometheus-postgres-exporter.spec

  rpmbuild \
  	--clean \
  	-ba ${HOME}/rpmbuild/SPECS/prometheus-postgres-exporter.spec

  cp ${HOME}/rpmbuild/RPMS/x86_64/*.rpm ${HOME}/workspace/build/
}

build_node_exporter() {
  cp ${HOME}/workspace/exporters/prometheus-node-exporter.spec ${HOME}/rpmbuild/SPECS
  cp ${HOME}/workspace/exporters/* ${HOME}/rpmbuild/SOURCES
  spectool -g -R ${HOME}/rpmbuild/SPECS/prometheus-node-exporter.spec

  rpmbuild \
  	--clean \
  	-ba ${HOME}/rpmbuild/SPECS/prometheus-node-exporter.spec

  cp ${HOME}/rpmbuild/RPMS/x86_64/*.rpm ${HOME}/workspace/build/
}


sudo yum install rpmdevtools -y
rm -rf ${HOME}/.rpmmacros
rpmdev-setuptree
mkdir -p ${HOME}/workspace/build/

case $1 in
  prometheus )
  build_prometheus
    ;;
  alertmanager )
  build_alertmanager
    ;;
  postgres_exporter )
  build_postgres_exporter
    ;;
  node_exporter )
  build_node_exporter
    ;;
  all )
  build_prometheus
  build_postgres_exporter
  build_node_exporter
  build_alertmanager
    ;;
  *)    # unknown option
  echo "Unknown option."
  exit 1
  ;;
esac
