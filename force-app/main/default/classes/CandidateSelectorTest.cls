@isTest
private class CandidateSelectorTest {

    @isTest
    static void testGetAllFieldSetNames() {
        System.assertEquals(
            CandidateSelector.getAllFieldSetNames('Candidate__c'),
            ( (SObject)Type.forName('Candidate__c').newInstance() ).getSObjectType().getDescribe().FieldSets.getMap().keySet());
    }
    
    @isTest
    static void testSelectByIdsWithLimitAndOffset() {
        
        List<Candidate__c> testCandidates = TestFactory.generateCandidates(2);
        Set<Id> candidatesIds = new Set<Id>();
        for (Candidate__c testCandidate : testCandidates) {
            candidatesIds.add(testCandidate.Id);
        }
        Set<String> fieldsForQuery = new Set<String>{'Email__c'};
        
        Test.startTest();
        
        List<Candidate__c> methodCandidates = CandidateSelector.selectByIdsWithLimitAndOffset(fieldsForQuery, candidatesIds, 2, 0);
        
        Test.stopTest();
        
        System.assertEquals (2, methodCandidates.size());
        System.assertEquals (testCandidates[0].Email__c, methodCandidates[0].Email__c);
        System.assertEquals (testCandidates[1].Email__c, methodCandidates[1].Email__c);
    }
    
    @isTest
    static void testReadFieldSet() {
        System.assertEquals(
            CandidateSelector.readFieldSet('Candidate__c', 'CandidateTileFieldSet').size(),
            ( (SObject)Type.forName('Candidate__c').newInstance() ).getSObjectType().getDescribe().FieldSets.getMap().get('CandidateTileFieldSet').getFields().size());
    }
}