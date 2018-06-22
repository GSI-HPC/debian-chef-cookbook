require 'spec_helper'

describe command('sudo -u mirror /etc/mirror.d/debian-security.sh --verbose --dry-run') do
  its(:exit_status) { should eq 0 }
end
