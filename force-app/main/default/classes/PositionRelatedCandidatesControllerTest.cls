@isTest
private class PositionRelatedCandidatesControllerTest {

    @isTest
    static void testGetCandidatesWrapperAsRecruiter() {
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
        insert recruiter;
        Id userId = recruiter.Id;
        
        System.runAs(recruiter) {
            Test.startTest();
        	
            PositionRelatedCandidatesLwcController.CandidatesWrapper testCandidatesWrapper = PositionRelatedCandidatesLwcController.getCandidatesWrapper(userId, positionId, 3, 0);
        
        	Test.stopTest();
            
            System.assertEquals(2, testCandidatesWrapper.candidatesAmount);
            System.assertEquals(2, testCandidatesWrapper.candidateTileRecords.size());
            System.assertEquals(2, testCandidatesWrapper.candidateModalRecords.size());
            System.assertEquals(
                ( (SObject)Type.forName('Candidate__c').newInstance() ).getSObjectType().getDescribe().FieldSets.getMap().get('recruiterCandidateTileFieldSet').getFields().size(),
                testCandidatesWrapper.candidateTileFieldsData.size()
            );
            System.assertEquals(
                ( (SObject)Type.forName('Candidate__c').newInstance() ).getSObjectType().getDescribe().FieldSets.getMap().get('recruiterCandidateModalFieldSet').getFields().size(),
                testCandidatesWrapper.candidateModalFieldsData.size()
            );
        }
    }
    
    @isTest
    static void testGetCandidatesWrapperAsInterviewer() {
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        User interviewer;
        Id positionId;
        
        System.runAs (thisUser) {
        
            List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 1);
            positionId = testPositionsWithStatusOpen[0].Id;
            
            List<Candidate__c> testCandidates = TestFactory.generateCandidates(2);
            Set<Id> candidatesIds = new Set<Id>();
            for (Candidate__c testCandidate : testCandidates) {
                candidatesIds.add(testCandidate.Id);
            }
            
            List<Job_Application__c> testJobApps = TestFactory.generateJobApplications(positionId, candidatesIds);
            Set<Id> testJobAppsIds = new Set<Id>();
            for (Job_Application__c jobApp : testJobApps) {
                testJobAppsIds.add(jobApp.Id);
            }
            
            String interviewerName = 'interviewer' + DateTime.now().getTime() + '@testorg.com';
            Profile se = [SELECT Id FROM Profile WHERE Name='Standard Employee'];
            interviewer = new User(Alias = 'standt',
                                   Email = 'standardemployee@testorg.com',
                                   EmailEncodingKey = 'UTF-8',
                                   LastName = 'Testing',
                                   LanguageLocaleKey = 'en_US',
                                   LocaleSidKey = 'en_US',
                                   ProfileId = se.Id,
                                   TimeZoneSidKey = 'America/Los_Angeles',
                                   UserName = interviewerName);
            insert interviewer;
            Id userId = interviewer.Id;
            PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Interviewer'];
            insert new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = ps.Id);
        }
        
        System.runAs(interviewer) {
            Test.startTest();
        	
            PositionRelatedCandidatesLwcController.CandidatesWrapper testCandidatesWrapper = PositionRelatedCandidatesLwcController.getCandidatesWrapper(interviewer.Id, positionId, 3, 0);
        
        	Test.stopTest();
            
            System.assertEquals(2, testCandidatesWrapper.candidatesAmount);
            System.assertEquals(2, testCandidatesWrapper.candidateTileRecords.size());
            System.assertEquals(2, testCandidatesWrapper.candidateModalRecords.size());
            System.assertEquals(
                ( (SObject)Type.forName('Candidate__c').newInstance() ).getSObjectType().getDescribe().FieldSets.getMap().get('interviewerCandidateTileFieldSet').getFields().size(),
                testCandidatesWrapper.candidateTileFieldsData.size()
            );
            System.assertEquals(
                ( (SObject)Type.forName('Candidate__c').newInstance() ).getSObjectType().getDescribe().FieldSets.getMap().get('interviewerCandidateModalFieldSet').getFields().size(),
                testCandidatesWrapper.candidateModalFieldsData.size()
            );
        }
    }
    
    @isTest
    static void testGetColumnsForDatatable() {
        Test.startTest();
        	
        List<PositionRelatedCandidatesLwcController.ColumnsForDatatable> testColumnsForDatatable = PositionRelatedCandidatesLwcController.getColumnsForDatatable('Job_Application__c', 'JobAppModalFieldSet');
        
        Test.stopTest();
        
        System.assertEquals(
            ( (SObject)Type.forName('Job_Application__c').newInstance() ).getSObjectType().getDescribe().FieldSets.getMap().get('JobAppModalFieldSet').getFields().size(),
            testColumnsForDatatable.size());
    }
    
    @isTest
    static void testGetJobAppsWrapper() {
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
        
        System.runAs(recruiter) {
            Test.startTest();
        	
            PositionRelatedCandidatesLwcController.JobAppsWrapper testJobAppsWrapper = PositionRelatedCandidatesLwcController.getJobAppsWrapper(testCandidates[0].Id, 3, 0);
        
        	Test.stopTest();
            
            System.assertEquals(1, testJobAppsWrapper.jobAppsAmount);
            System.assertEquals(1, testJobAppsWrapper.jobAppsRecords.size());
            System.assertEquals(
                ( (SObject)Type.forName('Job_Application__c').newInstance() ).getSObjectType().getDescribe().FieldSets.getMap().get('JobAppModalFieldSet').getFields().size(),
                testJobAppsWrapper.columns.size()
            );
        }
    }
}