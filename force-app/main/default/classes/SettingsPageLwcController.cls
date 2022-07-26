public class SettingsPageLwcController {

    public class SelectOption {
        @AuraEnabled
        public string value {get; set;}
        @AuraEnabled
        public string label {get; set;}
    }

    public static List<SelectOption> getSelectOptions() {
        List<SelectOption> selectOptions = new List<SelectOption>();
        Set<String> fieldSetNames = CandidateSelector.getAllFieldSetNames('Candidate__c');
        for (String fieldSetName : fieldSetNames) {
            SelectOption selectOption = new SelectOption();
            selectOption.value = fieldSetName;
            selectOption.label = fieldSetName;
            selectOptions.add(selectOption);
        }
        return selectOptions;
    }
    
    public static Map<String, Field_set__mdt> getFieldSetRecords() {
        return Field_set__mdt.getAll();
    }

    public class SettingsDataWrapper {
        @AuraEnabled
        public List<SelectOption> selectOptions {get; set;}
        @AuraEnabled
        public Map<String, Field_set__mdt> customMetadataRecords {get; set;}
    }

    @AuraEnabled(cacheable=true)
    public static SettingsDataWrapper getSettingsDataWrapper() {
        SettingsDataWrapper settingsDataWrapper = new SettingsDataWrapper();
        settingsDataWrapper.selectOptions = SettingsPageLwcController.getSelectOptions();
        settingsDataWrapper.customMetadataRecords = Field_set__mdt.getAll();
        return settingsDataWrapper;
    }

    public class FieldsData {
        @AuraEnabled
        public String fieldName {get; set;}
        @AuraEnabled
        public Boolean isAccessible {get; set;}
    }

    @AuraEnabled(cacheable=true)
    public static List<FieldsData> getFieldSetFields(String profileOrPermissionSet, String profileOrPermissionSetName, String fieldSetName) {
        List<FieldsData> fieldSetFields = new List<FieldsData>();
        List<FieldPermissions> accessibleFieldsData = new List<FieldPermissions>();
        Set<String> accessibleFields = new Set<String>();
        if (profileOrPermissionSet == 'Profile') {
            accessibleFieldsData = FieldPermissionsSelector.selectByObjectAndProfile('Candidate__c', profileOrPermissionSetName);
        } else {
            accessibleFieldsData = FieldPermissionsSelector.selectByObjectAndPermissionSet('Candidate__c', profileOrPermissionSetName);
        }
        for (FieldPermissions fp : accessibleFieldsData) {
            String accessibleField = fp.field.substringAfter('.');
            accessibleFields.add(accessibleField);
        }
        List<Schema.FieldSetMember> fieldSetFieldsData = CandidateSelector.readFieldSet('Candidate__c', fieldSetName);
        for (Schema.FieldSetMember field : fieldSetFieldsData) {
            FieldsData fieldSetField = new FieldsData();
            String fieldName = field.getFieldPath();
            fieldSetField.fieldName = fieldName;
            fieldSetField.isAccessible = accessibleFields.contains(fieldName);
            fieldSetFields.add(fieldSetField);
        }
        return fieldSetFields;
    }

    @AuraEnabled(cacheable=true)
    public static List<String> updateCustomMetadataRecords(Map<String, Field_set__mdt> customMetadataRecords) {
        try {
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
            Id asyncResultId = Metadata.Operations.enqueueDeployment(container, null);
            List<String> sendToJS  = new List<String>();
            sendToJS.add('Success');
            sendToJS.add( (String)asyncResultId );
            return sendToJS;
        } catch (Exception e) {
            System.debug(e.getMessage());
            List<String> sendToJS  = new List<String>();
            sendToJS.add('Error');
            sendToJs.add(e.getMessage());
            return sendToJs;
        }
    }
}
