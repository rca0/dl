# Vault Project

- [https://vaultproject.io/]

IMAGE: `rca0/vault:latest`

- Standard directories:

* /vault/config
* /vault/pki
* /vault/file
* /vault/logs

- In mode default it will create the following certificates:

Certificates | description | validate
--- | --- | ---
pki/vault.crt | TLS certificate file | 20 years
pki/vault.key | TLS Key file | 20 years

Port default: `8200`

```bash
Usage: [command] [parameter]=[value]
        server:
            --tls-key-file      "Pass the key file: /vault.key"
            --tls-crt-file      "Pass the certificate file: /vault.crt"

        Example:
            server --tls-key-file=/etc/pki/vault.key --tls-crt-file=/etc/pki/vault.crt

    If not pass `server` and `tls files` parameters it will run in mode default
```

## Run container

- Running vault in Server Mode:

You must specify the volume like this: `-v <local-dir>:<container-dir>`


```bash
docker run \
        --privileged \
        -it \
        -p 8200:8200 \
        -v $(pwd)/pki:/vault/pki rca0/vault \
        server \
                --tls-key-file=/vault/pki/vault.key \
                --tls-crt-file=/vault/pki/vault.crt
```

Or run in default mode, not necessary pass the volume it will create automatically.

If you pass the volume, it will update the file config/local.json, that needs to run vault project.

Example without volume:

```bash
docker run \
        --privileged \
        -it \
        -p 8200:8200 \
        rca0/vault
```

Example passing the volume:

```bash
docker run \
        --privileged \
        -it \
        -p 8200:8200 \
        -v $(pwd)/pki:/vault/pki \
        rca0/vault
```

## AWS S3 Storage

- To configure AWS s3 storage into vault, it will be necessary to pass 3 parameters, so that the script can identify that will be the AWS credentials, follows the others parameters, the next is `--access_key`, `--secret_key` and the last `--bucket`. These parameters will be synchronized with the Amazon Cloud, and will store the data vault.

Follows the example:

```bash
docker run \
        --privileged \
        -it \
        -p 8200:8200 \
        -v $(pwd)/pki:/vault/pki rca0/vault \
        server \
                --tls-key-file=/vault/pki/vault.key \
                --tls-crt-file=/vault/pki/vault.crt \
                --access_key="KADAODAJDJ2323IDODJD" \
                --secret_key="FFFADADACCB4224DDFbD" \
                --bucket="vault-bucket-us-east-1"
```

Or if you don't want to pass the certificates, follow the standard example:

```bash
docker run \
        --privileged \
        -it \
        -p 8200:8200 \
        rca0/vault \
                --access_key="KADAODAJDJ2323IDODJD" \
                --secret_key="FFFADADACCB4224DDFbD" \
                --bucket="vault-bucket-us-east-1"
```

## Testing

Define alias for vault:

```bash
alias vault='docker exec -it e267ce0c2b5d vault "$@"'
```

Writing and read:

```bash
# WRITE
vault write -address=http://127.0.0.1:8200 secret/yeah value=my-value-yeah

# READ
vault read secret/yeah

# RESULT
Key             	Value
---             	-----
refresh_interval	2592000
value           	my-value-yeah
```
