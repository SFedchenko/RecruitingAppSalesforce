trigger SetReviewsAmountAndMeanGrade on Review__c (after insert, after update) {
    
    Set<Id> jaIds = new Set<Id>();
    
    if (Trigger.isInsert) {
        
    	for (Review__c r : Trigger.New) {
            Id jaId = r.Job_Application__c;
            jaIds.add(jaId);
        }
        
    	List<Job_Application__c> jobAppsToUpdate = JobApplicationService.jobAppsToUpdate(jaIds);
        update jobAppsToUpdate;
    }
    
    if (Trigger.isUpdate) {
        
        for (Review__c rOld : Trigger.Old) {
            for (Review__c rNew : Trigger.New) {
                if (rOld.Grade__c != rNew.Grade__c) {
                    Id jaId = rNew.Job_Application__c;
                    jaIds.add(jaId);
                }
            }
        }
        
        if (jaIds.size() > 0) {
            List<Job_Application__c> jobAppsToUpdate = JobApplicationService.jobAppsToUpdate(jaIds);
            update jobAppsToUpdate;
        }
    }
}