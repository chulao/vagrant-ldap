exec { "apt-update":
    command => "/usr/bin/apt-get update"
}

# Ensure that 'apt-update' will run before any other package
Exec["apt-update"] -> Package <| |>