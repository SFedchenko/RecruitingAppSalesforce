public with sharing class CandidateService {

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