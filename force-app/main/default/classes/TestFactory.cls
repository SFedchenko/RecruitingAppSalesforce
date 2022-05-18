@isTest
public class TestFactory {
    public static List<Position__c> generatePositions(String status, Integer amount) {
        List<Position__c> positions = new List<Position__c>();
        for(integer i = 0; i < amount; i++) {
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
}