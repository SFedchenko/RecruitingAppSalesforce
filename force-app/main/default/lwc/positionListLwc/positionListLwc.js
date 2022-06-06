import { LightningElement, wire, api } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { updateRecord } from 'lightning/uiRecordApi';
import { reduceErrors } from 'c/ldsUtils';
import POSITION__C_OBJECT from '@salesforce/schema/Position__c';
import STATUS__C_FIELD from '@salesforce/schema/Position__c.Status__c';
import getPositions from '@salesforce/apex/PositionListLwcController.getPositions';

export default class PositionListLwc extends NavigationMixin(LightningElement) {
    selectedStatus = 'Open';
    picklistValues = [];
    filterPicklistValues = [];
    selectedPositions = [];
    @wire( getObjectInfo, { objectApiName:  POSITION__C_OBJECT })
    objectInfo;
    @wire( getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: STATUS__C_FIELD } )
    wiredData( { data, error } ) {
        if ( data ) {
            this.picklistValues = data.values.map( objPL => {
                return {
                    value: `${objPL.value}`,
                    label: `${objPL.label}`
                };
            });
            this.additionalPicklistValues = [{value: 'All', label: 'All'}];
            this.filterPicklistValues = [...this.additionalPicklistValues, ...this.picklistValues];
        } else if ( error ) {
            this.loadingPicklistValuesErrors = reduceErrors(error);
        }
    }
    
    handleChange(event) {
        this.selectedStatus = event.detail.value;
        getPositions ({
            selectedStatus: this.selectedStatus
        })
            .then (data => {
                console.log(data.length);
                this.selectedPositions = data;
            })
            .catch(error => {
				this.loadingSelectedPositionsErrors = reduceErrors(error);
			});
    }

    /*
    updatePositions(){
        const fields = this.selectedPositions[0];
        const recordsInput = {fields};
        console.log(recordsInput);
        console.log(typeof STATUS__C_FIELD.fieldApiName);
        updateRecord(recordsInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Case Updated',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                console.log(error);
            });
    }
    */

    connectedCallback() {
		getPositions ({
            selectedStatus: this.selectedStatus
        })
            .then (data => {
                this.selectedPositions = data;
            })
            .catch(error => {
				this.loadingSelectedPositionsErrors = reduceErrors(error);
			});
	}

    navigateToPositionRecord(event){
        event.preventDefault();
        let linkId = event.target.getAttribute('id');
        let navigatedRecordId = linkId.substring(0, linkId.indexOf('-'));
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: navigatedRecordId,
                actionName: 'view'
            }
        }).then(url => {
            window.open(url);
        })
    }
}