param virtualNetworks_vn_az104LearnDev_storage_cus_001_name string = 'vn-az104LearnDev-storage-cus-001'

resource virtualNetworks_vn_az104LearnDev_storage_cus_001_name_resource 'Microsoft.Network/virtualNetworks@2025-05-01' = {
  name: virtualNetworks_vn_az104LearnDev_storage_cus_001_name
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
        name: 'default'
        id: virtualNetworks_vn_az104LearnDev_storage_cus_001_name_default.id
        properties: {
          addressPrefixes: [
            '10.0.0.0/24'
          ]
          serviceEndpoints: [
            {
              service: 'Microsoft.Storage'
              locations: [
                'centralus'
                'eastus2'
              ]
            }
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

resource virtualNetworks_vn_az104LearnDev_storage_cus_001_name_default 'Microsoft.Network/virtualNetworks/subnets@2025-05-01' = {
  name: '${virtualNetworks_vn_az104LearnDev_storage_cus_001_name}/default'
  properties: {
    addressPrefixes: [
      '10.0.0.0/24'
    ]
    serviceEndpoints: [
      {
        service: 'Microsoft.Storage'
        locations: [
          'centralus'
          'eastus2'
        ]
      }
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_vn_az104LearnDev_storage_cus_001_name_resource
  ]
}
