#!/bin/bash
export GOOS=linux
export GOARCH=amd64

DEFAULT_MASHLING_APP_NAME='sample-mashling-app'

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
        printf "\nUsing the default app name '$DEFAULT_MASHLING_APP_NAME'"
        MASHLING_NAME=$DEFAULT_MASHLING_APP_NAME
    fi    
fi

pushd gateway
if $use_mashling_json_input
then
    printf "\nCreating Mashling $MASHLING_NAME from definition under ./gateway folder\n"
    $GOPATH/bin/mashling create -f $MASHLING_JSON_PATH $MASHLING_NAME
else
    printf "\nCreating Mashling $MASHLING_NAME under ./gateway folder\n"
    $GOPATH/bin/mashling create $MASHLING_NAME
fi    

export MASHLING=$MASHLING_NAME

popd
printf "\nMashling $MASHLING created successfully under ./gateway folder\n"

chmod u+x setupEnvoyFrontProxy.sh

# invoke the envoy mesh setup script with the following options:
#   -n (name of the mashling)
#   -p (path to the mashling app folder)
#   -e (flag to indicate that the mashling app already exists ...and should not be deleted)
bash ./setupEnvoyFrontProxy.sh -n $MASHLING -p ./gateway/$MASHLING -e