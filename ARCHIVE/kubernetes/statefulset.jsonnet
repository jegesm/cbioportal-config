local Config = import 'config.libsonnet';
local volumes = import 'volumes.jsonnet';

{
  'statefulset.yaml-raw': {
    apiVersion: 'apps/v1',
    kind: 'StatefulSet',
    metadata: {
      name: 'cbioportal',
      namespace: Config.ns,
    },
    spec: {
      serviceName: 'cbioportal',
      selector: {
        matchLabels: {
          app: 'cbioportal',
        },
      },
      template: {
        metadata: {
          labels: {
            app: 'cbioportal',
          },
        },
        spec: {
          containers: [
            {
              image: 'image-registry.vo.elte.hu/cbioportal-custom',
              name: 'cbioportal',
              ports: [
                {
                  containerPort: 8080,
                  name: 'http',
                },
              ],
              volumeMounts: [
                {
                  mountPath: '/cbioportal_logs/',
                  name: 'data',
                  subPath: 'cbiolog',
                },
                {
                  mountPath: '/usr/local/tomcat/logs/',
                  name: 'data',
                  subPath: 'tomcatlog',
                },
                {
                  mountPath: '/studies/',
                  name: 'data',
                  subPath: '_cbioportal-studies',
                },
                {
                  mountPath: '/usr/local/tomcat/webapps/',
                  name: 'data',
                  subPath: '_cbioportal',
                },
                {
                  mountPath: '/etc/htpasswd/pw',
                  name: 'auth',
                  readOnly: true,
                },
              ],
              env: [
                {
                  name: 'PREFIX',
                  value: 'temp2',
                },
                {
                  name: 'DOMAIN',
                  value: 'cbioportal.vo.elte.hu',
                },
                {
                  name: 'CBIOPORTALDB',
                  value: Config.dbname,
                },
                {
                  name: 'CBIOPORTALDB_USER',
                  value: Config.dbuser,
                },
                {
                  name: 'CBIOPORTALDB_PW',
                  value: Config.dbpw,
                },
                {
                  name: 'CBIOPORTALDBROOT_PW',
                  value: Config.dbrootpw,
                },
              ],
            },
          ],
          nodeSelector: {
            'kubernetes.io/hostname': 'future1',
          },
          volumes: [
            {
              name: 'data',
              persistentVolumeClaim: {
                claimName: volumes['pvc.yaml-raw'].name,
              },
            },
            {
              name: 'auth',
              secret: {
                secretName: 'basic-auth',
              },
            },
          ],
        },
      },
    },

  }
                          {
    apiVersion: 'apps/v1',
    kind: 'StatefulSet',
    metadata: {
      name: 'cbioportal-mysql',
      namespace: 'cbioportal-hunco',
    },
    spec: {
      serviceName: 'mysql',
      podManagementPolicy: 'Parallel',
      replicas: 1,
      selector: {
        matchLabels: {
          app: 'mysql',
        },
      },
      template: {
        metadata: {
          labels: {
            app: 'mysql',
          },
        },
        spec: {
          containers: [
            {
              image: 'mariadb:10.5.4',
              name: 'mysql',
              ports: [
                {
                  containerPort: 3306,
                  name: 'mysql',
                },
              ],
              volumeMounts: [
                {
                  mountPath: '/var/lib/mysql',
                  name: 'data-hunco',
                  subPath: '_cbioportaldb',
                },
              ],
              env: [
                {
                  name: 'MYSQL_ROOT_PASSWORD',
                  value: 'almafa',
                },
                {
                  name: 'MYSQL_USER',
                  value: 'cbioportal',
                },
                {
                  name: 'MYSQL_PASSWORD',
                  value: 'almafa',
                },
                {
                  name: 'MYSQL_DATABASE',
                  value: 'cbioportaldb',
                },
                {
                  name: 'MYSQL_LOG_CONSOLE',
                  value: 'true',
                },
              ],
            },
          ],
          nodeSelector: {
            'kubernetes.io/hostname': 'future1',
          },
          volumes: [
            {
              name: 'data-hunco',
              persistentVolumeClaim: {
                claimName: 'data-hunco',
              },
            },
          ],
        },
      },
    },

  },
}
