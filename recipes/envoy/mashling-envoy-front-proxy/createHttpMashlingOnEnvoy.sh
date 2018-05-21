#!/bin/bash
set -e

export GOOS=linux
export GOARCH=amd64

#   set up the root dir for this script
export ROOT_DIR=$(pwd)
pushd $ROOT_DIR > /dev/null

DEFAULT_MASHLING_APP_NAME='http-mashling-app'
DEFAULT_MASHLING_DEFINITION=$ROOT_DIR/http/mashling-http-definition.json
DEFAULT_MASHLING_BINARY=$ROOT_DIR/mashling-gateway

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
    printf "Creating Http Mashling $MASHLING_NAME from definition under $ROOT_DIR/gateway folder\n"
    mkdir -m777 $MASHLING_NAME
    cp -fr /$MASHLING_JSON_PATH $ROOT_DIR/gateway/$MASHLING_NAME
    cp -fr /$DEFAULT_MASHLING_BINARY $ROOT_DIR/gateway/$MASHLING_NAME
else
    printf "Creating Http Mashling $MASHLING_NAME under $ROOT_DIR/gateway folder\n"
    mkdir -m777 $MASHLING_NAME
    cp -R /$DEFAULT_MASHLING_DEFINITION $ROOT_DIR/gateway/$MASHLING_NAME
    cp -R /$DEFAULT_MASHLING_BINARY $ROOT_DIR/gateway/$MASHLING_NAME
fi    

cp -r $MASHLING_NAME/ $ROOT_DIR/http/$MASHLING_NAME

export MASHLING=$MASHLING_NAME

popd > /dev/null
printf "Mashling $MASHLING created successfully under $ROOT_DIR/gateway folder\n"

chmod u+x setupEnvoyFrontProxy.sh

# invoke the envoy mesh setup script with the following options:
#   -n (name of the mashling)
#   -p (path to the mashling app folder)
#   -f (docker-compose yaml template)
#   -e (flag to indicate that the mashling app already exists ...and should not be deleted)
bash ./setupEnvoyFrontProxy.sh -n $MASHLING -p $ROOT_DIR/gateway/$MASHLING -f $ROOT_DIR/http/docker-compose-http.yml -e
