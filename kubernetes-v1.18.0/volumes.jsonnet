local Config = import 'config.libsonnet';

{
  'pv.yaml-raw': {
    apiVersion: 'v1',
    kind: 'PersistentVolume',
    metadata: {
      name: 'cbioportal-hunco',
      labels: {
        pvl: 'cbioportal-hunco',
      },
    },
    spec: {
      capacity: {
        storage: '100G',
      },
      volumeMode: 'Filesystem',
      accessModes: [
        'ReadWriteMany',
      ],
      persistentVolumeReclaimPolicy: 'Retain',
      nfs: {
        path: '/cbioportal-hunco/',
        server: 'veo1.krft',
      },
    },
  },
  'pvc.yaml-raw': {
    apiVersion: 'v1',
    kind: 'PersistentVolumeClaim',
    metadata: {
      name: 'data-hunco',
      namespace: Config.ns,
    },
    spec: {
      accessModes: [
        'ReadWriteMany',
      ],
      volumeMode: 'Filesystem',
      resources: {
        requests: {
          storage: '100G',
        },
      },
      storageClassName: '',
      volumeName: $['pv.yaml-raw'].metadata.name,
    },
  },
}
