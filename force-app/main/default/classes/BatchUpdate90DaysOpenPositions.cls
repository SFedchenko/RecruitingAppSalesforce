public class BatchUpdate90DaysOpenPositions implements
    Database.Batchable<sObject>, Database.Stateful {
    
    public Integer recordsProcessed = 0;
        
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String status = 'Open';
        String q = 'SELECT Id, Status__c FROM Position__c WHERE Status__c = \'' + String.escapeSingleQuotes(status) + '\' AND Start_Date__c < LAST_N_DAYS:89';
        return Database.getQueryLocator(q);
    }
        
    public void execute(Database.BatchableContext bc, List<Position__c> positionsScope){
        for (Position__c p : positionsScope) {
            p.Status__c = 'Archived';
            recordsProcessed++;
        }
        update positionsScope;
    }
        
    public void finish(Database.BatchableContext bc){
        if (recordsProcessed == 1) {
            System.debug('1 position updated.');
        } else {
        	System.debug(recordsProcessed + ' positions updated.');
        }
    }
}