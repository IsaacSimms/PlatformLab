param virtualNetworks_vnet_implementVirtualNetworkingLab_prod_cus_001_name string = 'vnet-implementVirtualNetworkingLab-prod-cus-001'

resource virtualNetworks_vnet_implementVirtualNetworkingLab_prod_cus_001_name_resource 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworks_vnet_implementVirtualNetworkingLab_prod_cus_001_name
  location: 'centralus'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.20.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'subnet-SharedServicesSubnet-prod-cus-001'
        id: virtualNetworks_vnet_implementVirtualNetworkingLab_prod_cus_001_name_subnet_SharedServicesSubnet_prod_cus_001.id
        properties: {
          addressPrefixes: [
            '10.20.10.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
      {
        name: 'subnet-DatabaseSubnet-prod-cus-001'
        id: virtualNetworks_vnet_implementVirtualNetworkingLab_prod_cus_001_name_subnet_DatabaseSubnet_prod_cus_001.id
        properties: {
          addressPrefixes: [
            '10.20.20.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualNetworks_vnet_implementVirtualNetworkingLab_prod_cus_001_name_subnet_DatabaseSubnet_prod_cus_001 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_vnet_implementVirtualNetworkingLab_prod_cus_001_name}/subnet-DatabaseSubnet-prod-cus-001'
  properties: {
    addressPrefixes: [
      '10.20.20.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_implementVirtualNetworkingLab_prod_cus_001_name_resource
  ]
}

resource virtualNetworks_vnet_implementVirtualNetworkingLab_prod_cus_001_name_subnet_SharedServicesSubnet_prod_cus_001 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_vnet_implementVirtualNetworkingLab_prod_cus_001_name}/subnet-SharedServicesSubnet-prod-cus-001'
  properties: {
    addressPrefixes: [
      '10.20.10.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vnet_implementVirtualNetworkingLab_prod_cus_001_name_resource
  ]
}
