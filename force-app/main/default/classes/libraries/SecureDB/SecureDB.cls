public inherited sharing class SecureDB {
  /**
   * Enforces sharing rules, and gives across all DB operations. This should be the most widely used Database for
   * any purposes, unless an exposure to more data is needed
   */
  public static SecureDatabase withSharing() {
    return new WithSharing_Database();
  }

  /**
   * Works in WITHOUT SHARING mode for all DB operations. This is meant to be used for cases
   * where access to all data is needed for transactions. Specially in Aysnc, Batch, Scheduled context
   */
  public static SecureDatabase withoutSharing() {
    return new WithoutSharing_Database();
  }

  /**
   * Works in INHERITED SHARING mode for all DB operations. This is meant to be used for cases
   * where access to all data is needed for transactions.
   */
  public static SecureDatabase inheritedSharing() {
    return new InheritedSharing_Database();
  }

  /**
   * Contract for Database operations. This layer is meant to enfore security transparently,
   * which avoids need of a similar CRUD/FLS check code before/after every SOQL, or DML.
   * Thus, this makes the developer free to focus more on business logic, instead of
   * Database security.
   *
   * Note: One can add more overloaded forms of methods to the contract as needed,
   * as of now the bare minimum contract required by the App is added here.
   */
  public interface SecureDatabase {
    List<SObject> dbQuery(String query);
    /**
     * All of the DML operations below assume ALLORNONE = TRUE mode, i.e. the whole transaction with all records
     * will crash in case of any error. If partial success transactions are needed, please expose more contract m
     * methods.
     */
    Database.SaveResult dbInsert(SObject record);
    List<Database.SaveResult> dbInsert(List<SObject> records);
    Database.SaveResult dbUpdate(SObject record);
    List<Database.SaveResult> dbUpdate(List<SObject> records);
    Database.UpsertResult dbUpsert(SObject record);
    List<Database.UpsertResult> dbUpsert(List<SObject> records);
    Database.UpsertResult dbUpsert(
      SObject record,
      Schema.SObjectField externalIdField
    );
    List<Database.UpsertResult> dbUpsert(
      List<SObject> records,
      Schema.SObjectField externalIdField
    );
    Database.DeleteResult dbDelete(SObject record);
    List<Database.DeleteResult> dbDelete(List<SObject> records);
  }

  /**
   * WITH SHARING database implementation
   */
  public with sharing class WithSharing_Database implements SecureDatabase {
    //encapsulating inherited sharing SecureDatabase implementation to make it
    // easy to reuse code and logic for all the contract
    InheritedSharing_Database isDB = new InheritedSharing_Database();

    public List<SObject> dbQuery(String query) {
      return isDB.dbQuery(query);
    }

    public Database.SaveResult dbInsert(SObject record) {
      return isDB.dbInsert(record);
    }

    public List<Database.SaveResult> dbInsert(List<SObject> records) {
      return isDB.dbInsert(records);
    }

    public Database.SaveResult dbUpdate(SObject record) {
      return isDB.dbUpdate(record);
    }

    public List<Database.SaveResult> dbUpdate(List<SObject> records) {
      return isDB.dbUpdate(records);
    }

    public Database.UpsertResult dbUpsert(SObject record) {
      return isDB.dbUpsert(record);
    }

    public List<Database.UpsertResult> dbUpsert(List<SObject> records) {
      return isDB.dbUpsert(records);
    }

    public Database.UpsertResult dbUpsert(
      SObject record,
      Schema.SObjectField externalIdField
    ) {
      return isDB.dbUpsert(record, externalIdField);
    }

    public List<Database.UpsertResult> dbUpsert(
      List<SObject> records,
      Schema.SObjectField externalIdField
    ) {
      return isDB.dbUpsert(records, externalIdField);
    }

    public Database.DeleteResult dbDelete(SObject record) {
      return isDB.dbDelete(record);
    }

    public List<Database.DeleteResult> dbDelete(List<SObject> records) {
      return isDB.dbDelete(records);
    }
  }

  /**
   * Without Sharing mode of SecureDatabase implementation
   */
  public without sharing class WithoutSharing_Database implements SecureDatabase {
    InheritedSharing_Database isDB = new InheritedSharing_Database();

    public List<SObject> dbQuery(String query) {
      return isDB.dbQuery(query);
    }

    public Database.SaveResult dbInsert(SObject record) {
      return isDB.dbInsert(record);
    }

    public List<Database.SaveResult> dbInsert(List<SObject> records) {
      return isDB.dbInsert(records);
    }

    public Database.SaveResult dbUpdate(SObject record) {
      return isDB.dbUpdate(record);
    }

    public List<Database.SaveResult> dbUpdate(List<SObject> records) {
      return isDB.dbUpdate(records);
    }

    public Database.UpsertResult dbUpsert(SObject record) {
      return isDB.dbUpsert(record);
    }

    public List<Database.UpsertResult> dbUpsert(List<SObject> records) {
      return isDB.dbUpsert(records);
    }

    public Database.UpsertResult dbUpsert(
      SObject record,
      Schema.SObjectField externalIdField
    ) {
      return isDB.dbUpsert(record, externalIdField);
    }

    public List<Database.UpsertResult> dbUpsert(
      List<SObject> records,
      Schema.SObjectField externalIdField
    ) {
      return isDB.dbUpsert(records, externalIdField);
    }

    public Database.DeleteResult dbDelete(SObject record) {
      return isDB.dbDelete(record);
    }

    public List<Database.DeleteResult> dbDelete(List<SObject> records) {
      return isDB.dbDelete(records);
    }
  }

  /**
   * SecureDatabase Implementation in inherited mode, makes it flexible to adapt to any
   * required sharing mode
   */
  public inherited sharing class InheritedSharing_Database implements SecureDatabase {
    Boolean allOrNone = true;

    public List<SObject> dbQuery(String query) {
      List<SObject> records = null;
      try {
        records = Database.query(query);
      } catch (QueryException queryExp) {
        if (
          queryExp.getMessage().containsIgnoreCase('Insufficient permissions')
        ) {
          throw new SecureDBException(queryExp.getMessage());
        } else {
          throw queryExp;
        }
      }
      // Check CRUD/FLS
      assertRead(records);
      return records;
    }

    public Database.SaveResult dbInsert(SObject record) {
      assertCreate(record);
      return Database.insert(record, allOrNone);
    }

    public List<Database.SaveResult> dbInsert(List<SObject> records) {
      assertCreate(records);
      return Database.insert(records, allOrNone);
    }

    public Database.SaveResult dbUpdate(SObject record) {
      assertUpdate(record);
      return Database.update(record, allOrNone);
    }

    public List<Database.SaveResult> dbUpdate(List<SObject> records) {
      assertUpdate(records);
      return Database.update(records, allOrNone);
    }

    public Database.DeleteResult dbDelete(SObject record) {
      assertDelete(record);
      return Database.delete(record, allOrNone);
    }

    public List<Database.DeleteResult> dbDelete(List<SObject> records) {
      assertDelete(records);
      return Database.delete(records, allOrNone);
    }

    public Database.UpsertResult dbUpsert(SObject record) {
      assertUpsert(record);
      return Database.upsert(record);
    }

    public List<Database.UpsertResult> dbUpsert(List<SObject> records) {
      assertUpsert(records);
      return Database.upsert(records);
    }

    public Database.UpsertResult dbUpsert(
      SObject record,
      Schema.SObjectField externalIdField
    ) {
      assertUpsert(record);
      return Database.upsert(record, externalIdField);
    }

    public List<Database.UpsertResult> dbUpsert(
      List<SObject> records,
      Schema.SObjectField externalIdField
    ) {
      assertUpsert(records);
      return Database.upsert(records, externalIdField);
    }
  }

  /**
   * Checks READ access on Object, and Fields accessed on the given records
   * @param records to be checked for CRUD/FLS access.
   */
  public static void assertRead(List<SObject> records) {
    assertAccess(AccessType.READABLE, records);
  }

  /**
   * Checks UPDATE access on Object, and Fields accessed on the given record
   * @param record to be checked for CRUD/FLS access.
   */
  public static void assertUpdate(SObject record) {
    assertUpdate(new List<SObject>{ record });
  }

  /**
   * Checks UPDATE access on Object, and Fields accessed on the given records
   * @param records to be checked for CRUD/FLS access.
   */
  public static void assertUpdate(List<SObject> records) {
    assertAccess(AccessType.UPDATABLE, records);
  }

  /**
   * Checks UPSERT access on Object, and Fields accessed on the given record
   * @param record to be checked for CRUD/FLS access.
   */
  public static void assertUpsert(SObject record) {
    assertUpsert(new List<SObject>{ record });
  }

  /**
   * Checks UPSERT access on Object, and Fields accessed on the given records
   * @param records to be checked for CRUD/FLS access.
   */
  public static void assertUpsert(List<SObject> records) {
    assertAccess(AccessType.UPSERTABLE, records);
  }

  /**
   * Checks CREATE access on Object, and Fields accessed on the given record
   * @param record to be checked for CRUD/FLS access.
   */
  public static void assertCreate(SObject record) {
    assertCreate(new List<SObject>{ record });
  }

  /**
   * Checks CREATE access on Object, and Fields accessed on the given records
   * @param records to be checked for CRUD/FLS access.
   */
  public static void assertCreate(List<SObject> records) {
    assertAccess(AccessType.CREATABLE, records);
  }
  /**
   * Checks DELETE access on Object
   * @param record to be checked for CRUD access.
   */
  public static void assertDelete(SObject record) {
    assertDelete(new List<SObject>{ record });
  }

  /**
   * Checks DELETE access on Object
   * @param records to be checked for CRUD access.
   */
  public static void assertDelete(List<SObject> records) {
    if (records.size() > 0) {
      Schema.SObjectType sObj = records[0].getSObjectType();
      if (!sObj.getDescribe().isDeletable()) {
        throw new SecureDBException('Delete access missing on ' + records[0]);
      }
    }
  }

  /**
   * Checks required access level on Object, and Fields accessed on the given records
   * @param accessType type of access to assert on the given records
   * @param records to be checked for CRUD/FLS access.
   */
  static void assertAccess(AccessType accessType, List<SObject> records) {
    if (records == null || accessType == null || records.isEmpty()) {
      return;
    }
    Schema.DescribeSObjectResult describeSObjectResult = records[0]
      .getSObjectType()
      .getDescribe();
    String objectName = describeSObjectResult.getName();
    if (objectName != 'AggregateResult') {
      // Normal Object
      try {
        // Strip fields that are not updatable
        SObjectAccessDecision decision = Security.stripInaccessible(
          accessType,
          records
        );
        //K: SObject Name, V: Set of Field Names which are not accessible.
        Map<String, Set<String>> removedFields = decision.getRemovedFields();

        for (String objName : removedFields.keySet()) {
          throw new SecureDBException('Field-level security restriction');
        }
      } catch (System.NoAccessException ex) {
        // Object access missing
        throw new SecureDBException('Object-level security restriction');
      }
    }
  }

  /**
   * Handles errors related to SecureDB operations, including CRUD and security violations.
   */
  public class SecureDBException extends Exception {
  }
}
