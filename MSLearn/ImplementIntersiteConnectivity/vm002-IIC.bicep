param virtualMachines_vm_IICManufacturingVM_cus_001_name string = 'vm-IICManufacturingVM-cus-001'
param disks_vm_IICManufacturingVM_cus_001_OsDisk_1_d4e6b60688f14c02a04fd16e49b558fb_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-implementIntersiteConnectivity-cus-001/providers/Microsoft.Compute/disks/vm-IICManufacturingVM-cus-001_OsDisk_1_d4e6b60688f14c02a04fd16e49b558fb'
param networkInterfaces_vm_iicmanufacturingvm_cus_00122_externalid string = '/subscriptions/c18da72d-9a6e-4df6-9c0d-9cff6d667a85/resourceGroups/rg-implementIntersiteConnectivity-cus-001/providers/Microsoft.Network/networkInterfaces/vm-iicmanufacturingvm-cus-00122'

resource virtualMachines_vm_IICManufacturingVM_cus_001_name_resource 'Microsoft.Compute/virtualMachines@2025-11-01' = {
  name: virtualMachines_vm_IICManufacturingVM_cus_001_name
  location: 'centralus'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D2s_v3'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2025-datacenter-g2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_vm_IICManufacturingVM_cus_001_name}_OsDisk_1_d4e6b60688f14c02a04fd16e49b558fb'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
          id: disks_vm_IICManufacturingVM_cus_001_OsDisk_1_d4e6b60688f14c02a04fd16e49b558fb_externalid
        }
        deleteOption: 'Delete'
        diskSizeGB: 127
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: 'vm-IICManufactu'
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'localadmin'
    }
    securityProfile: {
      securityType: 'Standard'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_iicmanufacturingvm_cus_00122_externalid
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
  }
}
