public class JobApplicationService {

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