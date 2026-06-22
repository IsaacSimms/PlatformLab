param virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name string = 'Vnet-createVnetLabApp-prod-cus-001'
param virtualNetworks_vnet_createvnetLabHub_prod_cus_001_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-createVnetLab-prod-cus-001/providers/Microsoft.Network/virtualNetworks/vnet-createvnetLabHub-prod-cus-001'

resource virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name_resource 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name
  location: 'centralus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'subnet-createVnetLabFrontend-prod-cus-001'
        id: virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name_subnet_createVnetLabFrontend_prod_cus_001.id
        properties: {
          addressPrefixes: [
            '10.1.0.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'subnet-createVnetLabBackend-prod-cus-001'
        id: virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name_subnet_createVnetLabBackend_prod_cus_001.id
        properties: {
          addressPrefixes: [
            '10.1.1.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: [
      {
        name: 'Hub-To-App'
        id: virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name_Hub_To_App.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_vnet_createvnetLabHub_prod_cus_001_externalid
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

resource virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name_subnet_createVnetLabBackend_prod_cus_001 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name}/subnet-createVnetLabBackend-prod-cus-001'
  properties: {
    addressPrefixes: [
      '10.1.1.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name_resource
  ]
}

resource virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name_subnet_createVnetLabFrontend_prod_cus_001 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name}/subnet-createVnetLabFrontend-prod-cus-001'
  properties: {
    addressPrefixes: [
      '10.1.0.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name_resource
  ]
}

resource virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name_Hub_To_App 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-05-01' = {
  name: '${virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name}/Hub-To-App'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_vnet_createvnetLabHub_prod_cus_001_externalid
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
    virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_name_resource
  ]
}
