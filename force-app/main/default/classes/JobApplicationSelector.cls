public class JobApplicationSelector {

    public static Integer selectCountByCandidateId(Id candidateId) {
        String q = 'SELECT COUNT() FROM Job_Application__c WHERE Candidate__c =: candidateId';
        return Database.countQuery(q);
    }

    public static List<Job_Application__c> selectByCandidateIdWithLimitAndOffset(String objectName, String fieldSetName, Id candidateId, Integer limitParam, Integer offsetParam) {
        String q = 'SELECT ';
        List<Schema.FieldSetMember> jobAppModalFieldSet = CandidateSelector.readFieldSet(objectName, fieldSetName);
        for (Schema.FieldSetMember f : jobAppModalFieldSet) {
            q += f.getFieldPath() + ', ';
        }
        q += 'Id FROM Job_Application__c WHERE Candidate__c =: candidateId LIMIT :limitParam OFFSET :offsetParam';
        return Database.query(q);
    }
    
    public static List<Job_Application__c> selectByPositionId(Id recordId) {
		String q = 'SELECT Id, Candidate__c FROM Job_Application__c WHERE Position__c =: recordId';
        return Database.query(q);
    }
    
    public static List<Job_Application__c> selectByIds(Set<Id> Ids) {
		String q = 'SELECT Id, Current_reviews_amount__c, Mean_review_grade__c FROM Job_Application__c WHERE Id IN :Ids';
        return Database.query(q);
    }
}