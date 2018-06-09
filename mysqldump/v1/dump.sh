#!/bin/bash

DATE=$(date +%Y%m%d)

if [ "${ALL_DATABASES}" == "yes" ] || [ "${DB_NAME}" == "" ]; then
	# fetching all databases
	DATABASES=`mysql --user="${DB_USER}" --password="${DB_PASS}" --host="${DB_HOST}" -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`
	# filtering databases and dump
	for database in $DATABASES; do
		if [[ "${database}" != "information_schema" ]] && [[ "$database" != "performance_schema" ]] && \
		 [[ "$database" != "mysql" ]] && [[ "$database" != _* ]] && [[ "$database" != "${IGNORE_DATABASE}" ]]; then
			echo -n "Dumping database: ${database}"
			mysqldump --user="${DB_USER}" \
					  --password="${DB_PASS}" \
					  --host="${DB_HOST}" \
					  --databases ${database} > /mysqldump/${database}-"${DATE}".sql
		fi
	done
	exit 0;
fi

echo -n "Dumping database: ${DB_NAME}"
mysqldump --user="${DB_USER}" \
		  --password="${DB_PASS}" \
		  --host="${DB_HOST}" \
		  "$@" "${DB_NAME}" > /mysqldump/"${DB_NAME}"-"${DATE}".sql