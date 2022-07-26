import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import Id from '@salesforce/user/Id';
import getCandidatesWrapper from '@salesforce/apex/PositionRelatedCandidatesLwcController.getCandidatesWrapper';
import getJobAppsWrapper from '@salesforce/apex/PositionRelatedCandidatesLwcController.getJobAppsWrapper';
import CANDIDATE__C_OBJECT from '@salesforce/schema/Candidate__c';

export default class PositionRelatedCandidatesLwc extends NavigationMixin(LightningElement) {
    
    renderedCallback() {
        const tileForms = this.template.querySelectorAll('.tile-fieldset-data-form');
        for (const el of tileForms) {
            const tileId = el.dataset.tileId;
            const tileRecord = this.tileData.get(tileId);
            let innerHtml = '';
            for (const field of this.candidateTileFieldSetData) {
                if (field.isAccessible) {
                    innerHtml += `<div class="form-label">${field.fieldLabel}</div>` + `<div class="form-text">${tileRecord[field.fieldName] || ''}</div>` + '<br>';
                } else {
                    innerHtml += `<div class="inaccessible-fields"><div class="form-label">${field.fieldLabel}</div>` + `<div class="form-text">${tileRecord[field.fieldName] || ''}</div></div>` + '<br>';
                }
            }
            el.innerHTML = innerHtml;
        }
        if (this.isModalOpen) {
            const modalForm = this.template.querySelector('.modal-fieldset-data-form');
            const modalId = modalForm.dataset.modalId;
            const modalRecord = this.modalData.get(modalId);
            let innerHtml = '';
            for (const field of this.candidateModalFieldSetData) {
                if (field.isAccessible) {
                    innerHtml += `<div class="form-label">${field.fieldLabel}</div>` + `<div class="form-text">${modalRecord[field.fieldName] || ''}</div>` + '<br>';
                } else {
                    innerHtml += `<div class="inaccessible-fields"><div class="form-label">${field.fieldLabel}</div>` + `<div class="form-text">${modalRecord[field.fieldName] || ''}</div></div>` + '<br>';
                }
            }
            modalForm.innerHTML = innerHtml;
        }
      }

    @api recordId; //variable to store current page record Id
    userId = Id; //variable to store current user Id
    candidateObjectName = CANDIDATE__C_OBJECT;
    @api recordsPerPageParent = 4; //number variable to store amount of records displayed per page
    @api pagesAmountParent; //number variable to store amount of pages
    componentOffsetParam; //number variable to store offset parameter for the database query fo candidates records
    @api pageNumber; //number variable to store starting page number
    tileRecords = []; //array to store candidates records received from the org and display in the component
    tileData = new Map();
    modalRecords = [];
    modalData = new Map();
    candidateTileFieldSetData = []; //array to store candidate tile field set data
    candidateModalFieldSetData = []; //array to store candidate modal field set data

    isModalOpen = false; //boolean variable to open and close modal
    candidateName; //variable to store candidate name displayed in modal header
    candidateId; //variable to store candidate Id to pass in modal record form

    @api modalTableRecordsPerPage = 2; //number variable to store amount of records displayed per page in modal table
    @api modalTablePageNumber; //number variable to store starting page number for modal table
    @api modalTablePagesAmount; //number variable to store amount of pages for modal table
    selectedJobApps = []; //array to store job applications records received from the org and display in the modal table
    modalTableColumns = []; //array to store objects of data for columns to display in the modal table
    modalTableColumnsFinal = [];
    modalTableOffsetParam; //number variable to store offset parameter for the database query of job applications records

    //Calculating starting offset parameter from starting page number
    getStartingOffsetParam(){
        this.componentOffsetParam = (this.pageNumber - 1) * this.recordsPerPageParent;
    }

    //Loading 1st page with related candidates
    connectedCallback() {
        this.pageNumber = 1;
        this.getStartingOffsetParam();
        this.loadCandidatesWrapper(this.userId, this.recordId, this.recordsPerPageParent, this.componentOffsetParam);
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
    loadCandidatesWrapper(userId, componentId, recordsPerPage, componentOffsetParam){
        getCandidatesWrapper ({
            userId: userId,
            positionId: componentId,
            limitParamWrapper: recordsPerPage,
            offsetParamWrapper: componentOffsetParam
        })
            .then (data => {
                this.tileRecords = data.candidateTileRecords;
                if (this.tileRecords.length === 0){
                    this.showMessage('There are no related candidate records for this position', '', 'warning');
                } else {
                    for (const tileRecord of this.tileRecords) {
                        this.tileData.set(tileRecord.Id, tileRecord);
                    }
                    this.modalRecords = data.candidateModalRecords;
                    for (const modalRecord of this.modalRecords) {
                        this.modalData.set(modalRecord.Id, modalRecord);
                    }
                    this.pagesAmountParent = Math.ceil(data.candidatesAmount / this.recordsPerPageParent);
                    this.candidateTileFieldSetData = data.candidateTileFieldsData;
                    this.candidateModalFieldSetData = data.candidateModalFieldsData;
                }
            })
            .catch (error => {
				this.showMessage('There was an error loading related candidate records', '', 'error');
                console.log(error);
			}); 
    }

    //Function to navigate to candidate record details page at new browser tab, if candidate name clicked
    navigateToCandidateRecord(event){
        event.preventDefault();
        const id = event.target.dataset.candidateId;
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

    /*
    Function for working with child pagination component that is:
    - getting current page number from event detail;
    - calculating appropriate offset parameter componentOffsetParam;
    - loading appropriate candidates records from database.
    */
    paginateRecordsHandler(event){
        this.pageNumber = event.detail.currentPageNumber;
        this.getStartingOffsetParam();
        this.loadCandidatesWrapper(this.userId, this.recordId, this.recordsPerPageParent, this.componentOffsetParam);
    }

    openModal(event) {
        this.isModalOpen = true;
        this.candidateId = event.target.dataset.candidateId;
        this.candidateName = this.modalData.get(this.candidateId).Name;
        /*for (const candidate of this.modalRecords) {
            if (candidate.Id == this.candidateId) {
                this.candidateName = candidate.Name;
            }
        }*/
        this.modalTablePageNumber = 1;
        this.getStartingOffsetParamModalTable();
        this.loadJobAppsWrapper(this.candidateId, this.modalTableRecordsPerPage, this.modalTableOffsetParam);
    }

    closeModal() {
        this.isModalOpen = false;
    }

    //Calculating starting offset parameter from starting page number of modal table
    getStartingOffsetParamModalTable(){
        this.modalTableOffsetParam = (this.modalTablePageNumber - 1) * this.modalTableRecordsPerPage;
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
    loadJobAppsWrapper(candidateId, modalTableRecordsPerPage, modalTableOffsetParam){
        getJobAppsWrapper ({
            candidateId: candidateId,
            limitParamWrapper: modalTableRecordsPerPage,
            offsetParamWrapper: modalTableOffsetParam
        })
            .then (data => {
                this.selectedJobApps = data.jobAppsRecords;
                this.modalTablePagesAmount = Math.ceil(data.jobAppsAmount / this.modalTableRecordsPerPage);
                this.modalTableColumns = data.columns;
                this.modalTableColumnsFinal = JSON.parse(JSON.stringify(this.modalTableColumns));
                this.modalTableColumnsFinal.forEach(element => element.hideDefaultActions = true);
                if (this.selectedJobApps.length === 0){
                    this.showMessage('There are no related job applications records for this candidate', '', 'warning');
                }
            })
            .catch (error => {
				this.showMessage('There was an error loading related job applications records', '', 'error');
                console.log(error);
			}); 
    }

    paginateModalTableRecordsHandler(event) {
        this.modalTablePageNumber = event.detail.currentPageNumber;
        this.getStartingOffsetParamModalTable();
        this.loadJobAppsWrapper(this.candidateId, this.modalTableRecordsPerPage, this.modalTableOffsetParam);
    }
}