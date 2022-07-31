import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import Id from '@salesforce/user/Id';
import getCandidatesWrapper from '@salesforce/apex/PositionRelatedCandidatesLwcController.getCandidatesWrapper';
import getJobAppsWrapper from '@salesforce/apex/PositionRelatedCandidatesLwcController.getJobAppsWrapper';
import ComponentTitle from '@salesforce/label/c.ComponentTitle';
import ComponentModalDatatableTitle from '@salesforce/label/c.ComponentModalDatatableTitle';
import ComponentModalCloseButtonTitle from '@salesforce/label/c.ComponentModalCloseButtonTitle';
import TextWhenHoverOverCandidateName from '@salesforce/label/c.TextWhenHoverOverCandidateName';
import TextWhenHoverOverCandidateTile from '@salesforce/label/c.TextWhenHoverOverCandidateTile';
import LoadingCandidateRecordsError from '@salesforce/label/c.LoadingCandidateRecordsError';
import NoRelatedCandidates from '@salesforce/label/c.NoRelatedCandidates';
import NoRelatedJobApps from '@salesforce/label/c.NoRelatedJobApps';
import LoadingJobAppsRecordsError from '@salesforce/label/c.LoadingJobAppsRecordsError';

export default class PositionRelatedCandidatesLwc extends NavigationMixin(LightningElement) {

    @api recordId; //variable to store current page record Id
    userId = Id; //variable to store current user Id
    @api recordsPerPageParent; //number variable to store amount of records displayed per page
    @api pagesAmountParent; //number variable to store amount of pages
    componentOffsetParam; //number variable to store offset parameter for the database query of candidates records
    @api pageNumber; //number variable to store starting page number
    tileData = new Map(); //map to store data received from the org and needed for display in the component tiles
    modalData = new Map(); //map to store data received from the org and needed for display in the component modals
    tileRecords = []; //array to store candidates records received from the org and display in the component tiles
    modalRecords = []; //array to store candidates records received from the org and display in the component modals
    candidateTileFieldSetData = []; //array to store candidate tile field set fields data
    candidateModalFieldSetData = []; //array to store candidate modal field set fields data
    isModalOpen = false; //boolean variable to open and close modal
    candidateName; //variable to store candidate name displayed in modal header
    candidateId; //variable to store candidate Id to pass in modal record form
    @api modalTableRecordsPerPage; //number variable to store amount of records displayed per page in modal table
    @api modalTablePageNumber; //number variable to store starting page number for modal table
    @api modalTablePagesAmount; //number variable to store amount of pages for modal table
    selectedJobApps = []; //array to store job application records received from the org and display in the modal table
    modalTableColumns = []; //array to store objects of data for columns to display in the modal table
    modalTableColumnsFinal = []; //array to store modified objects of data for columns to display in the modal table
    modalTableOffsetParam; //number variable to store offset parameter for the database query of job application records

    labels = {
        ComponentTitle,
        ComponentModalDatatableTitle,
        ComponentModalCloseButtonTitle,
        TextWhenHoverOverCandidateName,
        TextWhenHoverOverCandidateTile,
    }

    messages = {
        LoadingCandidateRecordsError,
        NoRelatedCandidates,
        NoRelatedJobApps,
        LoadingJobAppsRecordsError,
    }

    //Calculating starting offset parameter from starting page number
    getStartingOffsetParam(){
        this.componentOffsetParam = (this.pageNumber - 1) * this.recordsPerPageParent;
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

    //Loading 1st page with related candidates
    connectedCallback() {
        this.pageNumber = 1;
        this.getStartingOffsetParam();
        this.loadCandidatesWrapper(this.userId, this.recordId, this.recordsPerPageParent, this.componentOffsetParam);
	}

    //Building appropriate record forms for candidate tiles and modal
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

    //Loading data from org, calculating appropriate variables values and showing appropriate message, if there are no related candidate records or there was an error loading data
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
                    this.showMessage(this.messages.NoRelatedCandidates, '', 'warning');
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
				this.showMessage(this.messages.LoadingCandidateRecordsError, '', 'error');
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

    //Working with child pagination component for candidate tiles
    paginateRecordsHandler(event){
        this.pageNumber = event.detail.currentPageNumber;
        this.getStartingOffsetParam();
        this.loadCandidatesWrapper(this.userId, this.recordId, this.recordsPerPageParent, this.componentOffsetParam);
    }

    //opening modal and building appropriate record form
    openModal(event) {
        this.isModalOpen = true;
        this.candidateId = event.target.dataset.candidateId;
        this.candidateName = this.modalData.get(this.candidateId).Name;
        this.modalTablePageNumber = 1;
        this.getStartingOffsetParamModalTable();
        this.loadJobAppsWrapper(this.candidateId, this.modalTableRecordsPerPage, this.modalTableOffsetParam);
    }

    //closing modal
    closeModal() {
        this.isModalOpen = false;
    }

    //Calculating starting offset parameter from starting page number of modal datatable
    getStartingOffsetParamModalTable(){
        this.modalTableOffsetParam = (this.modalTablePageNumber - 1) * this.modalTableRecordsPerPage;
    }

    //Loading data from org, calculating appropriate variables values and showing appropriate message, if there are no related candidate records or there was an error loading data
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
                    this.showMessage(this.messages.NoRelatedJobApps, '', 'warning');
                }
            })
            .catch (error => {
				this.showMessage(this.messages.LoadingJobAppsRecordsError, '', 'error');
                console.log(error);
			}); 
    }

    //Working with child pagination component for modal datatable
    paginateModalTableRecordsHandler(event) {
        this.modalTablePageNumber = event.detail.currentPageNumber;
        this.getStartingOffsetParamModalTable();
        this.loadJobAppsWrapper(this.candidateId, this.modalTableRecordsPerPage, this.modalTableOffsetParam);
    }
}