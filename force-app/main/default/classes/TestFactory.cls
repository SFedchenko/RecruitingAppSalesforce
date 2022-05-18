@isTest
public class TestFactory {
    public static List<Position__c> generatePositionsWithStatusOpen(Integer amount) {
        List<Position__c> positions = new List<Position__c>();
        for(integer i = 0; i < amount; i++) {
            Position__c pos = new Position__c();
            pos.Name = 'Position ' + i;
           	pos.Status__c = 'Open';
           	pos.Start_Date__c = System.today();
           	pos.Min_Salary__c = 500*(1+i);
           	pos.Max_Salary__c = 1000*(1+i);
           	positions.add(pos);
        }
        insert positions;
        return positions;
    }
    public static List<Position__c> generatePositionsWithStatusClosed(Integer amount) {
        List<Position__c> positions = new List<Position__c>();
        for(integer i = 0; i < amount; i++) {
            Position__c pos = new Position__c();
            pos.Name = 'Position ' + i;
           	pos.Status__c = 'Closed';
           	pos.Start_Date__c = System.today();
           	pos.Min_Salary__c = 500*(1+i);
           	pos.Max_Salary__c = 1000*(1+i);
           	positions.add(pos);
        }
        insert positions;
        return positions;
    }
    public static List<Position__c> generatePositionsWithStatusStartsOn(Integer amount) {
        List<Position__c> positions = new List<Position__c>();
        for(integer i = 0; i < amount; i++) {
            Position__c pos = new Position__c();
            pos.Name = 'Position ' + i;
           	pos.Status__c = 'Starts on';
           	pos.Start_Date__c = System.today();
           	pos.Min_Salary__c = 500*(1+i);
           	pos.Max_Salary__c = 1000*(1+i);
           	positions.add(pos);
        }
        insert positions;
        return positions;
    }
    public static List<Position__c> generatePositionsWithStatusEndsOn(Integer amount) {
        List<Position__c> positions = new List<Position__c>();
        for(integer i = 0; i < amount; i++) {
            Position__c pos = new Position__c();
            pos.Name = 'Position ' + i;
           	pos.Status__c = 'Ends on';
           	pos.Start_Date__c = System.today();
           	pos.Min_Salary__c = 500*(1+i);
           	pos.Max_Salary__c = 1000*(1+i);
           	positions.add(pos);
        }
        insert positions;
        return positions;
    }
    public static List<Position__c> generatePositionsWithStatusArchived(Integer amount) {
        List<Position__c> positions = new List<Position__c>();
        for(integer i = 0; i < amount; i++) {
            Position__c pos = new Position__c();
            pos.Name = 'Position ' + i;
           	pos.Status__c = 'Archived';
           	pos.Start_Date__c = System.today();
           	pos.Min_Salary__c = 500*(1+i);
           	pos.Max_Salary__c = 1000*(1+i);
           	positions.add(pos);
        }
        insert positions;
        return positions;
    }
}