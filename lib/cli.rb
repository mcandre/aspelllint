require_relative 'aspelllint'

require 'find'
require 'optparse'
require 'dotsmack'

require 'docopt'
require 'json'

STAT_HEADER = <<-eos
{
  "statVersion": "0.4.0",
  "process": {
    "name": "Spell check for large projects",
    "version": "#{Aspelllint::VERSION}",
    "description": "Aspelllint searches your projects for spelling errors",
    "maintainer": "Andrew Pennebaker",
    "email": "andrew.pennebaker@gmail.com",
    "website": "https://github.com/mcandre/aspelllint",
    "repeatability": "Associative"
  },
  "findings": [
eos

STAT_FOOTER = <<-eos

  ]
}
eos

USAGE = <<DOCOPT
Usage:
  aspelllint [options] [-i <pattern>]... [<file>]...
  aspelllint -s | --stat
  aspelllint -v | --version
  aspelllint -h | --help

Arguments:
  <file>                 Filename, or - for stdin [default: -]

Options:
  -i --ignore <pattern>  Ignore file pattern (fnmatch)
  -p --personal <file>   Personal dictionary
  -s --stat              Output in STAT
  -v --version           Print version info
  -h --help              Print usage info
DOCOPT

module Aspelllint
  def self.main
    ignores = DEFAULT_IGNORES

    begin
      options = Docopt::docopt(USAGE, version: Aspelllint::VERSION)

      if options['--ignore']
        ignores = ignores.concat(options['--ignore'])
      end

      filenames = options['<file>']

      is_stat = options['--stat']

      # Work around https://github.com/docopt/docopt/issues/274
      if filenames == []
        filenames = ['-']
      end

      dotsmack = Dotsmack::Smacker.new(
        dotignore = '.aspelllintignore',
        additional_ignores = ignores
      )

      personal = options['--personal']

      finding_count = 0
      dotsmack.enumerate(filenames).each do |filename, _|
        begin
          if filename == '-'
            Aspelllint::check_stdin
          else
            if !is_stat
              Aspelllint::check(filename, filename, is_stat, personal)
            else
              Aspelllint::check(filename, filename, is_stat, personal ) { |finding|
                puts STAT_HEADER if finding_count == 0
                puts ',' if finding_count > 0
                print JSON.pretty_generate(finding).lines.map { |line| '    ' + line }.join
                finding_count += 1
              }
            end
          end
        #
        # Invalid byte sequence in UTF-8 file.
        # Likely a false positive text file.
        #
        rescue ArgumentError
          nil
        end
      end

      if is_stat && finding_count > 0
        puts STAT_FOOTER
      end

    rescue Docopt::Exit => e
      puts e.message
    end
  rescue Interrupt
    nil
  rescue Errno::EPIPE, Errno::EMFILE
    nil
  end
end
