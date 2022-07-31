@isTest
private class UserServiceTest {

    @isTest
    static void testGetUserProfileName() {
        String standardEmployeeName = 'standardemployee' + DateTime.now().getTime() + '@testorg.com';
        Profile se = [SELECT Id FROM Profile WHERE Name='Standard Employee'];
        User standardEmployee = new User(Alias = 'standt',
                          		Email = 'standardemployee@testorg.com',
                          		EmailEncodingKey = 'UTF-8',
                          		LastName = 'Testing',
                          		LanguageLocaleKey = 'en_US',
                          		LocaleSidKey = 'en_US',
                          		ProfileId = se.Id,
                          		TimeZoneSidKey = 'America/Los_Angeles',
                          		UserName = standardEmployeeName);
        insert standardEmployee;
        
        Id userId = standardEmployee.Id;
        
        Test.startTest();
        
        String methodUserProfileName = UserService.getUserProfileName(userId);
        
        Test.stopTest();
            
        System.assertEquals('Standard Employee', methodUserProfileName);
    }
    
    @isTest
    static void testSelectByAssigneeId() {
        String standardEmployeeName = 'standardemployee' + DateTime.now().getTime() + '@testorg.com';
        Profile se = [SELECT Id FROM Profile WHERE Name='Standard Employee'];
        User standardEmployee = new User(Alias = 'standt',
                          		Email = 'standardemployee@testorg.com',
                          		EmailEncodingKey = 'UTF-8',
                          		LastName = 'Testing',
                          		LanguageLocaleKey = 'en_US',
                          		LocaleSidKey = 'en_US',
                          		ProfileId = se.Id,
                          		TimeZoneSidKey = 'America/Los_Angeles',
                          		UserName = standardEmployeeName);
        insert standardEmployee;
        
        Id userId = standardEmployee.Id;
        
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Interviewer'];
		insert new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = ps.Id);
        
        Test.startTest();
        
        Set<String> methodPermissionSetNames = UserService.getUserPermissionSetsNames(userId);
        
        Test.stopTest();
        
        System.assertEquals(true, methodPermissionSetNames.contains('Interviewer'));
    }
}