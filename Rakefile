task :default => 'test'

task :gem => 'aspelllint.gemspec' do
  sh 'gem build *.gemspec'
end

task :install => [:gem] do
  sh 'gem install ./*.gem'
end

task :test => [:clean, :install] do
  sh 'cucumber'
end

task :publish => [:clean, :gem] do
  sh 'gem push ./*.gem'
end

task :ruby => [] do
  begin
    sh 'for f in **/*.rb; do ruby -wc $f 2>&1 | grep -v "Syntax OK" | grep -v openssl | grep -v rubygems; done'
  rescue
  end
end

task :reek => [] do
  sh 'bundle exec reek -q .; true'
end

task :flay => [] do
  sh 'bundle exec flay .'
end

task :roodi => [] do
  sh 'bundle exec roodi -config=roodi.yml *.rb **/*.rb'
end

task :cane => [] do
  sh 'bundle exec cane -f *.rb; bundle exec cane **/*.rb'
end

task :excellent => [] do
  sh 'bundle exec excellent .'
end

task :rubocop => [] do
  sh 'bundle exec rubocop **/*.rb **/*.erb **/Guardfile*'
end

task :tailor => [] do
  sh 'bundle exec tailor'
end

task :cowl => [] do
  sh 'cowl .'
end

task :lili => [] do
  sh 'bundle exec lili .'
end

task :editorconfig=> [] do
  sh 'find . \\( -wholename \'*/bin/*\' -o -wholename \'*/ts/*.js\' -o -wholename \'*/dash/lib/*\' -o -wholename \'*/ash/lib/*\' -o -name \'*.gem\' -o -name \'*.bc\' -o -name \'*.aux\' -o -name \'*.jad\' -o -name \'*.m\' -o -name \'*.snu\' -o -name \'*.txt\' -o -name \'*.md\' -o -name \'*.rkt\' -o -name \'*.clj\' -o -name \'*.lsp\' -o -name .yaws -o -name \'*.pdf\' -o -name \'*.ps\' -o -wholename \'*/.idea/*\' -o -name \'*.iml\' -o -name \'*.ser\' -o -name \'*.[ps]k\' -o -name \'*.flip\' -o -name \'*.db\' -o -name \'*.log\' -o -wholename \'*/bower_components/*\' -o -wholename \'*/vendor/*\' -o -wholename \'*/*.xcodeproj/*\' -o -wholename \'*/*.dSYM/*\' -o -wholename \'*/build/*\' -o -wholename \'*/*.app/*\' -o -name \'*.scpt\' -o -wholename \'*/perl/Makefile\' -o -wholename \'*/CMakeFiles/*\' -o -name \'*.cmake\' -o -name \'*.lock\' -o -name \'*.cm[io]\' -o -name \'*.hi\' -o -name \'*.swiftdoc\' -o -name \'*.swiftmodule\' -o -name \'*.rlib\' -o -name \'*.dylib\' -o -name \'*.so\' -o -name \'*.o\' -o -name \'*.beam\' -o -name \'*.dump\' -o -name \'*.pyc\' -o -name \'*.jar\' -o -name \'*.class\' -o -name \'*.bin\' -o -wholename \'*/tmp/*\' -o -name .gitmodules -o -wholename \'*/.git/*\' -o -wholename \'*/node_modules/*\' -o -wholename \'*/.cabal/*\' -o -name \'*.ttf\' -o -name \'*.plist\' -o -name \'*.dot\' -o -name \'*.wav\' -o -name \'*.jpeg\' -o -name \'*.jpg\' -o -name \'*.ico\' -o -name \'*.png\' -o -name \'*.gif\' -o -name .DS_Store -o -name Thumbs.db \\) -prune -o -type f -print | pargs -n 100 node_modules/.bin/editorconfig-tools check'
end

task :shlint => [] do
  sh 'find . \( -wholename \'*/node_modules*\' \) -prune -o -type f \( -name \'*.sh\' -o -name \'*.bashrc*\' -o -name \'.*profile*\' -o -name \'*.envrc*\' \) -print | xargs shlint'
end

task :checkbashisms => [] do
  sh 'find . \( -wholename \'*/node_modules*\' \) -prune -o -type f \( -name \'*.sh\' -o -name \'*.bashrc*\' -o -name \'.*profile*\' -o -name \'*.envrc*\' \) -print | xargs checkbashisms -n -p'
end

task :shellcheck => [] do
  sh 'find . \( -wholename \'*/node_modules*\' \) -prune -o -type f \( -name \'*.sh\' -o -name \'*.bashrc*\' -o -name \'.*profile*\' -o -name \'*.envrc*\' \) -print | xargs shellcheck'
end

task :funk => [] do
  sh 'funk .'
end

task :lint => [
  :ruby,
  :reek,
  :flay,
  :roodi,
  :cane,
  :excellent,
  :rubocop,
  :tailor,
  :cowl,
  :lili,
  :editorconfig,
  :shlint,
  :checkbashisms,
  :shellcheck,
  :funk
] do
end

task :flog => [] do
  sh 'bundle exec flog .'
end

task :churn => [] do
  sh 'bundle exec churn'
end

task :clean => [] do
  begin
    sh 'rm *.gem'
  rescue
  end
end
