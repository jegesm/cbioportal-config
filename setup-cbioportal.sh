CONFDIR=$PWD
PREFIX=portal-dev
CBIOPORTAL_NAME=cbioportal-dev
CBIOPORTALDB=cbioportaldb
CBIOPORTALDB_USER=cbioportal
CBIOPORTALDB_PW=almafa
CBIOPORTALDBROOT_PW=almafa
CBIOPORTALDB_URL=$PREFIX"-"$CBIOPORTAL_NAME"-mysql"
OUTERHOST="kooplex-temp.elte.hu"

ROOT="/srv/"$PREFIX
BUILDDIR=$ROOT"/build"
RF=$BUILDDIR/${CBIOPORTAL_NAME}

mkdir -p $RF
mkdir -p $RF/cbiolog
mkdir -p $RF/tomcatlog

SRV=$ROOT/$PREFIX
mkdir -p $SRV/_${CBIOPORTAL_NAME}-seeddb
mkdir -p $SRV/_${CBIOPORTAL_NAME}-studies
mkdir -p $SRV/_${CBIOPORTAL_NAME}-db
mkdir -p $SRV/_${CBIOPORTAL_NAME}
mkdir -p $SRV/_${CBIOPORTAL_NAME}-install
mkdir -p $SRV/_report

CBIOPORTAL=$SRV/"_cbioportal"
CBIOPORTALE=$(echo $CBIOPORTAL| sed s"/\//\\\\\//"g)
RFS=$(echo $RF| sed s"/\//\\\\\//"g)

mkdir -p $CBIOPORTAL
mkdir -p $CBIOPORTAL/cbiolog
mkdir -p $CBIOPORTAL/tomcatlog

docker $DOCKERARGS volume create -o type=none -o device=$SRV/_${CBIOPORTAL_NAME}-seeddb -o o=bind ${PREFIX}-${CBIOPORTAL_NAME}-seeddb
docker $DOCKERARGS volume create -o type=none -o device=$SRV/_${CBIOPORTAL_NAME}-db -o o=bind ${PREFIX}-${CBIOPORTAL_NAME}-db
docker $DOCKERARGS volume create -o type=none -o device=$SRV/_report -o o=bind ${PREFIX}-report
docker $DOCKERARGS volume create -o type=none -o device=$SRV/_${CBIOPORTAL_NAME}-studies -o o=bind ${PREFIX}-${CBIOPORTAL_NAME}-studies

#cp Dockerfile  $RF/Dockerfile
cp templates/entrypoint.sh $RF/entrypoint.sh
[ ! -d $RF/src.cbioportal ] && git clone https://github.com/jegesm/cbioportal.git $RF/src.cbioportal\
	&& cd $RF/src.cbioportal && git checkout tags/v1.18.0
cd $CONFDIR

#cp log4j.properties $RF/etc
#cp -r images $RF/

sed -e "s/##PREFIX##/${PREFIX}/" \
    -e "s/##CBIOPORTAL##/${CBIOPORTALE}/" \
    -e "s/##CBIOPORTALDB##/${CBIOPORTALDB}/" \
    -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/g" \
    -e "s/##CBIOPORTALDB_USER##/${CBIOPORTALDB_USER}/"\
    -e "s/##CBIOPORTALDB_PW##/${CBIOPORTALDB_PW}/"\
    -e "s/##CBIOPORTALDBROOT_PW##/${CBIOPORTALDBROOT_PW}/"\
    -e "s/##OUTERHOST##/${OUTERHOST}/" templates/docker-compose-cbioportal.yml-template  > $RF/docker-compose.yml-cbioportal


sed -e "s/##PREFIX##/${PREFIX}/" \
    -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/" \
    -e "s/##CBIOPORTALDB##/${CBIOPORTALDB}/"\
    -e "s/##CBIOPORTALDB_URL##/${CBIOPORTALDB_URL}/"\
    -e "s/##CBIOPORTALDB_USER##/${CBIOPORTALDB_USER}/"\
    -e "s/##CBIOPORTALDB_PW##/${CBIOPORTALDB_PW}/"  templates/portal.properties_template > $RF/portal.properties 

sed -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/"  templates/app.json-template > $RF/src.cbioportal/app.json 
sed -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/"  templates/pom.xml-template > $RF/src.cbioportal/pom.xml 
sed -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/"  templates/Dockerfile-template > $RF/Dockerfile 

sed -e "s/##PREFIX##/${PREFIX}/" \
    -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/"\
    -e "s/##CBIOPORTALDB_URL##/${CBIOPORTALDB_URL}\/$CBIOPORTALDB/"\
    -e "s/##CBIOPORTALDB##/${CBIOPORTALDB}/"\
    -e "s/##CBIOPORTALDB_USER##/${CBIOPORTALDB_USER}/"\
    -e "s/##CBIOPORTALDB_PW##/${CBIOPORTALDB_PW}/"\
    -e "s/##CBIOPORTALDBROOT_PW##/${CBIOPORTALDBROOT_PW}/"\
    -e "s/##OUTERHOST##/${OUTERHOST}/" templates/context.xml_template > $RF/context.xml

sed -e "s/##PREFIX##/${PREFIX}/" \
    -e "s/##CBIOPORTALDB##/${CBIOPORTALDB}/"\
    -e "s/##CBIOPORTALDB_USER##/${CBIOPORTALDB_USER}/"\
    -e "s/##CBIOPORTALDB_PW##/${CBIOPORTALDB_PW}/"\
    -e "s/##CBIOPORTALDBROOT_PW##/${CBIOPORTALDBROOT_PW}/"\
    -e "s/##OUTERHOST##/${OUTERHOST}/" templates/settings.xml_template > $RF/settings.xml 

sed -e "s/##PREFIX##/${PREFIX}/" \
    -e "s/##CBIOPORTAL_NAME##/${CBIOPORTAL_NAME}/" \
    -e "s/##CBIOPORTALDB##/${CBIOPORTALDB}/"\
    -e "s/##RF##/${RFS}/"\
    -e "s/##CBIOPORTALDB_USER##/${CBIOPORTALDB_USER}/"\
    -e "s/##CBIOPORTALDB_URL##/${CBIOPORTALDB_URL}/"\
    -e "s/##CBIOPORTALDB_PW##/${CBIOPORTALDB_PW}/"  templates/initialization.sh_template > $RF/initialization.sh 


cp $RF/portal.properties $RF/src.cbioportal/src/main/resources/portal.properties
#cp $RF/app.json $RF/src.cbioportal/src/main/resources/app.json
