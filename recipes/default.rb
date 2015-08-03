package 'python'
package 'python-pip'

cache = ::File.join(Chef::Config['file_cache_path'], 'aws_cli')
directory cache

bash 'install AWS CLI tools' do
  code <<-EOH
  pip install awscli
  EOH
  not_if { ::File.exist?('/usr/bin/aws') }
end

kms_config = ::File.join(cache, 'kmsconfig')
cookbook_file kms_config do
  mode 0666
end

initialise_and_mount_sh = ::File.join(cache, 'initialise-and-mount.sh')
cookbook_file initialise_and_mount_sh do
  mode 0755
end

unmount_sh = ::File.join(cache, 'unmount.sh')
cookbook_file unmount_sh do
  mode 0755
end

attach_ebs_volume_sh = ::File.join(cache, 'attach-ebs-volume.sh')
cookbook_file attach_ebs_volume_sh do
  mode 0755
end

detach_ebs_volume_sh = ::File.join(cache, 'detach-ebs-volume.sh')
cookbook_file detach_ebs_volume_sh do
  mode 0755
end
