@isTest
private class JobApplicationSelectorTest {
	
    @isTest
    static void testSelectByIds() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 1);
        Id positionId = testPositionsWithStatusOpen[0].Id;
        
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
        
        Test.startTest();
        
        List<Job_Application__c> methodJobApps = JobApplicationSelector.selectByIds(testJobAppsIds);
        Set<Id> methodJobAppsIds = new Set<Id>();
        for (Job_Application__c jobApp : methodJobApps) {
            methodJobAppsIds.add(jobApp.Id);
        }
        
        Test.stopTest();
        
        System.assertEquals (testJobAppsIds, methodJobAppsIds);
    }
    
    @isTest
    static void testSelectByPositionId() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 1);
        Id positionId = testPositionsWithStatusOpen[0].Id;
        
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(2);
        Set<Id> candidatesIds = new Set<Id>();
        for (Candidate__c testCandidate : testCandidates) {
            candidatesIds.add(testCandidate.Id);
        }
        
        List<Job_Application__c> testJobApps = TestFactory.generateJobApplications(positionId, candidatesIds);
        
        Test.startTest();
        
        List<Job_Application__c> methodJobApps = JobApplicationSelector.selectByPositionId(positionId);
                
        Test.stopTest();
        
        System.assertEquals (testJobApps.size(), methodJobApps.size());
    }
    
    @isTest
    static void testSelectByCandidateIdWithLimitAndOffset() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 1);
        Id positionId = testPositionsWithStatusOpen[0].Id;
        
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(2);
        Set<Id> candidatesIds = new Set<Id>();
        for (Candidate__c testCandidate : testCandidates) {
            candidatesIds.add(testCandidate.Id);
        }
        
        List<Job_Application__c> testJobApps = TestFactory.generateJobApplications(positionId, candidatesIds);
        
        Test.startTest();
        
        List<Job_Application__c> methodJobApps = JobApplicationSelector.selectByCandidateIdWithLimitAndOffset('Job_Application__c', 'JobAppModalFieldSet', testCandidates[0].Id, 1, 0);
                
        Test.stopTest();
        
        System.assertEquals (1, methodJobApps.size());
    }
    
    @isTest
    static void testSelectCountByCandidateId() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 1);
        Id positionId = testPositionsWithStatusOpen[0].Id;
        
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(2);
        Set<Id> candidatesIds = new Set<Id>();
        for (Candidate__c testCandidate : testCandidates) {
            candidatesIds.add(testCandidate.Id);
        }
        
        List<Job_Application__c> testJobApps = TestFactory.generateJobApplications(positionId, candidatesIds);
        
        Test.startTest();
        
        Integer methodJobAppsAmount = JobApplicationSelector.selectCountByCandidateId(testCandidates[0].Id);
                
        Test.stopTest();
        
        System.assertEquals (1, methodJobAppsAmount);
    }
}