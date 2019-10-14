source /etc/os-release
tmp=$(mktemp -d)

git clone https://github.com/devzero2000/rpmbuild-vault.git ${tmp}
mkdir -p ${tmp}/{SOURCES,SRPMS}
spectool -g -C ${tmp}/SOURCES ${tmp}/SPECS/*.spec

mock --clean \
     --root epel-${VERSION_ID}-$(uname -i)

mock --buildsrpm \
     --cleanup-after \
     --resultdir ${tmp}/SRPMS \
     --root epel-${VERSION_ID}-$(uname -i) \
     --sources ${tmp}/SOURCES \
     --spec ${tmp}/SPECS/*.spec


mock --rebuild \
     --root epel-${VERSION_ID}-$(uname -i) \
     ${tmp}/SRPMS/*.src.rpm


mv  /var/lib/mock/epel-${VERSION_ID}-$(uname -i)/result/*.src.rpm $(pwd)/SRPMS
mv  /var/lib/mock/epel-${VERSION_ID}-$(uname -i)/result/*.$(uname -i).rpm $(pwd)/RPMS
rm -rf ${tmp}

