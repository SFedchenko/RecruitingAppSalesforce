public class Update90DaysOpenPositions implements Schedulable {
	public void execute(SchedulableContext ctx) {
        List<Position__c> positionsToUpdate = PositionSelector.selectByStatusAndStartDate('Open');
        if (positionsToUpdate.size() > 0) {
            for (Position__c p : positionsToUpdate) {
                p.Status__c = 'Archived';
            }
            update positionsToUpdate;
        }
    }
}