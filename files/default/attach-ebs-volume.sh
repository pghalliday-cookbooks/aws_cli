#/bin/bash

set -e

RUBY=$1
VOLUME_ID=$2
INSTANCE_ID=$3
DEVICE=$4
REGION=$5
AWS_ACCESS_KEY_ID=$6
AWS_SECRET_ACCESS_KEY=$7

function get_state {
  aws --region $REGION ec2 describe-volumes --volume-ids $VOLUME_ID | $RUBY -e "
  require 'json'
  json = ARGF.read
  description = JSON.parse(json)['Volumes'][0]
  state = description['State']
  state = description['Attachments'][0]['State'] if state == 'in-use'
  print state
  "
}

if [ "$(get_state)" == "available" ]; then
  aws --region $REGION ec2 attach-volume --volume-id $VOLUME_ID --instance-id $INSTANCE_ID --device $DEVICE

  while ! [ "$(get_state)" == "attached" ]; do
    sleep 1
  done
fi
