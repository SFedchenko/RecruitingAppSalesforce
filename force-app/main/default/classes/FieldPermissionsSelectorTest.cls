@isTest
private class FieldPermissionsSelectorTest {

    @isTest
    static void testSelectByObjectAndProfile() {
        
        Test.startTest();
        
        List<FieldPermissions> testFieldPermissionsForRecruiter = FieldPermissionsSelector.selectByObjectAndProfile('Candidate__c', 'Recruiter');
        
        Test.stopTest();
        
        System.assertEquals(8, testFieldPermissionsForRecruiter.size());
    }
    
    @isTest
    static void testSelectByObjectAndPermissionSet() {
        
        Test.startTest();
        
        List<FieldPermissions> testFieldPermissionsForInterviewer = FieldPermissionsSelector.selectByObjectAndPermissionSet('Candidate__c', 'Interviewer');
        
        Test.stopTest();
        
        System.assertEquals(6, testFieldPermissionsForInterviewer.size());
    }
}