/**
 * QOrderTest is used to test QOrder logic
 * @author  Jean-Philippe Monette
 * @since   2017-03-29
 */
@isTest
private class QOrderTest {
  @isTest
  static void testConstructor() {
    String segment = new QOrder('Name').build();
    Assert.areEqual(
      'Name ASC',
      segment,
      'It should output an ASC order by default.'
    );
  }

  @isTest
  static void testAscending() {
    String segment = new QOrder('Name').ascending().build();
    Assert.areEqual('Name ASC', segment, 'It should output an ASC order.');
  }

  @isTest
  static void testDescending() {
    String segment = new QOrder('Name').descending().build();
    Assert.areEqual('Name DESC', segment, 'It should output a DESC order.');
  }

  @isTest
  static void testNullsFirst() {
    String segment = new QOrder('Name').nullsFirst().build();
    Assert.areEqual(
      'Name ASC NULLS FIRST',
      segment,
      'It should output an ASC NULLS FIRST order.'
    );
  }

  @isTest
  static void testNullsLast() {
    String segment = new QOrder('Name').nullsLast().build();
    Assert.areEqual(
      'Name ASC NULLS LAST',
      segment,
      'It should output an ASC NULLS LAST order.'
    );
  }
}