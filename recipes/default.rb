package 'python'
package 'python-pip'
bash 'install AWS CLI tools' do
  code <<-EOH
  pip install awscli
  EOH
  not_if { ::File.exist?('/usr/bin/aws') }
end
kms_config = ::File.join(Chef::Config['file_cache_path'], 'kmsconfig')
cookbook_file kms_config do
  source 'kms_config'
  mode 0666
end
