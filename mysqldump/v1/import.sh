#!/bin/bash

DATE=$(date +%Y%m%d)

if [ "${ALL_DATABASES}" == "yes" ] || [ "${DB_NAME}" == "" ]; then
	# fetching all databases
	cd /mysqldump
	DATABASES=`for f in *.sql; do
    	printf '%s\n' "${f%.sql}"
	done`
	for database in ${DATABASES}; do
		if [[ "${database}" != "information_schema.sql" ]] && [[ "${database}" != "performance_schema.sql" ]] && \
		[[ "${database}" != "mysql.sql" ]] && [[ "${database}" != _* ]]; then
			echo "Importing database: ${database}"
			mysql --user="${DB_USER}" \
				  --password="${DB_PASS}" \
				  --host="${DB_HOST}" \
				  "$@" "${database}" < /mysqldump/${database}-"${DATE}".sql
		fi
	done
fi

echo -n "Importing database: ${DB_NAME}"
mysql --user="${DB_USER}" \
	  --password="${DB_PASS}" \
	  --host="${DB_HOST}" \
	  "$@" "${DB_NAME}" < /mysqldump/"${DB_NAME}"-"${DATE}".sql
