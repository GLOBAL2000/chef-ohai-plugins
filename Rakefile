desc 'upload to chef server'
task :upload do
  sh '(cd ohai && git pull) || git clone https://github.com/cookbooks/ohai.git ohai'
  sh 'rsync *.rb ohai/files/default/plugins'
  sh 'cd ohai && knife cookbook upload $(basename $PWD) -o ..'
end


