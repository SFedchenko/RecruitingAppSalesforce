@isTest
public class PositionListLwcControllerTest {
    
	@isTest
    static void testGetPositions() {
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 2);
        List<Position__c> testPositionsWithStatusClosed = TestFactory.generatePositions('Closed', 2);
        
        Test.startTest();
        
        List<Position__c> methodPositionsListWithStatusOpen = PositionListLwcController.getPositions('Open', 2, 0);
        List<Position__c> methodPositionsListWithStatusAll = PositionListLwcController.getPositions('All', 4, 0);
        
        Test.stopTest();
        
        System.assertEquals (testPositionsWithStatusOpen, methodPositionsListWithStatusOpen);
        System.assertEquals(4, methodPositionsListWithStatusAll.size());
    }
    
    @isTest
    static void testGetPositionsAmount() {
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 2);
        List<Position__c> testPositionsWithStatusClosed = TestFactory.generatePositions('Closed', 2);
        
        Test.startTest();
        
        Integer methodPositionsAmountWithStatusOpen = PositionListLwcController.getPositionsAmount('Open');
        Integer methodPositionsAmountWithStatusAll = PositionListLwcController.getPositionsAmount('All');
        
        Test.stopTest();
        
        System.assertEquals (2, methodPositionsAmountWithStatusOpen);
        System.assertEquals(4, methodPositionsAmountWithStatusAll);
    }
    
    @isTest
    static void testGetPositionsWrapper() {
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 2);
        
        Test.startTest();
        
        PositionListLwcController.PositionsWrapper methodPositionsWrapper = PositionListLwcController.getPositionsWrapper('Open', 2, 0);
        
        Test.stopTest();
        
        System.assertEquals (testPositionsWithStatusOpen, methodPositionsWrapper.positionsRecords);
        System.assertEquals (2, methodPositionsWrapper.positionsAmount);
    }
    
    @isTest
    static void testUpdatePositions() {
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 2);
        List<Position__c> testPositionsWithStatusClosed = TestFactory.generatePositions('Closed', 2);
        
        Test.startTest();
        
        List<Position__c> methodPositionsListWithStatusOpen = PositionListLwcController.getPositions('Open', 2, 0);
        List<Position__c> methodPositionsListWithStatusClosed = PositionListLwcController.getPositions('Closed', 2, 0);
        methodPositionsListWithStatusOpen[1].Status__c = 'Closed';
        methodPositionsListWithStatusClosed[1].Status__c = 'AnyStatus';
        String methodMessageFromTryBlock = PositionListLwcController.updatePositions(methodPositionsListWithStatusOpen);
        String methodMessageFromCatchBlock = PositionListLwcController.updatePositions(methodPositionsListWithStatusClosed);
        
        Test.stopTest();
        
        System.assertEquals ('Success', methodMessageFromTryBlock);
        System.assertEquals ('Error', methodMessageFromCatchBlock);
    }
}