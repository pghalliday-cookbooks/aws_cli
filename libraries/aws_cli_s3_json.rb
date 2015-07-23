require File.join(File.dirname(__FILE__), 's3api_get_object')
require 'json'

module AwsCliS3Json
  def aws_cli_s3_json (region, bucket, key, access_key_id, secret_access_key, kms)
    JSON.parse S3api::GetObject.new(region, bucket, key, access_key_id, secret_access_key, kms).read
  end
end

class Chef::Recipe ; include AwsCliS3Json ; end
class Chef::Resource ; include AwsCliS3Json ; end
