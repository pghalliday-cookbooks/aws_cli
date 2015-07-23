def whyrun_supported?
  true
end

use_inline_resources

action :create do
  content = S3api.get_object(
    new_resource.region,
    new_resource.bucket,
    new_resource.key,
    new_resource.access_key_id,
    new_resource.secret_access_key,
    new_resource.kms
  )
  file new_resource.path do
    content content
  end
end
