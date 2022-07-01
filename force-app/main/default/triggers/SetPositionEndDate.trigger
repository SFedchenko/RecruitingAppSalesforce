trigger SetPositionEndDate on Position__c (before update) {
	for (Position__c p : Trigger.Old) {
        if (p.Status__c != 'Closed') {
            for (Position__c pos : Trigger.New) {
                if (p.Id == pos.Id && pos.Status__c == 'Closed') {
                    pos.End_Date__c = date.today();
                }
            }
        }
    }
}