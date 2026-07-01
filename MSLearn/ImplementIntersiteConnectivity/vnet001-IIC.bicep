param virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name string = 'vnet-IICCoreServicesVnet-cus-001'
param routeTables_rt_IICCoreServices_cus_001_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-implementIntersiteConnectivity-cus-001/providers/Microsoft.Network/routeTables/rt-IICCoreServices-cus-001'
param virtualNetworks_vnet_IICManufacturingVnet_cus_001_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-implementIntersiteConnectivity-cus-001/providers/Microsoft.Network/virtualNetworks/vnet-IICManufacturingVnet-cus-001'

resource virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name_resource 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name
  location: 'centralus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'Core'
        id: virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name_Core.id
        properties: {
          addressPrefix: '10.0.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
      {
        name: 'perimeter'
        id: virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name_perimeter.id
        properties: {
          addressPrefix: '10.0.1.0/24'
          routeTable: {
            id: routeTables_rt_IICCoreServices_cus_001_externalid
          }
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'CoreServicesVnet-to-ManufacturingVnet'
        id: virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name_CoreServicesVnet_to_ManufacturingVnet.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_vnet_IICManufacturingVnet_cus_001_externalid
          }
          allowVirtualNetworkAccess: true
          allowForwardedTraffic: false
          allowGatewayTransit: false
          useRemoteGateways: false
          doNotVerifyRemoteGateways: false
          peerCompleteVnets: true
          enableOnlyIPv6Peering: false
          remoteAddressSpace: {
            addressPrefixes: [
              '172.16.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '172.16.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name_Core 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name}/Core'
  properties: {
    addressPrefix: '10.0.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name_resource
  ]
}

resource virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name_perimeter 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name}/perimeter'
  properties: {
    addressPrefix: '10.0.1.0/24'
    routeTable: {
      id: routeTables_rt_IICCoreServices_cus_001_externalid
    }
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name_resource
  ]
}

resource virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name_CoreServicesVnet_to_ManufacturingVnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-05-01' = {
  name: '${virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name}/CoreServicesVnet-to-ManufacturingVnet'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_vnet_IICManufacturingVnet_cus_001_externalid
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: false
    allowGatewayTransit: false
    useRemoteGateways: false
    doNotVerifyRemoteGateways: false
    peerCompleteVnets: true
    enableOnlyIPv6Peering: false
    remoteAddressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_vnet_IICCoreServicesVnet_cus_001_name_resource
  ]
}
