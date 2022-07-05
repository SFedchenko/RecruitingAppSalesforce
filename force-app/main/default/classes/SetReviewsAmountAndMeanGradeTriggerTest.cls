@isTest
private class SetReviewsAmountAndMeanGradeTriggerTest {

    @isTest
    static void testSetReviewsAmountAndMeanGradeTriggerInsert() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 1);
        Id positionId = testPositionsWithStatusOpen[0].Id;
        
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(2);
        Set<Id> candidatesIds = new Set<Id>();
        for (Candidate__c testCandidate : testCandidates) {
            candidatesIds.add(testCandidate.Id);
        }
        
        List<Job_Application__c> testJobApps = TestFactory.generateJobApplications(positionId, candidatesIds);
        Set<Id> jobAppsIds = new Set<Id>();
        for (Job_Application__c testJobApp : testJobApps) {
            jobAppsIds.add(testJobApp.Id);
        }
        
        Test.startTest();
        
        List<Review__c> testReviews = TestFactory.generateReviews(jobAppsIds, 90, 2);
        List<Job_Application__c> jobAppsAfterInsert = [SELECT Id, Current_reviews_amount__c, Mean_review_grade__c FROM Job_Application__c];
        
        Test.stopTest();
        
        System.assertEquals (2, jobAppsAfterInsert[0].Current_reviews_amount__c);
        System.assertEquals (90, jobAppsAfterInsert[0].Mean_review_grade__c);
        System.assertEquals (2, jobAppsAfterInsert[1].Current_reviews_amount__c);
        System.assertEquals (90, jobAppsAfterInsert[1].Mean_review_grade__c);
    }
    
    @isTest
    static void testSetReviewsAmountAndMeanGradeTriggerGradeUpdate() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 1);
        Id positionId = testPositionsWithStatusOpen[0].Id;
        
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(2);
        Set<Id> candidatesIds = new Set<Id>();
        for (Candidate__c testCandidate : testCandidates) {
            candidatesIds.add(testCandidate.Id);
        }
        
        List<Job_Application__c> testJobApps = TestFactory.generateJobApplications(positionId, candidatesIds);
        Set<Id> jobAppsIds = new Set<Id>();
        for (Job_Application__c testJobApp : testJobApps) {
            jobAppsIds.add(testJobApp.Id);
        }
        
        List<Review__c> testReviews = TestFactory.generateReviews(jobAppsIds, 90, 2);
        
        testReviews[0].Grade__c = 100;
        testReviews[1].Grade__c = 100;
        testReviews[2].Grade__c = 100;
        testReviews[3].Grade__c = 100;
        
        Test.startTest();
        
        update testReviews;
        List<Job_Application__c> jobAppsAfterUpdate = [SELECT Id, Current_reviews_amount__c, Mean_review_grade__c FROM Job_Application__c];
        
        Test.stopTest();
        
        System.assertEquals (2, jobAppsAfterUpdate[0].Current_reviews_amount__c);
        System.assertEquals (100, jobAppsAfterUpdate[0].Mean_review_grade__c);
        System.assertEquals (2, jobAppsAfterUpdate[1].Current_reviews_amount__c);
        System.assertEquals (100, jobAppsAfterUpdate[1].Mean_review_grade__c);
    }
    
    @isTest
    static void testSetReviewsAmountAndMeanGradeTriggerJobAppIdUpdate() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 1);
        Id positionId = testPositionsWithStatusOpen[0].Id;
        
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(2);
        Set<Id> candidatesIds = new Set<Id>();
        for (Candidate__c testCandidate : testCandidates) {
            candidatesIds.add(testCandidate.Id);
        }
        
        List<Job_Application__c> testJobApps = TestFactory.generateJobApplications(positionId, candidatesIds);
        Set<Id> jobAppsIds = new Set<Id>();
        for (Job_Application__c testJobApp : testJobApps) {
            jobAppsIds.add(testJobApp.Id);
        }
        
        List<Review__c> testReviews = TestFactory.generateReviews(jobAppsIds, 90, 2);
        
        testReviews[1].Job_Application__c = testReviews[2].Job_Application__c;
        
        Test.startTest();
        
        update testReviews;
        List<Job_Application__c> jobAppsAfterUpdate = [SELECT Id, Current_reviews_amount__c, Mean_review_grade__c FROM Job_Application__c];
        
        Test.stopTest();
        
        System.assertEquals (1, jobAppsAfterUpdate[0].Current_reviews_amount__c);
        System.assertEquals (90, jobAppsAfterUpdate[0].Mean_review_grade__c);
        System.assertEquals (3, jobAppsAfterUpdate[1].Current_reviews_amount__c);
        System.assertEquals (90, jobAppsAfterUpdate[1].Mean_review_grade__c);
    }
}