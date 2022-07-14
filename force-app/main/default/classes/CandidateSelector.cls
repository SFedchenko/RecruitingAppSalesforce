public class CandidateSelector {
    
    public static List<Candidate__c> selectByIdsWithLimitAndOffset(Set<Id> candidatesIds, Integer limitParam, Integer offsetParam) {
        String q = 'SELECT Id, Name FROM Candidate__c WHERE Id IN :candidatesIds ORDER BY Name LIMIT :limitParam OFFSET :offsetParam';
        return Database.query(q);
    }
    
    public static List<Schema.FieldSetMember> readFieldSet(String objectName, String fieldSetName) {
    	Map<String, Schema.SObjectType> globalDescribeMap = Schema.getGlobalDescribe();
    	Schema.SObjectType sObjectTypeObj = globalDescribeMap.get(objectName);
    	Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
    	Schema.FieldSet fieldSetObj = describeSObjectResultObj.FieldSets.getMap().get(fieldSetName);
    	return fieldSetObj.getFields();
	}
}