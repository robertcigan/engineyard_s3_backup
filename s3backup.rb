require 'rubygems'
require 'aws-sdk'
require 'yaml'

config_path = File.expand_path(File.dirname(__FILE__) + '/s3backup.yaml')
config = YAML.load(File.read(config_path))
s3_source = AWS::S3.new(:access_key_id => config['source']['aws_id'], :secret_access_key => config['source']['aws_key'])
s3_target = AWS::S3.new(:access_key_id => config['target']['aws_id'], :secret_access_key => config['target']['aws_key'])
source_buckets = s3_source.buckets.select { |b| b.name.include?(config['source']['bucket_pattern']) }

target_bucket = s3_target.buckets[config['target']['bucket']]
target_bucket = s3_target.buckets.create(config['target']['bucket']) unless target_bucket.exists?

source_buckets.each do |bucket|
  puts "Source bucket: #{bucket.name}"
  bucket.objects.each do |object|
    print object.key
    $stdout.flush
    target_object = target_bucket.objects[object.key]
    if target_object.exists?
      puts ' ....... skipped'
    else
      target_object = target_bucket.objects.create(object.key)
      target_object.write(object.read)
      puts ' ....... copied'
    end
  end
end