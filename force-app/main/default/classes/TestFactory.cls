@isTest
public class TestFactory {
    
    public static List<Position__c> generatePositions(String status, Integer amount) {
        List<Position__c> positions = new List<Position__c>();
        for (integer i = 0; i < amount; i++) {
        	Position__c pos = new Position__c();
            pos.Name = 'Position ' + i;
           	pos.Status__c = status;
           	pos.Start_Date__c = System.today();
           	pos.Min_Salary__c = 500*(1+i);
           	pos.Max_Salary__c = 1000*(1+i);
           	positions.add(pos);
        }
        insert positions;
        return positions;
    }
    
    public static List<Candidate__c> generateCandidates(Integer amount) {
        List<Candidate__c> candidates = new List<Candidate__c>();
        for (Integer i = 0; i < amount; i++) {
        	Candidate__c candidate = new Candidate__c();
        	candidate.Name = 'Candidate ' + i;
            candidate.Email__c = 'candidate' + i + '@company.name';
            candidates.add(candidate);
        }
        insert candidates;
        return candidates;
    }
    
    public static List<Job_Application__c> generateJobApplications(Id positionId, Set<Id> candidatesIds) {
        List<Job_Application__c> jobApplications = new List<Job_Application__c>();
        for (Id candidateId : candidatesIds) {
            Job_Application__c jobApp = new Job_Application__c();
            jobApp.Position__c = positionId;
            jobApp.Candidate__c = candidateId;
            jobApp.JAStatus__c = 'Under consideration';
            jobApplications.add(jobApp);
        }
        insert jobApplications;
        return jobApplications;
    }
    
    public static List<Review__c> generateReviews(Set<Id> jobAppsIds, Integer grade, Integer reviewsAmount) {
        List<Review__c> reviews = new List<Review__c>();
        for (Id jobAppId : jobAppsIds) {
            for (Integer i = 0; i < reviewsAmount; i++) {
                Review__c review = new Review__c();
                review.Job_Application__c = jobAppId;
                review.Grade__c = grade;
                reviews.add(review);
            }
        }
        insert reviews;
        return reviews;
    }
}