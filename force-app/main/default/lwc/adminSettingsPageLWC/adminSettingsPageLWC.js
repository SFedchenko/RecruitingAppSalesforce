import { LightningElement} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSettingsDataWrapper from '@salesforce/apex/SettingsPageLwcController.getSettingsDataWrapper';
import getFieldSetFields from '@salesforce/apex/SettingsPageLwcController.getFieldSetFields';
import updateCustomMetadataRecords from '@salesforce/apex/SettingsPageLwcController.updateCustomMetadataRecords';
import RecruiterSectionLabel from '@salesforce/label/c.RecruiterSectionLabel';
import InterviewerSectionLabel from '@salesforce/label/c.InterviewerSectionLabel';
import CandidateTileFieldSet from '@salesforce/label/c.CandidateTileFieldSet';
import CandidateModalFieldSet from '@salesforce/label/c.CandidateModalFieldSet';
import ShowInaccessibleFields from '@salesforce/label/c.ShowInaccessibleFields';
import SaveButtonLabel from '@salesforce/label/c.SaveButtonLabel';
import LoadingDataErrorMessage from '@salesforce/label/c.LoadingDataErrorMessage';
import LoadingFieldSetFieldsDataError from '@salesforce/label/c.LoadingFieldSetFieldsDataError';
import SuccessfulUpdateMessage from '@salesforce/label/c.SuccessfulUpdateMessage';
import UpdatingErrorMessage from '@salesforce/label/c.UpdatingErrorMessage';

export default class AdminSettingsPageLWC extends LightningElement {

    selectOptions = []; //array to store Candidate__c custom object field sets as select options for picklists on the page
    customMetadataRecords = {}; //object to store custom metadata type records map received from org
    modifiedMetadataRecords = {}; //object to store cloned customMetadataRecords object and modified values of this object
    recruiterTileFieldset; //string variable to store value for recruiter candidate tile field set received from org
    currentRecruiterTileFieldset; //string variable to store value for recruiter candidate tile field set picklist on the page
    recruiterTileFieldsetFields = []; //array to store selected recruiter candidate tile field set fields data
    recruiterModalFieldset; //string variable to store value for recruiter candidate modal field set received from org
    currentRecruiterModalFieldset; //string variable to store value for recruiter candidate modal field set picklist on the page
    recruiterModalFieldsetFields = []; //array to store selected recruiter candidate modal field set fields data
    recruiterCheckboxValue; //boolean variable to store 'Show inaccessible fields' field value of recruiter custom metadata type record
    currentRecruiterCheckboxValue; //boolean variable to store value for recruiter 'Show inaccessible fields' checkbox on the page
    interviewerTileFieldset; //string variable to store value for interviewer candidate tile field set received from org
    currentInterviewerTileFieldset; //string variable to store value for interviewer candidate tile field set picklist on the page
    interviewerTileFieldsetFields = []; //array to store selected interviewer candidate tile field set fields data
    interviewerModalFieldset; //string variable to store value for interviewer candidate modal field set received from org
    currentInterviewerModalFieldset; //string variable to store value for interviewer candidate modal field set picklist on the page
    interviewerModalFieldsetFields = []; //array to store selected interviewer candidate modal field set fields data
    interviewerCheckboxValue; //boolean variable to store 'Show inaccessible fields' field value of interviewer custom metadata type record
    currentInterviewerCheckboxValue; //boolean variable to store value for interviewer 'Show inaccessible fields' checkbox on the page
    saveButtonIsDisabled; //boolean variable to set 'Save' button accessibility
    messageArray = []; //array to store response from apex class method execution in updateRecords function

    labels = {
        RecruiterSectionLabel,
        InterviewerSectionLabel,
        CandidateTileFieldSet,
        CandidateModalFieldSet,
        ShowInaccessibleFields,
        SaveButtonLabel,
    }

    messages = {
        LoadingDataErrorMessage,
        LoadingFieldSetFieldsDataError,
        SuccessfulUpdateMessage,
        UpdatingErrorMessage,
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

    //Loading page with appropriate values received from org
    connectedCallback() {
        this.saveButtonIsDisabled = true;
        this.loadSettingsDataWrapper();
    }

    //Loading data from ord or showing error message, if there was an error
    loadSettingsDataWrapper() {
        getSettingsDataWrapper ({})
            .then (data => {
                this.selectOptions = data.selectOptions;

                this.customMetadataRecords = data.customMetadataRecords;
                this.modifiedMetadataRecords = JSON.parse(JSON.stringify(this.customMetadataRecords));
                
                this.recruiterTileFieldset = this.customMetadataRecords.Recruiter_field_set.Candidate_tile_field_set__c.toLowerCase();
                this.currentRecruiterTileFieldset = this.recruiterTileFieldset;
                this.loadRecruiterTileFieldSetFields(this.currentRecruiterTileFieldset);

                this.recruiterModalFieldset = this.customMetadataRecords.Recruiter_field_set.Candidate_modal_field_set__c.toLowerCase();
                this.currentRecruiterModalFieldset = this.recruiterModalFieldset;
                this.loadRecruiterModalFieldSetFields(this.currentRecruiterModalFieldset);

                this.recruiterCheckboxValue = this.customMetadataRecords.Recruiter_field_set.Show_inaccessible_fields__c;
                this.currentRecruiterCheckboxValue = this.recruiterCheckboxValue;
                
                this.interviewerTileFieldset = this.customMetadataRecords.Interviewer_field_set.Candidate_tile_field_set__c.toLowerCase();
                this.currentInterviewerTileFieldset = this.interviewerTileFieldset;
                this.loadInterviewerTileFieldSetFields(this.interviewerTileFieldset);

                this.interviewerModalFieldset = this.customMetadataRecords.Interviewer_field_set.Candidate_modal_field_set__c.toLowerCase();
                this.currentInterviewerModalFieldset = this.interviewerModalFieldset;
                this.loadInterviewerModalFieldSetFields(this.interviewerModalFieldset);

                this.interviewerCheckboxValue = this.customMetadataRecords.Interviewer_field_set.Show_inaccessible_fields__c;
                this.currentInterviewerCheckboxValue = this.interviewerCheckboxValue;
            })
            .catch (error => {
				this.showMessage(this.messages.LoadingDataErrorMessage, '', 'error');
                console.log(error);
			});
    }

    //Loading selected field set fields data for selected value of recruiter candidate tile field set picklist
    loadRecruiterTileFieldSetFields(fieldSetName) {
        getFieldSetFields ({
            profileOrPermissionSet: 'Profile',
            profileOrPermissionSetName: 'Recruiter',
            fieldSetName: fieldSetName
        })
            .then (data => {
                this.recruiterTileFieldsetFields = data;
            })
            .catch (error => {
				this.showMessage(this.messages.LoadingFieldSetFieldsDataError, '', 'error');
                console.log(error);
			});
    }

    //Loading selected field set fields data for selected value of recruiter candidate modal field set picklist
    loadRecruiterModalFieldSetFields(fieldSetName) {
        getFieldSetFields ({
            profileOrPermissionSet: 'Profile',
            profileOrPermissionSetName: 'Recruiter',
            fieldSetName: fieldSetName
        })
            .then (data => {
                this.recruiterModalFieldsetFields = data;
            })
            .catch (error => {
				this.showMessage(this.messages.LoadingFieldSetFieldsDataError, '', 'error');
                console.log(error);
			});
    }

    //Loading selected field set fields data for selected value of interviewer candidate tile field set picklist
    loadInterviewerTileFieldSetFields(fieldSetName) {
        getFieldSetFields ({
            profileOrPermissionSet: 'PermissionSet',
            profileOrPermissionSetName: 'Interviewer',
            fieldSetName: fieldSetName
        })
            .then (data => {
                this.interviewerTileFieldsetFields = data;
            })
            .catch (error => {
				this.showMessage(this.messages.LoadingFieldSetFieldsDataError, '', 'error');
                console.log(error);
			});
    }

    //Loading selected field set fields data for selected value of interviewer candidate modal field set picklist
    loadInterviewerModalFieldSetFields(fieldSetName) {
        getFieldSetFields ({
            profileOrPermissionSet: 'PermissionSet',
            profileOrPermissionSetName: 'Interviewer',
            fieldSetName: fieldSetName
        })
            .then (data => {
                this.interviewerModalFieldsetFields = data;
            })
            .catch (error => {
				this.showMessage(this.messages.LoadingFieldSetFieldsDataError, '', 'error');
                console.log(error);
			});
    }

    //Handling value change of recruiter candidate tile field set picklist
    recruiterTileFieldSetChangeHandler(event) {
        this.currentRecruiterTileFieldset = event.detail.value;
        this.modifiedMetadataRecords.Recruiter_field_set.Candidate_tile_field_set__c = this.currentRecruiterTileFieldset;
        this.loadRecruiterTileFieldSetFields(this.currentRecruiterTileFieldset);
        this.setSaveButtonAccessibility();
    }

    //Handling value change of recruiter candidate modal field set picklist
    recruiterModalFieldSetChangeHandler(event) {
        this.currentRecruiterModalFieldset = event.detail.value;
        this.modifiedMetadataRecords.Recruiter_field_set.Candidate_modal_field_set__c = this.currentRecruiterModalFieldset;
        this.loadRecruiterModalFieldSetFields(this.currentRecruiterModalFieldset);
        this.setSaveButtonAccessibility();
    }

    //Handling value change of recruiter 'Show inaccessible fields' checkbox
    recruiterCheckboxChangeHandler(event) {
        this.currentRecruiterCheckboxValue = event.target.checked;
        this.modifiedMetadataRecords.Recruiter_field_set.Show_inaccessible_fields__c = this.currentRecruiterCheckboxValue;
        this.setSaveButtonAccessibility();
    }

    //Handling value change of interviewer candidate tile field set picklist
    interviewerTileFieldSetChangeHandler(event) {
        this.currentInterviewerTileFieldset = event.detail.value;
        this.modifiedMetadataRecords.Interviewer_field_set.Candidate_tile_field_set__c = this.currentInterviewerTileFieldset;
        this.loadInterviewerTileFieldSetFields(this.currentInterviewerTileFieldset);
        this.setSaveButtonAccessibility();
    }

    //Handling value change of interviewer candidate modal field set picklist
    interviewerModalFieldSetChangeHandler(event) {
        this.currentInterviewerModalFieldset = event.detail.value;
        this.modifiedMetadataRecords.Interviewer_field_set.Candidate_modal_field_set__c = this.currentInterviewerModalFieldset;
        this.loadInterviewerModalFieldSetFields(this.currentInterviewerModalFieldset);
        this.setSaveButtonAccessibility();
    }

    //Handling value change of interviewer 'Show inaccessible fields' checkbox
    interviewerCheckboxChangeHandler(event) {
        this.currentInterviewerCheckboxValue = event.target.checked;
        this.modifiedMetadataRecords.Interviewer_field_set.Show_inaccessible_fields__c = this.currentInterviewerCheckboxValue;
        this.setSaveButtonAccessibility();
    }

    //Setting appropriate 'Save' button accessibility
    setSaveButtonAccessibility() {
        if (this.currentRecruiterTileFieldset == this.recruiterTileFieldset &&
            this.currentRecruiterModalFieldset == this.recruiterModalFieldset &&
            this.currentRecruiterCheckboxValue == this.recruiterCheckboxValue &&
            this.currentInterviewerTileFieldset == this.interviewerTileFieldset &&
            this.currentInterviewerModalFieldset == this.interviewerModalFieldset &&
            this.currentInterviewerCheckboxValue == this.interviewerCheckboxValue
            ) {
                this.saveButtonIsDisabled = true;
        } else {
            this.saveButtonIsDisabled = false;
        }
    }

    //Updating custom metadata type records
    updateRecords() {
        updateCustomMetadataRecords ({
            customMetadataRecords: this.modifiedMetadataRecords
        })
            .then (data => {
                this.messageArray = data;
                if (this.messageArray[0] == 'Success') {
                    console.log('Job Id - ' + this.messageArray[1]);
                    this.showMessage(this.messages.SuccessfulUpdateMessage + this.messageArray[1], '', 'success');
                    this.saveButtonIsDisabled = true;
                } else {
                    this.showMessage(this.messageArray[1], '', 'error');
                }
            })
            .catch (error => {
                console.log(error);
                this.showMessage(this.messages.UpdatingErrorMessage, '', 'error');
            })
    }
}