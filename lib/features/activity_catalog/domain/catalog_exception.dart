import 'package:logly/core/exceptions/app_exception.dart';

/// Base exception for activity catalog-related errors.
abstract class CatalogException extends AppException {
  const CatalogException(super.message, [super.technicalDetails]);
}

/// Thrown when fetching categories fails.
class CategoryFetchException extends CatalogException {
  const CategoryFetchException([String? technicalDetails])
    : super('Unable to load categories. Please try again.', technicalDetails);
}

/// Thrown when fetching activities fails.
class ActivityFetchException extends CatalogException {
  const ActivityFetchException([String? technicalDetails])
    : super('Unable to load activities. Please try again.', technicalDetails);
}

/// Thrown when searching activities fails.
class ActivitySearchException extends CatalogException {
  const ActivitySearchException([String? technicalDetails])
    : super('Search failed. Please try again.', technicalDetails);
}

/// Thrown when an activity is not found.
class ActivityNotFoundException extends CatalogException {
  const ActivityNotFoundException([String? technicalDetails]) : super('Activity not found.', technicalDetails);
}

/// Thrown when a category is not found.
class CategoryNotFoundException extends CatalogException {
  const CategoryNotFoundException([String? technicalDetails]) : super('Category not found.', technicalDetails);
}
