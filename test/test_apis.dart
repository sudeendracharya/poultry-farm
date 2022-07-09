import 'package:flutter_test/flutter_test.dart';

import 'package:poultry_login_signup/providers/apicalls.dart';
import 'package:poultry_login_signup/infrastructure/providers/infrastructure_apicalls.dart';

void main() {
  var token;
  group('Authentication and SignUp Tests', () {
    Apicalls api = Apicalls();
    test('Log In', () async {
      Apicalls api = Apicalls();

      var result = await api.authenticateTest('test', 'test@2021');
      expect(result, 200);
    });
    test('Sign Up Failed Because UserName and Password Is already exist',
        () async {
      var result = await api.signUpTest({
        'username': 'ramya',
        'email': 'ramya@r.com',
        'password1': 'Rahul@2021',
        'password2': 'Rahul@2021',
      });
      expect(result, 400);
    });
  });

  group('Getting Token', () {});

  group('Testing Get Methods', () {
    group('Testing Infrastructure Get Methods', () {
      Apicalls mainApi = Apicalls();

      InfrastructureApis api = InfrastructureApis();
      test('Get Firm Details', () async {
        await mainApi.tryAutoLogin().then((value) {
          print(value);
          token = mainApi.token;
        });
        var result = await api.getFirmDetails(token);
        expect(result, 200);
      });
      // test('Get Plant Details', () async {
      //   var result = await api.getPlantDetails(key);
      //   expect(result, 200);
      // });
      test('Get Warehouse section Details', () async {
        var result = await api.getWareHouseSectionDetails(01, token);
        expect(result, 200);
      });
      test('Get ware house section Line Details', () async {
        var result = await api.getWareHouseSectionLineDetails(token);
        expect(result, 200);
      });
      test('Get ware house category', () async {
        var result = await api.getWarehouseCategory(token);
        expect(result, 200);
      });
      // test('Get wareHouse Details', () async {
      //   var result = await api.getWarehouseDetails(token);
      //   expect(result, 200);
      // });
      //   test('Get Firm Details', () async {
      //   var result = await api.getWarehouseSubCategoryForDisplay(key);
      //   expect(result, 200);
      // });
    });
    // group('Testing Activity Plan Get methods', () {
    //   ActivityApis api = ActivityApis();
    //   test('Get Activity Header', () async {
    //     var result = await api.getActivityHeader(key);
    //     expect(result, 200);
    //   });
    //   test('Get Activity Plan', () async {
    //     var result = await api.getActivityPlan(key);
    //     expect(result, 200);
    //   });
    //   test('Get Medication Header', () async {
    //     var result = await api.getMedicationHeader(key);
    //     expect(result, 200);
    //   });
    //   test('Get Medication Plan', () async {
    //     var result = await api.getMedicationPlan(key);
    //     expect(result, 200);
    //   });
    //   test('Get Vaccination Header', () async {
    //     var result = await api.getVaccinationHeader(key);
    //     expect(result, 200);
    //   });
    //   test('Get Vaccination Plan', () async {
    //     var result = await api.getVaccinationPlan(key);
    //     expect(result, 200);
    //   });
    // });

    // group('Testing Batch Plan', () {
    //   BatchApis api = BatchApis();
    //   test('Get Batch Plan', () async {
    //     var result = await api.getBatchPlan(key);
    //     expect(result, 200);
    //   });
    //   test('Get Batch Plan Mapping', () async {
    //     var result = await api.getBatchPlanMapping(key);
    //     expect(result, 200);
    //   });
    // });
    // group('Testing Breed Info Apis', () {
    //   BreedInfoApis api = BreedInfoApis();
    //   test('Get Bird Age Group', () async {
    //     var result = await api.getBirdAgeGroup(key);
    //     expect(result, 200);
    //   });
    //   test('Get Bird Reference Data', () async {
    //     var result = await api.getBirdReferenceData(key);
    //     expect(result, 200);
    //   });
    //   test('Get Breed Info', () async {
    //     var result = await api.getBreedInfo(key);
    //     expect(result, 200);
    //   });
    //   test('Get Breed Version Info', () async {
    //     var result = await api.getBreedversionInfo(key);
    //     expect(result, 200);
    //   });
    // });
    // group('Testing Customer/Sales Record Apis', () {
    //   CustomerSalesApis api = CustomerSalesApis();
    //   test('Get Breed Version Info', () async {
    //     var result = await api.getCustomerInfo(key);
    //     expect(result, 200);
    //   });
    // });
    // group('Testing Egg Collection Apis', () {
    //   EggCollectionApis api = EggCollectionApis();
    //   test('Get Bird Mortality', () async {
    //     var result = await api.getBirdMortality(key);
    //     expect(result, 200);
    //   });
    //   test('Get Egg Collection', () async {
    //     var result = await api.getEggCollection(key);
    //     expect(result, 200);
    //   });
    // });
    // group('Testing Item Apis', () {
    //   ItemApis api = ItemApis();
    //   test('Get Inventory Adjustment', () async {
    //     var result = await api.getInventoryAdjustment(key);
    //     expect(result, 200);
    //   });
    //   test('Get get Inventory Items', () async {
    //     var result = await api.getInventoryItems(key);
    //     expect(result, 200);
    //   });
    //   test('Get Item Category', () async {
    //     var result = await api.getItemCategory(key);
    //     expect(result, 200);
    //   });
    //   test('Get Item Details', () async {
    //     var result = await api.getItemDetails(key);
    //     expect(result, 200);
    //   });
    //   test('Get Item Mapping', () async {
    //     var result = await api.getItemMapping(key);
    //     expect(result, 200);
    //   });
    //   test('Get Item sub Category', () async {
    //     var result = await api.getItemSubCategory(key);
    //     expect(result, 200);
    //   });
    // });
    // group('Testing Journal Apis', () {
    //   JournalApi api = JournalApi();
    //   test('Get Journal Info', () async {
    //     var result = await api.getJournalInfo(key);
    //     expect(result, 200);
    //   });
    // });
  });
}
