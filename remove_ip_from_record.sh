#!/bin/bash
ZONE_RESOURCE_GROUP=$1
ZONE_NAME=$2
RECORD_NAME=$3
IP_LIST=$4

for member in ${IP_LIST}; do
  echo "${member}"
  if [ "$(az network private-dns record-set a remove-record --record-set-name ${RECORD_NAME} --resource-group ${ZONE_RESOURCE_GROUP} --zone-name ${ZONE_NAME} --ipv4-address ${member} --only-show-errors)" ]; then
    echo "Given IP has been successfully removed from record set"
  else
    echo "Given IP does not exists in record set"
  fi
done
