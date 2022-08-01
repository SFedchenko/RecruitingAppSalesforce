public with sharing class CandidateService {

    public static Metadata.DeployContainer constructDeploymentRequest(Map<String, Field_set__mdt> customMetadataRecords) {
        Metadata.DeployContainer container = new Metadata.DeployContainer();
        List<String> fieldSetFullNames = new List<String>();
        for (String recordName : customMetadataRecords.keySet()) {
            fieldSetFullNames.add('Field_set.' + recordName);
        }
        List<Metadata.Metadata> records = Metadata.Operations.retrieve(Metadata.MetadataType.CustomMetadata, fieldSetFullNames);
        for (Metadata.Metadata record : records) {
            Metadata.CustomMetadata fieldSetRecord = (Metadata.CustomMetadata) record;
            String fieldSetRecordName = fieldSetRecord.fullName.substringAfter('.');
            Field_set__mdt fieldSetToCopy = customMetadataRecords.get(fieldSetRecordName);
            for (Metadata.CustomMetadataValue fieldSetRecordValue : fieldSetRecord.values) {
                fieldSetRecordValue.value = fieldSetToCopy.get(fieldSetRecordValue.field);
            }
            container.addMetadata(fieldSetRecord);
        }
        return container;
    }

    public static Boolean getIsFieldAccessible(String objectName, String fieldName){
        Schema.SObjectType sObjectTypeObj = ( (SObject)Type.forName(objectName).newInstance() ).getSObjectType();
        Schema.DescribeSObjectResult describeSObjectResultObj = sObjectTypeObj.getDescribe();
        Map<String, Schema.SObjectField> fieldsMap = describeSObjectResultObj.fields.getMap();
        Schema.DescribeFieldResult fieldObj = fieldsMap.get(fieldName).getDescribe();
        return fieldObj.isAccessible();
    }
}