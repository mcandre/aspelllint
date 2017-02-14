require_relative 'version'
require_relative 'cli'

require 'ptools'
require 'tempfile'
require 'English'

DEFAULT_IGNORES = %w(
  .hg
  .svn
  .git
  .aspelllintignore
  .gtdlintignore
  .gtdlintrc.yml
  node_modules
  bower_components
  target
  dist
  .vagrant
  Gemfile.lock
  *.exe
  *.bin
  *.apk
  *.ap_
  res
  *.class
  *.zip
  *.jar
  *.war
  *.xpi
  *.dmg
  *.pkg
  *.app
  *.xcodeproj
  *.lproj
  *.xcassets
  *.pmdoc
  *.dSYM
  *.jad
  *.cmo
  *.cmi
  *.png
  *.gif
  *.jpg
  *.jpeg
  *.tiff
  *.ico
  *.svg
  *.dot
  *.wav
  *[.-]min.*
)

#
# Parse, model, and print a misspelling
#
class Misspelling
  attr_accessor :filename, :line, :column, :word, :suggestions

  def self.parse(filename, aspell_line)
    match = aspell_line.match(/^\&\s(.+)\s([0-9]+)\s([0-9]+)\:\s(.+)$/)

    w = match[1]
    l = match[2]
    c = match[3]
    s = match[4]

    Misspelling.new(filename, w, l, c, s)
  end

  def initialize(filename, word, line, column, suggestions)
    @filename = filename
    @word = word
    @line = line
    @column = column
    @suggestions = suggestions
  end

  def to_s
    "#{filename}:#{line}:#{column} #{word}: #{suggestions}"
  end

  def to_finding
    {
        :failure => true,
        :rule => 'Spelling error',
        :description => "Observed word: #{word}",
        :categories => [
            'Bug Risk'
        ],
        :location => {
            :path => "#{filename}",
            :beginLine => "#{line}",
        },
        :fixes => generate_fixes
    }
  end
    def generate_fixes
      f = []
      suggestions.split(', ').each { |w|
        f <<
          {
                :location => {
                    :path => "#{filename}",
                    :beginLine => "#{line}",
                },
                :newText => "#{w}"
            }
      }
      return f
    end
end

module Aspelllint
  def self.check_stdin
    contents = $stdin.read

    t = Tempfile.new('aspelllint')
    t.write(contents)
    t.close

    check(t.path, 'stdin')
  ensure
    t.delete
  end

  def self.executable_in_path?(name)
    ENV['PATH'].split(File::PATH_SEPARATOR).any? do |path|
      File.executable?(File.join(path, name))
    end
  end

  def self.check(filename, original_name = filename, is_stat = false, personal = nil)
    fail 'aspell not found in PATH' unless executable_in_path?('aspell')
    options = "-p #{personal}" if personal
    output = `sed 's/#/ /g' "#{filename}" 2>&1 | aspell -a -c #{options} 2>&1`

    fail('aspell failed: ' << output) unless $CHILD_STATUS.success?

    lines = output.split("\n").select { |line| line =~ /^\&\s.+$/ }
    misspellings = lines.map { |line| Misspelling.parse(original_name, line) }

    if is_stat
      misspellings.each { |finding|
            yield finding.to_finding if block_given?
        }
    else
      misspellings.each { |m| puts m }
    end
  end
end
