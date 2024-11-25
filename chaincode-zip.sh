CHAINCODE_NAME_VERSION="chaincodesv1"
# Zip Chaincode
bin/peer lifecycle chaincode package ./channel-artifacts/${CHAINCODE_NAME}.tar.gz --path ./chaincodes/${CHAINCODE_LANG} --lang node --label $CHAINCODE_NAME_VERSION