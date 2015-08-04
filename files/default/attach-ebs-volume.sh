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
  print JSON.parse(ARGF.read)['Volumes'][0]['State']
  "
}

if ! [ "$(get_state)" == "in-use" ]; then
  aws --region $REGION ec2 attach-volume --volume-id $VOLUME_ID --instance-id $INSTANCE_ID --device $DEVICE

  while ! [ "$(get_state)" == "in-use" ]; do
    sleep 1
  done
fi
