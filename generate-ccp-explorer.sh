#!/bin/bash
# Generate CCP
function one_line_pem {
    echo "`awk 'NF {sub(/\\n/, ""); printf "%s\\\\\\\n",$0;}' $1`"
}

function json_ccp {
    local PP=$(one_line_pem $4)
    local CP=$(one_line_pem $5)
    sed -e "s/\${ORGNAME}/$1/" \
        -e "s/\${P0PORT}/$2/" \
        -e "s/\${CAPORT}/$3/" \
        -e "s#\${PEERPEM}#$PP#" \
        -e "s#\${CAPEM}#$CP#" \
        template/ccp-template.json
}

function json_connection_profile {
    sed -e "s/\${ORG_NAME}/$1/" \
        -e "s/\${NETWORK_NAME}/$2/" \
        -e "s/\${ADMIN_USERNAME}/$3/" \
        -e "s/\${ADMIN_PASSWORD}/$4/" \
        -e "s/\${ORG_MSPNAME}/$5/" \
        -e "s/\${PEER_ORG_DOMAIN}/$6/" \
        -e "s/\${ORG_DOMAIN}/$7/" \
        -e "s/\${PEER_ORG_CORE_ADDRESS}/$8/" \
        -e "s/\${CHANNEL_NAME}/$9/" \
        template/connection-profile-org.json
}

function json_config_org {
    sed -e "s/\${ORG_NAME}/$1/" \
        template/config-org.json
}

## Generate CCP

PEERPEM=./crypto-config/peerOrganizations/${ORG1_DOMAIN}/tlsca/tlsca.${ORG1_DOMAIN}-cert.pem
CAPEM=./crypto-config/peerOrganizations/${ORG1_DOMAIN}/ca/ca.${ORG1_DOMAIN}-cert.pem
echo "$(json_ccp $ORG1_NAME $PEER0_ORG1_PORT $HOST1_CAPORT $PEERPEM $CAPEM)" > ./crypto-config/peerOrganizations/${ORG1_DOMAIN}/connection-${ORG1_NAME}.json

PEERPEM=./crypto-config/peerOrganizations/${ORG2_DOMAIN}/tlsca/tlsca.${ORG2_DOMAIN}-cert.pem
CAPEM=./crypto-config/peerOrganizations/${ORG2_DOMAIN}/ca/ca.${ORG2_DOMAIN}-cert.pem
echo "$(json_ccp $ORG2_NAME $PEER0_ORG2_PORT $HOST2_CAPORT $PEERPEM $CAPEM)" > ./crypto-config/peerOrganizations/${ORG2_DOMAIN}/connection-${ORG2_NAME}.json

mkdir -p ./explorer/${ORG1_NAME}
mkdir -p ./explorer/${ORG2_NAME}

## Generate Config for explorer
echo "$(json_connection_profile $ORG1_NAME $NETWORK_NAME $HOST1_CA_ADMIN_NAME $HOST1_CA_ADMIN_PASSWORD $ORG1_MSPNAME $PEER0_ORG1_DOMAIN $ORG1_DOMAIN $PEER0_ORG1_CORE_ADDRESS $CHANNEL_NAME)" > ./explorer/${ORG1_NAME}/connection-profile-${ORG1_NAME}.json
echo "$(json_config_org $ORG1_NAME)" > ./explorer/${ORG1_NAME}/config-global.json
echo "$(json_config_org $ORG1_NAME)" > ./explorer/${ORG1_NAME}/config-${ORG1_NAME}.json

echo "$(json_connection_profile $ORG2_NAME $NETWORK_NAME $HOST2_CA_ADMIN_NAME $HOST2_CA_ADMIN_PASSWORD $ORG2_MSPNAME $PEER0_ORG2_DOMAIN $ORG2_DOMAIN $PEER0_ORG2_CORE_ADDRESS $CHANNEL_NAME)" > ./explorer/${ORG2_NAME}/connection-profile-${ORG2_NAME}.json
echo "$(json_config_org $ORG1_NAME)" > ./explorer/${ORG2_NAME}/config-global.json
echo "$(json_config_org $ORG2_NAME)" > ./explorer/${ORG2_NAME}/config-${ORG2_NAME}.json