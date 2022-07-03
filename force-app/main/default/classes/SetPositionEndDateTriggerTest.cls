@isTest
private class SetPositionEndDateTriggerTest {

    @isTest
    static void testSetPositionEndDateTrigger() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 2);
        Set<Id> testPositionsIds = new Set<Id>();
        for (Position__c testPosition : testPositionsWithStatusOpen) {
            testPosition.Status__c = 'Closed';
            Id testPositionId = testPosition.Id;
            testPositionsIds.add(testPositionId);
        }
        update testPositionsWithStatusOpen;
        
        Test.startTest();
        
        List<Position__c> positionsAfterUpdate = [SELECT Id, End_Date__c FROM Position__c WHERE Id IN :testPositionsIds];
        
        Test.stopTest();
        
        System.assertEquals(Date.today(), positionsAfterUpdate[0].End_Date__c);
        System.assertEquals(Date.today(), positionsAfterUpdate[1].End_Date__c);
    }
}