require 'tempfile'

module S3api

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

  def aws_config (kms)
    kms_config = ::File.join(Chef::Config['file_cache_path'], 'kmsconfig')
    if kms
      "AWS_CONFIG_FILE=#{kms_config}"
    else
      ''
    end
  end

  def aws_command (region, bucket, key, path, access_key_id, secret_access_key, kms)
    [
      aws_authentication(access_key_id, secret_access_key),
      aws_config(kms),
      'aws s3api get-object',
      "--region #{region}",
      "--bucket #{bucket}",
      "--key #{key}",
      path
    ].join(' ')
  end

  def S3api.get_object (region, bucket, key, access_key_id, secret_access_key, kms)
    temp_file = Tempfile.new('s3api_json')
    begin
      get_object = Mixlib::ShellOut.new aws_command(region, bucket, key, temp_file.path, access_key_id, secret_access_key, kms)
      get_object.run_command
      get_object.error!
      File.read(temp_file)
    ensure
      temp_file.unlink
    end
  end

end
