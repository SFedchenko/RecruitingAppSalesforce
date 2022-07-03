trigger SetReviewsAmountAndMeanGrade on Review__c (after insert, after update) {
    
    Set<Id> jaIds = new Set<Id>();
    
    if (Trigger.isInsert) {
        
    	for (Review__c r : Trigger.New) {
            jaIds.add(r.Job_Application__c);
        }
        
    	List<Job_Application__c> jobAppsToUpdate = JobApplicationService.jobAppsToUpdate(jaIds);
        update jobAppsToUpdate;
    }
    
    if (Trigger.isUpdate) {
        
        for (Id reviewId : Trigger.oldMap.keySet()) {
            if (Trigger.oldMap.get( reviewId ).Grade__c != Trigger.newMap.get( reviewId ).Grade__c
                ||
                Trigger.oldMap.get( reviewId ).Job_Application__c != Trigger.newMap.get( reviewId ).Job_Application__c) {
                    jaIds.add( Trigger.oldMap.get( reviewId ).Job_Application__c );
                    jaIds.add( Trigger.newMap.get( reviewId ).Job_Application__c );
                }
        }
        
        if (jaIds.size() > 0) {
            List<Job_Application__c> jobAppsToUpdate = JobApplicationService.jobAppsToUpdate(jaIds);
            update jobAppsToUpdate;
        }
    }
}