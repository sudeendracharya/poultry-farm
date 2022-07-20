import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ActivityValidation {
  static bool validate(
    TextEditingController activityCodeController,
    String activityCodeValidationMessage,
    bool activityCodeValidation,
    TextEditingController recommendedByController,
    String recommendedByValidationMessage,
    bool recommendedByValidation,
    var breedVersionId,
    String breedVersionValidationMessage,
    bool breedVersionValidation,
    List sendData,
    TextEditingController ageController,
    String ageValidationMessage,
    bool ageValidation,
    TextEditingController activityNameController,
    String activityNameValidationMessage,
    bool activityNameValidation,
    TextEditingController notificationPriorController,
    String notificationPriorValidationMessage,
    bool notificationPriorValidation,
  ) {
    if (activityCodeController.text == '') {
      activityCodeValidationMessage = 'Activity Code cannot be empty';
      activityCodeValidation = false;
    } else if (activityCodeController.text.length > 6) {
      activityCodeValidationMessage = 'Activity Code cannot be greater then 6';
      activityCodeValidation = false;
    } else {
      activityCodeValidation = true;
    }

    if (recommendedByController.text == '') {
      recommendedByValidationMessage = 'Recommended by cannot be empty';
      recommendedByValidation = false;
    } else {
      recommendedByValidation = true;
    }

    if (breedVersionId == null) {
      breedVersionValidationMessage = 'Breed Version cannot be empty';
      breedVersionValidation = false;
    } else {
      breedVersionValidation = true;
    }

    if (sendData.isEmpty) {
      if (ageController.text.isNum != true) {
        ageValidationMessage = 'Ente a valid Age';
        ageValidation = false;
      } else if (ageController.text.length > 6) {
        ageValidationMessage = 'Age cannot be greater then 6 characters';
        ageValidation = false;
      } else if (ageController.text == '') {
        ageValidationMessage = 'Age cannot be empty';
        ageValidation = false;
      } else {
        ageValidation = true;
      }

      if (activityNameController.text.length > 16) {
        activityNameValidationMessage =
            'Activity name cannot be greater then 16 characters';
        activityNameValidation = false;
      } else if (activityNameController.text == '') {
        activityNameValidationMessage = 'Activity name cannot be empty';
        activityNameValidation = false;
      } else {
        activityNameValidation = true;
      }

      if (notificationPriorController.text.isNum != true) {
        notificationPriorValidationMessage =
            'Enter a valid Notification prior to days';
        notificationPriorValidation = false;
      } else if (notificationPriorController.text.length > 2) {
        notificationPriorValidationMessage =
            'Notification prior to days cannot be greater then 2 characters';
        notificationPriorValidation = false;
      } else if (notificationPriorController.text == '') {
        notificationPriorValidationMessage =
            'Notification prior to days cannot be empty';
        notificationPriorValidation = false;
      } else {
        notificationPriorValidation = true;
      }

      if (activityCodeValidation == true &&
          recommendedByValidation == true &&
          breedVersionValidation == true &&
          ageValidation == true &&
          activityNameValidation == true &&
          notificationPriorValidation == true) {
        return true;
      } else {
        return false;
      }
    } else {
      if (activityCodeValidation == true &&
          recommendedByValidation == true &&
          breedVersionValidation == true) {
        return true;
      } else {
        return false;
      }
    }
  }
}
