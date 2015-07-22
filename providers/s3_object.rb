require 'tempfile'

def whyrun_supported?
  true
end

use_inline_resources

def aws_authentication
  if new_resource.access_key_id
    [
      "AWS_ACCESS_KEY_ID=#{new_resource.access_key_id}",
      "AWS_SECRET_ACCESS_KEY=#{new_resource.secret_access_key}"
    ].join(' ')
  else
    ''
  end
end

def aws_config
  kms_config = ::File.join(Chef::Config['file_cache_path'], 'kmsconfig')
  if new_resource.kms
    "AWS_CONFIG_FILE=#{kms_config}"
  else
    ''
  end
end

def aws_command
  [
    aws_authentication,
    aws_config,
    'aws s3api get-object',
    "--region #{new_resource.region}",
    "--bucket #{new_resource.bucket}",
    "--key #{new_resource.key}",
    new_resource.path
  ].join(' ')
end

action :create do
  bash "s3_object create #{new_resource.path}" do
    code aws_command
  end
end
