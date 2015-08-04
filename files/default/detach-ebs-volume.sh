#/bin/bash -e

RUBY=$1
VOLUME_ID=$2
INSTANCE_ID=$3
REGION=$4
AWS_ACCESS_KEY_ID=$5
AWS_SECRET_ACCESS_KEY=$6

function get_state {
  aws --region $REGION ec2 describe-volumes --volume-ids $VOLUME_ID | $RUBY -e "
  require 'json'
  print JSON.parse(ARGF.read)['Volumes'][0]['State']
  "
}

aws --region $REGION ec2 detach-volume --volume-id $VOLUME_ID --instance-id $INSTANCE_ID

while ! [ "$(get_state)" == "available" ]; do
  sleep 1
done
