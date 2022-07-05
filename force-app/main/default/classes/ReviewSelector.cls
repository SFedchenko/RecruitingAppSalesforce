public class ReviewSelector {
    
    public static List<AggregateResult> selectByJobAppsIds(Set<Id> Ids) {
		String q = 'SELECT Job_Application__c, COUNT(Id)reviewsAmount, AVG(Grade__c)meanReviewsGrade FROM Review__c WHERE Job_Application__c IN :Ids GROUP BY Job_Application__c';
        return Database.query(q);
    }
}