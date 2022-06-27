public class PositionListLwcController {
    
    public class PositionsWrapper{
        @AuraEnabled
        public List<Position__c> positionsRecords {get; set;}
        @AuraEnabled
        public Integer positionsAmount {get; set;}
    }

    @AuraEnabled
    public static PositionsWrapper getPositionsWrapper(String selectedFilterOptionWrapper, Integer limitParamWrapper, Integer offsetParamWrapper){
        PositionsWrapper componentPositionsWrapper = new PositionsWrapper();
        componentPositionsWrapper.positionsRecords = PositionListLwcService.positionsWithFieldsAndObjectAccess(
            PositionsSelector.selectByStatusWithLimitAndOffset(selectedFilterOptionWrapper, limitParamWrapper, offsetParamWrapper)
        );
        componentPositionsWrapper.positionsAmount = PositionsSelector.selectAmountByStatus(selectedFilterOptionWrapper);
        return componentPositionsWrapper;
    }

    @AuraEnabled
    public static String updatePositions(List<Position__c> positions) {
        String s = PositionListLwcService.updateRecords(positions);
        return s;
  }
}