#!/bin/bash

#VERB=$1

# This is a kooplex add-on it follows it's setup architecture
# First we need to load kooplex's config
#KOOPLEX_DIR=/srv/kooplex-config/
#. ${KOOPLEX_DIR}/lib.sh

MODULE_NAME=cbioportal
RF=$BUILDDIR/${MODULE_NAME}

mkdir -p $RF

CBIOPORTALDB=cbioportaldb
CBIOPORTALDB_USER=cbioportal
CBIOPORTALDB_PW=${DUMMYPASS}
CBIOPORTALDBROOT_PW=${DUMMYPASS}
CBIOPORTALDB_URL=$PREFIX"-"$MODULE_NAME"-mysql"

#CBIOPORTAL_HTML=$NGINX_DIR/html
CBIOPORTAL_LOG=$LOG_DIR/${MODULE_NAME}
CBIOPORTAL_CONF=$CONF_DIR/${MODULE_NAME}

CBIOPORTAL_DIR=$SRV/"_cbioportal"

DJANGO_SECRET_KEY=oyberng3ta6oh74wehx2dePiqvci7toh
DB=${MODULE_NAME}_admin
DB_USER=${MODULE_NAME}_admin
DB_PW=${DUMMYPASS}
DBROOT_PW=${DUMMYPASS}
LDAP_PW=${DUMMYPASS}
LDAPDOMAIN="kooplex.cbio"
LDAPORG="dc=kooplex,dc=cbio"
LDAPPORT=389

DOCKER_COMPOSE_FILE=$RF/docker-compose.yml

case $VERB in
  "build")
    echo "Building cbioportal image ${PREFIX}-base"

    
    mkdir -p ${CBIOPORTAL_DIR}
    mkdir -p ${CBIOPORTAL_DIR}-admin
    mkdir -p ${CBIOPORTAL_DIR}-ldap
    mkdir -p ${CBIOPORTAL_DIR}-ldap/etc
    mkdir -p ${CBIOPORTAL_DIR}-ldap/var
    mkdir -p ${CBIOPORTAL_DIR}-seeddb
    mkdir -p ${CBIOPORTAL_DIR}-studies
    mkdir -p ${CBIOPORTAL_DIR}-db
    mkdir -p ${CBIOPORTAL_CONF} 
    mkdir -p ${CBIOPORTAL_LOG} 
    
    
    cp Dockerfile.ldap scripts/entrypoint-ldap.sh $RF/
    cp Dockerfile.admin etc/entrypoint-admin.sh $RF/ 
    cp etc/cgds.sql $RF/
    
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_DIR}-admin -o o=bind ${PREFIX}-${MODULE_NAME}-admin
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_DIR}-ldap -o o=bind ${PREFIX}-${MODULE_NAME}-ldap-etc
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_DIR}-ldap -o o=bind ${PREFIX}-${MODULE_NAME}-ldap-var
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_DIR}-seeddb -o o=bind ${PREFIX}-${MODULE_NAME}-seeddb
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_DIR}-db -o o=bind ${PREFIX}-${MODULE_NAME}-mysqldb
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_DIR}-studies -o o=bind vol-cbioportal-studies
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_LOG} -o o=bind ${PREFIX}-${MODULE_NAME}-log
    
      DIR=${CBIOPORTAL_DIR}-admin
      if [ -d $DIR/.git ] ; then
          echo $DIR
          #cd $DIR && git pull && cd -
      else
          git clone https://github.com/jegesm/cbioportal-admin.git $DIR
      fi

#    sed -e "s/##MODULE_NAME##/${MODULE_NAME}/"  templates/entrypoint.sh-template > $RF/entrypoint.sh
    
    sed -e "s/##PREFIX##/${PREFIX}/" \
        -e "s,##CBIOPORTAL##,${CBIOPORTAL_DIR}," \
        -e "s/##CBIOPORTALDB##/${CBIOPORTALDB}/" \
        -e "s/##MODULE_NAME##/${MODULE_NAME}/g" \
        -e "s,##CBIOPORTAL_CONF##,$CBIOPORTAL_CONF," \
	-e "s/##CBIOPORTALDB_USER##/${CBIOPORTALDB_USER}/"\
        -e "s/##CBIOPORTALDB_PW##/${CBIOPORTALDB_PW}/"\
        -e "s/##CBIOPORTALDBROOT_PW##/${CBIOPORTALDBROOT_PW}/"\
        -e "s/##SLAPD_PASSWORD##/${LDAP_PW}/" \
        -e "s/##SLAPD_CONFIG_PASSWORD##/${LDAP_PW}/" \
        -e "s/##SLAPD_DOMAIN##/${LDAPDOMAIN}/"\
        -e "s/##LDAP_DOMAIN##/${LDAPORG}/"\
        -e "s/##LDAP_PORT##/${LDAPPORT}/"\
        -e "s/##LDAP_ADMIN##/admin/"\
        -e "s/##LDAP_PW##/${LDAP_PW}/" \
        -e "s/##DB##/${DB}/" \
        -e "s/##DB_PW##/${DB_PW}/" \
        -e "s/##DB_USER##/${DB_USER}/" \
        -e "s/##DBROOT_PW##/${DBROOT_PW}/" \
        -e "s/##DJANGO_SECRET_KEY##/${DJANGO_SECRET_KEY}/" \
        -e "s/##OUTERHOST##/${OUTERHOST}/" docker-compose-cbioportal.yml-template  > $RF/docker-compose.yml

    sed -e "s/##PREFIX##/${PREFIX}/" \
        -e "s/##LDAPORG##/${LDAPORG}/"\
        -e "s/##LDAP_PW##/${LDAP_PW}/"\
        -e "s/##MODULE_NAME##/${MODULE_NAME}/" \
        -e "s/##CBIOPORTALDB##/${CBIOPORTALDB}/"\
        -e "s/##CBIOPORTALDB_URL##/${CBIOPORTALDB_URL}/"\
        -e "s/##CBIOPORTALDB_USER##/${CBIOPORTALDB_USER}/"\
        -e "s/##CBIOPORTALDB_PW##/${CBIOPORTALDB_PW}/"  etc/portal.properties_template > ${CBIOPORTAL_CONF}/portal.properties
    
#    sed -e "s/##MODULE_NAME##/${MODULE_NAME}/"  templates/app.json-template > $RF/src.cbioportal/app.json
#    sed -e "s/##MODULE_NAME##/${MODULE_NAME}/"  templates/pom.xml-template > $RF/src.cbioportal/pom.xml
#    cp templates/version.sh $RF/
#    sed -e "s/##MODULE_NAME##/${MODULE_NAME}/"  templates/Dockerfile-template > $RF/Dockerfile
    
#    sed -e "s/##PREFIX##/${PREFIX}/" \
#        -e "s/##MODULE_NAME##/${MODULE_NAME}/"\
#        -e "s/##CBIOPORTALDB_URL##/${CBIOPORTALDB_URL}\/$CBIOPORTALDB/"\
#        -e "s/##CBIOPORTALDB##/${CBIOPORTALDB}/"\
#        -e "s/##CBIOPORTALDB_USER##/${CBIOPORTALDB_USER}/"\
#        -e "s/##CBIOPORTALDB_PW##/${CBIOPORTALDB_PW}/"\
#        -e "s/##CBIOPORTALDBROOT_PW##/${CBIOPORTALDBROOT_PW}/"\
#        -e "s/##OUTERHOST##/${OUTERHOST}/" templates/context.xml_template > $RF/context.xml
    
#    sed -e "s/##PREFIX##/${PREFIX}/" \
#        -e "s/##CBIOPORTALDB##/${CBIOPORTALDB}/"\
#        -e "s/##CBIOPORTALDB_USER##/${CBIOPORTALDB_USER}/"\
#        -e "s/##CBIOPORTALDB_PW##/${CBIOPORTALDB_PW}/"\
#        -e "s/##CBIOPORTALDBROOT_PW##/${CBIOPORTALDBROOT_PW}/"\
#        -e "s/##OUTERHOST##/${OUTERHOST}/" templates/settings.xml_template > $RF/settings.xml
#    
#    sed -e "s/##PREFIX##/${PREFIX}/" \
#        -e "s/##MODULE_NAME##/${MODULE_NAME}/" \
#        -e "s/##CBIOPORTALDB##/${CBIOPORTALDB}/"\
#        -e "s/##RF##/${RFS}/"\
#        -e "s/##CBIOPORTALDB_USER##/${CBIOPORTALDB_USER}/"\
#        -e "s/##CBIOPORTALDB_URL##/${CBIOPORTALDB_URL}/"\
#        -e "s/##CBIOPORTALDB_PW##/${CBIOPORTALDB_PW}/"  templates/initialization.sh_template > $RF/initialization.sh
    
    
#    cp $RF/portal.properties $RF/src.cbioportal/src/main/resources/portal.properties
#    cp $RF/portal.properties ${CBIOPORTAL_CONF}/portal.properties

###### LDAP SECTION 
      sed -e "s/##LDAPORG##/$LDAPORG/" etc/new_group.ldiftemplate_template > $RF/new_group.ldiftemplate
      sed -e "s/##LDAPORG##/$LDAPORG/" etc/new_user.ldiftemplate_template > $RF/new_user.ldiftemplate
      sed -e "s/##LDAPORG##/$LDAPORG/" etc/ldap.conf_template > $RF/ldap.conf

      sed -e "s/##LDAPORG##/$LDAPORG/" \
          -e "s/##SLAPD_PASSWORD##/$LDAP_PW/" \
          -e "s/##LDAPHOST##/${PREFIX}-${MODULE_NAME}-ldap/" \
          -e "s/##LDAPPORT##/$LDAPPORT/" scripts/addgroup.sh_template > $RF/addgroup.sh
      sed -e "s/##LDAPORG##/$LDAPORG/" \
          -e "s/##SLAPD_PASSWORD##/$LDAP_PW/" \
          -e "s/##LDAPHOST##/${PREFIX}-${MODULE_NAME}-ldap/" \
          -e "s/##LDAPPORT##/$LDAPPORT/" scripts/adduser.sh_template > $RF/adduser.sh
          

      sed -e "s/##LDAPORG##/$LDAPORG/" \
          -e "s/##SLAPD_PASSWORD##/$LDAP_PW/" \
          -e "s/##LDAPHOST##/${PREFIX}-${MODULE_NAME}-ldap/" \
          -e "s/##LDAPPORT##/$LDAPPORT/" scripts/init.sh-template > $RF/init.sh
          
      sed -e "s/##LDAPORG##/$LDAPORG/" \
          -e "s/##SLAPD_PASSWORD##/$LDAP_PW/" \
          -e "s/##LDAPHOST##/${PREFIX}-${MODULE_NAME}-ldap/" \
          -e "s/##LDAPPORT##/$LDAPPORT/" scripts/init-core.sh-template > $RF/init-core.sh

      docker-compose $DOCKER_HOST -f $DOCKER_COMPOSE_FILE build
        echo "Generating secrets..."

  ;;
  "install")

  ;;
  "install-nginx")
    register_nginx $MODULE_NAME
  ;;
  "uninstall-nginx")
    unregister_nginx $MODULE_NAME
  ;;
  "start")
    echo "Starting container ${PREFIX}-${MODULE_NAME}"
    docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE up -d
    
  ;;
  "init")
#    echo "Initializing slapd $PROJECT-ldap [$LDAPIP]"
#    docker exec ${PREFIX}-${MODULE_NAME}-ldap bash -c /init.sh
#    docker exec ${PREFIX}-${MODULE_NAME}-ldap bash -c /init-core.sh
#    docker exec ${PREFIX}-${MODULE_NAME}-ldap bash -c "/usr/local/bin/addgroup.sh users 1000"
#    docker exec ${PREFIX}-${MODULE_NAME}-ldap bash -c "/usr/local/bin/addgroup.sh report 9990"
  

    docker exec ${PREFIX}-${MODULE_NAME}-mysql bash -c "echo 'show databases' | mysql -u root --password=$CBIOPORTALDBROOT_PW -h $PREFIX-${MODULE_NAME}-mysql | grep  -q $CBIOPORTALDB" ||\
       if [ ! $? -eq 0 ];then
    docker exec ${PREFIX}-${MODULE_NAME}-mysql bash -c " echo \"CREATE DATABASE $DB; CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PW'; GRANT ALL ON $DB.* TO '$DB_USER'@'%';\" |  \
             mysql -u root --password=$DBROOT_PW  -h $PREFIX-${MODULE_NAME}-mysql"
       fi
    docker cp $RF/cgds.sql ${PREFIX}-${MODULE_NAME}-mysql:/tmp/
    docker exec ${PREFIX}-${MODULE_NAME}-mysql bash -c "mysql -u root --password=$CBIOPORTALDBROOT_PW $CBIOPORTALDB < /tmp/cgds.sql"
    docker exec ${PREFIX}-${MODULE_NAME} bash -c "python3 /cbioportal/core/src/main/scripts/migrate_db.py -y --properties-file /cbioportal/portal.properties --sql /cbioportal/db-scripts/src/main/resources/migration.sql"
    echo "${PREFIX}-${MODULE_NAME} Mysql (cbio) is setup."


    docker exec ${PREFIX}-${MODULE_NAME}-mysql bash -c "echo 'show databases' | mysql -u root --password=$CBIOPORTALDBROOT_PW -h $PREFIX-${MODULE_NAME}-mysql | grep  -q $DB" ||\
       if [ ! $? -eq 0 ];then
    docker exec ${PREFIX}-${MODULE_NAME}-mysql bash -c " echo \"CREATE DATABASE $DB; CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PW'; GRANT ALL ON $DB.* TO '$DB_USER'@'%';\" |  \
             mysql -u root --password=$DBROOT_PW  -h $PREFIX-${MODULE_NAME}-mysql"
       fi
    docker exec ${PREFIX}-${MODULE_NAME}-admin python3 /cbioportal/cbioportal/manage.py makemigrations
    docker exec ${PREFIX}-${MODULE_NAME}-admin python3 /cbioportal/cbioportal/manage.py migrate
    docker exec -it ${PREFIX}-${MODULE_NAME}-admin python3 /cbioportal/cbioportal/manage.py createsuperuser
    echo "${PREFIX}-${MODULE_NAME} Mysql (admin) is setup."

  ;;
  "stop")
      echo "Stopping container ${PREFIX}-${MODULE_NAME}"
      docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE down
  ;;
    
  "remove")
      echo "Removing $DOCKER_COMPOSE_FILE"
      docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE kill
      docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE rm    

  ;;
  "purge")
  echo "Cleaning cbioportal folder $SRV/${MODULE_NAME}"
  
    rm -r ${CBIOPORTAL_DIR}* $CBIOPORTAL_LOG $CBIOPORTAL_CONF
    docker $DOCKERARGS volume rm  ${PREFIX}-${MODULE_NAME}-admin ${PREFIX}-${MODULE_NAME}-ldap-etc ${PREFIX}-${MODULE_NAME}-ldap-var\
           ${PREFIX}-${MODULE_NAME}-seeddb ${PREFIX}-${MODULE_NAME}-mysqldb ${PREFIX}-${MODULE_NAME}-studies\
	   ${PREFIX}-${MODULE_NAME}-log

  ;;
  "clean")
    echo "Cleaning cbioportal image ${PREFIX}-cbioportal"
    docker $DOCKERARGS rmi ${PREFIX}-cbioportal
  ;;
esac
