@isTest
private class ClosePositionTriggerTest {

    @isTest
    static void testClosePositionTrigger() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 1);
        Id positionId = testPositionsWithStatusOpen[0].Id;
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(2);
        Set<Id> candidatesIds = new Set<Id>();
        for (Candidate__c testCandidate : testCandidates) {
            Id candidateId = testCandidate.Id;
            candidatesIds.add(candidateId);
        }
        List<Job_Application__c> testJobApps = TestFactory.generateJobApplications(positionId, candidatesIds);
        testJobApps[0].JAStatus__c = 'Hired';
        update testJobApps;
        
        Test.startTest();
        
        List<Position__c> positionsAfterUpdate = [SELECT Id, Status__c FROM Position__c];
        
        Test.stopTest();
        
        System.assertEquals ('Closed', positionsAfterUpdate[0].Status__c);
    }
}