public class JobApplicationService {

    public static List<Job_Application__c> jobAppsWithFieldsAndObjectAccess(List<Job_Application__c> jobAppsWithNotAppliedPermissions) {
        return Security.stripInaccessible(AccessType.READABLE, jobAppsWithNotAppliedPermissions, true).getRecords();
    }
    
    public static Set<Id> candidatesIds(Id recordId) {
        Set<Id> relatedCandidatesIds = new Set<Id>();
        List<Job_Application__c> relatedJobApps = JobApplicationSelector.selectByPositionId(recordId);
        for (Job_Application__c ja : relatedJobApps) {
            relatedCandidatesIds.add(ja.Candidate__c);
        }
        return relatedCandidatesIds;
    }

    public static List<Job_Application__c> jobAppsToUpdate(Set<Id> jaIds) {
        List<Job_Application__c> jobAppsToUpdate = JobApplicationSelector.selectByIds(jaIds);
    	List<AggregateResult> aggregateResults = ReviewSelector.selectByJobAppsIds(jaIds);
        Map<Id, AggregateResult> aggregateResultsMap = new Map<Id, AggregateResult>();
        for (AggregateResult ar : aggregateResults) {
            aggregateResultsMap.put((Id)ar.get('Job_Application__c'), ar);
        }
        for (Job_Application__c ja : jobAppsToUpdate) {
            ja.Current_reviews_amount__c = (Integer)aggregateResultsMap.get( ja.Id ).get('reviewsAmount');
            ja.Mean_review_grade__c = (Decimal)aggregateResultsMap.get( ja.Id ).get('meanReviewsGrade');
        }
        return jobAppsToUpdate;
    }
}