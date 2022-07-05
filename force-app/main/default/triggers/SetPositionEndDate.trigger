trigger SetPositionEndDate on Position__c (before update) {
    Position__c oldP;
    for (Position__c newP : Trigger.New) {
        oldP = Trigger.oldMap.get(newP.Id);
        if (oldP.Status__c != 'Closed' && newP.Status__c == 'Closed') {
            newP.End_Date__c = date.today();
        }
    }
}