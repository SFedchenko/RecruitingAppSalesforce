public class JobApplicationSelector {
    
    public static List<Job_Application__c> selectByIds(Set<Id> Ids) {
		String q = 'SELECT Id, Current_reviews_amount__c, Mean_review_grade__c FROM Job_Application__c WHERE Id IN :Ids';
        return Database.query(q);
    }
}