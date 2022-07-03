trigger ClosePosition on Job_Application__c (after update) {
    Set<Id> positionsIds = new Set<Id>();
    
    for (Id jobAppId : Trigger.oldMap.keySet()) {
        if (Trigger.oldMap.get( jobAppId ).JAStatus__c != 'Hired' && Trigger.newMap.get( jobAppId ).JAStatus__c == 'Hired') {
            Id positionId = Trigger.oldMap.get( jobAppId ).Position__c;
            positionsIds.add(positionId);
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