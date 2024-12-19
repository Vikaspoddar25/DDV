@isTest
private class SecureDB_Test {
  @testSetup
  static void makeData() {
    List<Account> accounts = TestDataFactory.createAccounts(1);
    TestDataFactory.createOpportunities(accounts, 1);
  }

  @IsTest
  static void inheritedSharing_expectDmlAndSoqlSuccess() {
    Account acc = new Account(Name = 'Testing Inherited Company');
    Contact con = new Contact(LastName = 'Hawthorne', AccountId = acc.Id);

    Test.startTest();
    SecureDB.inheritedSharing().dbInsert(acc);
    acc.Name = 'Testing Updated Name';
    SecureDB.inheritedSharing().dbUpdate(acc);
    SecureDB.inheritedSharing().dbUpsert(con, Contact.Fields.Id);
    SecureDB.inheritedSharing().dbDelete(con);
    List<Account> accounts = SecureDB.inheritedSharing()
      .dbQuery(
        'SELECT Id, Name FROM Account WHERE Name LIKE \'' + acc.Name + '\''
      );
    Test.stopTest();

    List<Contact> contacts = [SELECT Id FROM Contact LIMIT 10];
    Assert.isFalse(accounts.isEmpty(), 'Account query failed.');
    Assert.areEqual(acc.Name, accounts[0].Name, 'Account Name was not updated');
    Assert.isTrue(contacts.size() == 0, 'Contact record was not deleted.');
  }

  @IsTest
  static void inheritedSharing_expectException() {
    Account acc = new Account(Name = 'Testing Company');

    Test.startTest();
    try {
      SecureDB.inheritedSharing().dbInsert(acc);
      SecureDB.inheritedSharing()
        .dbQuery('Not a valid query');
      Assert.fail('dbQuery method was expected to fail.');
    } catch (Exception ex) {
      Assert.areEqual(
        'System.QueryException',
        ex.getTypeName(),
        'Expected exception of type QueryException to be thrown'
      );
    }
    Test.stopTest();
  }

  @IsTest
  static void withSharing_expectDmlAndSoqlSuccess() {
    SecureDB.SecureDatabase secureDb = SecureDB.withSharing();
    makeDml(secureDb);
  }

  @IsTest
  static void withoutSharing_expectDmlAndSoqlSuccess() {
    SecureDB.SecureDatabase secureDb = SecureDB.withoutSharing();
    makeDml(secureDb);
  }

  @IsTest
  static void withSharingBulk_expectDmlAndSoqlSuccess() {
    SecureDB.SecureDatabase secureDb = SecureDB.withSharing();
    makeBulkDml(secureDb);
  }

  @IsTest
  static void withoutSharingBulk_expectDmlAndSoqlSuccess() {
    SecureDB.SecureDatabase secureDb = SecureDB.withoutSharing();
    makeBulkDml(secureDb);
  }

  private static void makeDml(SecureDB.SecureDatabase secureDb) {
    Account acc = new Account(Name = 'Testing Company 1');
    Account acc2 = new Account(Name = 'Testing Company 2');
    Contact newContact = new Contact(LastName = 'Hawthorne');

    // Single record operations
    Test.startTest();
    secureDb.dbInsert(acc);
    acc.Name += ' Updated';
    secureDb.dbUpdate(acc);
    secureDb.dbUpsert(acc2);
    secureDb.dbDelete(acc2);
    newContact.AccountId = acc.Id;
    secureDb.dbUpsert(newContact, Contact.Fields.Id);
    List<Account> accounts = secureDb.dbQuery(
      'SELECT Id, Name FROM Account WHERE Name LIKE \'Testing Company%\''
    );
    List<Contact> upsertedContacts = secureDb.dbQuery(
      'SELECT Id, Name FROM Contact'
    );
    Test.stopTest();

    Assert.isFalse(accounts.isEmpty(), 'Query of Accounts failed.');
    Assert.areEqual(acc.Name, accounts[0].Name, 'Account Name was updated.');
    Assert.isTrue(accounts.size() == 1, 'Second Account is not deleted');
    Assert.isTrue(upsertedContacts.size() > 0, 'Contact was not upserted');
  }

  private static void makeBulkDml(SecureDB.SecureDatabase secureDb) {
    List<Contact> newContacts = new List<Contact>();
    for (Integer i = 0; i < 3; i++) {
      newContacts.add(new Contact(LastName = 'Hawthorne ' + i));
    }
    List<Account> newAccounts = new List<Account>();
    for (Integer i = 0; i < 3; i++) {
      newAccounts.add(new Account(Name = 'Testing Company ' + i));
    }

    // Multiple records operations
    Test.startTest();
    secureDb.dbInsert(newAccounts);
    for (Account acc : newAccounts) {
      acc.Name += ' Updated';
    }
    secureDb.dbUpdate(newAccounts);
    secureDb.dbUpsert(newAccounts);
    for (Contact con : newContacts) {
      con.put('AccountId', newAccounts[0].Id);
    }
    secureDb.dbUpsert(newContacts, Contact.Fields.Id);
    List<Account> updatedAccounts = secureDb.dbQuery(
      'SELECT Id, Name FROM Account WHERE Name LIKE \'Testing Company%\''
    );
    List<Contact> upsertedContacts = secureDb.dbQuery(
      'SELECT Id, LastName FROM Contact'
    );
    secureDb.dbDelete(updatedAccounts);
    Test.stopTest();

    Assert.areEqual(
      3,
      updatedAccounts.size(),
      'Expected 3 accounts to be retrieved'
    );
    for (Account acc : updatedAccounts) {
      Assert.isTrue(
        acc.Name.contains('Updated'),
        'Account names should be updated'
      );
    }
    Assert.areEqual(
      3,
      upsertedContacts.size(),
      'Expected 3 Contacts to have been retrieved.'
    );
    Assert.areEqual(
      0,
      [SELECT COUNT() FROM Contact],
      'Expected 0 Contacts to be retrieved'
    );
    Assert.areEqual(
      0,
      [SELECT COUNT() FROM Account WHERE Name LIKE 'Testing Company%'],
      'Expected testing company accounts to be deleted'
    );
  }
}
