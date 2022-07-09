import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart';
import 'package:poultry_login_signup/admin/providers/admin_apis.dart';
import 'package:poultry_login_signup/colors.dart';
import 'package:poultry_login_signup/main.dart';
import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/providers/exception_handle.dart';
import 'package:poultry_login_signup/widgets/display_exception.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../infrastructure/providers/infrastructure_apicalls.dart';
import '../../styles.dart';
import '../../widgets/modular_widgets.dart';

class EditUserRoles extends StatefulWidget {
  EditUserRoles({Key? key, required this.reFresh, required this.userRoles})
      : super(key: key);
  final ValueChanged<int> reFresh;

  final Map<String, dynamic> userRoles;

  static const routeName = '/EditUserRoles';
  @override
  State<EditUserRoles> createState() => _EditUserRolesState();
}

class _EditUserRolesState extends State<EditUserRoles> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  List firmList = [];

  List plantList = [];

  List selectedFirmPermissionList = [];

  List selectedSectionList = [];

  List selectedPlantPermissionList = [];

  List selectedWareHousePermissionList = [];

  List selectedSectionPermissionList = [];

  bool activityPlanView = false;

  bool ActivityPlanCreate = false;

  var ActivityPlanEdit = false;

  var ActivityPlanDelete = false;

  bool vaccinationPlanView = false;

  bool vaccinationPlanCreate = false;

  bool vaccinationPlanEdit = false;

  bool vaccinationPlanDelete = false;

  bool medicationPlanView = false;

  bool medicationPlanCreate = false;

  bool medicationPlanDelete = false;

  bool medicationPlanEdit = false;

  bool breedView = false;

  bool breedCreate = false;

  bool breedEdit = false;

  bool breedDelete = false;

  bool breedVersionView = false;

  bool breedVersionCreate = false;

  bool breedVersionEdit = false;

  bool breedVersionDelete = false;

  bool birdAgeView = false;

  bool birdAgeCreate = false;

  bool birdAgeEdit = false;

  bool birdAgeDelete = false;

  bool productManagementView = false;

  bool productManagementCreate = false;

  bool productManagementEdit = false;

  bool productManagementDelete = false;

  bool batchPlanningView = false;

  bool batchPlanningCreate = false;

  bool batchPlanningEdit = false;

  bool batchPlanningDelete = false;
  bool transferInView = false;

  bool transferInCreate = false;

  bool transferInEdit = false;

  bool transferInDelete = false;

  List selectedActivityPlanPermissionList = [];
  List selectedVaccinationPlanPermissionList = [];
  List selectedMedicationPlanPermissionList = [];
  List selectedBreedPermissionList = [];
  List selectedBreedVersionPermissionList = [];
  List selectedBirdAgeGroupingPermissionList = [];
  List selectedProductManagementPermissionList = [];
  List selectedBatchPlanningPermissionList = [];
  List selectedTransferInPermissionList = [];
  List selectedTransferOutPermissionList = [];
  List selectedSalesPermissionList = [];
  List selectedInventoryAdjustmentJournalPermissionList = [];
  List selectedBirdGradingPermissionList = [];
  List selectedMortalityPermissionList = [];
  List selectedEggCollectionPermissionList = [];
  List selectedEggGradingPermissionList = [];
  List selectedActivityLogPermissionList = [];
  List selectedVaccinationLogPermissionList = [];
  List selectedMedicationLogPermissionList = [];
  List selectedLogDailyBatchesPermissionList = [];
  List selectedAddBatchPermissionList = [];

  bool transferOutView = false;

  bool transferOutCreate = false;

  bool transferOutEdit = false;

  bool transferOutDelete = false;

  bool salesView = false;

  bool salesCreate = false;

  bool salesEdit = false;

  bool salesDelete = false;

  bool inventoryAdjustmentJournalView = false;

  bool inventoryAdjustmentJournalCreate = false;

  bool inventoryAdjustmentJournalEdit = false;

  bool inventoryAdjustmentJournalDelete = false;

  bool birdGradingView = false;

  bool birdGradingCreate = false;

  bool birdGradingEdit = false;

  bool birdGradingDelete = false;

  bool mortalityView = false;

  bool mortalityCreate = false;

  bool mortalityEdit = false;

  bool mortalityDelete = false;

  bool eggCollectionView = false;

  bool eggCollectionCreate = false;

  bool eggCollectionEdit = false;

  bool eggCollectionDelete = false;

  bool eggGradingView = false;

  bool eggGradingCreate = false;

  bool eggGradingEdit = false;

  bool eggGradingDelete = false;

  bool activityLogView = false;

  bool activityLogCreate = false;

  bool activityLogEdit = false;

  bool activityLogDelete = false;

  bool vaccinationLogView = false;

  bool vaccinationLogCreate = false;

  bool vaccinationLogEdit = false;

  bool vaccinationLogDelete = false;

  bool medicationLogView = false;

  bool medicationLogCreate = false;

  bool medicationLogEdit = false;

  bool medicationLogDelete = false;

  bool logDailyView = false;

  bool logDailyCreate = false;

  bool logDailyEdit = false;

  bool logDailyDelete = false;

  bool addBatchView = false;

  bool addBatchCreate = false;

  bool addBatchEdit = false;

  bool addBatchDelete = false;

  Map<String, dynamic> individualUserRoles = {};

  TextEditingController roleNameController = TextEditingController();

  TextEditingController roleDescriptionController = TextEditingController();

  var _roleId;

  bool usersView = false;

  bool usersCreate = false;

  bool usersEdit = false;

  bool usersDelete = false;

  List selectedUsersPermissionList = [];

  bool usersApprove = false;

  bool roleView = false;

  bool roleCreate = false;

  bool roleEdit = false;

  bool roleDelete = false;

  List selectedRolePermissionList = [];

  void recordRolePermissions(Map<String, dynamic> data) {
    if (selectedRolePermissionList.isEmpty) {
      selectedRolePermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedRolePermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedRolePermissionList.remove(firm);
          selectedRolePermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedRolePermissionList.add(data);
      }
    }
    print('selected Role List $selectedRolePermissionList');
    setState(() {});
  }

  void recordUsersPermissions(Map<String, dynamic> data) {
    if (selectedUsersPermissionList.isEmpty) {
      selectedUsersPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedUsersPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedUsersPermissionList.remove(firm);
          selectedUsersPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedUsersPermissionList.add(data);
      }
    }
    // print('selected User List $selectedUsersPermissionList');
    setState(() {});
  }

  void recordAddBatchPermissions(Map<String, dynamic> data) {
    if (selectedAddBatchPermissionList.isEmpty) {
      selectedAddBatchPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedAddBatchPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedAddBatchPermissionList.remove(firm);
          selectedAddBatchPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedAddBatchPermissionList.add(data);
      }
    }
    // print('selected Add batches List $selectedAddBatchPermissionList');
    setState(() {});
  }

  void recordLogDailyBatchesPermissions(Map<String, dynamic> data) {
    if (selectedLogDailyBatchesPermissionList.isEmpty) {
      selectedLogDailyBatchesPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedLogDailyBatchesPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedLogDailyBatchesPermissionList.remove(firm);
          selectedLogDailyBatchesPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedLogDailyBatchesPermissionList.add(data);
      }
    }
    // print(
    // 'selected Log Daily batches List $selectedLogDailyBatchesPermissionList');
    setState(() {});
  }

  void recordMedicationLogPermissions(Map<String, dynamic> data) {
    if (selectedMedicationLogPermissionList.isEmpty) {
      selectedMedicationLogPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedMedicationLogPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedMedicationLogPermissionList.remove(firm);
          selectedMedicationLogPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedMedicationLogPermissionList.add(data);
      }
    }
    // print('selected Medication Log List $selectedMedicationLogPermissionList');
    setState(() {});
  }

  void recordVaccinationLogPermissions(Map<String, dynamic> data) {
    if (selectedVaccinationLogPermissionList.isEmpty) {
      selectedVaccinationLogPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedVaccinationLogPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedVaccinationLogPermissionList.remove(firm);
          selectedVaccinationLogPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedVaccinationLogPermissionList.add(data);
      }
    }
    print(
        'selected Vaccination Log List $selectedVaccinationLogPermissionList');
    setState(() {});
  }

  void recordActivityLogPermissions(Map<String, dynamic> data) {
    if (selectedActivityLogPermissionList.isEmpty) {
      selectedActivityLogPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedActivityLogPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedActivityLogPermissionList.remove(firm);
          selectedActivityLogPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedActivityLogPermissionList.add(data);
      }
    }
    // print('selected Activity Log List $selectedActivityLogPermissionList');
    setState(() {});
  }

  void recordEggGradingPermissions(Map<String, dynamic> data) {
    if (selectedEggGradingPermissionList.isEmpty) {
      selectedEggGradingPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedEggGradingPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedEggGradingPermissionList.remove(firm);
          selectedEggGradingPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedEggGradingPermissionList.add(data);
      }
    }
    // print('selected Egg grading List $selectedEggGradingPermissionList');
    setState(() {});
  }

  void recordEggCollectionPermissions(Map<String, dynamic> data) {
    if (selectedEggCollectionPermissionList.isEmpty) {
      selectedEggCollectionPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedEggCollectionPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedEggCollectionPermissionList.remove(firm);
          selectedEggCollectionPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedEggCollectionPermissionList.add(data);
      }
    }
    // print('selected Egg Collection List $selectedEggCollectionPermissionList');
    setState(() {});
  }

  void recordMortalityPermissions(Map<String, dynamic> data) {
    if (selectedMortalityPermissionList.isEmpty) {
      selectedMortalityPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedMortalityPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedMortalityPermissionList.remove(firm);
          selectedMortalityPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedMortalityPermissionList.add(data);
      }
    }
    // print('selected Mortality List $selectedMortalityPermissionList');
    setState(() {});
  }

  void recordBirdGradingPermissions(Map<String, dynamic> data) {
    if (selectedBirdGradingPermissionList.isEmpty) {
      selectedBirdGradingPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedBirdGradingPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedBirdGradingPermissionList.remove(firm);
          selectedBirdGradingPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedBirdGradingPermissionList.add(data);
      }
    }
    // print('selected bird grading List $selectedBirdGradingPermissionList');
    setState(() {});
  }

  void recordInventoryAdjustmentJournalPermissions(Map<String, dynamic> data) {
    if (selectedInventoryAdjustmentJournalPermissionList.isEmpty) {
      selectedInventoryAdjustmentJournalPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedInventoryAdjustmentJournalPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedInventoryAdjustmentJournalPermissionList.remove(firm);
          selectedInventoryAdjustmentJournalPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedInventoryAdjustmentJournalPermissionList.add(data);
      }
    }
    // print(
    // 'selected inventory Adjustment journal List $selectedInventoryAdjustmentJournalPermissionList');
    setState(() {});
  }

  void recordSalesPermissions(Map<String, dynamic> data) {
    if (selectedSalesPermissionList.isEmpty) {
      selectedSalesPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedSalesPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedSalesPermissionList.remove(firm);
          selectedSalesPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedSalesPermissionList.add(data);
      }
    }
    // print('selected sales permission List $selectedSalesPermissionList');
    setState(() {});
  }

  void recordTransferOutPermissions(Map<String, dynamic> data) {
    if (selectedTransferOutPermissionList.isEmpty) {
      selectedTransferOutPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedTransferOutPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedTransferOutPermissionList.remove(firm);
          selectedTransferOutPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedTransferOutPermissionList.add(data);
      }
    }
    // print(
    // 'selected transfer out permission List $selectedTransferOutPermissionList');
    setState(() {});
  }

  void recordTransferInPermissions(Map<String, dynamic> data) {
    if (selectedTransferInPermissionList.isEmpty) {
      selectedTransferInPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedTransferInPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedTransferInPermissionList.remove(firm);
          selectedTransferInPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedTransferInPermissionList.add(data);
      }
    }
    // print(
    // 'selected transfer in permission List $selectedTransferInPermissionList');
    setState(() {});
  }

  void recordBatchPlanningPermissions(Map<String, dynamic> data) {
    if (selectedBatchPlanningPermissionList.isEmpty) {
      selectedBatchPlanningPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedBatchPlanningPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedBatchPlanningPermissionList.remove(firm);
          selectedBatchPlanningPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedBatchPlanningPermissionList.add(data);
      }
    }
    // print(
    // 'selected Batch Planning permission List $selectedBatchPlanningPermissionList');
    setState(() {});
  }

  void recordProductManagamentPermissions(Map<String, dynamic> data) {
    if (selectedProductManagementPermissionList.isEmpty) {
      selectedProductManagementPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedProductManagementPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedProductManagementPermissionList.remove(firm);
          selectedProductManagementPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedProductManagementPermissionList.add(data);
      }
    }
    // print(
    // 'selected Product Management permission List $selectedProductManagementPermissionList');
    setState(() {});
  }

  void recordBirdAgeGroupingPermissions(Map<String, dynamic> data) {
    if (selectedBirdAgeGroupingPermissionList.isEmpty) {
      selectedBirdAgeGroupingPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedBirdAgeGroupingPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedBirdAgeGroupingPermissionList.remove(firm);
          selectedBirdAgeGroupingPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedBirdAgeGroupingPermissionList.add(data);
      }
    }
    // print(
    // 'selected BirdAge Grouping permission List $selectedBirdAgeGroupingPermissionList');
    setState(() {});
  }

  void recordBreedVersionPermissions(Map<String, dynamic> data) {
    if (selectedBreedVersionPermissionList.isEmpty) {
      selectedBreedVersionPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedBreedVersionPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedBreedVersionPermissionList.remove(firm);
          selectedBreedVersionPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedBreedVersionPermissionList.add(data);
      }
    }
    // print(
    // 'selected Breed Version permission List $selectedBreedVersionPermissionList');
    setState(() {});
  }

  void recordBreedPermissions(Map<String, dynamic> data) {
    if (selectedBreedPermissionList.isEmpty) {
      selectedBreedPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedBreedPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedBreedPermissionList.remove(firm);
          selectedBreedPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedBreedPermissionList.add(data);
      }
    }
    // print('selected Breed permission List $selectedBreedPermissionList');
    setState(() {});
  }

  void recordMedicationPlanPermissions(Map<String, dynamic> data) {
    if (selectedMedicationPlanPermissionList.isEmpty) {
      selectedMedicationPlanPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedMedicationPlanPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedMedicationPlanPermissionList.remove(firm);
          selectedMedicationPlanPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedMedicationPlanPermissionList.add(data);
      }
    }
    // print(
    // 'selected Medication Plan permission List $selectedMedicationPlanPermissionList');
    setState(() {});
  }

  void recordVaccinationPlanPermissions(Map<String, dynamic> data) {
    if (selectedVaccinationPlanPermissionList.isEmpty) {
      selectedVaccinationPlanPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedVaccinationPlanPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedVaccinationPlanPermissionList.remove(firm);
          selectedVaccinationPlanPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedVaccinationPlanPermissionList.add(data);
      }
    }
    // print(
    // 'selected Vaccination Plan permission List $selectedVaccinationPlanPermissionList');
    setState(() {});
  }

  void recordActivityPlanPermissions(Map<String, dynamic> data) {
    if (selectedActivityPlanPermissionList.isEmpty) {
      selectedActivityPlanPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedActivityPlanPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedActivityPlanPermissionList.remove(firm);
          selectedActivityPlanPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedActivityPlanPermissionList.add(data);
      }
    }
    // print(
    // 'selected Activity Plan permission List $selectedActivityPlanPermissionList');
    setState(() {});
  }

  void recordWareHouseSectionPermissions(Map<String, dynamic> data) {
    if (selectedSectionPermissionList.isEmpty) {
      selectedSectionPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedSectionPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedSectionPermissionList.remove(firm);
          selectedSectionPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedSectionPermissionList.add(data);
      }
    }
    // print(
    // 'selected WareHouse Section permission List $selectedSectionPermissionList');
    setState(() {});
  }

  void storeSelectedSection(int data) {
    if (selectedSectionList.isEmpty) {
      selectedSectionList.add(data);
    } else {
      if (selectedSectionList.contains(data)) {
        selectedSectionList.remove(data);
      } else {
        selectedSectionList.add(data);
      }
    }
  }

  void recordWareHousePermissions(Map<String, dynamic> data) {
    if (selectedWareHousePermissionList.isEmpty) {
      selectedWareHousePermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedWareHousePermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedWareHousePermissionList.remove(firm);
          selectedWareHousePermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedWareHousePermissionList.add(data);
      }
    }
    // print(
    // 'selected WareHouse permission List $selectedWareHousePermissionList');
    setState(() {});
  }

  void storeSelectedWareHouse(int data) {
    if (selectedWareHouseList.isEmpty) {
      selectedWareHouseList.add(data);
    } else {
      if (selectedWareHouseList.contains(data)) {
        selectedWareHouseList.remove(data);
      } else {
        selectedWareHouseList.add(data);
      }
    }
    getWarehouseSectionList(selectedWareHouseList);
  }

  List selectedWareHouseList = [];

  void storeSelectedPlants(int data) {
    if (selectedPlantList.isEmpty) {
      selectedPlantList.add(data);
    } else {
      if (selectedPlantList.contains(data)) {
        selectedPlantList.remove(data);
      } else {
        selectedPlantList.add(data);
      }
    }
    getWarehouseList(selectedPlantList);
  }

  void recordPlantPermissions(Map<String, dynamic> data) {
    if (selectedPlantPermissionList.isEmpty) {
      selectedPlantPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedPlantPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedPlantPermissionList.remove(firm);
          selectedPlantPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedPlantPermissionList.add(data);
      }
    }
    // print('selected plant permission List $selectedPlantPermissionList');
    setState(() {});
  }

  List selectedPlantList = [];

  EdgeInsetsGeometry getPadding() {
    return const EdgeInsets.only(left: 8.0);
  }

  var wareHouseId;

  var user = {
    'Role_Name': '',
    'Role_Description': '',
    'Role_Permission': '',
  };

  Future<String> fetchCredientials() async {
    bool data =
        await Provider.of<Apicalls>(context, listen: false).tryAutoLogin();

    if (data != false) {
      var token = Provider.of<Apicalls>(context, listen: false).token;

      return token;
    } else {
      return '';
    }
  }

  // bool loading = true;
  var extratedData;
  bool loading = true;
  @override
  void initState() {
    Provider.of<ExceptionHandle>(context, listen: false).exceptionData.clear();
    getPermission('Roles').then((value) {
      extratedData = value;
      setState(() {
        loading = false;
      });
    });
    fetchCredientials().then((token) async {
      await Provider.of<InfrastructureApis>(context, listen: false)
          .getFirmDetails(token);
    });

    if (widget.userRoles.isNotEmpty) {
      roleNameController.text = widget.userRoles['Role_Name'];
      roleDescriptionController.text = widget.userRoles['Description'];

      if (widget.userRoles['Role_Permission']['Firms'] != null) {
        List temp = [];

        for (var data in widget.userRoles['Role_Permission']['Firms']) {
          temp.add(data['Id']);

          selectedFirmPermissionList.addAll([
            {
              'Id': data['Id'],
              'Key': 'View',
              'Value': data['View'],
            },
            {
              'Id': data['Id'],
              'Key': 'Create',
              'Value': data['Create'],
            },
            {
              'Id': data['Id'],
              'Key': 'Edit',
              'Value': data['Edit'],
            },
            {
              'Id': data['Id'],
              'Key': 'Delete',
              'Value': data['Delete'],
            },
          ]);
          getPlantList(temp);
        }
      }
      if (widget.userRoles['Role_Permission']['Plants'] != null) {
        List temp = [];

        for (var data in widget.userRoles['Role_Permission']['Plants']) {
          temp.add(data['Id']);

          selectedPlantPermissionList.addAll([
            {
              'Id': data['Id'],
              'Key': 'View',
              'Value': data['View'],
            },
            {
              'Id': data['Id'],
              'Key': 'Create',
              'Value': data['Create'],
            },
            {
              'Id': data['Id'],
              'Key': 'Edit',
              'Value': data['Edit'],
            },
            {
              'Id': data['Id'],
              'Key': 'Delete',
              'Value': data['Delete'],
            },
          ]);
          getWarehouseList(temp);
        }
      }
      if (widget.userRoles['Role_Permission']['WareHouses'] != null) {
        List temp = [];

        for (var data in widget.userRoles['Role_Permission']['WareHouses']) {
          temp.add(data['Id']);

          selectedWareHousePermissionList.addAll([
            {
              'Id': data['Id'],
              'Key': 'View',
              'Value': data['View'],
            },
            {
              'Id': data['Id'],
              'Key': 'Create',
              'Value': data['Create'],
            },
            {
              'Id': data['Id'],
              'Key': 'Edit',
              'Value': data['Edit'],
            },
            {
              'Id': data['Id'],
              'Key': 'Delete',
              'Value': data['Delete'],
            },
          ]);
          getWarehouseSectionList(temp);
        }
      }
      if (widget.userRoles['Role_Permission']['Sections'] != null) {
        List temp = [];

        for (var data in widget.userRoles['Role_Permission']['Sections']) {
          temp.add(data['Id']);

          selectedSectionPermissionList.addAll([
            {
              'Id': data['Id'],
              'Key': 'View',
              'Value': data['View'],
            },
            {
              'Id': data['Id'],
              'Key': 'Create',
              'Value': data['Create'],
            },
            {
              'Id': data['Id'],
              'Key': 'Edit',
              'Value': data['Edit'],
            },
            {
              'Id': data['Id'],
              'Key': 'Delete',
              'Value': data['Delete'],
            },
          ]);
          // getWarehouseSectionList(temp);
        }
      }
      if (widget.userRoles['Role_Permission']['Add_Batch'] != null) {
        selectedAddBatchPermissionList.addAll([
          {
            'Id': 'Add Batch',
            'Key': 'View',
            'Value': widget.userRoles['Role_Permission']['Add_Batch']['View'],
          },
          {
            'Id': 'Add Batch',
            'Key': 'Create',
            'Value': widget.userRoles['Role_Permission']['Add_Batch']['Create'],
          },
          {
            'Id': 'Add Batch',
            'Key': 'Edit',
            'Value': widget.userRoles['Role_Permission']['Add_Batch']['Edit'],
          },
          {
            'Id': 'Add Batch',
            'Key': 'Delete',
            'Value': widget.userRoles['Role_Permission']['Add_Batch']['Delete'],
          },
        ]);
      }
      if (widget.userRoles['Role_Permission']['Users'] != null) {
        selectedUsersPermissionList.addAll([
          {
            'Id': 'Users',
            'Key': 'View',
            'Value': widget.userRoles['Role_Permission']['Users']['View'],
          },
          {
            'Id': 'Users',
            'Key': 'Create',
            'Value': widget.userRoles['Role_Permission']['Users']['Create'],
          },
          {
            'Id': 'Users',
            'Key': 'Edit',
            'Value': widget.userRoles['Role_Permission']['Users']['Edit'],
          },
          {
            'Id': 'Users',
            'Key': 'Delete',
            'Value': widget.userRoles['Role_Permission']['Users']['Delete'],
          },
          {
            'Id': 'Users',
            'Key': 'Approve',
            'Value': widget.userRoles['Role_Permission']['Users']['Approve'],
          },
        ]);
      }
      assignPermissions(
          'Transfer In',
          widget.userRoles['Role_Permission']['Transfers']['Transfer_In'],
          selectedTransferInPermissionList);
      assignPermissions(
          'Transfer Out',
          widget.userRoles['Role_Permission']['Transfers']['Transfer_Out'],
          selectedTransferOutPermissionList);
      assignPermissions(
          'Activity Log',
          widget.userRoles['Role_Permission']['Activity_Log'],
          selectedActivityLogPermissionList);
      assignPermissions(
          'Batch Planning',
          widget.userRoles['Role_Permission']['Batch_Planning'],
          selectedBatchPlanningPermissionList);
      assignPermissions(
          'Medication Log',
          widget.userRoles['Role_Permission']['Medication_Log'],
          selectedMedicationLogPermissionList);
      assignPermissions(
          'Breed',
          widget.userRoles['Role_Permission']['Reference_Data']['Breed'],
          selectedBreedPermissionList);
      assignPermissions(
          'Activity Plan',
          widget.userRoles['Role_Permission']['Reference_Data']
              ['Activity_Plan'],
          selectedActivityPlanPermissionList);
      assignPermissions(
          'Breed Version',
          widget.userRoles['Role_Permission']['Reference_Data']
              ['Breed_Version'],
          selectedBreedVersionPermissionList);
      assignPermissions(
          'Medication Plan',
          widget.userRoles['Role_Permission']['Reference_Data']
              ['Medication_Plan'],
          selectedMedicationPlanPermissionList);
      assignPermissions(
          'Vaccination Plan',
          widget.userRoles['Role_Permission']['Reference_Data']
              ['Vaccination_Plan'],
          selectedVaccinationPlanPermissionList);
      assignPermissions(
          'Bird Age Grouping',
          widget.userRoles['Role_Permission']['Reference_Data']
              ['Bird_Age_Grouping'],
          selectedBirdAgeGroupingPermissionList);
      assignPermissions(
          'vaccination Log',
          widget.userRoles['Role_Permission']['Vaccination_Log'],
          selectedVaccinationLogPermissionList);
      assignPermissions(
          'Log Daily Batches',
          widget.userRoles['Role_Permission']['Log_Daily_Batches'],
          selectedLogDailyBatchesPermissionList);
      assignPermissions(
          'Product Management',
          widget.userRoles['Role_Permission']['Product_Management'],
          selectedProductManagementPermissionList);
      assignPermissions(
          'Mortality',
          widget.userRoles['Role_Permission']['Inventory_Adjustment']
              ['Mortality'],
          selectedMortalityPermissionList);
      assignPermissions(
          'Egg Grading',
          widget.userRoles['Role_Permission']['Inventory_Adjustment']
              ['Egg_Grading'],
          selectedEggGradingPermissionList);
      assignPermissions(
          'Bird Grading',
          widget.userRoles['Role_Permission']['Inventory_Adjustment']
              ['Bird_Grading'],
          selectedBirdGradingPermissionList);
      assignPermissions(
          'Egg Collection',
          widget.userRoles['Role_Permission']['Inventory_Adjustment']
              ['Egg_Collection'],
          selectedEggCollectionPermissionList);
      assignPermissions(
          'Inventory Adjustment Journal',
          widget.userRoles['Role_Permission']['Inventory_Adjustment']
              ['Inventory_Adjustment_Journal'],
          selectedInventoryAdjustmentJournalPermissionList);
      assignPermissions('Sales', widget.userRoles['Role_Permission']['Sales'],
          selectedSalesPermissionList);
      assignPermissions('Roles', widget.userRoles['Role_Permission']['Roles'],
          selectedRolePermissionList);
      // setState(() {
      //   // loading = false;
      // });
    }
    super.initState();
  }

  void assignPermissions(
    var id,
    var data,
    List list,
  ) {
    if (data != null) {
      list.addAll([
        {
          'Id': id,
          'Key': 'View',
          'Value': data['View'],
        },
        {
          'Id': id,
          'Key': 'Create',
          'Value': data['Create'],
        },
        {
          'Id': id,
          'Key': 'Edit',
          'Value': data['Edit'],
        },
        {
          'Id': id,
          'Key': 'Delete',
          'Value': data['Delete'],
        },
      ]);
    }
  }

  Future<void> getPlantList(var data) async {
    await fetchCredientials().then((token) async {
      await Provider.of<InfrastructureApis>(context, listen: false)
          .getPlantlist(token, data);
    });
  }

  Future<void> getWarehouseList(var data) async {
    await fetchCredientials().then((token) async {
      await Provider.of<InfrastructureApis>(context, listen: false)
          .getWareHouselist(token, data);
    });
  }

  Future<void> getWarehouseSectionList(var data) async {
    await fetchCredientials().then((token) async {
      await Provider.of<InfrastructureApis>(context, listen: false)
          .getWareHouseSectionList(token, data);
    });
  }

  List selectedFirmList = [];

  void storeSelectedFirms(int data) {
    if (selectedFirmList.isEmpty) {
      selectedFirmList.add(data);
    } else {
      if (selectedFirmList.contains(data)) {
        selectedFirmList.remove(data);
      } else {
        selectedFirmList.add(data);
      }
    }
    // print(selectedFirmList);
    getPlantList(selectedFirmList);
  }

  Map<String, dynamic> permissions = {};
  bool roleNameValidate = true;
  bool roleDescriptionValidate = true;

  String roleNameValidationMessage = '';
  String roleDescriptionValidationMessage = '';
  bool validation = true;
  bool validate() {
    if (roleNameController.text.length > 18) {
      roleNameValidate = false;
      roleNameValidationMessage =
          'Role Name Cannot Contain More Then 18 Characters';
    } else if (roleNameController.text == '') {
      roleNameValidate = false;
      roleNameValidationMessage = 'Role Name Cannot be Empty';
    } else {
      roleNameValidate = true;
    }

    if (roleDescriptionController.text.length > 45) {
      roleDescriptionValidate = false;
      roleDescriptionValidationMessage =
          'Role Description Cannot Contain More Then 45 Characters';
    } else if (roleDescriptionController.text == '') {
      roleDescriptionValidate = false;
      roleDescriptionValidationMessage = 'Role Description Cannot be Empty';
    } else {
      roleDescriptionValidate = true;
    }

    if (roleNameValidate == true && roleDescriptionValidate == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> save() async {
    validation = validate();
    if (validation != true) {
      setState(() {});
      return;
    }

    _formKey.currentState!.save();
    if (selectedFirmPermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedFirmPermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0; j < selectedFirmPermissionList.length; j++) {
          if (selectedFirmPermissionList[j]['Id'] == sortedIds[i]) {
            if (selectedFirmPermissionList[j]['Key'] == 'View') {
              view = selectedFirmPermissionList[j]['Value'];
            } else if (selectedFirmPermissionList[j]['Key'] == 'Create') {
              create = selectedFirmPermissionList[j]['Value'];
            } else if (selectedFirmPermissionList[j]['Key'] == 'Edit') {
              edit = selectedFirmPermissionList[j]['Value'];
            } else if (selectedFirmPermissionList[j]['Key'] == 'Delete') {
              delete = selectedFirmPermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete
        });
      }

      // print(temp);
      permissions['Firms'] = temp;
    }

    if (selectedPlantPermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedPlantPermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0; j < selectedPlantPermissionList.length; j++) {
          if (selectedPlantPermissionList[j]['Id'] == sortedIds[i]) {
            if (selectedPlantPermissionList[j]['Key'] == 'View') {
              view = selectedPlantPermissionList[j]['Value'];
            } else if (selectedPlantPermissionList[j]['Key'] == 'Create') {
              create = selectedPlantPermissionList[j]['Value'];
            } else if (selectedPlantPermissionList[j]['Key'] == 'Edit') {
              edit = selectedPlantPermissionList[j]['Value'];
            } else if (selectedPlantPermissionList[j]['Key'] == 'Delete') {
              delete = selectedPlantPermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete
        });
      }

      // print(temp);
      permissions['Plants'] = temp;
    }

    if (selectedWareHousePermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedWareHousePermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0; j < selectedWareHousePermissionList.length; j++) {
          if (selectedWareHousePermissionList[j]['Id'] == sortedIds[i]) {
            if (selectedWareHousePermissionList[j]['Key'] == 'View') {
              view = selectedWareHousePermissionList[j]['Value'];
            } else if (selectedWareHousePermissionList[j]['Key'] == 'Create') {
              create = selectedWareHousePermissionList[j]['Value'];
            } else if (selectedWareHousePermissionList[j]['Key'] == 'Edit') {
              edit = selectedWareHousePermissionList[j]['Value'];
            } else if (selectedWareHousePermissionList[j]['Key'] == 'Delete') {
              delete = selectedWareHousePermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete
        });
      }

      // print(temp);
      permissions['WareHouses'] = temp;
    }
    if (selectedSectionPermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedSectionPermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0; j < selectedSectionPermissionList.length; j++) {
          if (selectedSectionPermissionList[j]['Id'] == sortedIds[i]) {
            if (selectedSectionPermissionList[j]['Key'] == 'View') {
              view = selectedSectionPermissionList[j]['Value'];
            } else if (selectedSectionPermissionList[j]['Key'] == 'Create') {
              create = selectedSectionPermissionList[j]['Value'];
            } else if (selectedSectionPermissionList[j]['Key'] == 'Edit') {
              edit = selectedSectionPermissionList[j]['Value'];
            } else if (selectedSectionPermissionList[j]['Key'] == 'Delete') {
              delete = selectedSectionPermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete
        });
      }

      // print(temp);
      permissions['Sections'] = temp;
    }
    if (selectedActivityPlanPermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedActivityPlanPermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0; j < selectedActivityPlanPermissionList.length; j++) {
          if (selectedActivityPlanPermissionList[j]['Id'] == sortedIds[i]) {
            if (selectedActivityPlanPermissionList[j]['Key'] == 'View') {
              view = selectedActivityPlanPermissionList[j]['Value'];
            } else if (selectedActivityPlanPermissionList[j]['Key'] ==
                'Create') {
              create = selectedActivityPlanPermissionList[j]['Value'];
            } else if (selectedActivityPlanPermissionList[j]['Key'] == 'Edit') {
              edit = selectedActivityPlanPermissionList[j]['Value'];
            } else if (selectedActivityPlanPermissionList[j]['Key'] ==
                'Delete') {
              delete = selectedActivityPlanPermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete
        });
      }

      // print(temp);
      permissions['Activity_Plan'] = temp;
    }
    if (selectedVaccinationPlanPermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedVaccinationPlanPermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0; j < selectedVaccinationPlanPermissionList.length; j++) {
          if (selectedVaccinationPlanPermissionList[j]['Id'] == sortedIds[i]) {
            if (selectedVaccinationPlanPermissionList[j]['Key'] == 'View') {
              view = selectedVaccinationPlanPermissionList[j]['Value'];
            } else if (selectedVaccinationPlanPermissionList[j]['Key'] ==
                'Create') {
              create = selectedVaccinationPlanPermissionList[j]['Value'];
            } else if (selectedVaccinationPlanPermissionList[j]['Key'] ==
                'Edit') {
              edit = selectedVaccinationPlanPermissionList[j]['Value'];
            } else if (selectedVaccinationPlanPermissionList[j]['Key'] ==
                'Delete') {
              delete = selectedVaccinationPlanPermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete
        });
      }

      // print(temp);
      permissions['Vaccination_Plan'] = temp;
    }
    if (selectedMedicationPlanPermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedMedicationPlanPermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0; j < selectedMedicationPlanPermissionList.length; j++) {
          if (selectedMedicationPlanPermissionList[j]['Id'] == sortedIds[i]) {
            if (selectedMedicationPlanPermissionList[j]['Key'] == 'View') {
              view = selectedMedicationPlanPermissionList[j]['Value'];
            } else if (selectedMedicationPlanPermissionList[j]['Key'] ==
                'Create') {
              create = selectedMedicationPlanPermissionList[j]['Value'];
            } else if (selectedMedicationPlanPermissionList[j]['Key'] ==
                'Edit') {
              edit = selectedMedicationPlanPermissionList[j]['Value'];
            } else if (selectedMedicationPlanPermissionList[j]['Key'] ==
                'Delete') {
              delete = selectedMedicationPlanPermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete
        });
      }

      // print(temp);
      permissions['Medication_Plan'] = temp;
    }
    if (selectedBreedPermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedBreedPermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0; j < selectedBreedPermissionList.length; j++) {
          if (selectedBreedPermissionList[j]['Id'] == sortedIds[i]) {
            if (selectedBreedPermissionList[j]['Key'] == 'View') {
              view = selectedBreedPermissionList[j]['Value'];
            } else if (selectedBreedPermissionList[j]['Key'] == 'Create') {
              create = selectedBreedPermissionList[j]['Value'];
            } else if (selectedBreedPermissionList[j]['Key'] == 'Edit') {
              edit = selectedBreedPermissionList[j]['Value'];
            } else if (selectedBreedPermissionList[j]['Key'] == 'Delete') {
              delete = selectedBreedPermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete
        });
      }

      // print(temp);
      permissions['Breed'] = temp;
    }

    if (selectedBreedVersionPermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedBreedVersionPermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0; j < selectedBreedVersionPermissionList.length; j++) {
          if (selectedBreedVersionPermissionList[j]['Id'] == sortedIds[i]) {
            if (selectedBreedVersionPermissionList[j]['Key'] == 'View') {
              view = selectedBreedVersionPermissionList[j]['Value'];
            } else if (selectedBreedVersionPermissionList[j]['Key'] ==
                'Create') {
              create = selectedBreedVersionPermissionList[j]['Value'];
            } else if (selectedBreedVersionPermissionList[j]['Key'] == 'Edit') {
              edit = selectedBreedVersionPermissionList[j]['Value'];
            } else if (selectedBreedVersionPermissionList[j]['Key'] ==
                'Delete') {
              delete = selectedBreedVersionPermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete
        });
      }

      // print(temp);
      permissions['Breed_Version'] = temp;
    }
    if (selectedBirdAgeGroupingPermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedBirdAgeGroupingPermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0; j < selectedBirdAgeGroupingPermissionList.length; j++) {
          if (selectedBirdAgeGroupingPermissionList[j]['Id'] == sortedIds[i]) {
            if (selectedBirdAgeGroupingPermissionList[j]['Key'] == 'View') {
              view = selectedBirdAgeGroupingPermissionList[j]['Value'];
            } else if (selectedBirdAgeGroupingPermissionList[j]['Key'] ==
                'Create') {
              create = selectedBirdAgeGroupingPermissionList[j]['Value'];
            } else if (selectedBirdAgeGroupingPermissionList[j]['Key'] ==
                'Edit') {
              edit = selectedBirdAgeGroupingPermissionList[j]['Value'];
            } else if (selectedBirdAgeGroupingPermissionList[j]['Key'] ==
                'Delete') {
              delete = selectedBirdAgeGroupingPermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete
        });
      }

      // print(temp);
      permissions['Bird_Age_Grouping'] = temp;
    }

    if (selectedProductManagementPermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedProductManagementPermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0;
            j < selectedProductManagementPermissionList.length;
            j++) {
          if (selectedProductManagementPermissionList[j]['Id'] ==
              sortedIds[i]) {
            if (selectedProductManagementPermissionList[j]['Key'] == 'View') {
              view = selectedProductManagementPermissionList[j]['Value'];
            } else if (selectedProductManagementPermissionList[j]['Key'] ==
                'Create') {
              create = selectedProductManagementPermissionList[j]['Value'];
            } else if (selectedProductManagementPermissionList[j]['Key'] ==
                'Edit') {
              edit = selectedProductManagementPermissionList[j]['Value'];
            } else if (selectedProductManagementPermissionList[j]['Key'] ==
                'Delete') {
              delete = selectedProductManagementPermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete
        });
      }

      // print(temp);
      permissions['Product_Management'] = temp;
    }

    if (selectedBatchPlanningPermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedBatchPlanningPermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0; j < selectedBatchPlanningPermissionList.length; j++) {
          if (selectedBatchPlanningPermissionList[j]['Id'] == sortedIds[i]) {
            if (selectedBatchPlanningPermissionList[j]['Key'] == 'View') {
              view = selectedBatchPlanningPermissionList[j]['Value'];
            } else if (selectedBatchPlanningPermissionList[j]['Key'] ==
                'Create') {
              create = selectedBatchPlanningPermissionList[j]['Value'];
            } else if (selectedBatchPlanningPermissionList[j]['Key'] ==
                'Edit') {
              edit = selectedBatchPlanningPermissionList[j]['Value'];
            } else if (selectedBatchPlanningPermissionList[j]['Key'] ==
                'Delete') {
              delete = selectedBatchPlanningPermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete
        });
      }

      // print(temp);
      permissions['Batch_Planning'] = temp;
    }

    if (selectedUsersPermissionList.isNotEmpty) {
      var edit;
      var view;
      var create;
      var delete;
      var approve;
      List ids = [];
      List sortedIds = [];
      List temp = [];
      for (var data in selectedUsersPermissionList) {
        ids.add(data['Id']);
      }
      sortedIds = ids.toSet().toList();
      for (int i = 0; i < sortedIds.length; i++) {
        for (int j = 0; j < selectedUsersPermissionList.length; j++) {
          if (selectedUsersPermissionList[j]['Id'] == sortedIds[i]) {
            if (selectedUsersPermissionList[j]['Key'] == 'View') {
              view = selectedUsersPermissionList[j]['Value'];
            } else if (selectedUsersPermissionList[j]['Key'] == 'Create') {
              create = selectedUsersPermissionList[j]['Value'];
            } else if (selectedUsersPermissionList[j]['Key'] == 'Edit') {
              edit = selectedUsersPermissionList[j]['Value'];
            } else if (selectedUsersPermissionList[j]['Key'] == 'Delete') {
              delete = selectedUsersPermissionList[j]['Value'];
            } else if (selectedUsersPermissionList[j]['Key'] == 'Approve') {
              approve = selectedUsersPermissionList[j]['Value'];
            }
          }
        }
        temp.add({
          'Id': sortedIds[i],
          'View': view,
          'Create': create,
          'Edit': edit,
          'Delete': delete,
          'Approve': approve,
        });
      }

      // print(temp);
      permissions['Users'] = temp;
    }

    if (selectedTransferInPermissionList.isNotEmpty) {
      sort(selectedTransferInPermissionList, 'Transfer_In');
    }

    if (selectedTransferOutPermissionList.isNotEmpty) {
      sort(selectedTransferOutPermissionList, 'Transfer_Out');
    }

    if (selectedSalesPermissionList.isNotEmpty) {
      sort(selectedSalesPermissionList, 'Sales');
    }

    if (selectedInventoryAdjustmentJournalPermissionList.isNotEmpty) {
      sort(selectedInventoryAdjustmentJournalPermissionList,
          'Inventory_Adjustment_Journal');
    }

    if (selectedBirdGradingPermissionList.isNotEmpty) {
      sort(selectedBirdGradingPermissionList, 'Bird_Grading');
    }

    if (selectedMortalityPermissionList.isNotEmpty) {
      sort(selectedMortalityPermissionList, 'Mortality');
    }

    if (selectedEggCollectionPermissionList.isNotEmpty) {
      sort(selectedEggCollectionPermissionList, 'Egg_Collection');
    }

    if (selectedEggGradingPermissionList.isNotEmpty) {
      sort(selectedEggGradingPermissionList, 'Egg_Grading');
    }

    if (selectedActivityLogPermissionList.isNotEmpty) {
      sort(selectedActivityLogPermissionList, 'Activity_Log');
    }

    if (selectedVaccinationLogPermissionList.isNotEmpty) {
      sort(selectedVaccinationLogPermissionList, 'Vaccination_Log');
    }
    if (selectedMedicationLogPermissionList.isNotEmpty) {
      sort(selectedMedicationLogPermissionList, 'Medication_Log');
    }
    if (selectedLogDailyBatchesPermissionList.isNotEmpty) {
      sort(selectedLogDailyBatchesPermissionList, 'Log_Daily_Batches');
    }
    if (selectedAddBatchPermissionList.isNotEmpty) {
      sort(selectedAddBatchPermissionList, 'Add_Batch');
    }

    if (selectedRolePermissionList.isNotEmpty) {
      sort(selectedRolePermissionList, 'Roles');
    }

    Map<String, dynamic> finalPermissions = {
      'Firms': permissions['Firms'],
      'Plants': permissions['Plants'],
      'WareHouses': permissions['WareHouses'],
      'Sections': permissions['Sections'],
      'Users': permissions['Users'] == null
          ? {"Edit": false, "View": false, "Create": false, "Delete": false}
          : permissions['Users'][0],
      'Roles': permissions['Users'] == null
          ? {"Edit": false, "View": false, "Create": false, "Delete": false}
          : permissions['Roles'][0],
      'Reference_Data': {
        'Activity_Plan': permissions['Activity_Plan'] == null
            ? {"Edit": false, "View": false, "Create": false, "Delete": false}
            : permissions['Activity_Plan'][0],
        'Vaccination_Plan': permissions['Vaccination_Plan'] == null
            ? {"Edit": false, "View": false, "Create": false, "Delete": false}
            : permissions['Vaccination_Plan'][0],
        'Medication_Plan': permissions['Medication_Plan'] == null
            ? {"Edit": false, "View": false, "Create": false, "Delete": false}
            : permissions['Medication_Plan'][0],
        'Breed': permissions['Breed'] == null
            ? {"Edit": false, "View": false, "Create": false, "Delete": false}
            : permissions['Breed'][0],
        'Breed_Version': permissions['Breed_Version'] == null
            ? {"Edit": false, "View": false, "Create": false, "Delete": false}
            : permissions['Breed_Version'][0],
        'Bird_Age_Grouping': permissions['Bird_Age_Grouping'] == null
            ? {"Edit": false, "View": false, "Create": false, "Delete": false}
            : permissions['Bird_Age_Grouping'][0],
      },
      'Product_Management': permissions['Product_Management'] == null
          ? {"Edit": false, "View": false, "Create": false, "Delete": false}
          : permissions['Product_Management'][0],
      'Batch_Planning': permissions['Batch_Planning'] == null
          ? {"Edit": false, "View": false, "Create": false, "Delete": false}
          : permissions['Batch_Planning'][0],
      'Transfers': {
        'Transfer_In': permissions['Transfer_In'] == null
            ? {"Edit": false, "View": false, "Create": false, "Delete": false}
            : permissions['Transfer_In'][0],
        'Transfer_Out': permissions['Transfer_Out'] == null
            ? {"Edit": false, "View": false, "Create": false, "Delete": false}
            : permissions['Transfer_Out'][0],
      },
      'Sales': permissions['Sales'] == null
          ? {"Edit": false, "View": false, "Create": false, "Delete": false}
          : permissions['Sales'][0],
      'Inventory_Adjustment': {
        'Inventory_Adjustment_Journal':
            permissions['Inventory_Adjustment_Journal'] == null
                ? {
                    "Edit": false,
                    "View": false,
                    "Create": false,
                    "Delete": false
                  }
                : permissions['Inventory_Adjustment_Journal'][0],
        'Bird_Grading': permissions['Bird_Grading'] == null
            ? {"Edit": false, "View": false, "Create": false, "Delete": false}
            : permissions['Bird_Grading'][0],
        'Mortality': permissions['Mortality'] == null
            ? {"Edit": false, "View": false, "Create": false, "Delete": false}
            : permissions['Mortality'][0],
        'Egg_Collection': permissions['Egg_Collection'] == null
            ? {"Edit": false, "View": false, "Create": false, "Delete": false}
            : permissions['Egg_Collection'][0],
        'Egg_Grading': permissions['Egg_Grading'] == null
            ? {"Edit": false, "View": false, "Create": false, "Delete": false}
            : permissions['Egg_Grading'][0],
      },
      'Activity_Log': permissions['Activity_Log'] == null
          ? {"Edit": false, "View": false, "Create": false, "Delete": false}
          : permissions['Activity_Log'][0],
      'Vaccination_Log': permissions['Vaccination_Log'] == null
          ? {"Edit": false, "View": false, "Create": false, "Delete": false}
          : permissions['Vaccination_Log'][0],
      'Medication_Log': permissions['Medication_Log'] == null
          ? {"Edit": false, "View": false, "Create": false, "Delete": false}
          : permissions['Medication_Log'][0],
      'Log_Daily_Batches': permissions['Log_Daily_Batches'] == null
          ? {"Edit": false, "View": false, "Create": false, "Delete": false}
          : permissions['Log_Daily_Batches'][0],
      'Add_Batch': permissions['Add_Batch'] == null
          ? {"Edit": false, "View": false, "Create": false, "Delete": false}
          : permissions['Add_Batch'][0],
    };

    // List test = [
    //   {
    //     "Firms": [
    //       // {
    //       //   "Id": 2,
    //       //   "Edit": "TRUE",
    //       //   "View": "TRUE",
    //       //   "Create": "TRUE",
    //       //   "Delete": "FALSE"
    //       // },
    //       {
    //         "Id": 2,
    //         "Edit": true,
    //         "View": false,
    //         "Create": true,
    //         "Delete": false,
    //       }
    //     ]
    //   }
    // ];

    Map<String, dynamic> temp = {
      "Role_Name": user['Role_Name'],
      // "Role_Permission": test,
      "Role_Permission": [finalPermissions],
      "Description": user['Role_Description'],
    };

    // print(temp);
    Provider.of<Apicalls>(context, listen: false).tryAutoLogin().then((value) {
      var token = Provider.of<Apicalls>(context, listen: false).token;
      Provider.of<AdminApis>(context, listen: false)
          .updateUserRoles(
        temp,
        token,
        widget.userRoles['Role_Id'],
      )
          .then((value) {
        if (value == 202 || value == 201) {
          getData();

          successSnackbar('User Role has been updated successfully');
        }
      });
    });
  }

  void getData() {
    getRoleId().then((value) {
      if (_roleId != null) {
        fetchCredientials().then((token) {
          Provider.of<AdminApis>(context, listen: false)
              .getIndividualUserRoles(token, _roleId);
        });
      }
    });
  }

  Future<void> getRoleId() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('Role_Id')) {
      var extratedData =
          json.decode(prefs.getString('Role_Id')!) as Map<String, dynamic>;
      // print(extratedData);
      _roleId = extratedData['Role_Id'].toString();
    }
  }

  void sort(List selectedPermissionsList, var name) {
    var edit;
    var view;
    var create;
    var delete;
    List ids = [];
    List sortedIds = [];
    List temp = [];
    for (var data in selectedPermissionsList) {
      ids.add(data['Id']);
    }
    sortedIds = ids.toSet().toList();
    for (int i = 0; i < sortedIds.length; i++) {
      for (int j = 0; j < selectedPermissionsList.length; j++) {
        if (selectedPermissionsList[j]['Id'] == sortedIds[i]) {
          if (selectedPermissionsList[j]['Key'] == 'View') {
            view = selectedPermissionsList[j]['Value'];
          } else if (selectedPermissionsList[j]['Key'] == 'Create') {
            create = selectedPermissionsList[j]['Value'];
          } else if (selectedPermissionsList[j]['Key'] == 'Edit') {
            edit = selectedPermissionsList[j]['Value'];
          } else if (selectedPermissionsList[j]['Key'] == 'Delete') {
            delete = selectedPermissionsList[j]['Value'];
          }
        }
      }
      temp.add({
        'Id': sortedIds[i],
        'View': view,
        'Create': create,
        'Edit': edit,
        'Delete': delete
      });
    }

    // print(temp);
    permissions[name] = temp;
  }

  void recordFirmPermissions(Map<String, dynamic> data) {
    if (selectedFirmPermissionList.isEmpty) {
      selectedFirmPermissionList.add(data);
    } else {
      bool repeated = false;
      for (var firm in selectedFirmPermissionList) {
        if (firm['Id'] == data['Id'] && firm['Key'] == data['Key']) {
          selectedFirmPermissionList.remove(firm);
          selectedFirmPermissionList.add(data);
          repeated = true;
          break;
        }
      }

      if (repeated == false) {
        selectedFirmPermissionList.add(data);
      }
    }
    // print('selected firm permission List $selectedFirmPermissionList');
    setState(() {});
  }

  TextStyle headingStyle() {
    return GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.w600);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    // firmList = Provider.of<InfrastructureApis>(context).firmDetails;
    // plantList = Provider.of<InfrastructureApis>(context).plantDetails;

    return loading == true
        ? const Center(
            child: Text('Loading'),
          )
        : Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'Role',
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              color: Theme.of(context).backgroundColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 36),
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 440,
                            padding: const EdgeInsets.only(bottom: 12),
                            child: const Text('Role Name'),
                          ),
                          Container(
                            width: 440,
                            height: 36,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(color: Colors.black26),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    hintText: 'Enter Role',
                                    border: InputBorder.none),
                                controller: roleNameController,
                                onSaved: (value) {
                                  user['Role_Name'] = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  roleNameValidate == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, roleNameValidationMessage),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 440,
                            padding: const EdgeInsets.only(bottom: 12),
                            child: const Text('Role Description'),
                          ),
                          Container(
                            width: 440,
                            height: 150,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(color: Colors.black26),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    hintText: 'Enter Role Description',
                                    border: InputBorder.none),
                                controller: roleDescriptionController,
                                onSaved: (value) {
                                  user['Role_Description'] = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  roleDescriptionValidate == true
                      ? const SizedBox()
                      : ModularWidgets.validationDesign(
                          size, roleDescriptionValidationMessage),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<InfrastructureApis>(
                    builder: (context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Firms',
                            style: headingStyle(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.firmDetails.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CreateFirmPermissionList(
                                selectedPermissionList:
                                    selectedFirmPermissionList,
                                selectedFirmList: selectedFirmList,
                                firmDetails: value.firmDetails,
                                index: index,
                                reFresh: recordFirmPermissions,
                                key: UniqueKey(),
                                storeSelectedFirms: storeSelectedFirms,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<InfrastructureApis>(
                    builder: (context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Plants',
                            style: headingStyle(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.plantLists.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CreatePlantPermissionList(
                                selectedPlantList: selectedPlantList,
                                plantDetails: value.plantLists,
                                index: index,
                                recordPlantPermission: recordPlantPermissions,
                                key: UniqueKey(),
                                storeSelectedPlant: storeSelectedPlants,
                                selectedPermissionList:
                                    selectedPlantPermissionList,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<InfrastructureApis>(
                    builder: (context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WareHouses',
                            style: headingStyle(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.wareHouseLists.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CreateWarehousePermissionList(
                                selectedPermissionList:
                                    selectedWareHousePermissionList,
                                selectedWareHouseList: selectedWareHouseList,
                                wareHouseDetails: value.wareHouseLists,
                                index: index,
                                recordWareHousePermission:
                                    recordWareHousePermissions,
                                key: UniqueKey(),
                                storeSelectedWareHouse: storeSelectedWareHouse,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<InfrastructureApis>(
                    builder: (context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sections',
                            style: headingStyle(),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: value.wareHouseSectionLists.length,
                            itemBuilder: (BuildContext context, int index) {
                              return CreateWarehouseSectionPermissionList(
                                selectedPermissionList:
                                    selectedSectionPermissionList,
                                selectedSectionList: selectedSectionList,
                                sectionDetails: value.wareHouseSectionLists,
                                index: index,
                                recordWareHouseSectionPermission:
                                    recordWareHouseSectionPermissions,
                                key: UniqueKey(),
                                storeSelectedSection: storeSelectedSection,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Users',
                        style: headingStyle(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getUserPermissionRow(
                        'Users',
                        usersView,
                        usersCreate,
                        usersEdit,
                        usersDelete,
                        usersApprove,
                        selectedUsersPermissionList,
                        recordUsersPermissions,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Roles',
                        style: headingStyle(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Roles',
                        roleView,
                        roleCreate,
                        roleEdit,
                        roleDelete,
                        selectedRolePermissionList,
                        recordRolePermissions,
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reference Data',
                        style: headingStyle(),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      getPermissionRow(
                        'Activity Plan',
                        activityPlanView,
                        ActivityPlanCreate,
                        ActivityPlanEdit,
                        ActivityPlanDelete,
                        selectedActivityPlanPermissionList,
                        recordActivityPlanPermissions,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      getPermissionRow(
                        'Vaccination Plan',
                        vaccinationPlanView,
                        vaccinationPlanCreate,
                        vaccinationPlanEdit,
                        vaccinationPlanDelete,
                        selectedVaccinationPlanPermissionList,
                        recordVaccinationPlanPermissions,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      getPermissionRow(
                        'Medication Plan',
                        medicationPlanView,
                        medicationPlanCreate,
                        medicationPlanEdit,
                        medicationPlanDelete,
                        selectedMedicationPlanPermissionList,
                        recordMedicationPlanPermissions,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      getPermissionRow(
                        'Breed',
                        breedView,
                        breedCreate,
                        breedEdit,
                        breedDelete,
                        selectedBreedPermissionList,
                        recordBreedPermissions,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      getPermissionRow(
                        'Breed Version',
                        breedVersionView,
                        breedVersionCreate,
                        breedVersionEdit,
                        breedVersionDelete,
                        selectedBreedVersionPermissionList,
                        recordBreedVersionPermissions,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      getPermissionRow(
                        'Bird Age Grouping',
                        birdAgeView,
                        birdAgeCreate,
                        birdAgeEdit,
                        birdAgeDelete,
                        selectedBirdAgeGroupingPermissionList,
                        recordBirdAgeGroupingPermissions,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Product Management',
                        style: headingStyle(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Product Management',
                        productManagementView,
                        productManagementCreate,
                        productManagementEdit,
                        productManagementDelete,
                        selectedProductManagementPermissionList,
                        recordProductManagamentPermissions,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Batch Planning',
                        style: headingStyle(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Batch Planning',
                        batchPlanningView,
                        batchPlanningCreate,
                        batchPlanningEdit,
                        batchPlanningDelete,
                        selectedBatchPlanningPermissionList,
                        recordBatchPlanningPermissions,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transfers',
                        style: headingStyle(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Transfer In',
                        transferInView,
                        transferInCreate,
                        transferInEdit,
                        transferInDelete,
                        selectedTransferInPermissionList,
                        recordTransferInPermissions,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Transfer Out',
                        transferOutView,
                        transferOutCreate,
                        transferOutEdit,
                        transferOutDelete,
                        selectedTransferOutPermissionList,
                        recordTransferOutPermissions,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sales',
                        style: headingStyle(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Sales',
                        salesView,
                        salesCreate,
                        salesEdit,
                        salesDelete,
                        selectedSalesPermissionList,
                        recordSalesPermissions,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inventory Adjustment',
                        style: headingStyle(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Inventory Adjustment Journal',
                        inventoryAdjustmentJournalView,
                        inventoryAdjustmentJournalCreate,
                        inventoryAdjustmentJournalEdit,
                        inventoryAdjustmentJournalDelete,
                        selectedInventoryAdjustmentJournalPermissionList,
                        recordInventoryAdjustmentJournalPermissions,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Bird Grading',
                        birdGradingView,
                        birdGradingCreate,
                        birdGradingEdit,
                        birdGradingDelete,
                        selectedBirdGradingPermissionList,
                        recordBirdGradingPermissions,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Mortality',
                        mortalityView,
                        mortalityCreate,
                        mortalityEdit,
                        mortalityDelete,
                        selectedMortalityPermissionList,
                        recordMortalityPermissions,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Egg Collection',
                        eggCollectionView,
                        eggCollectionCreate,
                        eggCollectionEdit,
                        eggCollectionDelete,
                        selectedEggCollectionPermissionList,
                        recordEggCollectionPermissions,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Egg Grading',
                        eggGradingView,
                        eggGradingCreate,
                        eggGradingEdit,
                        eggGradingDelete,
                        selectedEggGradingPermissionList,
                        recordEggGradingPermissions,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Logs',
                        style: headingStyle(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Activity Log',
                        activityLogView,
                        activityLogCreate,
                        activityLogEdit,
                        activityLogDelete,
                        selectedActivityLogPermissionList,
                        recordActivityLogPermissions,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'vaccination Log',
                        vaccinationLogView,
                        vaccinationLogCreate,
                        vaccinationLogEdit,
                        vaccinationLogDelete,
                        selectedVaccinationLogPermissionList,
                        recordVaccinationLogPermissions,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                          'Medication Log',
                          medicationLogView,
                          medicationLogCreate,
                          medicationLogEdit,
                          medicationLogDelete,
                          selectedMedicationLogPermissionList,
                          recordMedicationLogPermissions),
                    ],
                  ),

                  const SizedBox(
                    height: 25,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inventory',
                        style: headingStyle(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Log Daily Batches',
                        logDailyView,
                        logDailyCreate,
                        logDailyEdit,
                        logDailyDelete,
                        selectedLogDailyBatchesPermissionList,
                        recordLogDailyBatchesPermissions,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      getPermissionRow(
                        'Add Batch',
                        addBatchView,
                        addBatchCreate,
                        addBatchEdit,
                        addBatchDelete,
                        selectedAddBatchPermissionList,
                        recordAddBatchPermissions,
                      ),
                    ],
                  ),

                  const DisplayException(),

                  // Padding(
                  //   padding: const EdgeInsets.only(top: 24.0),
                  //   child: Align(
                  //     alignment: Alignment.topLeft,
                  //     child: Column(
                  //       mainAxisSize: MainAxisSize.min,
                  //       children: [
                  //         Container(
                  //           width: 440,
                  //           padding: const EdgeInsets.only(bottom: 12),
                  //           child: const Text('Role Permission'),
                  //         ),
                  //         Container(
                  //           width: 440,
                  //           height: 36,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(8),
                  //             color: Colors.white,
                  //             border: Border.all(color: Colors.black26),
                  //           ),
                  //           child: Padding(
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 12, vertical: 6),
                  //             child: TextFormField(
                  //               decoration: const InputDecoration(
                  //                   labelText: 'Enter Role Permission',
                  //                   border: InputBorder.none),
                  //               //initialValue: initValues['Plant_Pincode'],
                  //               validator: (value) {},
                  //               onSaved: (value) {
                  //                 user['Role_Permission'] = value!;
                  //               },
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  extratedData['Edit'] == true
                      ? Align(
                          alignment: Alignment.topLeft,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 30),
                                child: SizedBox(
                                  width: 200,
                                  height: 48,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                          const Color.fromRGBO(44, 96, 154, 1),
                                        ),
                                      ),
                                      onPressed: save,
                                      child: Text(
                                        'Save Roles',
                                        style: GoogleFonts.roboto(
                                          textStyle: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18,
                                            color: Color.fromRGBO(
                                                255, 254, 254, 1),
                                          ),
                                        ),
                                      )),
                                ),
                              ),
                              const SizedBox(
                                width: 42,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  width: 200,
                                  height: 48,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color:
                                          const Color.fromRGBO(44, 96, 154, 1),
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: ProjectStyles.cancelStyle(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
  }

  StatefulBuilder getPermissionRow(
      var heading,
      bool view,
      bool create,
      bool edit,
      bool delete,
      List selectedPermissionList,
      ValueChanged<Map<String, dynamic>> recordPermission) {
    if (selectedPermissionList.isNotEmpty) {
      for (var data in selectedPermissionList) {
        if (data['Key'] == 'View') {
          view = data['Value'];
        } else if (data['Key'] == 'Create') {
          create = data['Value'];
        } else if (data['Key'] == 'Edit') {
          edit = data['Value'];
        } else if (data['Key'] == 'Delete') {
          delete = data['Value'];
        }
      }
    }
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Row(
          children: [
            Container(width: 150, child: Text(heading)),
            const SizedBox(
              width: 20,
            ),
            Row(
              children: [
                Checkbox(
                    activeColor: ProjectColors.themecolor,
                    value: view,
                    onChanged: (value) {
                      setState(() {
                        view = value!;
                        recordPermission({
                          'Id': heading,
                          'Key': 'View',
                          'Value': value,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Create',
                          'Value': false,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Edit',
                          'Value': false,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Delete',
                          'Value': false,
                        });
                      });
                    }),
                const Text('View'),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Checkbox(
                    activeColor: ProjectColors.themecolor,
                    value: create,
                    onChanged: (value) {
                      setState(() {
                        create = value!;
                        recordPermission({
                          'Id': heading,
                          'Key': 'Create',
                          'Value': value,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Edit',
                          'Value': false,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'View',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Delete',
                          'Value': false,
                        });
                      });
                    }),
                const Text('Create'),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Checkbox(
                    activeColor: ProjectColors.themecolor,
                    value: edit,
                    onChanged: (value) {
                      setState(() {
                        edit = value!;
                        recordPermission({
                          'Id': heading,
                          'Key': 'Edit',
                          'Value': value,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Create',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'View',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Delete',
                          'Value': false,
                        });
                      });
                    }),
                const Text('Edit'),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Checkbox(
                    activeColor: ProjectColors.themecolor,
                    value: delete,
                    onChanged: (value) {
                      setState(() {
                        delete = value!;
                        recordPermission({
                          'Id': heading,
                          'Key': 'Delete',
                          'Value': value,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Create',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'View',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Edit',
                          'Value': true,
                        });
                      });
                    }),
                const Text('Delete'),
              ],
            ),
          ],
        );
      },
    );
  }

  StatefulBuilder getUserPermissionRow(
      var heading,
      bool view,
      bool create,
      bool edit,
      bool delete,
      bool approve,
      List selectedPermissionList,
      ValueChanged<Map<String, dynamic>> recordPermission) {
    if (selectedPermissionList.isNotEmpty) {
      for (var data in selectedPermissionList) {
        if (data['Key'] == 'View') {
          view = data['Value'];
        } else if (data['Key'] == 'Create') {
          create = data['Value'];
        } else if (data['Key'] == 'Edit') {
          edit = data['Value'];
        } else if (data['Key'] == 'Delete') {
          delete = data['Value'];
        } else if (data['Key'] == 'Approve') {
          approve = data['Value'];
        }
      }
    }
    return StatefulBuilder(
      builder: (BuildContext context, setState) {
        return Row(
          children: [
            Container(width: 150, child: Text(heading)),
            const SizedBox(
              width: 20,
            ),
            Row(
              children: [
                Checkbox(
                    activeColor: ProjectColors.themecolor,
                    value: view,
                    onChanged: (value) {
                      setState(() {
                        view = value!;
                        recordPermission({
                          'Id': heading,
                          'Key': 'View',
                          'Value': value,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Create',
                          'Value': false,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Edit',
                          'Value': false,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Delete',
                          'Value': false,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Approve',
                          'Value': false,
                        });
                      });
                    }),
                Text('View'),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Checkbox(
                    activeColor: ProjectColors.themecolor,
                    value: create,
                    onChanged: (value) {
                      setState(() {
                        create = value!;
                        recordPermission({
                          'Id': heading,
                          'Key': 'Create',
                          'Value': value,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Edit',
                          'Value': false,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'View',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Delete',
                          'Value': false,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Approve',
                          'Value': false,
                        });
                      });
                    }),
                Text('Create'),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Checkbox(
                    activeColor: ProjectColors.themecolor,
                    value: edit,
                    onChanged: (value) {
                      setState(() {
                        edit = value!;
                        recordPermission({
                          'Id': heading,
                          'Key': 'Edit',
                          'Value': value,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Create',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'View',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Delete',
                          'Value': false,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Approve',
                          'Value': false,
                        });
                      });
                    }),
                Text('Edit'),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Checkbox(
                    activeColor: ProjectColors.themecolor,
                    value: delete,
                    onChanged: (value) {
                      setState(() {
                        delete = value!;
                        recordPermission({
                          'Id': heading,
                          'Key': 'Delete',
                          'Value': value,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Create',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'View',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Edit',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Approve',
                          'Value': false,
                        });
                      });
                    }),
                Text('Delete'),
              ],
            ),
            const SizedBox(
              width: 15,
            ),
            Row(
              children: [
                Checkbox(
                    activeColor: ProjectColors.themecolor,
                    value: approve,
                    onChanged: (value) {
                      setState(() {
                        delete = value!;
                        recordPermission({
                          'Id': heading,
                          'Key': 'Delete',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Create',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'View',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Edit',
                          'Value': true,
                        });
                        recordPermission({
                          'Id': heading,
                          'Key': 'Approve',
                          'Value': value,
                        });
                      });
                    }),
                const Text('Approve'),
              ],
            ),
          ],
        );
      },
    );
  }
}

class CreateFirmPermissionList extends StatefulWidget {
  const CreateFirmPermissionList({
    Key? key,
    required this.firmDetails,
    required this.reFresh,
    required this.index,
    required this.storeSelectedFirms,
    required this.selectedFirmList,
    required this.selectedPermissionList,
  }) : super(key: key);

  final List firmDetails;
  final ValueChanged<Map<String, dynamic>> reFresh;
  final int index;
  final ValueChanged<int> storeSelectedFirms;
  final List selectedFirmList;
  final List selectedPermissionList;

  @override
  State<CreateFirmPermissionList> createState() =>
      _CreateFirmPermissionListState();
}

class _CreateFirmPermissionListState extends State<CreateFirmPermissionList> {
  bool view = false;
  bool create = false;
  bool edit = false;
  bool delete = false;
  bool firmSelected = false;

  @override
  void initState() {
    if (widget.selectedPermissionList.isNotEmpty) {
      for (var data in widget.selectedPermissionList) {
        if (data['Id'] == widget.firmDetails[widget.index]['Firm_Id']) {
          if (data['Key'] == 'View') {
            view = data['Value'];
          } else if (data['Key'] == 'Create') {
            create = data['Value'];
          } else if (data['Key'] == 'Edit') {
            edit = data['Value'];
          } else if (data['Key'] == 'Delete') {
            delete = data['Value'];
          }
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Row(
              children: [
                Checkbox(
                    activeColor: ProjectColors.themecolor,
                    value: widget.selectedFirmList.contains(
                            widget.firmDetails[widget.index]['Firm_Id'])
                        ? true
                        : firmSelected,
                    onChanged: (value) {
                      widget.storeSelectedFirms(
                          widget.firmDetails[widget.index]['Firm_Id']);
                      setState(() {
                        firmSelected = value!;
                      });
                    }),
                Text(widget.firmDetails[widget.index]['Firm_Name']),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Row(
            children: [
              Checkbox(
                  activeColor: ProjectColors.themecolor,
                  value: view,
                  onChanged: (value) {
                    setState(() {
                      view = value!;
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'View',
                        'Value': value,
                      });
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'Create',
                        'Value': false,
                      });
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'Edit',
                        'Value': false,
                      });
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'Delete',
                        'Value': false,
                      });
                    });
                  }),
              const Text('View'),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Row(
            children: [
              Checkbox(
                  activeColor: ProjectColors.themecolor,
                  value: create,
                  onChanged: (value) {
                    setState(() {
                      create = value!;
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'Create',
                        'Value': value,
                      });
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'Edit',
                        'Value': false,
                      });
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'View',
                        'Value': true,
                      });
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'Delete',
                        'Value': false,
                      });
                    });
                  }),
              const Text('Create'),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Row(
            children: [
              Checkbox(
                  activeColor: ProjectColors.themecolor,
                  value: edit,
                  onChanged: (value) {
                    setState(() {
                      edit = value!;
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'Edit',
                        'Value': value,
                      });
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'Create',
                        'Value': true,
                      });
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'View',
                        'Value': true,
                      });
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'Delete',
                        'Value': false,
                      });
                    });
                  }),
              const Text('Edit'),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Row(
            children: [
              Checkbox(
                  activeColor: ProjectColors.themecolor,
                  value: delete,
                  onChanged: (value) {
                    setState(() {
                      delete = value!;
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'Delete',
                        'Value': value,
                      });
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'Create',
                        'Value': true,
                      });
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'View',
                        'Value': true,
                      });
                      widget.reFresh({
                        'Id': widget.firmDetails[widget.index]['Firm_Id'],
                        'Key': 'Edit',
                        'Value': true,
                      });
                    });
                  }),
              const Text('Delete'),
            ],
          ),
        ],
      ),
    );
  }
}

class CreatePlantPermissionList extends StatefulWidget {
  CreatePlantPermissionList({
    Key? key,
    required this.selectedPlantList,
    required this.plantDetails,
    required this.index,
    required this.recordPlantPermission,
    required this.storeSelectedPlant,
    required this.selectedPermissionList,
  }) : super(key: key);

  final List selectedPlantList;
  final List plantDetails;
  final int index;
  final ValueChanged<Map<String, dynamic>> recordPlantPermission;
  final ValueChanged<int> storeSelectedPlant;
  final List selectedPermissionList;

  @override
  State<CreatePlantPermissionList> createState() =>
      _CreatePlantPermissionListState();
}

class _CreatePlantPermissionListState extends State<CreatePlantPermissionList> {
  bool view = false;
  bool create = false;
  bool edit = false;
  bool delete = false;
  bool plantSelected = false;

  @override
  void initState() {
    if (widget.selectedPermissionList.isNotEmpty) {
      for (var data in widget.selectedPermissionList) {
        if (data['Id'] == widget.plantDetails[widget.index]['Plant_Id']) {
          if (data['Key'] == 'View') {
            view = data['Value'];
          } else if (data['Key'] == 'Create') {
            create = data['Value'];
          } else if (data['Key'] == 'Edit') {
            edit = data['Value'];
          } else if (data['Key'] == 'Delete') {
            delete = data['Value'];
          }
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          child: Row(
            children: [
              Checkbox(
                  activeColor: ProjectColors.themecolor,
                  value: widget.selectedPlantList.contains(
                          widget.plantDetails[widget.index]['Plant_Id'])
                      ? true
                      : plantSelected,
                  onChanged: (value) {
                    widget.storeSelectedPlant(
                        widget.plantDetails[widget.index]['Plant_Id']);
                    setState(() {
                      plantSelected = value!;
                    });
                  }),
              Text(widget.plantDetails[widget.index]['Plant_Name']),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Row(
          children: [
            Checkbox(
                activeColor: ProjectColors.themecolor,
                value: view,
                onChanged: (value) {
                  setState(() {
                    view = value!;
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'View',
                      'Value': value,
                    });
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'Create',
                      'Value': false,
                    });
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'Edit',
                      'Value': false,
                    });
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'Delete',
                      'Value': false,
                    });
                  });
                }),
            const Text('View'),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Row(
          children: [
            Checkbox(
                activeColor: ProjectColors.themecolor,
                value: create,
                onChanged: (value) {
                  setState(() {
                    create = value!;
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'Create',
                      'Value': value,
                    });
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'Edit',
                      'Value': false,
                    });
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'View',
                      'Value': true,
                    });
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'Delete',
                      'Value': false,
                    });
                  });
                }),
            const Text('Create'),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Row(
          children: [
            Checkbox(
                activeColor: ProjectColors.themecolor,
                value: edit,
                onChanged: (value) {
                  setState(() {
                    edit = value!;
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'Edit',
                      'Value': value,
                    });
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'Create',
                      'Value': true,
                    });
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'View',
                      'Value': true,
                    });
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'Delete',
                      'Value': false,
                    });
                  });
                }),
            const Text('Edit'),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Row(
          children: [
            Checkbox(
                activeColor: ProjectColors.themecolor,
                value: delete,
                onChanged: (value) {
                  setState(() {
                    delete = value!;
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'Delete',
                      'Value': value,
                    });
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'Create',
                      'Value': true,
                    });
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'View',
                      'Value': true,
                    });
                    widget.recordPlantPermission({
                      'Id': widget.plantDetails[widget.index]['Plant_Id'],
                      'Key': 'Edit',
                      'Value': true,
                    });
                  });
                }),
            const Text('Delete'),
          ],
        ),
      ],
    );
  }
}

class CreateWarehousePermissionList extends StatefulWidget {
  CreateWarehousePermissionList(
      {Key? key,
      required this.selectedWareHouseList,
      required this.wareHouseDetails,
      required this.index,
      required this.recordWareHousePermission,
      required this.storeSelectedWareHouse,
      required this.selectedPermissionList})
      : super(key: key);
  final List selectedWareHouseList;
  final List wareHouseDetails;
  final int index;
  final ValueChanged<Map<String, dynamic>> recordWareHousePermission;
  final ValueChanged<int> storeSelectedWareHouse;
  final List selectedPermissionList;

  @override
  State<CreateWarehousePermissionList> createState() =>
      _CreateWarehousePermissionListState();
}

class _CreateWarehousePermissionListState
    extends State<CreateWarehousePermissionList> {
  bool view = false;
  bool create = false;
  bool edit = false;
  bool delete = false;
  bool wareHouseSelected = false;

  @override
  void initState() {
    if (widget.selectedPermissionList.isNotEmpty) {
      for (var data in widget.selectedPermissionList) {
        if (data['Id'] ==
            widget.wareHouseDetails[widget.index]['WareHouse_Id']) {
          if (data['Key'] == 'View') {
            view = data['Value'];
          } else if (data['Key'] == 'Create') {
            create = data['Value'];
          } else if (data['Key'] == 'Edit') {
            edit = data['Value'];
          } else if (data['Key'] == 'Delete') {
            delete = data['Value'];
          }
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 200,
          child: Row(
            children: [
              Checkbox(
                  activeColor: ProjectColors.themecolor,
                  value: widget.selectedWareHouseList.contains(
                          widget.wareHouseDetails[widget.index]['WareHouse_Id'])
                      ? true
                      : wareHouseSelected,
                  onChanged: (value) {
                    widget.storeSelectedWareHouse(
                        widget.wareHouseDetails[widget.index]['WareHouse_Id']);
                    setState(() {
                      wareHouseSelected = value!;
                    });
                  }),
              Text(widget.wareHouseDetails[widget.index]['WareHouse_Name']),
            ],
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Row(
          children: [
            Checkbox(
                activeColor: ProjectColors.themecolor,
                value: view,
                onChanged: (value) {
                  setState(() {
                    view = value!;
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'View',
                      'Value': value,
                    });
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'Create',
                      'Value': false,
                    });
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'Edit',
                      'Value': false,
                    });
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'Delete',
                      'Value': false,
                    });
                  });
                }),
            const Text('View'),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Row(
          children: [
            Checkbox(
                activeColor: ProjectColors.themecolor,
                value: create,
                onChanged: (value) {
                  setState(() {
                    create = value!;
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'Create',
                      'Value': value,
                    });
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'Edit',
                      'Value': false,
                    });
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'View',
                      'Value': true,
                    });
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'Delete',
                      'Value': false,
                    });
                  });
                }),
            const Text('Create'),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Row(
          children: [
            Checkbox(
                activeColor: ProjectColors.themecolor,
                value: edit,
                onChanged: (value) {
                  setState(() {
                    edit = value!;
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'Edit',
                      'Value': value,
                    });
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'Create',
                      'Value': true,
                    });
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'View',
                      'Value': true,
                    });
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'Delete',
                      'Value': false,
                    });
                  });
                }),
            const Text('Edit'),
          ],
        ),
        const SizedBox(
          width: 15,
        ),
        Row(
          children: [
            Checkbox(
                activeColor: ProjectColors.themecolor,
                value: delete,
                onChanged: (value) {
                  setState(() {
                    delete = value!;
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'Delete',
                      'Value': value,
                    });
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'Create',
                      'Value': true,
                    });
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'View',
                      'Value': true,
                    });
                    widget.recordWareHousePermission({
                      'Id': widget.wareHouseDetails[widget.index]
                          ['WareHouse_Id'],
                      'Key': 'Edit',
                      'Value': true,
                    });
                  });
                }),
            const Text('Delete'),
          ],
        ),
      ],
    );
  }
}

class CreateWarehouseSectionPermissionList extends StatefulWidget {
  CreateWarehouseSectionPermissionList(
      {Key? key,
      required this.selectedSectionList,
      required this.sectionDetails,
      required this.index,
      required this.recordWareHouseSectionPermission,
      required this.storeSelectedSection,
      required this.selectedPermissionList})
      : super(key: key);
  final List selectedSectionList;
  final List sectionDetails;
  final int index;
  final ValueChanged<Map<String, dynamic>> recordWareHouseSectionPermission;
  final ValueChanged<int> storeSelectedSection;
  final List selectedPermissionList;

  @override
  State<CreateWarehouseSectionPermissionList> createState() =>
      _CreateWarehouseSectionPermissionListState();
}

class _CreateWarehouseSectionPermissionListState
    extends State<CreateWarehouseSectionPermissionList> {
  bool view = false;
  bool create = false;
  bool edit = false;
  bool delete = false;
  bool firmSelected = false;

  @override
  void initState() {
    if (widget.selectedPermissionList.isNotEmpty) {
      for (var data in widget.selectedPermissionList) {
        if (data['Id'] ==
            widget.sectionDetails[widget.index]['WareHouse_Section_Id']) {
          if (data['Key'] == 'View') {
            view = data['Value'];
          } else if (data['Key'] == 'Create') {
            create = data['Value'];
          } else if (data['Key'] == 'Edit') {
            edit = data['Value'];
          } else if (data['Key'] == 'Delete') {
            delete = data['Value'];
          }
        }
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Row(
              children: [
                // Checkbox(
                //     activeColor: ProjectColors.themecolor,
                //     value: widget.selectedSectionList.contains(
                //             widget.sectionDetails[widget.index]
                //                 ['WareHouse_Section_Id'])
                //         ? true
                //         : firmSelected,
                //     onChanged: (value) {
                //       widget.storeSelectedSection(
                //           widget.sectionDetails[widget.index]
                //               ['WareHouse_Section_Id']);
                //       setState(() {
                //         firmSelected = value!;
                //       });
                //     }),
                Text(widget.sectionDetails[widget.index]
                    ['WareHouse_Section_Code']),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Row(
            children: [
              Checkbox(
                  activeColor: ProjectColors.themecolor,
                  value: view,
                  onChanged: (value) {
                    setState(() {
                      view = value!;
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'View',
                        'Value': value,
                      });
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'Create',
                        'Value': false,
                      });
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'Edit',
                        'Value': false,
                      });
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'Delete',
                        'Value': false,
                      });
                    });
                  }),
              const Text('View'),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Row(
            children: [
              Checkbox(
                  activeColor: ProjectColors.themecolor,
                  value: create,
                  onChanged: (value) {
                    setState(() {
                      create = value!;
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'Create',
                        'Value': value,
                      });
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'Edit',
                        'Value': false,
                      });
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'View',
                        'Value': true,
                      });
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'Delete',
                        'Value': false,
                      });
                    });
                  }),
              const Text('Create'),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Row(
            children: [
              Checkbox(
                  activeColor: ProjectColors.themecolor,
                  value: edit,
                  onChanged: (value) {
                    setState(() {
                      edit = value!;
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'Edit',
                        'Value': value,
                      });
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'Create',
                        'Value': true,
                      });
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'View',
                        'Value': true,
                      });
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'Delete',
                        'Value': false,
                      });
                    });
                  }),
              const Text('Edit'),
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Row(
            children: [
              Checkbox(
                  activeColor: ProjectColors.themecolor,
                  value: delete,
                  onChanged: (value) {
                    setState(() {
                      delete = value!;
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'Delete',
                        'Value': value,
                      });
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'Create',
                        'Value': true,
                      });
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'View',
                        'Value': true,
                      });
                      widget.recordWareHouseSectionPermission({
                        'Id': widget.sectionDetails[widget.index]
                            ['WareHouse_Section_Id'],
                        'Key': 'Edit',
                        'Value': true,
                      });
                    });
                  }),
              const Text('Delete'),
            ],
          ),
        ],
      ),
    );
  }
}
