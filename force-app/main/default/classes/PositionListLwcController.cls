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
        componentPositionsWrapper.positionsRecords = PositionService.positionsWithFieldsAndObjectAccess(
            PositionSelector.selectByStatusWithLimitAndOffset(selectedFilterOptionWrapper, limitParamWrapper, offsetParamWrapper)
        );
        componentPositionsWrapper.positionsAmount = PositionSelector.selectAmountByStatus(selectedFilterOptionWrapper);
        return componentPositionsWrapper;
    }

    @AuraEnabled
    public static String updatePositions(List<Position__c> positions) {
        try {
            update positions;
            return 'Success';
        } catch (DmlException e) {
            return 'Error';
        }
  }
}