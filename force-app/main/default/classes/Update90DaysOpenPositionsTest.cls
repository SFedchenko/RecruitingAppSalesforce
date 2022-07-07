@isTest
private class Update90DaysOpenPositionsTest {

    @isTest
    static void testScheduledJob() {
        
        String CRON_EXP = '0 0 0 8 7 ? 2022';
        
        List<AsyncApexJob> jobsBefore = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob];
    	System.assertEquals(0, jobsBefore.size(), 'not expecting any asyncjobs');
        
        Test.startTest();
        
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new Update90DaysOpenPositions());
        
        Test.stopTest();
        
        List<AsyncApexJob> jobsScheduled = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'ScheduledApex'];
    	System.assertEquals(1, jobsScheduled.size(), 'expecting one scheduled job');
    	System.assertEquals('Update90DaysOpenPositions', jobsScheduled[0].ApexClass.Name, 'expecting specific scheduled job');

    	List<AsyncApexJob> jobsApexBatch = [select Id, ApexClassID, ApexClass.Name, Status, JobType from AsyncApexJob where JobType = 'BatchApex'];
    	System.assertEquals(1, jobsApexBatch.size(), 'expecting one apex batch job');
    	System.assertEquals('BatchUpdate90DaysOpenPositions', jobsApexBatch[0].ApexClass.Name, 'expecting specific batch job');

    }
}