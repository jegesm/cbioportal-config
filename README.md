# cbioportal-config
Customized cbioportal

#### Useful:
* You can restart the webserver: 
``` bash
sudo initctl restart tomcat
```

#### Important
* Each time you modify any java code, you must recompile and redeploy the WAR file.
* Each time you modify any properties (see customization options), you must restart tomcat.
* Each time you add new data, you must restart tomcat.

Further customization options: <br>
https://docs.cbioportal.org/2.3-customization/customizing-your-instance-of-cbioportal

### To put protect it a bit

* conf/server.xml : 
```
<Realm className="org.apache.catalina.realm.MemoryRealm"></Realm>
```
* conf/tomcat-users.xml :
```
 <user name="##USER##" password="##PASSWORD##" roles="test" />
```
* webapps/##CBIOPORTAL_NAME##/WEB-INF/web.xml
```
<security-constraint>
        <web-resource-collection>
                <web-resource-name> 
                My Protected WebSite 
                </web-resource-name>
                <url-pattern> /* </url-pattern>
                <http-method> GET </http-method>
                <http-method> POST </http-method>
        </web-resource-collection>
        <auth-constraint>
                <!-- the same like in your tomcat-users.conf file -->
                <role-name> test </role-name>
        </auth-constraint>
</security-constraint>
<login-config>
        <auth-method> BASIC </auth-method>
        <realm-name>  Basic Authentication </realm-name>
</login-config>
<security-role>
        <description> Test role </description>
        <role-name> test </role-name>
</security-role>
```
