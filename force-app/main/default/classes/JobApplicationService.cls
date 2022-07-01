public class JobApplicationService {

    public static List<Job_Application__c> jobAppsToUpdate(Set<Id> jaIds) {
        List<Job_Application__c> jobAppsToUpdate = JobApplicationSelector.selectByIds(jaIds);
    	List<AggregateResult> aggregateResults = ReviewSelector.selectByJobAppsIds(jaIds);
        for (Job_Application__c ja : jobAppsToUpdate) {
            for (AggregateResult ar : aggregateResults) {
                if (ja.Id == (Id)ar.get('Job_Application__c')) {
                    ja.Current_reviews_amount__c = (Integer)ar.get('reviewsAmount');
                    ja.Mean_review_grade__c = (Decimal)ar.get('meanReviewsGrade');
                }
            }
        }
        return jobAppsToUpdate;
    }
}