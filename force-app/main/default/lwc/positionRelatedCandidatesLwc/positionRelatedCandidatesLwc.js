import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import Id from '@salesforce/user/Id';
import getCandidatesWrapper from '@salesforce/apex/PositionRelatedCandidatesLwcController.getCandidatesWrapper';
import getJobAppsWrapper from '@salesforce/apex/PositionRelatedCandidatesLwcController.getJobAppsWrapper';
import CANDIDATE__C_OBJECT from '@salesforce/schema/Candidate__c';

export default class PositionRelatedCandidatesLwc extends NavigationMixin(LightningElement) {
    
    @api recordId; //variable to store current page record Id
    userId = Id; //variable to store current user Id
    candidateObjectName = CANDIDATE__C_OBJECT;
    @api recordsPerPageParent = 4; //number variable to store amount of records displayed per page
    @api pagesAmountParent; //number variable to store amount of pages
    componentOffsetParam; //number variable to store offset parameter for the database query fo candidates records
    @api pageNumber; //number variable to store starting page number
    selectedCandidates = []; //array to store candidates records received from the org and display in the component
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
                this.selectedCandidates = data.candidatesRecords;
                this.pagesAmountParent = Math.ceil(data.candidatesAmount / this.recordsPerPageParent);
                this.candidateTileFieldSetData = data.candidateTileFields;
                this.candidateModalFieldSetData = data.candidateModalFields;
                if (this.selectedCandidates.length === 0){
                    this.showMessage('There are no related candidates records for this position', '', 'warning');
                }
            })
            .catch (error => {
				this.showMessage('There was an error loading related candidates records', '', 'error');
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
        for (const candidate of this.selectedCandidates) {
            if (candidate.Id == this.candidateId) {
                this.candidateName = candidate.Name;
            }
        }
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
                console.log(this.modalTableColumnsFinal);
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