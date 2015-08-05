require 'tempfile'

module S3api
  class Object

    def self.get(region, bucket, key, access_key_id, secret_access_key, kms)
      temp_file = Tempfile.new('s3api_get_object_json')
      temp_config = Tempfile.new('s3api_get_object_config')
      if kms
        temp_config.write <<-EOH
[default]
s3 =
    signature_version = s3v4
EOH
        temp_config.close
      end
      command = aws_command region, bucket, key, access_key_id, secret_access_key, temp_config.path
      begin
        get_object = Mixlib::ShellOut.new "#{command} #{temp_file.path}"
        get_object.run_command
        get_object.error!
        yield File.read(temp_file)
      ensure
        temp_file.unlink
        temp_config.unlink
      end
    end

    def aws_authentication (access_key_id, secret_access_key)
      if access_key_id
        [
          "AWS_ACCESS_KEY_ID=#{access_key_id}",
          "AWS_SECRET_ACCESS_KEY=#{secret_access_key}"
        ].join(' ')
      else
        ''
      end
    end

    def aws_command (region, bucket, key, access_key_id, secret_access_key, config)
      [
        aws_authentication(access_key_id, secret_access_key),
        "AWS_CONFIG_FILE=#{config}",
        'aws s3api get-object',
        "--region #{region}",
        "--bucket #{bucket}",
        "--key #{key}"
      ].join(' ')
    end

  end
end
