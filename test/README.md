# Test Configuration for Mayegue App
#
# This file organizes the test structure and provides guidance for running tests

## Test Organization
- unit/ - Unit tests for individual functions, classes, and utilities
- integration/ - Integration tests for feature interactions
- widget/ - Widget tests for UI components

## Test Categories
### Unit Tests
- Core services (notification, payout, sync, content moderation)
- Utilities (security, validators, error handling)
- Domain layer (usecases, entities, repositories interfaces)
- Data layer (models, mappers)

### Integration Tests
- Repository implementations
- ViewModel interactions
- Feature workflows
- API integrations (mocked)

### Widget Tests
- Screen widgets
- UI components
- Navigation flows
- Form validations

## Running Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/security_utils_test.dart

# Run tests by directory
flutter test test/unit/
flutter test test/integration/
flutter test test/widget/

# Run with coverage
flutter test --coverage
```

## Test Coverage Goals
- Core utilities: 90%+
- Services: 80%+
- Usecases: 85%+
- ViewModels: 75%+
- Widgets: 70%+
- Integration: 60%+

## Mock Strategy
- Use Mockito for external dependencies (Firebase, HTTP, etc.)
- Create fake implementations for complex dependencies
- Use dependency injection to enable testability