#!/bin/bash

# Define variables
## Note : Change PACKAGE_ID after chaincode install
VERSION="1"
SEQUENCE="1"
PACKAGE_ID="chaincodesv1:eaf28f1364bbe18784c4f585136529ff82e26d2a0e63207bbd46c0a53a0c082f"
ORDERER_CA="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"

# Approve Chaincode on peer0.org1Name.example.com Host
docker exec cli peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $VERSION --sequence $SEQUENCE --waitForEvent --package-id $PACKAGE_ID

# Approve chaincode on peer0.org2Name.example.com Host
docker exec -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG2_DOMAIN}/users/Admin@${ORG2_DOMAIN}/msp -e CORE_PEER_ADDRESS=$PEER0_ORG2_CORE_ADDRESS -e CORE_PEER_LOCALMSPID="${ORG2_MSPNAME}" -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG2_DOMAIN}/peers/${PEER0_ORG2_DOMAIN}/tls/ca.crt cli peer lifecycle chaincode approveformyorg --tls --cafile $ORDERER_CA --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $VERSION --sequence $SEQUENCE --waitForEvent --package-id $PACKAGE_ID