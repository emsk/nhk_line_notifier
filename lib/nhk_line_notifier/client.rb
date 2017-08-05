require 'net/http'
require 'nhk_program'
require 'time'

module NhkLineNotifier
  class Client < NHKProgram::Client
    NHK_ENDPOINT = 'http://api.nhk.or.jp/v2/pg'.freeze
    LINE_NOTIFY_ENDPOINT = 'https://notify-api.line.me/api/notify'.freeze

    attr_accessor :area, :service, :date, :nhk_key, :line_key, :word

    def initialize(options = {})
      options.each do |key, value|
        instance_variable_set(:"@#{key}", value)
      end

      super(endpoint: NHK_ENDPOINT, api_key: @nhk_key)

      @programs = []
    end

    def search
      data = list(@area, @service, Date.today + @date)

      word = /#{Regexp.quote(@word)}/
      @programs = data.list.send(@service).map do |program|
        next unless word =~ program.title || word =~ program.content
        "[#{Time.parse(program.start_time).strftime('%Y-%m-%d %H:%M')}]\n#{program.title}"
      end

      @programs.compact!
    end

    def notify
      return if @programs.empty?

      uri = URI.parse(LINE_NOTIFY_ENDPOINT)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      req = Net::HTTP::Post.new(uri.request_uri)
      req['Authorization'] = "Bearer #{@line_key}"
      req.set_form_data(message: "\n#{@programs.join("\n")}")

      https.request(req)
    end
  end
end
