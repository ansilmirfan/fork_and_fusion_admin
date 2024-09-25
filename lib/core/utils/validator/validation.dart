// ignore_for_file: body_might_complete_normally_nullable

class Validation {
  //-------email validation------------
  static String? validateEmail(String? email) {
    if (email != null) {
      if (email.isEmpty) {
        return 'Email address cannot be empty';
      }
      final RegExp emailRegExp = RegExp(
        r'^([a-zA-Z0-9._%+-]+)@([a-zA-Z0-9.-]+\.[a-zA-Z]{2,})$',
        caseSensitive: false,
        multiLine: false,
      );
      if (!emailRegExp.hasMatch(email)) {
        return 'Invalid email address';
      }
    }
  }

  static String? passwordValidation(String? word) {
    const int minLength = 5;
    if (word != null) {
      if (word.isEmpty) {
        return 'Password cannot be empty';
      } else if (word.length < minLength) {
        return 'password must be at least $minLength characters long';
      }
    }
  }

  static String? validateName(String? querry,
      {int minLength = 5, String name = 'Name'}) {
    if (querry != null) {
      if (querry.isEmpty) {
        return '$name cannot be empty';
      } else if (querry.length < minLength) {
        return '$name must be at least $minLength characters long';
      }
    }
  }

  static String? variantValidation(String? querry) {
    if (querry != null) {
      if (querry.isEmpty) {
        return 'variant is required';
      }
    }
    return null;
  }

  static String? validateCategory(String? name) {
    const int minLength = 3;
    if (name != null) {
      if (name.isEmpty) {
        return 'category cannot be empty';
      } else if (name.length < minLength) {
        return 'category must be at least $minLength characters long';
      }
    }
  }

  static String? validateNumber(String? value,
      {num minValue = 0, String name = 'Number'}) {
    if (value != null) {
      if (value.isEmpty) {
        return '$name cannot be empty';
      }
      final parsedValue = num.tryParse(value);
      if (parsedValue == null) {
        return '$name must be a valid number';
      } else if (parsedValue < 0) {
        return 'negative numbers are not allowed';
      } else if (parsedValue < minValue) {
        return '$name must be at least $minValue';
      }
      final isNumeric = RegExp(r'^\d+$').hasMatch(value);
      if (!isNumeric) {
        return '$name must contain only numbers';
      }
    }
  }

  static String? validateNumberShort(String? query) {
    if (query != null) {
      if (query.isEmpty) {
        return 'required';
      }
      final isNumeric = RegExp(r'^\d+$').hasMatch(query);
      if (!isNumeric) {
        return 'only number';
      }
      final parsedValue = num.tryParse(query);
      if (parsedValue == null) {
        return 'invalid number';
      }

      if (parsedValue < 0) {
        return 'negative numbers are not allowed';
      }
    }
    return null;
  }

  static String? validatePercentage(String? word) {
    if (word == null) {
      return null;
    }
    final parsedValue = num.tryParse(word);
    if (parsedValue == null) {
      return null;
    } else if (parsedValue < 0) {
      return 'negative numbers are not allowed';
    }
  }
}
