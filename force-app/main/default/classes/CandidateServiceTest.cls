@isTest
private class CandidateServiceTest {
    
    @isTest
    static void testConstructDeploymentRequest() {
        Map<String, Field_set__mdt> customMetadataRecords = Field_set__mdt.getAll();
		Map<String, Field_set__mdt> customMetadataRecordsForUpdate = customMetadataRecords.deepClone();
		customMetadataRecordsForUpdate.get('Recruiter_field_set').Candidate_tile_field_set__c = 'CandidateTileFieldSet';
		Metadata.DeployContainer container = CandidateService.constructDeploymentRequest(customMetadataRecordsForUpdate);
        System.assertEquals(2, container.getMetadata().size());
    }

    @isTest
    static void testGetIsFieldAccessible() {
        String standardEmployeeName = 'standardemployee' + DateTime.now().getTime() + '@testorg.com';
        Profile se = [SELECT Id FROM Profile WHERE Name='Standard Employee'];
        User standardEmployee = new User(Alias = 'standt',
                          		Email = 'standardemployee@testorg.com',
                          		EmailEncodingKey = 'UTF-8',
                          		LastName = 'Testing',
                          		LanguageLocaleKey = 'en_US',
                          		LocaleSidKey = 'en_US',
                          		ProfileId = se.Id,
                          		TimeZoneSidKey = 'America/Los_Angeles',
                          		UserName = standardEmployeeName);
        
        String recruiterName = 'recruiter' + DateTime.now().getTime() + '@testorg.com';
        Profile r = [SELECT Id FROM Profile WHERE Name='Recruiter'];
        User recruiter = new User(Alias = 'standt',
                          	 Email = 'standardemployee@testorg.com',
                          	 EmailEncodingKey = 'UTF-8',
                          	 LastName = 'Testing',
                          	 LanguageLocaleKey = 'en_US',
                          	 LocaleSidKey = 'en_US',
                          	 ProfileId = r.Id,
                          	 TimeZoneSidKey = 'America/Los_Angeles',
                          	 UserName = recruiterName);
    
        System.runAs(standardEmployee) {
            System.assertEquals(false, CandidateService.getIsFieldAccessible('Position__c', 'Min_Salary__c'));
            System.assertEquals(true, CandidateService.getIsFieldAccessible('Position__c', 'Name'));
        }
        
        System.runAs(recruiter) {
            System.assertEquals(true, CandidateService.getIsFieldAccessible('Position__c', 'Min_Salary__c'));
            System.assertEquals(true, CandidateService.getIsFieldAccessible('Position__c', 'Name'));
        }
    }
}