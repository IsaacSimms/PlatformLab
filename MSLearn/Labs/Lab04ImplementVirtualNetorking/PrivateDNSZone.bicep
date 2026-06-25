param privateDnsZones_privatecreatevnetlab_com_name string = 'privatecreatevnetlab.com'
param virtualNetworks_ManufacturingVnet_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-ImplementVirtualNetworkingLab-prod-cus-001/providers/Microsoft.Network/virtualNetworks/ManufacturingVnet'

resource privateDnsZones_privatecreatevnetlab_com_name_resource 'Microsoft.Network/privateDnsZones@2024-06-01' = {
  name: privateDnsZones_privatecreatevnetlab_com_name
  location: 'global'
  properties: {}
}

resource privateDnsZones_privatecreatevnetlab_com_name_sensorvm 'Microsoft.Network/privateDnsZones/A@2024-06-01' = {
  parent: privateDnsZones_privatecreatevnetlab_com_name_resource
  name: 'sensorvm'
  properties: {
    ttl: 3600
    aRecords: [
      {
        ipv4Address: '10.1.1.4'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatecreatevnetlab_com_name 'Microsoft.Network/privateDnsZones/SOA@2024-06-01' = {
  parent: privateDnsZones_privatecreatevnetlab_com_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource privateDnsZones_privatecreatevnetlab_com_name_manufactoring_link 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2024-06-01' = {
  parent: privateDnsZones_privatecreatevnetlab_com_name_resource
  name: 'manufactoring-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworks_ManufacturingVnet_externalid
    }
  }
}
