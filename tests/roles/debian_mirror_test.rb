name "debian_mirror_test"
description "Use to test the [debian::mirror] recipe."
run_list( "recipe[debian::mirror]" )
default_attributes(
  :debian => {
    :mirrors => {
      "wheezy" => {
        :arch => ["i386","amd64"],
        :section => ["main","contrib","non-free"],
        :release => ["wheezy"],
        :server => "ftp.de.debian.org",
        :path => "/debian",
        :proto => "http"
      },
      "archive/lenny" => {
        :arch => ["i386","amd64"],
        :section => ["main","contrib","non-free"],
        :release => ["lenny"],
        :server => "archive.debian.org",
        :path => "/debian-archive/debian",
        :proto => "http"
      }
}
  }
)
