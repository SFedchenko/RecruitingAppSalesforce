@isTest
private class UserSelectorTest {

    @isTest
    static void testSelectById() {
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
        
        List<User> methodUser = UserSelector.selectById(userId);
        
        Test.stopTest();
            
        System.assertEquals(se.Id, methodUser[0].ProfileId);
    }
}