actions :create
default_action :create

attribute :path, name_attribute: true, kind_of: String, required: true
attribute :key, kind_of: String, required: true
attribute :bucket, kind_of: String, required: true
attribute :region, kind_of: String, required: true
attribute :access_key_id, kind_of: String
attribute :secret_access_key, kind_of: String
attribute :kms, kind_of: [TrueClass, FalseClass]
