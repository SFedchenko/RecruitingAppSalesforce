@isTest
private class PositionListVFControllerTest {
    @isTest
    static void testApplyFilterForExistingPositions() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 3);
        
        Test.startTest();
        
        PageReference pageRef = Page.AllPositions;
        Test.setCurrentPage(pageRef);
        PositionListVFController testController = new PositionListVFController();
        testController.selectedStatusFilterOption = 'Open';
        testController.applyFilter();
        List<Position__c> methodSelectedPositionsList = testController.selectedPositionsList;
        
        Test.stopTest();
        
        System.assertEquals (testPositionsWithStatusOpen.size(), methodSelectedPositionsList.size());
    }
    
    @isTest
    static void testApplyFilterForNotExistingPositions() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 3);
        
        Test.startTest();
        
        PageReference pageRef = Page.AllPositions;
        Test.setCurrentPage(pageRef);
        PositionListVFController testController = new PositionListVFController();
        testController.selectedStatusFilterOption = 'Closed';
        testController.applyFilter();
        List<Position__c> methodSelectedPositionsList = testController.selectedPositionsList;
        
        Test.stopTest();
        
        System.assertEquals (0, methodSelectedPositionsList.size());
        
    }
    
    @isTest
    static void testApplyFilterMessage() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 3);
        
        Test.startTest();
        
        PageReference pageRef = Page.AllPositions;
        Test.setCurrentPage(pageRef);
        PositionListVFController testController = new PositionListVFController();
        testController.selectedStatusFilterOption = 'Closed';
        testController.applyFilter();
        
        Boolean check = false;
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        for(ApexPages.Message msg : pageMessages){
            if (msg.getDetail().contains('There are no positions with status "Closed"')) {
                check = true;                
            }else{
                check = false;
            }
        }
        
        Test.stopTest();
        
        System.assertEquals(true, check);
    }
    
    @isTest
    static void testSave() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 3);
        
        Test.startTest();
        
        PageReference pageRef = Page.AllPositions;
        Test.setCurrentPage(pageRef);
        PositionListVFController testController = new PositionListVFController();
        testController.selectedStatusFilterOption = 'Open';
        testController.applyFilter();
        List<Position__c> methodSelectedPositionsList = testController.selectedPositionsList;
        Position__c anyPosition = methodSelectedPositionsList[0];
        anyPosition.Status__c = 'Closed';
        testController.save();
        testController.selectedStatusFilterOption = 'Closed';
        testController.applyFilter();
        List<Position__c> methodSelectedPositionsList2 = testController.selectedPositionsList;
        
        Test.stopTest();
        
        System.assertEquals (1, methodSelectedPositionsList2.size());
    }
    
    @isTest
    static void testChangesSavedMessage() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 3);
        
        Test.startTest();
        
        PageReference pageRef = Page.AllPositions;
        Test.setCurrentPage(pageRef);
        PositionListVFController testController = new PositionListVFController();
        testController.selectedStatusFilterOption = 'Open';
        testController.applyFilter();
        List<Position__c> methodSelectedPositionsList = testController.selectedPositionsList;
        Position__c anyPosition = methodSelectedPositionsList[0];
        anyPosition.Status__c = 'Closed';
        testController.save();
        
        Boolean check = false;
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        for(ApexPages.Message msg : pageMessages){
            if (msg.getDetail().contains('Changes were saved successfully')) {
                check = true;
            }else{
                check = false;
            }
        }
        
        Test.stopTest();
        
        System.assertEquals (true, check);
    }
    
    @isTest
    static void testUpdatindRecordsErrorMessage() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 3);
        
        Test.startTest();
        
        PageReference pageRef = Page.AllPositions;
        Test.setCurrentPage(pageRef);
        PositionListVFController testController = new PositionListVFController();
        testController.selectedStatusFilterOption = 'Open';
        testController.applyFilter();
        List<Position__c> methodSelectedPositionsList = testController.selectedPositionsList;
        Position__c anyPosition = methodSelectedPositionsList[0];
        anyPosition.Status__c = 'AnyStatus';
        testController.save();
        
        Boolean check = false;
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        for(ApexPages.Message msg : pageMessages){
            if (msg.getDetail().contains('There was an error during updating records')) {
                check = true;
            }else{
                check = false;
            }
        }
        
        Test.stopTest();
        
        System.assertEquals (true, check);
    }
    
    @isTest
    static void testNoPositionsWithStatusMessage() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 3);
        
        Test.startTest();
        
        PageReference pageRef = Page.AllPositions;
        Test.setCurrentPage(pageRef);
        PositionListVFController testController = new PositionListVFController();
        testController.selectedStatusFilterOption = 'Closed';
        testController.applyFilter();
        
        Boolean check = false;
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        for(ApexPages.Message msg : pageMessages){
            if (msg.getDetail().contains('There are no positions with status "Closed"')) {
                check = true;
            }else{
                check = false;
            }
        }
        
        Test.stopTest();
        
        System.assertEquals (true, check);
        System.assertEquals (false, testController.showTable);
    }
}