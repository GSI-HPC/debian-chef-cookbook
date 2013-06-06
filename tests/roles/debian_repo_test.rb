name "debian_repo_test"
description "Use to test the [debian::repo] recipe."
run_list( "recipe[debian::repo]" )
default_attributes(
  "debian" => {
    "repo" => {
      "distrib" => {
        "Origin" => "Devops Lab",
        "Label" => "devops",
        "Description" => "Devops packages from the Lab."
      },
      "key" => {
        "Name-Real" => "Devops Lab",
        "Name-Comment" => "Devops packages from the Lab.",
        "Name-Email" => "packages@devops.test"
      }
    }
  }
)
