public with sharing class CandidateService {

    public static Boolean getIsFieldAccessible(String objectName, String fieldName){
        Schema.SObjectType sObjectTypeObj = ( (SObject)Type.forName(objectName).newInstance() ).getSObjectType();
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> fieldsMap = describeSObjectResultObj.fields.getMap();
        Schema.DescribeFieldResult fieldObj = fieldsMap.get(fieldName).getDescribe();
        return fieldObj.isAccessible();
    }

    public static List<Candidate__c> candidatesWithFieldsAndObjectAccess(List<Candidate__c> candidatesWithNotAppliedPermissions) {
        return Security.stripInaccessible(AccessType.READABLE, candidatesWithNotAppliedPermissions, true).getRecords();
    }

    public static List<String> getFieldSetData(String objectName, String fieldSetName){
        List<String> fieldSetData = new List<String>();
        List<Schema.FieldSetMember> fieldSet = CandidateSelector.readFieldSet(objectName, fieldSetName);
        for (Schema.FieldSetMember f : fieldSet) {
            String fieldApiName = (String)f.getFieldPath();
            fieldSetData.add(fieldApiName);
        }
        return fieldSetData;
    }
}