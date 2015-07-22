actions :upsert, :delete
default_action :upsert

attribute :hosted_zone_id, name_attribute: true, kind_of: String, required: true
attribute :hosts, kind_of: Array, required: true
attribute :ip, kind_of: String
attribute :access_key_id, kind_of: String
attribute :secret_access_key, kind_of: String
