require 'tempfile'

def whyrun_supported?
  true
end

use_inline_resources

def attach_command
  [
    ::File.join(Chef::Config['file_cache_path'], 'aws_cli/attach-ebs-volume.sh'),
    new_resource.ruby,
    new_resource.volume_id,
    new_resource.instance_id,
    new_resource.device,
    new_resource.region,
    new_resource.access_key_id,
    new_resource.secret_access_key
  ].join(' ')
end

def detach_command
  [
    ::File.join(Chef::Config['file_cache_path'], 'aws_cli/detach-ebs-volume.sh'),
    new_resource.ruby,
    new_resource.volume_id,
    new_resource.instance_id,
    new_resource.region,
    new_resource.access_key_id,
    new_resource.secret_access_key
  ].join(' ')
end

def mount_command
  [
    ::File.join(Chef::Config['file_cache_path'], 'aws_cli/initialise-and-mount.sh'),
    new_resource.device,
    new_resource.file_system,
    new_resource.mount_point
  ].join(' ')
end

def unmount_command
  [
    ::File.join(Chef::Config['file_cache_path'], 'aws_cli/unmount.sh'),
    new_resource.device,
    new_resource.mount_point
  ].join(' ')
end

action :attach do
  bash "attach and mount EBS volume #{new_resource.name}" do
    code <<-EOH
    set -e
    #{attach_command}
    #{mount_command}
    EOH
  end
end

action :detach do
  bash "unmount and detach EBS volume #{new_resource.name}" do
    code <<-EOH
    set -e
    #{unmount_command}
    #{detach_command}
    EOH
  end
end
