public class CandidateSelector {

    public static Set<String> getAllFieldSetNames(String objectName) {
    	Schema.SObjectType sObjectTypeObj = ( (SObject)Type.forName(objectName).newInstance() ).getSObjectType();
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        return describeSObjectResultObj.FieldSets.getMap().keySet();
	}
    
    public static List<Candidate__c> selectByIdsWithLimitAndOffset(Set<String> fieldsForQuery, Set<Id> candidatesIds, Integer limitParam, Integer offsetParam) {
        String q = 'SELECT Name, ';
        for (String field : fieldsForQuery) {
            q += field + ', ';
        }
        q += 'Id FROM Candidate__c WHERE Id IN :candidatesIds ORDER BY Name LIMIT :limitParam OFFSET :offsetParam';
        return Database.query(q);
    }
    
    public static List<Schema.FieldSetMember> readFieldSet(String objectName, String fieldSetName) {
    	Schema.SObjectType sObjectTypeObj = ( (SObject)Type.forName(objectName).newInstance() ).getSObjectType();
    	Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
    	Schema.FieldSet fieldSetObj = describeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
    	return fieldSetObj.getFields();
	}
}