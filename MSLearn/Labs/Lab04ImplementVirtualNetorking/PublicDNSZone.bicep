param dnszones_createvnetlab_com_name string = 'createvnetlab.com'

resource dnszones_createvnetlab_com_name_resource 'Microsoft.Network/dnszones@2023-07-01-preview' = {
  name: dnszones_createvnetlab_com_name
  location: 'global'
  properties: {
    zoneType: 'Public'
  }
}

resource dnszones_createvnetlab_com_name_www 'Microsoft.Network/dnszones/A@2023-07-01-preview' = {
  parent: dnszones_createvnetlab_com_name_resource
  name: 'www'
  properties: {
    TTL: 3600
    ARecords: [
      {
        ipv4Address: '10.1.1.4'
      }
    ]
    targetResource: {}
    trafficManagementProfile: {}
  }
}

resource Microsoft_Network_dnszones_NS_dnszones_createvnetlab_com_name 'Microsoft.Network/dnszones/NS@2023-07-01-preview' = {
  parent: dnszones_createvnetlab_com_name_resource
  name: '@'
  properties: {
    TTL: 172800
    NSRecords: [
      {
        nsdname: 'ns1-09.azure-dns.com.'
      }
      {
        nsdname: 'ns2-09.azure-dns.net.'
      }
      {
        nsdname: 'ns3-09.azure-dns.org.'
      }
      {
        nsdname: 'ns4-09.azure-dns.info.'
      }
    ]
    targetResource: {}
    trafficManagementProfile: {}
  }
}

resource Microsoft_Network_dnszones_SOA_dnszones_createvnetlab_com_name 'Microsoft.Network/dnszones/SOA@2023-07-01-preview' = {
  parent: dnszones_createvnetlab_com_name_resource
  name: '@'
  properties: {
    TTL: 3600
    SOARecord: {
      email: 'azuredns-hostmaster.microsoft.com'
      expireTime: 2419200
      host: 'ns1-09.azure-dns.com.'
      minimumTTL: 300
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
    targetResource: {}
    trafficManagementProfile: {}
  }
}
