import { LightningElement, wire, api } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { reduceErrors } from 'c/ldsUtils';
import POSITION__C_OBJECT from '@salesforce/schema/Position__c';
import NAME_FIELD from '@salesforce/schema/Position__c.Name';
import STATUS__C_FIELD from '@salesforce/schema/Position__c.Status__c';
import START_DATE__C_FIELD from '@salesforce/schema/Position__c.Start_Date__c';
import END_DATE__C_FIELD from '@salesforce/schema/Position__c.End_Date__c';
import MIN_SALARY__C_FIELD from '@salesforce/schema/Position__c.Min_Salary__c';
import MAX_SALARY__C_FIELD from '@salesforce/schema/Position__c.Max_Salary__c';
import getPositions from '@salesforce/apex/PositionListLwcController.getPositions';

const COLUMNS = [
    { label: 'Position title', fieldName: NAME_FIELD.fieldApiName, type: 'text' },
    { label: 'Status', fieldName: STATUS__C_FIELD.fieldApiName, type: 'statusPicklist', },
    { label: 'Start date', fieldName: START_DATE__C_FIELD.fieldApiName, type: 'date-local' },
    { label: 'End date', fieldName: END_DATE__C_FIELD.fieldApiName, type: 'date-local' },
    { label: 'Min salary', fieldName: MIN_SALARY__C_FIELD.fieldApiName, type: 'currency' },
    { label: 'Max salary', fieldName: MAX_SALARY__C_FIELD.fieldApiName, type: 'currency' }
];

export default class PositionListLwc extends LightningElement {
    columns = COLUMNS;
    @api selectedStatus = 'Open';
    @api picklistValues = [];
    filterPicklistValues = [];
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
        console.log(this.selectedStatus);
        getPositions ({
            selectedStatus: this.selectedStatus
        })
            .then (data => {
                this.selectedPositions = data;
                console.log(this.selectedPositions);
            })
            .catch(error => {
				this.loadingSelectedPositionsErrors = reduceErrors(error);
			});
    }
}