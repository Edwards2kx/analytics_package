import 'package:analytics/src/services/analytic_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:analytics/analytics.dart';

void main() {
  test('assert for constructor with host paremeter empty', () {
    //Arrange
    const String host = '';
    //Act - Assert
    expect(() => AnalyticService.setup(host: host), throwsAssertionError);
  });

  test('assert for constructor with host paremeter without valid schema', () {
    //Arrange
    const String host = 'www.commodo.com';
    //Act - Assert
    expect(() => AnalyticService.setup(host: host), throwsAssertionError);
  });

  test('call instance before setup assertion', () {
    //Arrange
    //Act - Assert
    expect(() {
      AnalyticService.instance();
    }, throwsAssertionError);
  });

  test('instance', () {
    //Arrange
    const String host = 'https://www.commodo.com';
    AnalyticService.setup(host: host);
    final instance = AnalyticService.instance();
    //Act - Assert
    expect(instance, isInstanceOf<AnalyticService>());
  });
}
