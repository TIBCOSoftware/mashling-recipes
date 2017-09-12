#!/bin/bash
set -e

export GOOS=linux
export GOARCH=amd64

#   set up the root dir for this script
export ROOT_DIR=$(pwd)
pushd $ROOT_DIR > /dev/null

DEFAULT_MASHLING_APP_NAME='kafka-mashling-app'
DEFAULT_MASHLING_DEFINITION=$ROOT_DIR/kafka/mashling-kafka-definition.json

while getopts n:f: option
do
 case "${option}"
 in
 n) MASHLING_NAME=${OPTARG};;
 f) MASHLING_JSON_PATH=$OPTARG;;
 esac
done

use_mashling_json_input=true

if [ "$MASHLING_JSON_PATH" == "" ]
then
    # path of mashling.json not specified. use default mashling_name
    use_mashling_json_input=false
    if [ "$MASHLING_NAME" == "" ]
    then
        printf "Using the default app name '$DEFAULT_MASHLING_APP_NAME'\n"
        MASHLING_NAME=$DEFAULT_MASHLING_APP_NAME
    fi    
fi

pushd gateway > /dev/null
if $use_mashling_json_input
then
    printf "Creating Kafka Mashling $MASHLING_NAME from definition under $ROOT_DIR/gateway folder\n"
    export FLOGO_EMBED=false && $GOPATH/bin/mashling create -f $MASHLING_JSON_PATH $MASHLING_NAME
else
    printf "Creating Kafka Mashling $MASHLING_NAME under $ROOT_DIR/gateway folder\n"
    export FLOGO_EMBED=false && $GOPATH/bin/mashling create -f $DEFAULT_MASHLING_DEFINITION $MASHLING_NAME

fi    

export MASHLING=$MASHLING_NAME

popd > /dev/null
printf "Mashling $MASHLING created successfully under $ROOT_DIR/gateway folder\n"

chmod u+x setupEnvoyFrontProxy.sh

# invoke the envoy mesh setup script with the following options:
#   -n (name of the mashling)
#   -p (path to the mashling app folder)
#   -f (docker-compose yaml template)
#   -e (flag to indicate that the mashling app already exists ...and should not be deleted)
bash ./setupEnvoyFrontProxy.sh -n $MASHLING -p $ROOT_DIR/gateway/$MASHLING -f $ROOT_DIR/kafka/docker-compose-kafka.yml -e