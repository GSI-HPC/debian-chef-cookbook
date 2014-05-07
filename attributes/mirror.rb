default[:debian][:mirror][:path] = '/srv/mirror'
default[:debian][:mirror][:user] = 'mirror'
default[:debian][:mirror][:route] = '/debian'
default[:debian][:mirror][:notify] = String.new
default[:debian][:mirror][:skip_apache_config] = false
default[:debian][:mirrors] = Hash.new
