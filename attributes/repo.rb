default[:debian][:repo][:path] = '/srv/repo'
default[:debian][:repo][:distrib] = {
  'Origin' => 'Your project name',
  'Label' => 'Your project name',
  'Suite' => 'stable',
  'Codename' => 'wheezy',
  'Version' => '3.0',
  'Architectures' => 'amd64',
  'Components' => 'main',
  'Description' => 'Apt repository for project'
}
default[:debian][:repo][:options] = Array.new
default[:debian][:repo][:key] = {
  'Key-Type' =>  'RSA',
  'Key-Length' =>  2048,
  'Subkey-Type' => 'ELG-E',
  'Subkey-Length' => 2048,
  'Name-Real' =>  'Your project name',
  'Name-Comment' => 'Project Debian packages', 
  'Name-Email' => 'project@devops.test',
  'Expire-Date' => 0
}

