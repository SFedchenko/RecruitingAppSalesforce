@isTest
private class PositionListLwcControllerTest {
    
	@isTest
    static void testGetPositions() {
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 2);
        List<Position__c> testPositionsWithStatusClosed = TestFactory.generatePositions('Closed', 2);
        
        Test.startTest();
        
        List<Position__c> methodPositionsListWithStatusOpen = PositionListLwcController.getPositions('Open', 2, 0);
        List<Position__c> methodPositionsListWithStatusAll = PositionListLwcController.getPositions('All', 4, 0);
        
        Test.stopTest();
        
        System.assertEquals (testPositionsWithStatusOpen.size(), methodPositionsListWithStatusOpen.size());
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
        
        System.assertEquals (testPositionsWithStatusOpen.size(), methodPositionsWrapper.positionsRecords.size());
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
    
    @isTest
    static void testPermissions() {
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 2);
        
        String uniqueUserName = 'standardemployee' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard Employee'];
        User u = new User(Alias = 'standt',
                          Email = 'standardemployee@testorg.com',
                          EmailEncodingKey = 'UTF-8',
                          LastName = 'Testing',
                          LanguageLocaleKey = 'en_US',
                          LocaleSidKey = 'en_US',
                          ProfileId = p.Id,
                          TimeZoneSidKey = 'America/Los_Angeles',
                          UserName = uniqueUserName);
        
        System.runAs(u) {
            
            Test.startTest();
            
            List<Position__c> methodPositionsListWithStatusOpen = PositionListLwcController.getPositions('Open', 2, 0);
            Position__c position0 = methodPositionsListWithStatusOpen[0];
            Boolean minSalaryIsSet = position0.isSet('Min_Salary__c');
            Boolean maxSalaryIsSet = position0.isSet('Max_Salary__c');
            
            Test.stopTest();
        
        	System.assertEquals (false, minSalaryIsSet);
            System.assertEquals (false, maxSalaryIsSet);
        }
    }
}