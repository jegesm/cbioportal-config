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
