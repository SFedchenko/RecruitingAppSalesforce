trigger SetPositionEndDate on Position__c (before update) {
    for (Id positionId : Trigger.oldMap.keySet()) {
        if (Trigger.oldMap.get( positionId ).Status__c != 'Closed' && Trigger.newMap.get( positionId ).Status__c == 'Closed') {
            Trigger.newMap.get( positionId ).End_Date__c = date.today();
        }
    }
}