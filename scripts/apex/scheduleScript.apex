String sch = '0 0 0 * * ?';
String jobID = System.schedule('Daily positions update', sch, new Update90DaysOpenPositions());
System.debug(jobID);