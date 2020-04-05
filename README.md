This should be a in a repository in ELTEVO

# Create htpasswd files in nginx
echo "cbp:" > /etc/passwords/.htpasswd
openssl passwd -apr1 "almafa" >> /etc/passwords/.htpasswd
# cbp:$apr1$wsZYLGUa$yb8/vQBZjzCMJzTCdM.pZ/

It is not yet working. the frontend does not want to display anything and I don't know why

# TO SETUP MYSQL DB
` wget https://raw.githubusercontent.com/cBioPortal/cbioportal/v2.0.0/db-scripts/src/main/resources/cgds.sql ${CBIOPORTAL_DIR}-seeddb/`
 or if it is not working then
`docker $DOCKERARGS cp kooplex-fiek-cbioportal:/cbioportal/db-scripts/src/main/resources/cgds.sql ${CBIOPORTAL_DIR}-seeddb/ `
SEED_FILE=seed-cbioportal_hg19_v2.7.2.sql
`wget https://github.com/cBioPortal/datahub/raw/9d7b90c53c189b6d2c083d156cea2932cd318c0a/seedDB/${SEED_FILE}.gz ${CBIOPORTAL_DIR}-seeddb/`
`gunzip ${CBIOPORTAL_DIR}-seeddb/${SEED_FILE}.gz`
AND we don't need this `docker $DOCKERARGS exec kooplex-fiek-cbioportal-mysql bash -c "mysql --user=${CBIOPORTALDB_USER} --password=${CBIOPORTALDB_PW}  ${CBIOPORTALDB} < /docker-entrypoint-initdb.d/cgds.sql"`
and this  `docker $DOCKERARGS exec kooplex-fiek-cbioportal-mysql bash -c "mysql --user=${CBIOPORTALDB_USER} --password=${CBIOPORTALDB_PW}  ${CBIOPORTALDB} < /docker-entrypoint-initdb.d/${SEED_FILE}"`
 because at container start it imports them automatically (???)



## DJANGO Trukk
ERROR: Site matching query does not exist.

from django.contrib.sites.models import Site
site = Site()
site = Site.objects.get(site.domain = 'kooplex-fiek.elte.hu')
site.name = 'kooplex-fiek.elte.hu'
site.save()

## MYSQL "max_allowed_packet" Error. Fix it in the mysql container
sed -i -e 's/16M/500M/g' /etc/mysql/conf.d/mysqldump.cnf
