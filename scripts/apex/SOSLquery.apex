String soslFindClause = 'develop';
Date requiredDate = System.Today() - 7;
List<List<sObject>> searchList = [FIND :soslFindClause IN ALL FIELDS
                                  RETURNING
                                  Position__c (Id, Name WHERE CreatedDate < :requiredDate),
                                  Candidate__c (Id, Name WHERE CreatedDate < :requiredDate),
                                  Review__c (Id, Name WHERE CreatedDate < :requiredDate)];