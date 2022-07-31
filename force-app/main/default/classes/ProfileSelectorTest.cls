@isTest
private class ProfileSelectorTest {

    @isTest
    static void testSelectById() {
        Profile se = [SELECT Id FROM Profile WHERE Name='Standard Employee'];
        
        Test.startTest();
        
        List<Profile> methodProfile = ProfileSelector.selectById(se.Id);
        
        Test.stopTest();
            
        System.assertEquals('Standard Employee', methodProfile[0].Name);
    }
}