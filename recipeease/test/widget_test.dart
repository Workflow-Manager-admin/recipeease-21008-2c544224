import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipeease/main.dart';

void main() {
  testWidgets('RecipeEaseApp renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(RecipeEaseApp());

    // Check that title is present
    expect(find.text('RecipeEase'), findsWidgets);

    // Check that search field is visible
    expect(find.byType(TextField), findsOneWidget);

    // Check navigation bar is present
    expect(find.byType(BottomNavigationBar), findsOneWidget);

    // Check that at least one recipe card is rendered
    expect(find.byType(Card), findsWidgets);
  });
}
