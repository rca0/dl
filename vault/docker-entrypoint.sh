#!/bin/bash

set -eo pipefail

function _showHelp() {
   # intentionally mixed spaces and tabs here
   # tabs are stripped by "<<-EOF", spaces are kept in the output
   cat >&2 <<-EOF

	Usage: [command] [parameter]=[value]
        server:
            --tls-key-file      "Pass the key file: vault.key".
            --tls-crt-file      "Pass the certificate file: /vault.crt".
            --access_key        "AWS Access Key"
            --secret_key        "AWS Secret key"
            --bucket            "AWS Bucket name"

        Example:
            server \
                --tls-key-file=/etc/certs/vault.key \
                --tls-crt-file=/etc/certs/vault.crt \
                --access_key="KADAODAJDJ2323IDODJD" \
                --secret_key="FFFADADACCB4224DDFbD" \
                --bucket="vault-bucket-us-east-1"

    If not pass server and tls files parameters it will run in mode default.

	EOF
   exit 0
}

function _defaultConfig() {
    # creates the default setting

    echo >&2 "WARNING: Not specified parameters, putting default configuration."

    if [ -f "pki/vault.crt" ] || [ -f "pki/vault.key" ]; then
        echo >&2 "WARNING: Certificate and tls key already exist."
        _getParams --tls-key-file="pki/vault.key" --tls-crt-file="pki/vault.crt"
        return
    fi
    
    rm -rf "pki/vault.crt" "pki/vault.crt"; mkdir -p "pki"

    openssl req \
        -new \
        -newkey rsa:4096 \
        -x509 \
        -sha256 \
        -days 7300 \
        -nodes -out "pki/vault.crt" \
        -keyout "pki/vault.key" \
        -subj '/C=BR/ST=Santa Catarina/L=Joinville/CN=rca0'
    
    _getParams --tls-key-file="pki/vault.key" --tls-crt-file="pki/vault.crt"
}

function _generateConfig() {
    # generates the configuration file

    if [ "${keyPath}" == "" ] || [ "${crtPath}" == "" ]; then
         echo >&2 "WARNING: Not specified parameters, putting default configuration."
         _defaultConfig
    fi

    rm -rf "config/local.json"; mkdir -p "config"

    cat > "config/local.json" <<-EOF
{
  "backend": {"file": {"path": "/vault/file"}},
  "listener": {
    "tcp": {
      "address": "0.0.0.0:8200",
      "tls_cert_file": "${crtPath}",
      "tls_key_file": "${keyPath}",
    }
  },
  "default_lease_ttl": "168h", 
  "max_lease_ttl": "720h", 
  "disable_mlock": true, 
}
EOF
}

function _makeKeyConfig() {
    # get the value of parameter --tls-key-file
    
    if [ "$1" != "-1" ] && [ "$2" == "-1" ]; then
        keyPath=$(echo $1 | cut -d "=" -f2)
    fi
    if [ "$2" != "-1" ] && [ "$1" == "-1" ]; then
        keyPath="$(echo $2 | cut -d "=" -f2)"
        _generateConfig
    fi
}

function _makeCrtConfig() {
    # get the value of parameter --tls-crt-file
    
    if [ "$1" != "-1" ] && [ "$2" == "-1" ]; then
        crtPath=$(echo $1 | cut -d "=" -f2)
    fi
    if [ "$2" != "-1" ] && [ "$1" == "-1" ]; then
        crtPath=$(echo $2 | cut -d "=" -f2)
        _generateConfig
    fi
}

function _getParams() {
    # get the parameters and send them to the functions

    firstParam="${1}"
    secondParam="${2}"
    case "${firstParam}" in
        --tls-key-file*) _makeKeyConfig "${firstParam}" -1;;
    esac
    case "${secondParam}" in
        --tls-crt-file*) _makeCrtConfig -1 "${secondParam}";;
    esac
    case "${firstParam}" in
        --tls-crt-file*)
            _makeCrtConfig "${firstParam}" -1;
        ;;
    esac
    case "${secondParam}" in
        --tls-key-file*)
            _makeKeyConfig -1 "${secondParam}";
        ;;
    esac
}

if [ "$1" = "server" ]; then
    if [ "${2}" == "" ] || [ "${3}" == "" ]; then
        _showHelp
        exit 1
    fi
    _getParams "${2}" "${3}"

    # Runs original docker-entrypoint from vault image
    /usr/local/bin/docker-entrypoint.sh server \
        vault \
        -config=/vault/config/local.json \
        -dev-root-token-id="${VAULT_DEV_ROOT_TOKEN_ID}" \
        -dev-listen-address="${VAULT_DEV_LISTEN_ADDRESS}:-"0.0.0.0:8200"}"
fi

if [ "$1" = "" ]; then
    _defaultConfig
    
    # Runs original docker-entrypoint from vault image
    /usr/local/bin/docker-entrypoint.sh server \
        vault \
        -config=/vault/config/local.json \
        -dev-root-token-id="${VAULT_DEV_ROOT_TOKEN_ID}" \
        -dev-listen-address="${VAULT_DEV_LISTEN_ADDRESS}:-"0.0.0.0:8200"}"
fi

# If argument is not related, we assume that
# user wants to run his own process, for example
# a "bash" shell to explore this image
exec "$@"
