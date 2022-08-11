{
  'service.yaml-raw': {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: 'cbioportal',
      namespace: 'cbioportal-hunco',
    },
    spec: {
      selector: {
        app: 'cbioportal',
      },
      ports: [
        {
          name: 'ctld',
          protocol: 'TCP',
          port: 8080,
          targetPort: 8080,
        },
      ],
    },
  }
                      {
    apiVersion: 'v1',
    kind: 'Service',
    metadata: {
      name: 'temp2-cbioportal-mysql',
      namespace: 'cbioportal-hunco',
    },
    spec: {
      selector: {
        app: 'mysql',
      },
      ports: [
        {
          name: 'mysql',
          protocol: 'TCP',
          port: 3306,
          targetPort: 3306,
        },
      ],
    },
  },
}
