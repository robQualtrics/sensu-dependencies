#!/bin/bash

for i in "$@"
do
case $i in
    -e|--entity)
    ENTITY="$2"
    shift # past argument
    shift # past value
    ;;
    -c|--check)
    CHECK="$2"
    shift # past argument
    shift # past value
    ;;
    *)
        # unknown option
    ;;
esac
done
echo "ENTITY  = ${ENTITY}"
echo "CHECK   = ${CHECK}"

rep=$(curl -X GET \
http://sensu-go-backend.service.a1-prv.consul:8080/api/core/v2/namespaces/default/events/${ENTITY}/${CHECK} \
-H "Authorization: Key $SENSU_API_KEY" | jq '.check.status')
status="$?"

if [ $status -eq 0 ]; then
    exit "$rep"
else
    exit 0
fi