require 'net/http'
require 'nhk_program'
require 'thor'
require 'time'

module NhkLineNotifier
  class CLI < Thor
    NHK_ENDPOINT = 'http://api.nhk.or.jp/v2/pg'.freeze
    LINE_NOTIFY_ENDPOINT = 'https://notify-api.line.me/api/notify'.freeze

    default_command :execute

    desc 'execute', 'Search NHK programs and notify via LINE Notify'
    option :area, type: :string, aliases: '-a', required: true
    option :service, type: :string, aliases: '-s', required: true
    option :date, type: :numeric, aliases: '-d', required: true
    option :nhk_key, type: :string, aliases: '-n', required: true
    option :line_key, type: :string, aliases: '-l', required: true
    option :word, type: :string, aliases: '-w'

    def execute
      programs = search
      notify(programs)
    end

    private

    def search
      client = NHKProgram.new(endpoint: NHK_ENDPOINT, api_key: options[:nhk_key])

      data = client.list(options[:area], options[:service], Date.today + options[:date])

      word = /#{Regexp.quote(options[:word])}/
      programs = data.list.send(options[:service]).map do |program|
        next unless word =~ program.title || word =~ program.content
        "[#{Time.parse(program.start_time).strftime('%Y-%m-%d %H:%M')}]\n#{program.title}"
      end

      programs.compact
    end

    def notify(programs)
      return if programs.empty?

      uri = URI.parse(LINE_NOTIFY_ENDPOINT)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true

      req = Net::HTTP::Post.new(uri.request_uri)
      req['Authorization'] = "Bearer #{options[:line_key]}"
      req.set_form_data(message: "\n#{programs.join("\n")}")

      https.request(req)
    end
  end
end
