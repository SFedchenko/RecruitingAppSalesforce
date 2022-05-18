@isTest
private class PositionListControllerTest {
    
    @isTest
    static void testGetFilterPicklistOptions() {
        
        List<SelectOption> methodFilterPicklistOptions = PositionListController.getFilterPicklistOptions();
        
        List<String> stringValues = new List<String>();
        for(SelectOption option : methodFilterPicklistOptions) {
            stringValues.add(option.getValue());            
        }
        Boolean exists = stringValues.contains('All');
        System.assertEquals(true, exists);
    }
    
    @isTest
    static void testApplyFilterForExistingPositions() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 3);
        
        Test.startTest();
        
        PageReference pageRef = Page.AllPositions;
        Test.setCurrentPage(pageRef);
        PositionListController testController = new PositionListController();
        testController.selectedFilterPicklistOption = 'Open';
        testController.applyFilter();
        List<Position__c> methodSelectedPositionsList = testController.selectedPositionsList;
        
        Test.stopTest();
        
        System.assertEquals (testPositionsWithStatusOpen, methodSelectedPositionsList);
    }
    
    @isTest
    static void testApplyFilterForNotExistingPositions() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 3);
        
        Test.startTest();
        
        PageReference pageRef = Page.AllPositions;
        Test.setCurrentPage(pageRef);
        PositionListController testController = new PositionListController();
        testController.selectedFilterPicklistOption = 'Closed';
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
        PositionListController testController = new PositionListController();
        testController.selectedFilterPicklistOption = 'Closed';
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
        PositionListController testController = new PositionListController();
        testController.selectedFilterPicklistOption = 'Open';
        testController.applyFilter();
        List<Position__c> methodSelectedPositionsList = testController.selectedPositionsList;
        Position__c anyPosition = methodSelectedPositionsList[0];
        anyPosition.Status__c = 'Closed';
        testController.save();
        testController.selectedFilterPicklistOption = 'Closed';
        testController.applyFilter();
        List<Position__c> methodSelectedPositionsList2 = testController.selectedPositionsList;
        
        Test.stopTest();
        
        System.assertEquals (1, methodSelectedPositionsList2.size());
    }
    
    @isTest
    static void testSaveMessage() {
        
        List<Position__c> testPositionsWithStatusOpen = TestFactory.generatePositions('Open', 3);
        
        Test.startTest();
        
        PageReference pageRef = Page.AllPositions;
        Test.setCurrentPage(pageRef);
        PositionListController testController = new PositionListController();
        testController.selectedFilterPicklistOption = 'Open';
        testController.applyFilter();
        List<Position__c> methodSelectedPositionsList = testController.selectedPositionsList;
        Position__c anyPosition = methodSelectedPositionsList[0];
        anyPosition.Status__c = 'Closed';
        testController.save();
        
        Boolean check = false;
        ApexPages.Message[] pageMessages = ApexPages.getMessages();
        for(ApexPages.Message msg : pageMessages){
            if (msg.getDetail().contains('Changes were saved succsessfully')) {
                check = true;
            }else{
                check = false;
            }
        }
        
        Test.stopTest();
        
        System.assertEquals (true, check);
    }
}