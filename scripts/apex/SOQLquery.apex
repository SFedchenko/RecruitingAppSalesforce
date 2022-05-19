Date requiredDate = System.Today() - 7;
String profileName = 'Recruiter';
String q = 'SELECT Id, Name, Position__r.Name, Candidate__r.Name, '
            +
    		'(SELECT Name FROM Reviews__r) '
            +
            'FROM Job_Application__c '
            +
            'WHERE (CreatedDate >= :requiredDate AND Owner.Profile.Name = :profileName)';
List<Job_Application__c> lastWeekJobAppsForRecruiters = Database.query(q);