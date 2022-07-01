trigger ClosePosition on Job_Application__c (after update) {
    Set<Id> positionsIds = new Set<Id>();
    for (Job_Application__c ja : Trigger.Old) {
        if (ja.JAStatus__c != 'Hired') {
            for (Job_Application__c jobApp : Trigger.New) {
                if (jobApp.JAStatus__c == 'Hired') {
                    positionsIds.add(jobApp.Position__c);
                }
            }
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