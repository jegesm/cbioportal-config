# Setting up cbioportal

Add the following to 
$CATALINA_HOME/conf/context.xml

``` xml
<Context>
  <Resource name="jdbc/cbioportal" auth="Container" type="javax.sql.DataSource"
               maxTotal="100" maxIdle="30" maxWaitMillis="10000"
               username="user" password="pass" driverClassName="com.mysql.jdbc.Driver"
               url="jdbc:mysql://localhost:3306/dbname"/>
</Context>
```

/usr/local/tomcat/webapps/cbioportal/WEB-INF/classes/portal.properties should be

``` 
# database
db.user=cbioportal
db.password=*****
db.host=temp-cbioportal-mysql
db.portal_db_name=cbioportaldb
db.driver=com.mysql.jdbc.Driver
db.connection_string=jdbc:mysql://temp-cbioportal-mysql/cbioportaldb
db.tomcat_resource_name=jdbc/cbioportal
```

3. Added in $CATALINA_HOME/bin/catalina.sh to 

```
elif [ "$1" = "run" ]; then

...

      -Dauthenticate="false" \
```

Run
``` bash
migrate_db.py -p /cbioportal/src/main/resources/portal.properties -s /cbioportal/db-scripts/src/main/resources/migration.sql
```
