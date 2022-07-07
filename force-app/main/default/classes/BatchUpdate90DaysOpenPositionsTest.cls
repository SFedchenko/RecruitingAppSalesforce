@isTest
private class BatchUpdate90DaysOpenPositionsTest {

    @isTest
    static void testBatchApex() {
        
        List<Position__c> testPositions = TestFactory.generatePositions('Open', 2);
        for (Position__c p : testPositions) {
            p.Start_Date__c = Date.today().addDays(-90);
        }
        update testPositions;
        
        Test.startTest();
        
        BatchUpdate90DaysOpenPositions b = new BatchUpdate90DaysOpenPositions();
        database.executebatch(b);
        
        Test.stopTest();
        
        List<Position__c> positionsAfterBatchApex = [SELECT Id FROM Position__c WHERE Status__c = 'Archived'];
        
        System.assertEquals (testPositions.size(), positionsAfterBatchApex.size());
    }
}