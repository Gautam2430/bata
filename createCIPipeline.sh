#!/bin/bash
 
export PIPELINE_NAME=$1
export REPOSITORY_NAME=$2
export ENV=$3
 
if [ "${ENV}" == "dev" ]; then
  export REPOSITORY_BRANCH='develop'
elif [ "${ENV}" == "stage" ]; then
  export REPOSITORY_BRANCH='release'
elif [ "${ENV}" == "prod" ]; then
  export REPOSITORY_BRANCH='master'
fi
 
envsubst < "ContainerBuildTemplate.json" > "create-${PIPELINE_NAME}-build.json"
envsubst < "ModelPipelineTemplate.json" > "create-${PIPELINE_NAME}.json"
 
aws codebuild    create-project  --cli-input-json file://create-${PIPELINE_NAME}-build.json
aws codepipeline create-pipeline --cli-input-json file://create-${PIPELINE_NAME}.json