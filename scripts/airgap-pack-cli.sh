rm -rf bin/
mkdir -p bin
sh install/download-packer.sh
sh install/install-packer.sh
sh install/download-terraform.sh
sh install/install-terraform.sh

cp /usr/local/bin/packer ./bin/
cp /usr/local/bin/terraform ./bin/

cd bin && tar -zcvf cli.tar.gz *

