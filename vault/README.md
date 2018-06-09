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
        -v $(pwd)/pki:/vault/pki ops/vault \
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
        ops/vault
```

Example passing the volume:

```bash
docker run \
        --privileged \
        -it \
        -p 8200:8200 \
        -v $(pwd)/pki:/vault/pki \
        ops/vault
```