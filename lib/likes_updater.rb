require "grailbird_updater"
require "json"
require "colorize"
require "yaml"
require "oauth"

class LikesUpdater < GrailbirdUpdater
  def initialize(dir, verbose, prune, key_dir, write_csv)
    super
    @js_prefix = "data/js_likes"
    @js_path = "#{@base_dir}/#{@js_prefix}"
    @csv_path = "#{@base_dir}/data/csv_likes"
  end

  def make_twitter_request(uri, screen_name)
    if "/1.1/statuses/user_timeline.json" == uri.path
      uri = uri.dup
      uri.path = "/1.1/favorites/list.json"
    end
    response = super(uri, screen_name)
    if response.is_a?(Net::HTTPSuccess)
      response
    else
      $stderr.puts response.body
      exit(1)
    end
  end

  def update_tweet_index(tweet_index, year_month, count)
    super.each do |item|
      item.fetch("file_name").sub!("data/js/", "#{@js_prefix}/")
    end
  end
end

if __FILE__ == $0
  dir = File.expand_path("../..", __FILE__)
  LikesUpdater.new(dir, $VERBOSE, true, dir, false).update_tweets
end
