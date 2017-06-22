#!/bin/bash

# default app name and app location
DEFAULT_MASHLING_APP_NAME='sample-mashling-app'
DEFAULT_MASHLING_APP_FOLDER='./gateway/sample'

new_app=true
while getopts n:p:e option
do
 case "${option}"
 in
 n) NAME=${OPTARG};;
 p) DIR=${OPTARG};;
 e) new_app=false;;
 esac
done

if [ "${NAME}" = '' ] && [ "${DIR}" == '' ];
then
    # take user inputs and, if none provided, use default values
    echo -n "Enter the name of the mashling app (Default: $DEFAULT_MASHLING_APP_NAME) > "
    read NAME
    NAME=${NAME:-$DEFAULT_MASHLING_APP_NAME}
    echo -n "Enter the path of the mashling app folder (Default: $DEFAULT_MASHLING_APP_FOLDER) > "
    read DIR
    DIR=${DIR:-$DEFAULT_MASHLING_APP_FOLDER}
fi

# export env vars
export MASHLING_NAME=$NAME
export MASHLING_LOC=$DIR

# check if the mashling by the specified name exists in the app location
if ! ls $MASHLING_LOC/bin/$MASHLING_NAME* 1> /dev/null 2>&1; then
    printf "\nMashling $MASHLING_NAME does not exist in $MASHLING_LOC/bin folder!!\n\n"
    exit 1
fi

if $new_app
then
    # create the temp directory for the mashling app
    printf "\nCreating ./gateway/$MASHLING_NAME temp directory\n"
    rm -rf ./gateway/$MASHLING_NAME && mkdir ./gateway/$MASHLING_NAME && mkdir ./gateway/$MASHLING_NAME/bin

    # copy the mashling binary to the temp directory
    printf "\nCopying $MASHLING_NAME mashling binary into the ./gateway/$MASHLING_NAME folder\n"
    cp $MASHLING_LOC/bin/$MASHLING_NAME ./gateway/$MASHLING_NAME/bin

    # copy the mashling flogo.json file to the temp directory
    printf "\nCopying flogo.json into the ./gateway/$MASHLING_NAME folder\n"
    cp $MASHLING_LOC/bin/flogo.json ./gateway/$MASHLING_NAME/bin/flogo.json
fi

# export the env var under the .env file. please check https://docs.docker.com/compose/environment-variables/ for details.
# the MASHLING_NAME is accessed inside the docker-compose.yml and also inside the Dockerfile-mashling file.
printf "\nBuilding now Envoy front-proxy with mashling as a member service\n"
echo "MASHLING_NAME=$MASHLING_NAME" > .env

# set the .env file as effective input to the docker-compose
env $(cat .env | xargs) docker-compose up --build -d

# clean-up the temporary directory
if $new_app && [ "./gateway/$MASHLING_NAME" != "$DEFAULT_MASHLING_APP_FOLDER" ]
then
    printf "\nCleaning up temporary location ./gateway/$MASHLING_NAME\n"
    rm -rf ./gateway/$MASHLING_NAME
fi

printf "\nMashling is running as a member service inside Envoy front-proxy!\n\n"
