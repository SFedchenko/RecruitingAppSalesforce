@isTest
private class ReviewSelectorTest {
	
    @isTest
    static void testSelectByJobAppsIds() {
        
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
        
        List<Review__c> testReviews = TestFactory.generateReviews(testJobAppsIds, 90, 2);
        
        Test.startTest();
        
        List<AggregateResult> methodAggregateResults = ReviewSelector.selectByJobAppsIds(testJobAppsIds);
        Integer reviewsAmountForJobApp0 = (Integer)methodAggregateResults[0].get('reviewsAmount');
        Decimal meanReviewsGradeForJobApp0 = (Decimal)methodAggregateResults[0].get('meanReviewsGrade');
        
        Test.stopTest();
        
        System.assertEquals (2, reviewsAmountForJobApp0);
        System.assertEquals (90, meanReviewsGradeForJobApp0);
    }
}