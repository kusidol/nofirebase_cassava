import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/entities/planting.dart';

class InputCodeValidator {
  static String? validate(String? value, String input) {
    if (input != "") {
      RegExp regex = new RegExp(r'^[0-9]*$');
      if (!regex.hasMatch(input) || input.length >= 11) {
        if (!regex.hasMatch(input)) {
          return 'enter-only-number'.i18n();
        } else
          return 'enter-only-11-number'.i18n();
      } else
        return null;
    }
    return value == null || value.isEmpty ? 'enter-only-code'.i18n() : null;
  }

  static String? validateFieldName(String? value, String input) {
    if (input != "") {
      RegExp regex = new RegExp(r"^[\p{L} ,.'-]*$");
      if (!regex.hasMatch(input) && input.length >= 50) {
        return 'enter-number-char-50'.i18n();
      } else
        return null;
    }
    return value == null || value.isEmpty ? 'please-insert-info'.i18n() : null;
  }

  static String? validateMultiSelect(List<String>? value) {
    if (value!.length == 0) {
      return 'please-insert-info'.i18n();
    } else {
      return null;
    }
  }

  static String? validateFieldSize(String? value, String input) {
    print("input" + input);
    if (input != "") {
      RegExp regex = new RegExp(r"[0-9]+[.[0-9]+]?");
      if (!regex.hasMatch(input.toString())) {
        return 'enter-only-number'.i18n();
      } else
        return null;
    }
    return value == null || value.isEmpty ? 'enter-only-number'.i18n() : null;
  }

  static String? validatePlantVariety(String? value, String input) {
    if (input != "") {
      RegExp regex = new RegExp(r"^[\p{L} ,.'-]*$");
      if (!regex.hasMatch(input) && input.length >= 30) {
        return 'enter-number-char-30'.i18n();
      } else
        return null;
    }
    return value == null || value.isEmpty ? 'please-insert-info'.i18n() : null;
  }

  static String? validatePlantSecondaryType(String? value, String input) {
    if (input != "") {
      RegExp regex = new RegExp(r"^[\p{L} ,.'-]*$");
      if (!regex.hasMatch(input) && input.length >= 20) {
        return 'enter-number-char-20'.i18n();
      } else
        return null;
    }
    return value == null || value.isEmpty ? 'please-insert-info'.i18n() : null;
  }

  static String? validateFertilizerFormular(String? value, String input) {
    if (input != "") {
      RegExp regex = new RegExp(r"^[\p{L} ,.'-]*$");
      if (!regex.hasMatch(input) && input.length >= 20) {
        return 'enter-number-char-20'.i18n();
      } else
        return null;
    }
    return value == null || value.isEmpty ? 'please-insert-info'.i18n() : null;
  }

  static String? validateDropDown(String? value, String input) {
    if (value == input) {
      return 'please-insert-info'.i18n() + " ${input}";
    }
    return value == input || value!.isEmpty
        ? 'please-insert-info'.i18n()
        : null;
  }

  static String? validateRadioItem(String? value, String input) {
    if (value == null) {
      return 'please-insert-info'.i18n();
    }
    return value == null || value.isEmpty ? 'please-insert-info'.i18n() : null;
  }

  static String? validateNotSpecialCharacter(String? value, String input) {
    if (input != "") {
      RegExp regex = new RegExp(r'^([a-zA-Z0-9ก-๙ ]{1,25})([\S])$');
      if (!regex.hasMatch(input)) {
        return 'validate-not-special-character'.i18n();
      } else
        return null;
    }
    return value == null || value.isEmpty
        ? "please-insert-number-char".i18n()
        : null;
  }

  static String? validateNumber(String? value, String input) {
    RegExp regex = new RegExp(r'(^[0-9]*)([.]{0,1})([0-9]*$)');
    if (input == "0.0") {
      if (value != "") {
        if (value != null) {
          if (!regex.hasMatch(value)) {
            double valueDouble = double.parse(value);
            if (valueDouble < 0) {
              return 'non-negative-data'.i18n();
            } else {
              return 'please-insert-numerical'.i18n();
            }
          } else {
            double valueDouble = double.parse(input);
            if (valueDouble > 1000000) {
              return 'non-exceed-a-million'.i18n();
            }
            return null;
          }
        } else {
          return 'please-insert-numerical'.i18n();
        }
      } else {
        return 'please-insert-numerical'.i18n();
      }
    } else if (value == input) {
      if (value != null) {
        if (!regex.hasMatch(value)) {
          double valueDouble = double.parse(value);
          if (valueDouble < 0) {
            return 'non-negative-data'.i18n();
          } else {
            return 'please-insert-numerical'.i18n();
          }
        } else {
          double valueDouble = double.parse(input);
          if (valueDouble > 1000000) {
            return 'non-exceed-a-million'.i18n();
          }
          return null;
        }
      } else {
        return 'please-insert-numerical'.i18n();
      }
    } else if (value != input) {
      if (value != null) {
        if (!regex.hasMatch(value)) {
          double valueDouble = double.parse(value);
          if (valueDouble < 0) {
            return 'non-negative-data'.i18n();
          } else {
            return 'please-insert-numerical'.i18n();
          }
        } else {
          double valueDouble = double.parse(input);
          if (valueDouble > 1000000) {
            return 'non-exceed-a-million'.i18n();
          }
          return null;
        }
      } else {
        return 'please-insert-numerical'.i18n();
      }
    } else {
      return 'please-insert-numerical'.i18n();
    }
  }

  static String? validateBoxNumber(String? value, String input) {
    RegExp regex = new RegExp(r'(^[0-9]*)([.]{0,1})([0-9]*$)');
    if (input == "0.0") {
      if (value != "") {
        if (value != null) {
          if (!regex.hasMatch(value)) {
            double valueDouble = double.parse(value);
            if (valueDouble < -100) {
              return 'cannot-be-negative-more-than-100'.i18n();
            } else {
              return null;
            }
          } else {
            double valueDouble = double.parse(input);
            if (valueDouble > 100) {
              return 'non-exceed-a-hundred'.i18n();
            }
            return null;
          }
        } else {
          return 'please-insert-numerical'.i18n();
        }
      } else {
        return 'please-insert-numerical'.i18n();
      }
    } else if (value == input) {
      if (value != null) {
        if (!regex.hasMatch(value)) {
          double valueDouble = double.parse(value);
          if (valueDouble < -100) {
            return 'cannot-be-negative-more-than-100'.i18n();
          } else {
            return null;
          }
        } else {
          double valueDouble = double.parse(input);
          if (valueDouble > 100) {
            return 'non-exceed-a-hundred'.i18n();
          }
          return null;
        }
      } else {
        return 'please-insert-numerical'.i18n();
      }
    } else if (value != input) {
      if (value != null) {
        if (!regex.hasMatch(value)) {
          double valueDouble = double.parse(value);
          if (valueDouble < -100) {
            return 'cannot-be-negative-more-than-100'.i18n();
          } else {
            return null;
          }
        } else {
          double valueDouble = double.parse(input);
          if (valueDouble > 100) {
            return 'non-exceed-a-hundred'.i18n();
          }
          return null;
        }
      } else {
        return 'please-insert-numerical'.i18n();
      }
    } else {
      return 'please-insert-numerical'.i18n();
    }
  }

  static String? validateBoxHumidity(String? value, String input) {
    RegExp regex = new RegExp(r'(^[0-9]*)([.]{0,1})([0-9]*$)');
    if (input == "0.0") {
      if (value != "") {
        if (value != null) {
          if (!regex.hasMatch(value)) {
            double valueDouble = double.parse(value);
            if (valueDouble < 0) {
              return 'non-negative-data'.i18n();
            } else {
              return 'please-insert-numerical'.i18n();
            }
          } else {
            double valueDouble = double.parse(input);
            if (valueDouble > 100) {
              return 'non-exceed-a-hundred'.i18n();
            }
            return null;
          }
        } else {
          return 'please-insert-numerical'.i18n();
        }
      } else {
        return 'please-insert-numerical'.i18n();
      }
    } else if (value == input) {
      if (value != null) {
        if (!regex.hasMatch(value)) {
          double valueDouble = double.parse(value);
          if (valueDouble < 0) {
            return 'non-negative-data'.i18n();
          } else {
            return 'please-insert-numerical'.i18n();
          }
        } else {
          double valueDouble = double.parse(input);
          if (valueDouble > 100) {
            return 'non-exceed-a-hundred'.i18n();
          }
          return null;
        }
      } else {
        return 'please-insert-numerical'.i18n();
      }
    } else if (value != input) {
      if (value != null) {
        if (!regex.hasMatch(value)) {
          double valueDouble = double.parse(value);
          if (valueDouble < 0) {
            return 'non-negative-data'.i18n();
          } else {
            return 'please-insert-numerical'.i18n();
          }
        } else {
          double valueDouble = double.parse(input);
          if (valueDouble > 100) {
            return 'non-exceed-a-hundred'.i18n();
          }
          return null;
        }
      } else {
        return 'please-insert-numerical'.i18n();
      }
    } else {
      return 'please-insert-numerical'.i18n();
    }
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'please-select-date'.i18n();
    }
    return null;
  }

  static String? validateMyRadioListTile(int? value, int input) {
    if (value == null && input == 0) {
      return 'please-select-option'.i18n();
    }
    return null;
  }

  static String? validateDropdownProvider(String? value) {
    if (value == "other".i18n()) {
      return 'please-select-option'.i18n();
    } else if (value == 'add-new-agriculture'.i18n()) {
      return 'please-select-option'.i18n();
    } else if (value == null || value.isEmpty) {
      return 'please-select-option'.i18n();
    }
    return null;
  }
}
