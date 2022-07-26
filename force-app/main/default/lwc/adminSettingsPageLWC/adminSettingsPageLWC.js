import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getSettingsDataWrapper from '@salesforce/apex/SettingsPageLwcController.getSettingsDataWrapper';
import getFieldSetFields from '@salesforce/apex/SettingsPageLwcController.getFieldSetFields';
import updateCustomMetadataRecords from '@salesforce/apex/SettingsPageLwcController.updateCustomMetadataRecords';

export default class AdminSettingsPageLWC extends LightningElement {

    selectOptions = [];
    customMetadataRecords = {};
    modifiedMetadataRecords = {};
    recruiterTileFieldset;
    currentRecruiterTileFieldset;
    recruiterTileFieldsetFields = [];
    recruiterModalFieldset;
    currentRecruiterModalFieldset;
    recruiterModalFieldsetFields = [];
    recruiterCheckboxValue;
    currentRecruiterCheckboxValue;
    interviewerTileFieldset;
    currentInterviewerTileFieldset;
    interviewerTileFieldsetFields = [];
    interviewerModalFieldset;
    currentInterviewerModalFieldset;
    interviewerModalFieldsetFields = [];
    interviewerCheckboxValue;
    currentInterviewerCheckboxValue;
    saveButtonIsDisabled;
    messageArray = [];

    //Function for showing page message
    showMessage(customTitle = '', customMessage = '', customVariant = 'info'){
        const evt = new ShowToastEvent({
            title: customTitle,
            message: customMessage,
            variant: customVariant,
        });
        this.dispatchEvent(evt);
    }

    connectedCallback() {
        this.saveButtonIsDisabled = true;
        this.loadSettingsDataWrapper();
    }

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
				this.showMessage('There was an error loading data', '', 'error');
                console.log(error);
			});
    }

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
				this.showMessage('There was an error loading data', '', 'error');
                console.log(error);
			});
    }

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
				this.showMessage('There was an error loading data', '', 'error');
                console.log(error);
			});
    }

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
				this.showMessage('There was an error loading data', '', 'error');
                console.log(error);
			});
    }

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
				this.showMessage('There was an error loading data', '', 'error');
                console.log(error);
			});
    }

    recruiterTileFieldSetChangeHandler(event) {
        this.currentRecruiterTileFieldset = event.detail.value;
        this.modifiedMetadataRecords.Recruiter_field_set.Candidate_tile_field_set__c = this.currentRecruiterTileFieldset;
        this.loadRecruiterTileFieldSetFields(this.currentRecruiterTileFieldset);
        this.setSaveButtonAccessibility();
    }

    recruiterModalFieldSetChangeHandler(event) {
        this.currentRecruiterModalFieldset = event.detail.value;
        this.modifiedMetadataRecords.Recruiter_field_set.Candidate_modal_field_set__c = this.currentRecruiterModalFieldset;
        this.loadRecruiterModalFieldSetFields(this.currentRecruiterModalFieldset);
        this.setSaveButtonAccessibility();
    }

    recruiterCheckboxChangeHandler(event) {
        this.currentRecruiterCheckboxValue = event.target.checked;
        this.modifiedMetadataRecords.Recruiter_field_set.Show_inaccessible_fields__c = this.currentRecruiterCheckboxValue;
        this.setSaveButtonAccessibility();
    }

    interviewerTileFieldSetChangeHandler(event) {
        this.currentInterviewerTileFieldset = event.detail.value;
        this.modifiedMetadataRecords.Interviewer_field_set.Candidate_tile_field_set__c = this.currentInterviewerTileFieldset;
        this.loadInterviewerTileFieldSetFields(this.currentInterviewerTileFieldset);
        this.setSaveButtonAccessibility();
    }

    interviewerModalFieldSetChangeHandler(event) {
        this.currentInterviewerModalFieldset = event.detail.value;
        this.modifiedMetadataRecords.Interviewer_field_set.Candidate_modal_field_set__c = this.currentInterviewerModalFieldset;
        this.loadInterviewerModalFieldSetFields(this.currentInterviewerModalFieldset);
        this.setSaveButtonAccessibility();
    }

    interviewerCheckboxChangeHandler(event) {
        this.currentInterviewerCheckboxValue = event.target.checked;
        this.modifiedMetadataRecords.Interviewer_field_set.Show_inaccessible_fields__c = this.currentInterviewerCheckboxValue;
        this.setSaveButtonAccessibility();
    }

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

    updateRecords() {
        updateCustomMetadataRecords ({
            customMetadataRecords: this.modifiedMetadataRecords
        })
            .then (data => {
                this.messageArray = data;
                if (this.messageArray[0] == 'Success') {
                    console.log('Job Id - ' + this.messageArray[1]);
                    this.showMessage(`Custom metadata type records update job was enqueued for execution. Job Id - ${this.messageArray[1]}`, '', 'success');
                    this.saveButtonIsDisabled = true;
                } else {
                    this.showMessage(this.messageArray[1], '', 'error');
                }
            })
            .catch (error => {
                console.log(error);
                this.showMessage('There was an error updating records', '', 'error');
            })
    }
}