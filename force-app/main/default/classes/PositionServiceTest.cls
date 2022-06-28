@isTest
private class PositionServiceTest {

    @isTest
    static void testPositionFilterOptions() {
        
        List<SelectOption> methodFilterPicklistOptions = PositionService.positionFilterOptions();
        
        List<String> stringValues = new List<String>();
        for(SelectOption option : methodFilterPicklistOptions) {
            stringValues.add(option.getValue());            
        }
        Boolean exists = stringValues.contains('All');
        System.assertEquals(true, exists);
    }
    
    @isTest
    static void testPositionsWithFieldsAndObjectAccess() {
        
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
        	
        	List<Position__c> methodSelectedPositionsList = PositionService.positionsWithFieldsAndObjectAccess(testPositionsWithStatusOpen);
            Position__c position0 = methodSelectedPositionsList[0];
            Boolean minSalaryIsSet = position0.isSet('Min_Salary__c');
            Boolean maxSalaryIsSet = position0.isSet('Max_Salary__c');
        
        	Test.stopTest();
        
        	System.assertEquals (false, minSalaryIsSet);
            System.assertEquals (false, maxSalaryIsSet);
        }
    }
}