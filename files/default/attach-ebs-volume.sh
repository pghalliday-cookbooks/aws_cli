#/bin/bash

set -e

RUBY=$1
VOLUME_ID=$2
INSTANCE_ID=$3
DEVICE=$4
REGION=$5
AWS_ACCESS_KEY_ID=$6
AWS_SECRET_ACCESS_KEY=$7

STATE=
ATTACHMENT_STATE=
ATTACHMENT_INSTANCE_ID=

function get_state {
  aws --region $REGION ec2 describe-volumes --volume-ids $VOLUME_ID | $RUBY -e "
  require 'json'
  json = ARGF.read
  description = JSON.parse(json)['Volumes'][0]
  state = description['State']
  attachment_state = 'n/a'
  attachment_instance_id = 'n/a'
  if state == 'in use'
    attachment = description['Attachments'][0][
    attachment_state = attachment['State']
    attachment_instance_id = attachment['InstanceId']
  end
  print \"#{state} #{attachment_state} #{attachment_instance_id}\"
  "
}

function set_state_vars {
  states_and_instance=$(get_state)
  STATE=$(echo $states_and_instance | cut -f1)
  ATTACHMENT_STATE=$(echo $states_and_instance | cut -f2)
  ATTACHMENT_INSTANCE_ID=$(echo $states_and_instance | cut -f3)
}

set_state_vars

if [ "$STATE" == "in-use" ]; then
  if ! [ "$ATTACHMENT_INSTANCE_ID" == "$INSTANCE_ID" ]; then
    while ! [ "$STATE" == "available" ]; do
      sleep 1
      set_state_vars
    done
  fi
fi

if [ "$STATE" == "available" ]; then
  aws --region $REGION ec2 attach-volume --volume-id $VOLUME_ID --instance-id $INSTANCE_ID --device $DEVICE

  while ! [ "$ATTACHMENT_STATE" == "attached" ]; do
    sleep 1
    set_state_vars
  done
fi
