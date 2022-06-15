import { LightningElement, api } from 'lwc';

export default class Pagination extends LightningElement {

    currentPage = 1; //number variable to store number of current page
    allRecords = []; //array to store records received from parent component
    recordsPerPage; //number variable to store amount of records displayed per page
    pagesAmount; //number variable to store total amount of pages

    //Setter for "recordsperpage" variable that is receiving records displayed per page parameter from parent component
    @api
    set recordsperpage(data) {
        if (data){
            this.recordsPerPage = data;
        }
    }

    //Getter for "recordsperpage" variable
    get recordsperpage() {
        return this.recordsPerPage;
    }

    /*
    Setter for "records" variable that is:
    - receiving records from parent component;
    - calculating total amount of pages;
    - compositing appropriate array of numbers buttons to display on the page;
    - setting approprite accessibilite for these numbers buttons;
    - getting records appropriate to page number and sending them to parent component to display in page table.
    */
    @api
    set records(data) {
        if (data){
            this.allRecords = data;
            this.pagesAmount = Math.ceil(this.allRecords.length / this.recordsPerPage);
            this.getNumbersButtonsArray();
            this.setNumbersButtonsAccessibility();
            this.paginateRecords();
        }
    }

    //Getter for "records" variable
    get records() {
        return this.paginatedRecords;
    }

    //Function for compositing array of buttons to display on page
    getNumbersButtonsArray() {
        const arr = [];
        for(let i=1; i<=this.pagesAmount; i++){
            arr.push({number: i, isDisabled: false});
        }
        this.numbersButtonsArray = [...arr];
    }

    //Function for setting "Previous" button accessibility
    get previousButtonAccessibility() {
        if(this.currentPage <= 1){
            return true;
        } else {
            return false;
        }
    }

    //Function for setting "Next" button accessibility
    get nextButtonAccessibility() {
        if(this.currentPage >= this.pagesAmount){
            return true;
        } else {
            return false;
        }
    }

    //Function for setting appropriate accessibility for numbers buttons
    setNumbersButtonsAccessibility() {
        this.numbersButtonsArray.forEach(button => {
            button.isDisabled = button.number == this.currentPage;
        });
        this.numbersButtonsArray = [...this.numbersButtonsArray];
    }

    //Function for getting records appropriate to page number and sending them to parent component as event detail
    paginateRecords() {
        const startSlice = (this.currentPage - 1)*this.recordsPerPage;
        const endSlice = this.currentPage * this.recordsPerPage;
        this.paginatedRecords = this.allRecords.slice(startSlice, endSlice);
        this.dispatchEvent(new CustomEvent('paginate', {
            detail: {
                records: this.paginatedRecords
            }
        }))
    }

    /*
    Function for handling "Previous" button click that is:
    - decrease page number by 1;
    - compositing and sending to parent component appropriate to page number records;
    - setting appropriate accessibility for numbers buttons.
    */
    previousHandler() {
        if(this.currentPage > 1){
            this.currentPage--;
            this.paginateRecords();
            this.setNumbersButtonsAccessibility();
        }
    }

    /*
    Function for handling "Next" button click that is:
    - increase page number by 1;
    - compositing and sending to parent component appropriate to page number records;
    - setting appropriate accessibility for numbers buttons.
    */
    nextHandler() {    
        if(this.currentPage < this.pagesAmount){
            this.currentPage++;
            this.paginateRecords();
            this.setNumbersButtonsAccessibility();
        }
    }

    /*
    Function for handling number button click that is:
    - setting appropriate page number;
    - compositing and sending to parent component appropriate to page number records;
    - setting appropriate accessibility for numbers buttons.
    */
    numberButtonHandler(event) {
        this.currentPage = event.target.dataset.buttonId;
        this.paginateRecords();
        this.setNumbersButtonsAccessibility();
    }
}