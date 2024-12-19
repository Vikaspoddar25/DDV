/**
 * QConditionTest is used to test QCondition logic
 * @author  Jean-Philippe Monette
 * @since   2017-04-21
 */
@isTest
private class QConditionTest {
  @isTest
  static void testEqualsString() {
    String segment = new QCondition('Name')
      .equalsTo('Jean-Philippe Monette')
      .build();
    Assert.areEqual(
      'Name = \'Jean-Philippe Monette\'',
      segment,
      'It should output an equal condition.'
    );
  }

  @isTest
  static void testEqualsInteger() {
    String segment = new QCondition('Age').equalsTo(5).build();
    Assert.areEqual(
      'Age = 5',
      segment,
      'It should output an equal integer condition.'
    );
  }

  @isTest
  static void testNotEquals() {
    String segment = new QCondition('Name')
      .notEqualsTo('Jean-Philippe Monette')
      .build();
    Assert.areEqual(
      'Name != \'Jean-Philippe Monette\'',
      segment,
      'It should output a not equal condition.'
    );
  }

  @isTest
  static void testIsLessThan() {
    String segment = new QCondition('Age').isLessThan(5).build();
    Assert.areEqual(
      'Age < 5',
      segment,
      'It should output a less than condition.'
    );
  }

  @isTest
  static void testIsLessOrEquals() {
    String segment = new QCondition('Age').isLessOrEquals(5).build();
    Assert.areEqual(
      'Age <= 5',
      segment,
      'It should output a less or equal condition.'
    );
  }

  @isTest
  static void testIsGreaterThan() {
    String segment = new QCondition('Age').isGreaterThan(5).build();
    Assert.areEqual(
      'Age > 5',
      segment,
      'It should output a greather than condition.'
    );
  }

  @isTest
  static void testIsGreaterOrEquals() {
    String segment = new QCondition('Age').isGreaterOrEquals(5).build();
    Assert.areEqual(
      'Age >= 5',
      segment,
      'It should output a greater or equal condition.'
    );
  }

  @isTest
  static void testIsLike() {
    String segment = new QCondition('Name').isLike('%Acme%').build();
    Assert.areEqual(
      'Name LIKE \'%Acme%\'',
      segment,
      'It should output a LIKE condition.'
    );
  }

  @isTest
  static void testIsIn() {
    List<String> names = new List<String>{ 'John', 'Jane' };
    String segment = new QCondition('Name').isIn(names).build();
    Assert.areEqual(
      'Name IN (\'John\', \'Jane\')',
      segment,
      'It should output an IN condition.'
    );
  }

  @isTest
  static void testIsNotIn() {
    List<String> names = new List<String>{ 'John', 'Jane' };
    String segment = new QCondition('Name').isNotIn(names).build();
    Assert.areEqual(
      'Name NOT IN (\'John\', \'Jane\')',
      segment,
      'It should output a NOT IN condition.'
    );
  }

  @isTest
  static void testIncludes() {
    List<String> markets = new List<String>{ 'APAC', 'EMEA' };
    String segment = new QCondition('Market').includes(markets).build();
    Assert.areEqual(
      'Market INCLUDES (\'APAC\', \'EMEA\')',
      segment,
      'It should output an INCLUDES condition.'
    );
  }

  @isTest
  static void testExcludes() {
    List<String> markets = new List<String>{ 'APAC', 'EMEA' };
    String segment = new QCondition('Market').excludes(markets).build();
    Assert.areEqual(
      'Market EXCLUDES (\'APAC\', \'EMEA\')',
      segment,
      'It should output a EXCLUDES condition.'
    );
  }

  @isTest
  static void testIsNull() {
    String segment = new QCondition('Name').isNull().build();
    Assert.areEqual(
      'Name = null',
      segment,
      'It should output an IS NULL condition.'
    );
  }

  @isTest
  static void testIsNotNull() {
    String segment = new QCondition('Name').isNotNull().build();
    Assert.areEqual(
      'Name != null',
      segment,
      'It should output a IS NOT NULL condition.'
    );
  }
}
