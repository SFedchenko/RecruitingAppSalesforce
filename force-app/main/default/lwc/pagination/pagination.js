import { LightningElement, api } from 'lwc';

export default class Pagination extends LightningElement {

    currentPage; //number variable to store number of current page
    pagesAmount; //number variable to store total amount of pages

    /*
    Setter for "pagenumber" variable that is:
    - receiving page number from parent component;
    - compositing appropriate array of numbers buttons to display on the page;
    - setting approprite accessibility for these numbers buttons.
    */
    @api
    set pagenumber(data) {
        if (data){
            this.currentPage = data;
            this.getNumbersButtonsArray();
            this.setNumbersButtonsAccessibility();
        }
    }

    //Getter for "pagenumber" variable
    get pagenumber() {
        return this.currentPage;
    }


    /*
    Setter for "pagesamount" variable that is:
    - receiving amount of pages from parent component;
    - compositing appropriate array of numbers buttons to display on the page;
    - setting approprite accessibility for these numbers buttons.
    */
    @api
    set pagesamount(data) {
        if (data){
            this.pagesAmount = data;
            this.getNumbersButtonsArray();
            this.setNumbersButtonsAccessibility();
        }
    }

    //Getter for "records" variable
    get pagesamount() {
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
        this.currentPage = parseInt(event.target.dataset.buttonId);
        this.sendPageNumberToParent();
    }
}