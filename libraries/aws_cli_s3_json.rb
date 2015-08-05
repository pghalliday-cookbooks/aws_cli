require File.join(File.dirname(__FILE__), 's3api_get_object')
require 'json'

module AwsCliS3Json
  def aws_cli_s3_json (region, bucket, key, access_key_id, secret_access_key, kms)
    whichAws = Mixlib::ShellOut.new('which aws')
    whichAws.run_command
    if whichAws.error?
      # aws command not available so install it now
      installPython = Mixlib::ShellOut.new('apt-get -y install python')
      installPython.run_command
      installPython.error!
      installPythonPip = Mixlib::ShellOut.new('apt-get -y install python-pip')
      installPythonPip.run_command
      installPythonPip.error!
      installAws = Mixlib::ShellOut.new('pip install awscli')
      installAws.run_command
      installAws.error!
    end
    S3api::Object.get(region, bucket, key, access_key_id, secret_access_key, kms) do |content|
      JSON.parse content
    end
  end
end

class Chef::Recipe ; include AwsCliS3Json ; end
class Chef::Resource ; include AwsCliS3Json ; end
