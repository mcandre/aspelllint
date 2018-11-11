require_relative 'aspelllint'

require 'find'
require 'optparse'
require 'dotsmack'

require 'docopt'
require 'json'
require 'stat'

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

            findings = []
            dotsmack.enumerate(filenames).each do |filename, _|
                begin
                    if filename == '-'
                        Aspelllint::check_stdin
                    else
                        if !is_stat
                            Aspelllint::check(filename, filename, is_stat, personal)
                        else
                            Aspelllint::check(filename, filename, is_stat, personal ) { |finding|
                                findings.push(finding)
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

            if is_stat && findings.length > 0
                process = StatModule::Process.new('Aspellint')
                process.version = "#{Aspelllint::VERSION}"
                process.description = 'Aspelllint searches your projects for spelling errors.'
                process.maintainer = 'Andrew Pennebaker'
                process.email = 'andrew.pennebaker@gmail.com'
                process.website = 'https://github.com/mcandre/aspelllint'
                process.repeatability = 'Associative'
                stat = StatModule::Stat.new(process)
                stat.findings = findings
                puts stat.to_json
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
