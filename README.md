# aspelllint - spell check for large projects

Aspelllint searches your projects for spelling errors.

# EXAMPLES

```console
$ cat examples/nested/memo.md
# Announcing Casual Fribsday!

$ cat examples/toy-boats.txt
I like toy baots.

$ cat examples/toy-boats.txt | aspelllint
stdin:46:11 baots: boats, baits, bats, bots, bahts, boots, boat's, bait's, Bates, bat's, bates, beats, bits, bouts, Bootes, baht's, beauts, boot's, bets, bods, buts, blots, bad's, bards, bauds, bawds, beets, butts, beat's, bit's, bout's, beaut's, booty's, Batu's, bet's, bod's, Baotou's, bast's, blot's, Bert's, Burt's, bard's, baud's, bawd's, beet's, butt's

$ aspelllint examples/toy-boats.txt
examples/toy-boats.txt:46:11 baots: boats, baits, bats, bots, bahts, boots, boat's, bait's, Bates, bat's, bates, beats, bits, bouts, Bootes, baht's, beauts, boot's, bets, bods, buts, blots, bad's, bards, bauds, bawds, beets, butts, beat's, bit's, bout's, beaut's, booty's, Batu's, bet's, bod's, Baotou's, bast's, blot's, Bert's, Burt's, bard's, baud's, bawd's, beet's, butt's

$ aspelllint examples/
examples/nested/memo.md:18:20 Fribsday: FreeBSD, Frosty, Froissart, Frost, Freebased, Fireside, Freest, Frizzed, Robust, Forest, Fairest, Arabist, Forebode, Forebodes, Freebase, Foreboded, Fieriest, Furriest
examples/toy-boats.txt:46:11 baots: boats, baits, bats, bots, bahts, boots, boat's, bait's, Bates, bat's, bates, beats, bits, bouts, Bootes, baht's, beauts, boot's, bets, bods, buts, blots, bad's, bards, bauds, bawds, beets, butts, beat's, bit's, bout's, beaut's, booty's, Batu's, bet's, bod's, Baotou's, bast's, blot's, Bert's, Burt's, bard's, baud's, bawd's, beet's, butt's

$ aspelllint -i '*.md' examples/
examples/toy-boats.txt:46:11 baots: boats, baits, bats, bots, bahts, boots, boat's, bait's, Bates, bat's, bates, beats, bits, bouts, Bootes, baht's, beauts, boot's, bets, bods, buts, blots, bad's, bards, bauds, bawds, beets, butts, beat's, bit's, bout's, beaut's, booty's, Batu's, bet's, bod's, Baotou's, bast's, blot's, Bert's, Burt's, bard's, baud's, bawd's, beet's, butt's

$ aspelllint -i '*.md' -i '*.txt' examples/
$

$ cat examples/.aspell.en.pws
personal_ws-1.1 en 1
baots

$ aspelllint -p ./examples/.aspell.en.pws examples/toy-boats.txt
$

$ aspell -x -c examples/toy-boats.txt
I like toy [baots].

1) boats                                          6) boots
2) baits                                          7) boat's
3) bats                                           8) bait's
4) bots                                           9) Bates
5) bahts                                          0) bat's
i) Ignore                                         I) Ignore all
r) Replace                                        R) Replace all
a) Add                                            l) Add Lower
b) Abort                                          x) Exit

? 1

$ cat examples/toy-boats.txt
I like toy boats.

$ aspelllint examples/toy-boats.txt
$

$ aspelllint -h
Usage: aspelllint [options] [<files>|-]
-i, --ignore pattern             Ignore file pattern (fnmatch)
-s, --stat                       Output in STAT
-h, --help                       Print usage info
-v, --version                    Print version info
```

# HOMEPAGE

https://github.com/mcandre/aspelllint

# RUBYGEMS

https://rubygems.org/gems/aspelllint

# ABOUT

aspelllint scans large projects for spelling errors, reporting any misspelled or unidentified words found.

aspelllint is a shell wrapper around the traditional GNU [aspell](http://aspell.net/) backend, presenting a frontend similar to modern linters like [Reek](https://github.com/troessner/reek/wiki) and [JSHint](http://jshint.com/).

* Recursive file scanning, like `jshint .`
* Optional ignore patterns, like `.gitignore`
* Configuration via per-project and per-user [dotfiles](https://github.com/mcandre/aspelllint/blob/master/CONFIGURE.md#dotfiles)
* Install via a standard programming language package manager

# REQUIREMENTS

* [ruby](https://www.ruby-lang.org/) 2.3+
* [aspell](http://aspell.net/)
* [sed](http://www.gnu.org/software/sed/)

## Optional

* [GNU findutils](https://www.gnu.org/software/findutils/)
* [stank](https://github.com/mcandre/stank) (e.g. `go get github.com/mcandre/stank/...`)
* [Python](https://www.python.org) 3+ (for yamllint)
* [Node.js](https://nodejs.org/en/) (for eclint)

# INSTALL

Install via [RubyGems](http://rubygems.org/):

```console
$ gem install aspelllint
```

# LICENSE

FreeBSD

# DEVELOPMENT

## Testing

Keep the interface working:

```console
$ cucumber
```

## Linting

Keep the code tidy:

```console
$ rake lint
```
