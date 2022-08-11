local Config = import 'config.libsonnet';

{

  'ingress.yaml-raw': {
    apiVersion: 'networking.k8s.io/v1',
    kind: 'Ingress',
    metadata: {
      name: 'cbioportal',
      namespace: Config.ns,
      annotations: {
        'kubernetes.io/ingress.class': 'nginx',
        'nginx.ingress.kubernetes.io/rewrite-target': '/',
      },
      //    nginx.ingress.kubernetes.io/auth-type: basic
      //    nginx.ingress.kubernetes.io/auth-secret: basic-auth
      //    nginx.ingress.kubernetes.io/auth-realm: 'Authentication Required - cbp'
    },
    spec: {
      tls: [
        {
          hosts: [Config.fqdn],
          secretName: 'tls-cbioportal',
        },
      ],
      rules: [
        {
          host: Config.fqdn,
          http: {
            paths: [
              {
                path: '/',
                pathType: 'Prefix',
                backend: {
                  service: {
                    name: 'cbioportal',
                    port:
                      { number: 8080 },
                  },
                },
              },
            ],
          },
        },
      ],
    },
  },
}
