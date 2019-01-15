# MysqlDump

variables | type | description
--- | --- | ---
DB_HOST | required | Database Address
DB_USER | required | Database Username
DB_PASS | required | Database Password
DB_NAME | optional | Database Name
ALL_DATABASES | optional | Boolean option, yes/no (if DB_NAME empty, this option will be "yes")
IGNORE_DATABASE | optional | Database name that will ignore in procedure

## Execute dump

docker run --rm -e <VARIABLE> -v <src_volume>:<dst_volume> -it <image> <command>

Common example with Docker:

```bash
docker run --rm \
           --net=host \
           -e DB_HOST="database.domain.com" \
           -e DB_USER="myDbUser" \
           -e DB_PASS="s3cr3tP4ssw0rd" \
           -e DB_NAME="myDatabase" \
           -v $(pwd):/mysqldump \
           -it rca0/mysqldump dump
```

Dump all databases, it is not necessary pass DB_NAME, the script will understand that have to dump all databases.
Example:

```bash
docker run --rm \
           --net=host \
           -e DB_HOST="database.domain.com" \
           -e DB_USER="myDbUser" \
           -e DB_PASS="s3cr3tP4ssw0rd" \
           -v $(pwd):/mysqldump \
           -it rca0/mysqldump dump
```

Ignore one database:
Example:

```bash
docker run --rm \
           --net=host \
           -e DB_HOST="database.domain.com" \
           -e DB_USER="myDbUser" \
           -e DB_PASS="s3cr3tP4ssw0rd" \
           -e IGNORE_DATABASE="otherDatabase" \
           -v $(pwd):/mysqldump \
           -it rca0/mysqldump dump
```

## Execute import

This script will import file with format: `DB_NAME-DATE.sql`

docker run --rm -e <VARIABLE> -v <src_volume>:<dst_volume> -it <image> <command>

Your database have to be in the volume path:

```bash
docker run --rm \
           --net=host \
           -e DB_HOST="database.domain.com" \
           -e DB_USER="myDbUser" \
           -e DB_PASS="s3cr3tP4ssw0rd" \
           -e DB_NAME="myDatabase" \
           -v $(pwd):/mysqldump \
           -it rca0/mysqldump import
```

The files with extensions `<.sql>` have to be in your volume path:

```bash
docker run --rm \
           --net=host \
           -e DB_HOST="database.domain.com" \
           -e DB_USER="myDbUser" \
           -e DB_PASS="s3cr3tP4ssw0rd" \
           -v $(pwd):/mysqldump \
           -it rca0/mysqldump import
```

Ignore one database:
Example:

```bash
docker run --rm \
           --net=host \
           -e DB_HOST="database.domain.com" \
           -e DB_USER="myDbUser" \
           -e DB_PASS="s3cr3tP4ssw0rd" \
           -e IGNORE_DATABASE="otherDatabase" \
           -v $(pwd):/mysqldump \
           -it rca0/mysqldump import
```
