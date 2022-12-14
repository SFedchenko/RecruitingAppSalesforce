import { LightningElement, api } from 'lwc';
import PreviousLWC from '@salesforce/label/c.PreviousLWC';
import NextLWC from '@salesforce/label/c.NextLWC';

export default class Pagination extends LightningElement {

    labels = {
        PreviousLWC,
        NextLWC,
    };

    currentPage; //number variable to store number of current page
    pagesAmount; //number variable to store total amount of pages

    /*
    Setter for "pageNumber" variable that is:
    - receiving page number from parent component;
    - compositing appropriate array of numbers buttons to display on the page;
    - setting approprite accessibility for these numbers buttons.
    */
    @api
    set pageNumber(data) {
        if (data){
            this.currentPage = data;
            this.getNumbersButtonsArray();
            this.setNumbersButtonsAccessibility();
        }
    }

    //Getter for "pageNumber" variable
    get pageNumber() {
        return this.currentPage;
    }


    /*
    Setter for "pagesAmountParent" variable that is:
    - receiving amount of pages from parent component;
    - compositing appropriate array of numbers buttons to display on the page;
    - setting approprite accessibility for these numbers buttons.
    */
    @api
    set pagesAmountParent(data) {
        if (data){
            this.pagesAmount = data;
            this.getNumbersButtonsArray();
            this.setNumbersButtonsAccessibility();
        }
    }

    //Getter for "pagesAmountParent" variable
    get pagesAmountParent() {
        return this.pagesAmount;
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
        return this.currentPage <= 1;
    }

    //Function for setting "Next" button accessibility
    get nextButtonAccessibility() {
        return this.currentPage >= this.pagesAmount;
    }

    //Function for setting appropriate accessibility for numbers buttons
    setNumbersButtonsAccessibility() {
        this.numbersButtonsArray.forEach(button => {
            button.isDisabled = button.number == this.currentPage;
        });
        this.numbersButtonsArray = [...this.numbersButtonsArray];
    }

    //Function for sending appropriate page number to parent component as event detail
    sendPageNumberToParent() {
        this.dispatchEvent(new CustomEvent('paginate', {
            detail: {
                currentPageNumber: this.currentPage
            }
        }))
    }

    /*
    Function for handling "Previous" button click that is:
    - decrease page number by 1;
    - sending appropriate page number to parent component.
    */
    previousHandler() {
        if(this.currentPage > 1){
            this.currentPage--;
            this.sendPageNumberToParent();
        }
    }

    /*
    Function for handling "Next" button click that is:
    - increase page number by 1;
    - sending appropriate page number to parent component.
    */
    nextHandler() {    
        if(this.currentPage < this.pagesAmount){
            this.currentPage++;
            this.sendPageNumberToParent();
        }
    }

    /*
    Function for handling number button click that is:
    - setting appropriate page number;
    - sending appropriate page number to parent component.
    */
    numberButtonHandler(event) {
        this.currentPage = parseInt(event.target.label);
        this.sendPageNumberToParent();
    }
}