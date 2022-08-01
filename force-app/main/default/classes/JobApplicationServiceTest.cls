@isTest
private class JobApplicationServiceTest {
	
    @isTest
    static void testCandidatesIds() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 1);
        Id positionId = testPositionsWithStatusOpen[0].Id;
        
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(2);
        Set<Id> candidatesIds = new Set<Id>();
        for (Candidate__c testCandidate : testCandidates) {
            candidatesIds.add(testCandidate.Id);
        }
        
        List<Job_Application__c> testJobApps = TestFactory.generateJobApplications(positionId, candidatesIds);
        
        Test.startTest();
        
        Set<Id> methodCandidatesIds = JobApplicationService.candidatesIds(positionId);
        
        Test.stopTest();
        
        System.assertEquals (candidatesIds, methodCandidatesIds);
    }
    
    @isTest
    static void testNegativeJobAppsWithFieldsAndObjectAccess() {
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 1);
        Id positionId = testPositionsWithStatusOpen[0].Id;
        
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(2);
        Set<Id> candidatesIds = new Set<Id>();
        for (Candidate__c testCandidate : testCandidates) {
            candidatesIds.add(testCandidate.Id);
        }
        
        List<Job_Application__c> testJobApps = TestFactory.generateJobApplications(positionId, candidatesIds);
        
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

        List<Job_Application__c> methodJobApps = new List<Job_Application__c>();
        Boolean accessEntity;
        
        System.runAs(standardEmployee) {
            Test.startTest();
        
            try {
        		methodJobApps = JobApplicationService.jobAppsWithFieldsAndObjectAccess(testJobApps);
            } catch (Exception e) {
                accessEntity = e.getMessage().contains('No access to entity');
            }
        
        	Test.stopTest();
            
            System.assertEquals(true, accessEntity);
        }
    }
    
    @isTest
    static void testPositiveJobAppsWithFieldsAndObjectAccess() {
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 1);
        Id positionId = testPositionsWithStatusOpen[0].Id;
        
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(2);
        Set<Id> candidatesIds = new Set<Id>();
        for (Candidate__c testCandidate : testCandidates) {
            candidatesIds.add(testCandidate.Id);
        }
        
        List<Job_Application__c> testJobApps = TestFactory.generateJobApplications(positionId, candidatesIds);
        
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
        
        List<Job_Application__c> methodJobApps = new List<Job_Application__c>();
        Boolean accessEntity;
		
        System.runAs(recruiter) {
            Test.startTest();
        
        	methodJobApps = JobApplicationService.jobAppsWithFieldsAndObjectAccess(testJobApps);
        
        	Test.stopTest();
            
            System.assertEquals(2, methodJobApps.size());
        }
    }
}