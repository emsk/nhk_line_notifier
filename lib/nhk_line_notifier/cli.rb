require 'nhk_line_notifier/client'
require 'thor'

module NhkLineNotifier
  class CLI < Thor
    default_command :execute

    desc 'execute', 'Search NHK programs and notify via LINE Notify'
    option :area, type: :string, aliases: '-a', required: true
    option :service, type: :string, aliases: '-s', required: true
    option :date, type: :numeric, aliases: '-d', required: true
    option :nhk_key, type: :string, aliases: '-n', required: true
    option :line_key, type: :string, aliases: '-l', required: true
    option :word, type: :string, aliases: '-w'

    def execute
      client = Client.new(
        area:     options[:area],
        service:  options[:service],
        date:     options[:date],
        nhk_key:  options[:nhk_key],
        line_key: options[:line_key],
        word:     options[:word]
      )
      client.search
      client.notify
    end

    desc 'version, -v, --version', 'Print the version'
    map %w[-v --version] => :version

    def version
      puts "nhk_line_notifier #{NhkLineNotifier::VERSION}"
    end
  end
end
