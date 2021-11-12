require 'json'
require 'logger'
require 'aws-sdk-s3'
require 'open-uri'
require 'net/http'
require 'time'

def lambda_handler(event:, context:)
    logger = Logger.new($stdout)
    
    logger.info(event)
    
    body = JSON.parse(event["body"])
    
    logger.info(body)
    
    logger.info("Get Zoom Recording file download path")
    
    region = 'ap-northeast-1'
    bucket_name = "zoom-recoding"
    
    s3_client = Aws::S3::Client.new(region: region)
    
    recording_files = body["payload"]["object"]["recording_files"]
    meeting_id = body["payload"]["object"]["uuid"]
    host_id = body["payload"]["object"]["host_id"]
    start_time = Time.parse(body["payload"]["object"]["start_time"])
    start_time += 9*60*60
    
    token = body["download_token"]
    path = ""
    
    recording_files.each do |v|
        path = v["download_url"] if v["file_type"] == "MP4"
    end
    
    download_path = "#{path}?access_token=#{token}"

    object_key = "#{meeting_id}.mp4"

    logger.info(download_path)
    logger.info(token)
    
    URI.open(download_path) do |file|
        s3_client.put_object({
            :bucket => bucket_name,
            :key    => "recording/#{host_id}/#{start_time.strftime("%Y/%m/%d/%H:%M")}/#{object_key}",
            :content_type => "movie/mp4",
            :body   => file.read
        })
    end
end