#/bin/bash -e

VOLUME_ID=$1
INSTANCE_ID=$2
AWS_ACCESS_KEY_ID=$3
AWS_SECRET_ACCESS_KEY=$4

RUBY=/opt/chef/embedded/bin/ruby

function get_state {
  aws ec2 describe-volumes --volume-ids $VOLUME_ID | $RUBY -e "
  require 'json'
  print JSON.parse(ARGF.read)['Volumes'][0]['State']
  "
}

aws ec2 detach-volume --volume-id $VOLUME_ID --instance-id $INSTANCE_ID

while ! [ "$(get_state)" == "available" ]; do
  sleep 1
done
