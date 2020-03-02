#!/bin/bash

VERB=$1

# This is a kooplex add-on it follows it's setup architecture
# First we need to load kooplex's config
KOOPLEX_DIR=/srv/kooplex-config/
. ${KOOPLEX_DIR}/lib.sh

MODULE_NAME=cbioportal
RF=$BUILDDIR/${MODULE_NAME}

mkdir -p $RF

DOCKER_HOST=$DOCKERARGS

CBIOPORTAL_NAME=cbioportal
CBIOPORTALDB=cbioportaldb
CBIOPORTALDB_USER=cbioportal
CBIOPORTALDB_PW=${DUMMYPASS}
CBIOPORTALDBROOT_PW=${DUMMYPASS}
CBIOPORTALDB_URL=$PREFIX"-"$CBIOPORTAL_NAME"-mysql"

#CBIOPORTAL_HTML=$NGINX_DIR/html
CBIOPORTAL_LOG=$LOG_DIR/${MODULE_NAME}
CBIOPORTAL_CONF=$CONF_DIR/${MODULE_NAME}

DJANGO_SECRET_KEY=oyberng3ta6oh74wehx2dePiqvci7toh
DB=${CBIOPORTAL_NAME}_admin
DB_USER=${CBIOPORTAL_NAME}_admin
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

    
    CBIOPORTAL_DIR=$SRV/"_cbioportal"
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
    CBIOPORTALE=$(echo ${CBIOPORTAL_DIR}| sed s"/\//\\\\\//"g)
    RFS=$(echo $RF| sed s"/\//\\\\\//"g)
    
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_DIR}-admin -o o=bind ${PREFIX}-${CBIOPORTAL_NAME}-admin
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_DIR}-ldap -o o=bind ${PREFIX}-${CBIOPORTAL_NAME}-ldap-etc
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_DIR}-ldap -o o=bind ${PREFIX}-${CBIOPORTAL_NAME}-ldap-var
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_DIR}-seeddb -o o=bind ${PREFIX}-${CBIOPORTAL_NAME}-seeddb
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_DIR}-db -o o=bind ${PREFIX}-${CBIOPORTAL_NAME}-mysqldb
    docker $DOCKERARGS volume create -o type=none -o device=${CBIOPORTAL_DIR}-studies -o o=bind ${PREFIX}-${CBIOPORTAL_NAME}-studies
    
#    sed -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/"  templates/entrypoint.sh-template > $RF/entrypoint.sh
    
    sed -e "s/##PREFIX##/${PREFIX}/" \
        -e "s/##CBIOPORTAL##/${CBIOPORTALE}/" \
        -e "s/##CBIOPORTALDB##/${CBIOPORTALDB}/" \
        -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/g" \
        -e "s/##CBIOPORTAL_CONF##/$(echo $CBIOPORTAL_CONF | sed s"/\//\\\\\//"g)/" \
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
        -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/" \
        -e "s/##CBIOPORTALDB##/${CBIOPORTALDB}/"\
        -e "s/##CBIOPORTALDB_URL##/${CBIOPORTALDB_URL}/"\
        -e "s/##CBIOPORTALDB_USER##/${CBIOPORTALDB_USER}/"\
        -e "s/##CBIOPORTALDB_PW##/${CBIOPORTALDB_PW}/"  templates/portal.properties_template > ${CBIOPORTAL_CONF}/portal.properties
    
#    sed -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/"  templates/app.json-template > $RF/src.cbioportal/app.json
#    sed -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/"  templates/pom.xml-template > $RF/src.cbioportal/pom.xml
#    cp templates/version.sh $RF/
#    sed -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/"  templates/Dockerfile-template > $RF/Dockerfile
    
#    sed -e "s/##PREFIX##/${PREFIX}/" \
#        -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/"\
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
#        -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/" \
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
          -e "s/##LDAPHOST##/${PREFIX}-${CBIOPORTAL_NAME}-ldap/" \
          -e "s/##LDAPPORT##/$LDAPPORT/" scripts/addgroup.sh_template > $RF/addgroup.sh
      sed -e "s/##LDAPORG##/$LDAPORG/" \
          -e "s/##SLAPD_PASSWORD##/$LDAP_PW/" \
          -e "s/##LDAPHOST##/${PREFIX}-${CBIOPORTAL_NAME}-ldap/" \
          -e "s/##LDAPPORT##/$LDAPPORT/" scripts/adduser.sh_template > $RF/adduser.sh
          

      sed -e "s/##LDAPORG##/$LDAPORG/" \
          -e "s/##SLAPD_PASSWORD##/$LDAP_PW/" \
          -e "s/##LDAPHOST##/${PREFIX}-${CBIOPORTAL_NAME}-ldap/" \
          -e "s/##LDAPPORT##/$LDAPPORT/" scripts/init.sh-template > $RF/init.sh
          
      sed -e "s/##LDAPORG##/$LDAPORG/" \
          -e "s/##SLAPD_PASSWORD##/$LDAP_PW/" \
          -e "s/##LDAPHOST##/${PREFIX}-${CBIOPORTAL_NAME}-ldap/" \
          -e "s/##LDAPPORT##/$LDAPPORT/" scripts/init-core.sh-template > $RF/init-core.sh

      docker-compose $DOCKER_HOST -f $DOCKER_COMPOSE_FILE build
        echo "Generating secrets..."

  ;;
  "install")
# OUTER-NGINX
    sed -e "s/##PREFIX##/$PREFIX/"\
        -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/g" \
	    outer-nginx-${MODULE_NAME}-template > $CONF_DIR/outer_nginx/sites-enabled/${MODULE_NAME}
#        docker $DOCKERARGS restart $PREFIX-outer-nginx

  ;;
  "start")
    echo "Starting container ${PREFIX}-${MODULE_NAME}"
    docker-compose $DOCKERARGS -f $DOCKER_COMPOSE_FILE up -d
    
  ;;
  "init")
#    echo "Initializing slapd $PROJECT-ldap [$LDAPIP]"
#    docker exec ${PREFIX}-${CBIOPORTAL_NAME}-ldap bash -c /init.sh
#    docker exec ${PREFIX}-${CBIOPORTAL_NAME}-ldap bash -c /init-core.sh
#    docker exec ${PREFIX}-${CBIOPORTAL_NAME}-ldap bash -c "/usr/local/bin/addgroup.sh users 1000"
#    docker exec ${PREFIX}-${CBIOPORTAL_NAME}-ldap bash -c "/usr/local/bin/addgroup.sh report 9990"
  
    #docker exec ${PREFIX}-hub-mysql bash -c "echo 'show databases' | mysql -u root --password=$HUBDBROOT_PW -h $PREFIX-hub-mysql  | grep  -q $HUBDB"
#       docker exec ${PREFIX}-hub-mysql bash -c "echo 'use $HUBDB' | mysql -u root --password=$HUBDBROOT_PW -h $PREFIX-hub-mysql"
#       if [ ! $? -eq 0 ];then
    docker exec ${PREFIX}-${CBIOPORTAL_NAME}-mysql bash -c " echo \"CREATE DATABASE $DB; CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PW'; GRANT ALL ON $DB.* TO '$DB_USER'@'%';\" |  \
             mysql -u root --password=$DBROOT_PW  -h $PREFIX-${CBIOPORTAL_NAME}-mysql"
#       fi

    docker exec ${PREFIX}-${CBIOPORTAL_NAME}-mysql bash -c "echo 'use $DB' | mysql -u root --password=$DBROOT_PW -h $PREFIX-${CBIOPORTAL_NAME}-mysql"
    docker exec ${PREFIX}-${CBIOPORTAL_NAME}-admin python3 /cbioportal/cbioportal/manage.py makemigrations
    docker exec ${PREFIX}-${CBIOPORTAL_NAME}-admin python3 /cbioportal/cbioportal/manage.py migrate
    docker exec -it ${PREFIX}-${CBIOPORTAL_NAME}-admin python3 /cbioportal/cbioportal/manage.py createsuperuser

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
  echo "Cleaning cbioportal folder $SRV/; Remove aquota"
#  quotaoff -vu $SRV
#  quotaoff -vg $SRV
#  rm -f $SRV/aquota.*
  rm -r $SRV/.secrets
  ;;
  "clean")
    echo "Cleaning cbioportal image ${PREFIX}-cbioportal"
    #umount $SRV 
#    echo "Check if $SRV is still mounted! Then run: ' rm -f "$DISKIMG/$PROJECT"fs.img '" 
    #rm -f $DISKIMG/$PROJECT"fs.img" 
    docker $DOCKERARGS rmi ${PREFIX}-cbioportal
  ;;
esac
