actions :attach, :detach
default_action :attach

attribute :volume_id, name_attribute: true, kind_of: String, required: true
attribute :instance_id, kind_of: String, required: true
attribute :device, kind_of: String, required: true
attribute :file_system, kind_of: String, required: true
attribute :mount_point, kind_of: String, required: true
attribute :access_key_id, kind_of: String
attribute :secret_access_key, kind_of: String
