import { LightningElement, wire, api } from 'lwc';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import POSITION__C_OBJECT from '@salesforce/schema/Position__c';
import STATUS__C_FIELD from '@salesforce/schema/Position__c.Status__c';
import getPositionsWrapper from '@salesforce/apex/PositionListLwcController.getPositionsWrapper';
import updatePositions from '@salesforce/apex/PositionListLwcController.updatePositions';
import FilterByStatusLWC from '@salesforce/label/c.FilterByStatusLWC';
import SaveLWC from '@salesforce/label/c.SaveLWC';
import PositionTitleLWC from '@salesforce/label/c.PositionTitleLWC';
import StatusLWC from '@salesforce/label/c.StatusLWC';
import StartDateLWC from '@salesforce/label/c.StartDateLWC';
import EndDateLWC from '@salesforce/label/c.EndDateLWC';
import MinSalaryLWC from '@salesforce/label/c.MinSalaryLWC';
import MaxSalaryLWC from '@salesforce/label/c.MaxSalaryLWC';
import OptionsLoadingErrorLWC from '@salesforce/label/c.OptionsLoadingErrorLWC';
import NoPositionsWithStatusLWC from '@salesforce/label/c.NoPositionsWithStatusLWC';
import DataLoadingErrorLWC from '@salesforce/label/c.DataLoadingErrorLWC';
import NotModifiedAnyStatusLWC from '@salesforce/label/c.NotModifiedAnyStatusLWC';
import ChangesSavedLWC from '@salesforce/label/c.ChangesSavedLWC';
import UpdatindRecordsErrorLWC from '@salesforce/label/c.UpdatindRecordsErrorLWC';


export default class PositionListLwc extends NavigationMixin(LightningElement) {

    labels = {
        FilterByStatusLWC,
        SaveLWC,
        PositionTitleLWC,
        StatusLWC,
        StartDateLWC,
        EndDateLWC,
        MinSalaryLWC,
        MaxSalaryLWC,
    };

    messages = {
        OptionsLoadingErrorLWC,
        NoPositionsWithStatusLWC,
        DataLoadingErrorLWC,
        NotModifiedAnyStatusLWC,
        ChangesSavedLWC,
        UpdatindRecordsErrorLWC,
    }

    saveButtonAccessibility = true; //boolean variable to store "disabled" attribute of "Save" button to be able to enable it when user will change status of record in the page table
    selectedFilterOption = 'Open'; //string variable to store status picklist filter selected option with default value in it
    showTable = true; //boolean variable for hiding datatable if there are no records for selected status filter picklist option
    picklistValues = []; //array to store picklist options for Status__c field of Position__c object received from org. Used for Position status table cell
    filterPicklistValues = []; //array to store options for status picklist filter if there is a need to add options to existing at Status__c field options of Position__c object at org
    selectedPositions = []; //array to store position records received from the org and display in the page table
    modifiedPositions = []; //clone of selectedPositions array to store changes of Position status cell in page table
    @api recordsPerPageParent; //number variable to store amount of records displayed per page
    @api pagesAmountParent; //number variable to store amount of pages
    componentOffsetParam; //number variable to store offset parameter of the database query
    @api pageNumber; //number variable to store starting page number
    showSpinner; //boolean variable for showing spinner during loading and processing data

    //Calculating starting offset parameter from starting page number
    getStartingOffsetParam(){
        this.componentOffsetParam = (this.pageNumber - 1) * this.recordsPerPageParent;
    }

    //Loading 1st page with default value of status picklist filter
    connectedCallback() {
        this.pageNumber = 1;
        this.getStartingOffsetParam();
        this.loadPositionsWrapper(this.selectedFilterOption, this.recordsPerPageParent, this.componentOffsetParam);
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
            this.showMessage(this.messages.OptionsLoadingErrorLWC, '', 'error');
            console.log(error);
        }
    }

    /*
    Function for:
    - showing spinner;
    - disabling "Save" button;
    - receiving positions records and positions records amount from org;
    - calculating appropriate amount of pages;
    - cloning positions records array;
    - hiding table and showing warning message if there are no positions records for selected status picklist filter option;
    - hiding spinner;
    - showing error message if there was an error during loading data from org.
    */
    loadPositionsWrapper(statusFilterValue, recordsPerPage, componentOffsetParam){
        getPositionsWrapper ({
            selectedFilterOptionWrapper: statusFilterValue,
            limitParamWrapper: recordsPerPage,
            offsetParamWrapper: componentOffsetParam
        })
            .then (data => {
                this.showSpinner = true;
                this.saveButtonAccessibility = true;
                this.selectedPositions = data.positionsRecords;
                for(let i=0; i<this.selectedPositions.length; i++){
                    this.selectedPositions[i].UserRecordAccess.HasEditAccess = !this.selectedPositions[i].UserRecordAccess.HasEditAccess;
                }
                this.pagesAmountParent = Math.ceil(data.positionsAmount / this.recordsPerPageParent);
                this.modifiedPositions = JSON.parse(JSON.stringify(this.selectedPositions));
                if (this.selectedPositions.length === 0){
                    this.showTable = false;
                    this.showMessage(`${this.messages.NoPositionsWithStatusLWC} "${statusFilterValue}"`, '', 'warning');
                } else {
                    this.showTable = true;
                }
                this.showSpinner = false;
            })
            .catch (error => {
				this.showMessage(this.messages.DataLoadingErrorLWC, '', 'error');
                console.log(error);
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
        this.connectedCallback();
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
    - showing page message and disabling "Save" button if there were no any records changes;
    - updating records with updatePositions method from apex controller;
    - showing 'success' message and loading 1st page with current selectedFilterOption if records were saved successfully;
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
            this.showMessage(this.messages.NotModifiedAnyStatusLWC, '', 'warning');
            this.saveButtonAccessibility = true;
        } else {
            updatePositions ({
                positions: positionsToUpdate
            })
                .then (data => {
                    if (data === 'Success') {
                        this.showMessage(this.messages.ChangesSavedLWC, '', 'success');
                        this.connectedCallback();
                    } else if (data === 'Error') {
                        this.showMessage(this.messages.UpdatindRecordsErrorLWC, '', 'error');
                    }
                    
                })
                .catch (error => {
                    this.showMessage(this.messages.UpdatindRecordsErrorLWC, '', 'error');
                    console.log(error);
                });
        }
    }

    /*
    Function for working with child pagination component that is:
    - getting current page number from event detail;
    - calculating appropriate offset parameter componentOffsetParam;
    - loading appropriate positions records from database.
    */
    paginateRecordsHandler(event){
        this.pageNumber = event.detail.currentPageNumber;
        this.getStartingOffsetParam();
        this.loadPositionsWrapper(this.selectedFilterOption, this.recordsPerPageParent, this.componentOffsetParam);
    }
}