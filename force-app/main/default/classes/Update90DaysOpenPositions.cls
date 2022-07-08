public class Update90DaysOpenPositions implements Schedulable {
	public void execute(SchedulableContext ctx) {
        BatchUpdate90DaysOpenPositions b = new BatchUpdate90DaysOpenPositions();
        database.executebatch(b);
    }
}