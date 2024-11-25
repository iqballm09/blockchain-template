#!/bin/bash

# Define variables
## Note: Version and sequence must be same.
VERSION="1"
SEQUENCE="1"
ORDERER_CA="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
PEER0_ORG1_TLS_ROOTCERT="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG1_DOMAIN}/peers/${PEER0_ORG1_DOMAIN}/tls/ca.crt"
PEER0_ORG2_TLS_ROOTCERT="/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG2_DOMAIN}/peers/${PEER0_ORG2_DOMAIN}/tls/ca.crt"

# Commit chaincode
docker exec cli peer lifecycle chaincode commit -o orderer.example.com:${ORDERER_MAIN_PORT} --tls --cafile $ORDERER_CA \
  --peerAddresses $PEER0_ORG1_CORE_ADDRESS --tlsRootCertFiles $PEER0_ORG1_TLS_ROOTCERT \
  --peerAddresses $PEER0_ORG2_CORE_ADDRESS --tlsRootCertFiles $PEER0_ORG2_TLS_ROOTCERT \
  --channelID $CHANNEL_NAME --name $CHAINCODE_NAME --version $VERSION --sequence $SEQUENCE
