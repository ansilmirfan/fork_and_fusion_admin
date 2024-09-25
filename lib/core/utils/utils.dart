import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';

class Utils {
  static String extractFileName(String path) {
    return path.split('/').last;
  }

  static String capitalizeEachWord(String word) {
    if (word.isEmpty) {
      return word;
    }
    return word
        .split(' ')
        .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
        .join(' ');
  }

  static String removeAndCapitalize(String word) {
    return word
        .split('_')
        .map((e) => e[0].toUpperCase() + e.substring(1).toLowerCase())
        .join(' ');
  }

  static List<String> extractCategoryNames(List<CategoryEntity> data) {
    return data.map((e) => e.name).toList();
  }
}
