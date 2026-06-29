param virtualNetworks_vnet_createvnetLabHub_prod_cus_001_name string = 'vnet-createvnetLabHub-prod-cus-001'
param virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-createVnetLab-prod-cus-001/providers/Microsoft.Network/virtualNetworks/Vnet-createVnetLabApp-prod-cus-001'

resource virtualNetworks_vnet_createvnetLabHub_prod_cus_001_name_resource 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworks_vnet_createvnetLabHub_prod_cus_001_name
  location: 'centralus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'AzureFirewallSubnet'
        id: virtualNetworks_vnet_createvnetLabHub_prod_cus_001_name_AzureFirewallSubnet.id
        properties: {
          addressPrefixes: [
            '10.0.0.0/26'
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
        name: 'App-To-Hub'
        id: virtualNetworks_vnet_createvnetLabHub_prod_cus_001_name_App_To_Hub.id
        properties: {
          peeringState: 'Connected'
          peeringSyncLevel: 'FullyInSync'
          remoteVirtualNetwork: {
            id: virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_externalid
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
              '10.1.0.0/16'
            ]
          }
          remoteVirtualNetworkAddressSpace: {
            addressPrefixes: [
              '10.1.0.0/16'
            ]
          }
        }
      }
    ]
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet_createvnetLabHub_prod_cus_001_name_AzureFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_vnet_createvnetLabHub_prod_cus_001_name}/AzureFirewallSubnet'
  properties: {
    addressPrefixes: [
      '10.0.0.0/26'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_createvnetLabHub_prod_cus_001_name_resource
  ]
}

resource virtualNetworks_vnet_createvnetLabHub_prod_cus_001_name_App_To_Hub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2025-05-01' = {
  name: '${virtualNetworks_vnet_createvnetLabHub_prod_cus_001_name}/App-To-Hub'
  properties: {
    peeringState: 'Connected'
    peeringSyncLevel: 'FullyInSync'
    remoteVirtualNetwork: {
      id: virtualNetworks_Vnet_createVnetLabApp_prod_cus_001_externalid
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
        '10.1.0.0/16'
      ]
    }
    remoteVirtualNetworkAddressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
  }
  dependsOn: [
    virtualNetworks_vnet_createvnetLabHub_prod_cus_001_name_resource
  ]
}
