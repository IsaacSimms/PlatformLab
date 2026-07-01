param virtualNetworks_vnet_IICManufacturingVnet_cus_001_name string = 'vnet-IICManufacturingVnet-cus-001'
param virtualNetworks_vnet_IICCoreServicesVnet_cus_001_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-implementIntersiteConnectivity-cus-001/providers/Microsoft.Network/virtualNetworks/vnet-IICCoreServicesVnet-cus-001'

resource virtualNetworks_vnet_IICManufacturingVnet_cus_001_name_resource 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworks_vnet_IICManufacturingVnet_cus_001_name
  location: 'centralus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '172.16.0.0/16'
      ]
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'Manufacturing'
        id: virtualNetworks_vnet_IICManufacturingVnet_cus_001_name_Manufacturing.id
        properties: {
          addressPrefix: '172.16.0.0/24'
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'Manufacturing-to-CoreServicesVnet'
        id: virtualNetworks_vnet_IICManufacturingVnet_cus_001_name_Manufacturing_to_CoreServicesVnet.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_vnet_IICCoreServicesVnet_cus_001_externalid
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
              '10.0.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.0.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet_IICManufacturingVnet_cus_001_name_Manufacturing 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_vnet_IICManufacturingVnet_cus_001_name}/Manufacturing'
  properties: {
    addressPrefix: '172.16.0.0/24'
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
  dependsOn: [
    virtualNetworks_vnet_IICManufacturingVnet_cus_001_name_resource
  ]
}

resource virtualNetworks_vnet_IICManufacturingVnet_cus_001_name_Manufacturing_to_CoreServicesVnet 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-05-01' = {
  name: '${virtualNetworks_vnet_IICManufacturingVnet_cus_001_name}/Manufacturing-to-CoreServicesVnet'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_vnet_IICCoreServicesVnet_cus_001_externalid
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
        '10.0.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_vnet_IICManufacturingVnet_cus_001_name_resource
  ]
}
