require_relative 'aspelllint'

require 'find'
require 'optparse'
require 'dotsmack'

require 'docopt'
require 'json'

USAGE = <<DOCOPT
Usage:
    aspelllint [options] [-i <pattern>]... [<file>]...
    aspelllint -v | --version
    aspelllint -h | --help

Arguments:
    <file>                 Filename, or - for stdin [default: -]

Options:
    -i --ignore <pattern>  Ignore file pattern (fnmatch)
    -p --personal <file>   Personal dictionary
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

            # Work around https://github.com/docopt/docopt/issues/274
            if filenames == []
                filenames = ['-']
            end

            dotsmack = Dotsmack::Smacker.new(
                dotignore = '.aspelllintignore',
                additional_ignores = ignores
            )

            personal = options['--personal']

            findings = []
            dotsmack.enumerate(filenames).each do |filename, _|
                begin
                    if filename == '-'
                        Aspelllint::check_stdin
                    else
                        Aspelllint::check(filename, filename, personal)
                    end
                #
                # Invalid byte sequence in UTF-8 file.
                # Likely a false positive text file.
                #
                rescue ArgumentError
                    nil
                end
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
