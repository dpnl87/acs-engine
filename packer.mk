build-packer:
	@packer build -var-file=packer/settings.json packer/vhd-image.json

init-packer:
	@./packer/scripts/init-variables

az-login:
	az login --service-principal -u ${CLIENT_ID} -p ${CLIENT_SECRET} --tenant ${TENANT_ID}

run-packer:
	@packer version && make az-login && make init-packer && make build-packer | tee packer-output

az-copy:
	@make az-login && azcopy --source ${OS_DISK_URI} --destination ${CLASSIC_BLOB}/${VHD_NAME} --dest-sas "${SAS_TOKEN}"