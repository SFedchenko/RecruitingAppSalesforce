@isTest
private class PositionSelectorTest {

    @isTest
    static void testSelectByIds() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 2);
        Set<Id> Ids = new Set<Id>();
        for (Position__c testPosition : testPositionsWithStatusOpen) {
            Id testId = testPosition.Id;
            Ids.add(testId);
        }
        
        Test.startTest();
        
        List<Position__c> methodPositionsListWithStatusOpen = PositionSelector.selectByIds(Ids);
        
        Test.stopTest();
        
        System.assertEquals (testPositionsWithStatusOpen.size(), methodPositionsListWithStatusOpen.size());
    }

    @isTest
    static void testSelectByStatus() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 2);
        
        Test.startTest();
        
        List<Position__c> methodPositionsListWithStatusOpen = PositionSelector.selectByStatus('Open');
        
        Test.stopTest();
        
        System.assertEquals (testPositionsWithStatusOpen.size(), methodPositionsListWithStatusOpen.size());
    }
    
    @isTest
    static void testSelectByStatusWithLimitAndOffset() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 2);
        
        Test.startTest();
        
        List<Position__c> methodPositionsListWithStatusOpen = PositionSelector.selectByStatusWithLimitAndOffset('Open', 2, 0);
        
        Test.stopTest();
        
        System.assertEquals (testPositionsWithStatusOpen.size(), methodPositionsListWithStatusOpen.size());
    }
    
    @isTest
    static void testSelectAmountByStatus() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 2);
        
        Test.startTest();
        
        Integer methodPositionsAmountWithStatusOpen = PositionSelector.selectAmountByStatus('Open');
        
        Test.stopTest();
        
        System.assertEquals (testPositionsWithStatusOpen.size(), methodPositionsAmountWithStatusOpen);
    }
}