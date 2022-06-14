import { LightningElement, wire, api } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import POSITION__C_OBJECT from '@salesforce/schema/Position__c';
import STATUS__C_FIELD from '@salesforce/schema/Position__c.Status__c';
import getPositions from '@salesforce/apex/PositionListLwcController.getPositions';
import updatePositions from '@salesforce/apex/PositionListLwcController.updatePositions';


export default class PositionListLwc extends NavigationMixin(LightningElement) {

    saveButtonAccessibility = true; //boolean variable to store "disabled" attribute of "Save" button to be able to enable it when user will change status of record in the page table
    selectedFilterOption = 'Open'; //string variable to store status picklist filter selected option with default value in it
    showTable = true; //boolean variable for hiding datatable if there are no records for selected status filter picklist option
    picklistValues = []; //array to store picklist options for Status__c field of Position__c object received from org. Used for Position status table cell
    filterPicklistValues = []; //array to store options for status picklist filter if there is a need to add options to existing at Status__c field options of Position__c object at org
    selectedPositions = []; //array to store position records received from the org and display in the page table
    modifiedPositions = []; //clone of selectedPositions array to store changes of Position status cell in page table
    paginatedPositions;

    //Loading page with default value of status picklist filter
    connectedCallback() {
		this.loadPositions(this.selectedFilterOption);
	}

    //Function for cloning array of objects with primitives (position records)
    cloneArrayOfObjects(array){
        let clonedArray = [];
        for(let i=0; i<array.length; i++){
            let clonedObjectOfArray = {...array[i]};
            clonedArray.push(clonedObjectOfArray);
        }
        return clonedArray;
    }
    
    //Function for showing page message
    showMessage(customTitle = '', customMessage = '', customVariant = 'info'){
        const evt = new ShowToastEvent({
            title: customTitle,
            message: customMessage,
            variant: customVariant,
        });
        this.dispatchEvent(evt);
    }

    /*
    Receiving picklist options for Status__c field of Position__c object from org,
    composing filterPicklistValues array,
    showing error message if there was an error during loading picklist options for Status__c field of Position__c object from org
    */
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
            this.showMessage('There was a problem loading options for status filter/picklist from database', '', 'error');
        }
    }

    /*
    Function for:
    - receiving positions records from org;
    - cloning received array;
    - hiding table and showing warning message if there are no positions records for selected status picklist filter option;
    - showing error message if there was error during loading positions records from org.
    */
    loadPositions(statusFilterValue){
        getPositions ({
            selectedFilterOption: statusFilterValue
        })
            .then (data => {
                this.selectedPositions = data;
                this.modifiedPositions = this.cloneArrayOfObjects(this.selectedPositions);
                if (this.selectedPositions.length === 0){
                    this.showTable = false;
                    this.showMessage(`There are no positions with status "${statusFilterValue}"`, '', 'warning');
                } else {
                    this.showTable = true;
                }
            })
            .catch (error => {
				this.showMessage('There was a problem loading position records from database', '', 'error');
			});
        
    }

    //Function to navigate to position record details page at new browser tab if Position name clicked
    navigateToPositionRecord(event){
        event.preventDefault();
        const id = event.target.closest('tr').dataset.positionId;
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: id,
                actionName: 'view'
            }
        }).then(url => {
            window.open(url);
        })
    }
    
    //Function for handling status picklist filter change
    handleFilterChange(event) {
        this.selectedFilterOption = event.detail.value;
        this.loadPositions(this.selectedFilterOption);
    }

    //Function for handling status picklists changes in the page table
    handleStatusChange(event){
        this.saveButtonAccessibility = false;
        const selectedStatus = event.detail.value;
        const id = event.target.closest('tr').dataset.positionId;
        for(let i=0; i<this.modifiedPositions.length; i++){
            if(this.modifiedPositions[i].Id === id){
                this.modifiedPositions[i].Status__c = selectedStatus;
            }
        }
    }

    /*
    Function for handling onclick event of 'Save' button that is:
    - compositing array of position records that were modified and need to be updated as difference between selectedPositions array and modifiedPositions array;
    - showing page message if there were no any records changes;
    - updating records with updatePositions method from apex controller;
    - showing 'success' message and reloading page with current selectedFilterOption if records were saved successfully;
    - showing 'error' message if there were any errors during records updating.
    */
    updateRecords(){
        let positionsToUpdate = [];
        for(let i=0; i<this.modifiedPositions.length; i++){
            let positionToUpdate = {};
            if(this.modifiedPositions[i].Status__c !== this.selectedPositions[i].Status__c){
                positionToUpdate.Id = this.modifiedPositions[i].Id;
                positionToUpdate.Status__c = this.modifiedPositions[i].Status__c;
                positionsToUpdate.push(positionToUpdate);
            }
        }
        if(positionsToUpdate.length === 0){
            this.showMessage('Was not modified any status', '', 'warning');
        } else {
            updatePositions ({
                positions: positionsToUpdate
            })
                .then (data => {
                    if (data === 'Success') {
                        this.showMessage('Changes were saved successfully', '', 'success');
                        this.connectedCallback();
                    } else if (data === 'Error') {
                        this.showMessage('There was an error updating records. Please try again', '', 'error');
                    }
                    
                })
                .catch (error => {
                    this.showMessage('There was an error updating records. Please try again', '', 'error');
                });
        }
    }

    paginateRecordsHandler(event){
        this.paginatedPositions = [...event.detail.records];
    }
}