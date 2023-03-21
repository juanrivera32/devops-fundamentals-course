#!/bin/bash

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
  esac
shift
done

branch="${branch:=main}"
pollForSourceChanges="${pollForSourceChanges:=false}"
echo ">>>>>> $pollForSourceChanges"

echo "Creating copy of pipeline.json file"
echo ""
current_json=../pipeline.json
new_json_file="../pipeline$(date +%F_%H-%M-%S).json"
# touch $new_json_file
# cp ../pipeline.json $current_json

# Remove metadata from file
# jq '. |= del(.metadata)' $current_json >> $new_json_file

# Increment version by one
# jq '. |= del(.metadata) | .pipeline.version |= . + 1' $current_json >> $new_json_file

echo $branch
# set branch property
jq --arg branch $branch --arg owner $owner --arg pollForSourceChanges $pollForSourceChanges '. |= del(.metadata) | .pipeline.version |= . + 1 | .pipeline.stages[0].actions[0].configuration.Branch |= $branch | .pipeline.stages[0].actions[0].configuration.Owner |= $owner | .pipeline.stages[0].actions[0].configuration.PollForSourceChanges |= $pollForSourceChanges' $current_json >> $new_json_file


