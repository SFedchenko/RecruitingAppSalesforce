@isTest
private class Update90DaysOpenPositionsTest {

    @isTest
    static void testScheduledJob() {
        
        List<Position__c> testPositions = TestFactory.generatePositions('Open', 2);
        for (Position__c p : testPositions) {
            p.Start_Date__c = Date.today().addDays(-90);
        }
        update testPositions;
        String CRON_EXP = '0 0 0 7 7 ? 2022';
        
        Test.startTest();
        
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new Update90DaysOpenPositions());
        
        Test.stopTest();
        
        List<Position__c> positionsAfterScheduledJob = [SELECT Id FROM Position__c WHERE Status__c = 'Archived'];
        
        System.assertEquals (testPositions.size(), positionsAfterScheduledJob.size());
    }
}