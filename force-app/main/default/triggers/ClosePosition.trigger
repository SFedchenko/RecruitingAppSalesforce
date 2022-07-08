trigger ClosePosition on Job_Application__c (after update) {
    Set<Id> positionsIds = new Set<Id>();
    Job_Application__c oldJobApp;

    for (Job_Application__c newJobApp : Trigger.New) {
        oldJobApp = Trigger.oldMap.get(newJobApp.Id);
        if (oldJobApp.JAStatus__c != 'Hired' && newJobApp.JAStatus__c == 'Hired') {
            positionsIds.add(newJobApp.Position__c);
        }
    }
    
    if (positionsIds.size() > 0) {
        List<Position__c> positionsToUpdate = PositionSelector.selectByIds(positionsIds);
        for (Position__c p : positionsToUpdate) {
            p.Status__c = 'Closed';
        }
        update positionsToUpdate;
    }
}