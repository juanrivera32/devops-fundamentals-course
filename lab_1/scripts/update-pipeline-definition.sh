#!/bin/bash

# colors
red=$'\e[1;31m'
grn=$'\e[1;32m'
#yel=$'\e[1;33m'
#blu=$'\e[1;34m'
#mag=$'\e[1;35m'
#cyn=$'\e[1;36m'
end=$'\e[0m'

checkJQ() {
  # jq test
  type jq >/dev/null 2>&1
  exitCode=$?

  echo $exitCode;
  if [ "$exitCode" -ne 0 ]; then
    printf "  ${red}'jq' not found! (json parser)\n${end}"
    printf "    Ubuntu Installation: sudo apt install jq\n"
    printf "    Redhat Installation: sudo yum install jq\n"
    jqDependency=0
  elif [[ "$DEBUG" -eq 1 ]]; then
    printf "  ${grn}'jq' found!\n${end}"
  fi
}

checkJQ

current_json=$1

if [ ! -f "$current_json" ]; then
    echo "${red}$current_json is not a file or does not exist"
    exit 1;
fi

while [ ! -z "$1" ]; do
  case "$1" in
     --branch)
         shift
         branch=$1
         ;;
     --owner)
         shift
         owner=$1
         ;;
     --poll-for-source-changes)
        shift
        pollForSourceChanges=$1
         ;;
    --configuration)
         shift
         configuration=$1
         ;;
  esac
shift
done

branch="${branch:=main}"
pollForSourceChanges="${pollForSourceChanges:=false}"

echo ">>>>>> $pollForSourceChanges"

echo "Creating copy of pipeline.json file"
echo ""

new_json_file="../pipeline$(date +%F_%H-%M-%S).json"
# touch $new_json_file
# cp ../pipeline.json $current_json

# Remove metadata from file
# jq '. |= del(.metadata)' $current_json >> $new_json_file

# Increment version by one
# jq '. |= del(.metadata) | .pipeline.version |= . + 1' $current_json >> $new_json_file

# jq '.. | .EnvironmentVariables?'
# jq '(.. | .configuration?.EnvironmentVariables?) |= "XXXX"' $current_json

# jq --arg configuration $configuration '.. | .EnvironmentVariables? | select(. != null) | gsub("{{BUILD_CONFIGURATION value}}";$configuration)' $current_json


jq --arg configuration $configuration --arg branch $branch --arg owner $owner --arg pollForSourceChanges $pollForSourceChanges '. |= del(.metadata) | .pipeline.version |= . + 1 | .pipeline.stages[0].actions[0].configuration.Branch |= $branch | .pipeline.stages[0].actions[0].configuration.Owner |= $owner | .pipeline.stages[0].actions[0].configuration.PollForSourceChanges |= $pollForSourceChanges | .. | .EnvironmentVariables? | select(. != null) | sub("{{BUILD_CONFIGURATION value}}";$configuration)' $current_json >> $new_json_file


