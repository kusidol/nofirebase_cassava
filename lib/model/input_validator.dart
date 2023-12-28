import 'package:localization/src/localization_extension.dart';
import 'package:mun_bot/entities/planting.dart';

class InputCodeValidator {
  static String? validate(String? value, String input) {
    if (input != "") {
      RegExp regex = new RegExp(r'^[0-9]*$');
      if (!regex.hasMatch(input) || input.length >= 11) {
        if (!regex.hasMatch(input)) {
          return 'กรุณาใส่เพียงตัวเลข';
        } else
          return 'กรุณาใส่เพียงตัวเลขไม่เกิน11ตัว';
      } else
        return null;
    }
    return value == null || value.isEmpty ? "กรุณากรอกรหัส" : null;
  }

  static String? validateFieldName(String? value, String input) {
    if (input != "") {
      RegExp regex = new RegExp(r"^[\p{L} ,.'-]*$");
      if (!regex.hasMatch(input) && input.length >= 50) {
        return 'กรุณาใส่ตัวอักษรและตัวเลขไม่เกิน50ตัว';
      } else
        return null;
    }
    return value == null || value.isEmpty ? "กรุณากรอกข้อมูล" : null;
  }

  static String? validateMultiSelect(List<String>? value) {
    if (value!.length == 0) {
      return "กรุณากรอกข้อมูล";
    } else {
      return null;
    }
    return value == null || value.isEmpty ? "กรุณากรอกข้อมูล" : null;
  }

  static String? validateFieldSize(String? value, String input) {
    print("input" + input);
    if (input != "") {
      RegExp regex = new RegExp(r"[0-9]+[.[0-9]+]?");
      if (!regex.hasMatch(input.toString())) {
        return 'กรุณาใส่เพียงตัวเลข';
      } else
        return null;
    }
    return value == null || value.isEmpty ? "กรุณากรอกตัวเลข" : null;
  }

  static String? validatePlantVariety(String? value, String input) {
    if (input != "") {
      RegExp regex = new RegExp(r"^[\p{L} ,.'-]*$");
      if (!regex.hasMatch(input) && input.length >= 30) {
        return 'กรุณาใส่ตัวอักษรและตัวเลขไม่เกิน30ตัว';
      } else
        return null;
    }
    return value == null || value.isEmpty ? "กรุณากรอกข้อมูล" : null;
  }

  static String? validatePlantSecondaryType(String? value, String input) {
    if (input != "") {
      RegExp regex = new RegExp(r"^[\p{L} ,.'-]*$");
      if (!regex.hasMatch(input) && input.length >= 20) {
        return 'กรุณาใส่ตัวอักษรและตัวเลขไม่เกิน20ตัว';
      } else
        return null;
    }
    return value == null || value.isEmpty ? "กรุณากรอกข้อมูล" : null;
  }

  static String? validateFertilizerFormular(String? value, String input) {
    if (input != "") {
      RegExp regex = new RegExp(r"^[\p{L} ,.'-]*$");
      if (!regex.hasMatch(input) && input.length >= 20) {
        return 'กรุณาใส่ตัวอักษรและตัวเลขไม่เกิน20ตัว';
      } else
        return null;
    }
    return value == null || value.isEmpty ? "กรุณากรอกข้อมูล" : null;
  }

  static String? validateDropDown(String? value, String input) {
    if (value == input) {
      return "กรุณากรอกข้อมูล ${input}";
    }
    return value == input || value!.isEmpty ? "กรุณากรอกข้อมูล" : null;
  }

  static String? validateRadioItem(String? value, String input) {
    if (value == null) {
      return "กรุณากรอกข้อมูล";
    }
    return value == null || value.isEmpty ? "กรุณากรอกข้อมูล" : null;
  }

  static String? validateNotSpecialCharacter(String? value, String input) {
    if (input != "") {
      RegExp regex = new RegExp(r'^[a-zA-Z0-9ก-๙]+$');
      if (!regex.hasMatch(input)) {
        if (!regex.hasMatch(input)) {
          return 'กรุณาใส่เพียงตัวเลขไม่เกิน 25 ตัว';
        }
      } else if (input.length < 2) {
        return 'ต้องมีความยาวตั้งแต่ 2-25 ตัวอักษร, ห้ามเว้นว่าง';
      } else if (input.length >= 25) {
        return 'กรุณาใส่เพียงตัวเลขไม่เกิน 25 ตัว';
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
              return 'ค่าข้อมูลไม่สามารถติดลบได้';
            } else {
              return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
            }
          } else {
            double valueDouble = double.parse(input);
            if (valueDouble > 1000000) {
              return 'ค่าข้อมูลไม่สามารถเกินล้านได้';
            }
            return null;
          }
        } else {
          return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
        }
      } else {
        return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
      }
    } else if (value == input) {
      if (value != null) {
        if (!regex.hasMatch(value)) {
          double valueDouble = double.parse(value);
          if (valueDouble < 0) {
            return 'ค่าข้อมูลไม่สามารถติดลบได้';
          } else {
            return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
          }
        } else {
          double valueDouble = double.parse(input);
          if (valueDouble > 1000000) {
            return 'ค่าข้อมูลไม่สามารถเกินล้านได้';
          }
          return null;
        }
      } else {
        return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
      }
    } else if (value != input) {
      if (value != null) {
        if (!regex.hasMatch(value)) {
          double valueDouble = double.parse(value);
          if (valueDouble < 0) {
            return 'ค่าข้อมูลไม่สามารถติดลบได้';
          } else {
            return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
          }
        } else {
          double valueDouble = double.parse(input);
          if (valueDouble > 1000000) {
            return 'ค่าข้อมูลไม่สามารถเกินล้านได้';
          }
          return null;
        }
      } else {
        return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
      }
    } else {
      return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
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
              return 'ค่าข้อมูลไม่สามารถติดลบเกิน 100 ได้';
            } else {
              return null;
            }
          } else {
            double valueDouble = double.parse(input);
            if (valueDouble > 100) {
              return 'ค่าข้อมูลไม่สามารถเกินร้อยได้';
            }
            return null;
          }
        } else {
          return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
        }
      } else {
        return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
      }
    } else if (value == input) {
      if (value != null) {
        if (!regex.hasMatch(value)) {
          double valueDouble = double.parse(value);
          if (valueDouble < -100) {
            return 'ค่าข้อมูลไม่สามารถติดลบเกิน 100 ได้';
          } else {
            return null;
          }
        } else {
          double valueDouble = double.parse(input);
          if (valueDouble > 100) {
            return 'ค่าข้อมูลไม่สามารถเกินร้อยได้';
          }
          return null;
        }
      } else {
        return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
      }
    } else if (value != input) {
      if (value != null) {
        if (!regex.hasMatch(value)) {
          double valueDouble = double.parse(value);
          if (valueDouble < -100) {
            return 'ค่าข้อมูลไม่สามารถติดลบเกิน 100 ได้';
          } else {
            return null;
          }
        } else {
          double valueDouble = double.parse(input);
          if (valueDouble > 100) {
            return 'ค่าข้อมูลไม่สามารถเกินร้อยได้';
          }
          return null;
        }
      } else {
        return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
      }
    } else {
      return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
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
              return 'ค่าข้อมูลไม่สามารถติดลบได้';
            } else {
              return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
            }
          } else {
            double valueDouble = double.parse(input);
            if (valueDouble > 100) {
              return 'ค่าข้อมูลไม่สามารถเกินร้อยได้';
            }
            return null;
          }
        } else {
          return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
        }
      } else {
        return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
      }
    } else if (value == input) {
      if (value != null) {
        if (!regex.hasMatch(value)) {
          double valueDouble = double.parse(value);
          if (valueDouble < 0) {
            return 'ค่าข้อมูลไม่สามารถติดลบได้';
          } else {
            return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
          }
        } else {
          double valueDouble = double.parse(input);
          if (valueDouble > 100) {
            return 'ค่าข้อมูลไม่สามารถเกินร้อยได้';
          }
          return null;
        }
      } else {
        return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
      }
    } else if (value != input) {
      if (value != null) {
        if (!regex.hasMatch(value)) {
          double valueDouble = double.parse(value);
          if (valueDouble < 0) {
            return 'ค่าข้อมูลไม่สามารถติดลบได้';
          } else {
            return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
          }
        } else {
          double valueDouble = double.parse(input);
          if (valueDouble > 100) {
            return 'ค่าข้อมูลไม่สามารถเกินร้อยได้';
          }
          return null;
        }
      } else {
        return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
      }
    } else {
      return 'กรุณากรอกข้อมูลตัวเลข (ทศนิยมและจำนวนเต็ม)';
    }
  }

  static String? validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'กรุณาเลือกวันที่';
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
    if (value == "เพิ่มเติม") {
      return 'please-select-option'.i18n();
    } else if (value == 'add-new-agriculture'.i18n()) {
      return 'please-select-option'.i18n();
    } else if (value == null || value.isEmpty) {
      return 'please-select-option'.i18n();
    }
    return null;
  }
}
