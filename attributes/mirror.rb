default['debian']['mirror']['path'] = '/srv/mirror'
default['debian']['mirror']['user'] = 'mirror'
default['debian']['mirror']['route'] = '/debian'
default['debian']['mirror']['notify'] = String.new
default['debian']['mirror']['skip_apache_config'] = false
default['debian']['mirror']['update_minute'] = '0'
default['debian']['mirror']['update_hour'] = '2'
default['debian']['mirror']['update_day'] = '*'
default['debian']['mirrors'] = { }
default['debian']['mirror']['additional_keys'] = { }
