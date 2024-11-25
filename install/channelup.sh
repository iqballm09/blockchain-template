# Create channel
docker exec cli peer channel create -o orderer.example.com:${ORDERER_MAIN_PORT} -c ${CHANNEL_NAME} -f ./channel-artifacts/channel.tx --outputBlock ./channel-artifacts/${CHANNEL_NAME}.block --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

sleep 5

# menambahkan peer0.org1Name.example.com ke dalam channel
docker exec cli peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block
# update peer0.org1Name.example.com 
docker exec cli peer channel update -o orderer.example.com:${ORDERER_MAIN_PORT} -c ${CHANNEL_NAME} -f ./channel-artifacts/${ORG1_MSPNAME}anchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

# menambahkan peer0.org2Name.example.com ke dalam channel
docker exec -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG2_DOMAIN}/users/Admin@${ORG2_DOMAIN}/msp -e CORE_PEER_ADDRESS=${PEER0_ORG2_CORE_ADDRESS} -e CORE_PEER_LOCALMSPID="${ORG2_MSPNAME}" -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG2_DOMAIN}/peers/${PEER0_ORG2_DOMAIN}/tls/ca.crt cli peer channel join -b ./channel-artifacts/${CHANNEL_NAME}.block
# update peer0.org2Name.example.com
docker exec -e CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG2_DOMAIN}/users/Admin@${ORG2_DOMAIN}/msp -e CORE_PEER_ADDRESS=${PEER0_ORG2_CORE_ADDRESS} -e CORE_PEER_LOCALMSPID="${ORG2_MSPNAME}" -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/${ORG2_DOMAIN}/peers/${PEER0_ORG2_DOMAIN}/tls/ca.crt cli peer channel update -o orderer.example.com:${ORDERER_MAIN_PORT} -c ${CHANNEL_NAME} -f ./channel-artifacts/${ORG2_MSPNAME}anchors.tx --tls --cafile /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem