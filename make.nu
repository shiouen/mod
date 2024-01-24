use scripts

scripts dotenv load-config "./config/.env.toml"

const dns_path = "infra/dns"

def deploy [approve: bool = false] {
    let config = scripts config get-config "./config/variables.toml" "./config/tags.toml"

    print $config

    cd ./infra
    $config | to json | save --force variables.json

    terraform init

    mut options = [
        "apply",
        "-var-file",
        "variables.json"

    ]

    if $approve {
        options = "-auto-approve" | append $options
    }

    run-external terraform ...$options
}

def "main deploy" [--approve (-a)] {
    deploy $approve
}

def main [] {}
