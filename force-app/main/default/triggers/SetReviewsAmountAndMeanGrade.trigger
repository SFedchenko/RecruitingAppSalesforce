trigger SetReviewsAmountAndMeanGrade on Review__c (after insert, after update) {
    Set<Id> jaIds = new Set<Id>();
    Review__c oldR;
    
    if (Trigger.isInsert) {
        
    	for (Review__c r : Trigger.New) {
            jaIds.add(r.Job_Application__c);
        }
        
    	List<Job_Application__c> jobAppsToUpdate = JobApplicationService.jobAppsToUpdate(jaIds);
        update jobAppsToUpdate;
    }
    
    if (Trigger.isUpdate) {
        
        for (Review__c newR : Trigger.New) {
            oldR = Trigger.oldMap.get(newR.Id);
            if (oldR.Grade__c != newR.Grade__c || oldR.Job_Application__c != newR.Job_Application__c) {
                jaIds.add(oldR.Job_Application__c);
                jaIds.add(newR.Job_Application__c);
            }
        }
        
        if (jaIds.size() > 0) {
            List<Job_Application__c> jobAppsToUpdate = JobApplicationService.jobAppsToUpdate(jaIds);
            update jobAppsToUpdate;
        }
    }
}