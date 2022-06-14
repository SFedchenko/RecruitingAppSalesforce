import { LightningElement, api } from 'lwc';

export default class Pagination extends LightningElement {
    currentPage = 1;
    allRecords = [];
    recordsPerPage = 2;
    pagesAmount;

    @api
    set records(data){
        if (data){
            this.allRecords = data;
            this.pagesAmount = Math.ceil(this.allRecords.length / this.recordsPerPage);
            this.paginateRecords();
        }
    }

    get records(){
        return this.paginatedRecords;
    }

    get previousButtonAccessibility(){
        if(this.currentPage <= 1){
            return true;
        } else {
            return false;
        }
    }

    get nextButtonAccessibility(){
        if(this.currentPage >= this.pagesAmount){
            return true;
        } else {
            return false;
        }
    }

    paginateRecords(){
        const startSlice = (this.currentPage - 1)*this.recordsPerPage;
        const endSlice = this.currentPage * this.recordsPerPage;
        this.paginatedRecords = this.allRecords.slice(startSlice, endSlice);
        this.dispatchEvent(new CustomEvent('paginate', {
            detail: {
                records: this.paginatedRecords
            }
        }))
    }

    previousHandler(){
        if(this.currentPage > 1){
            this.currentPage--;
            this.paginateRecords();
            this.setNumbersButtonsAccessibility();
        }
    }

    nextHandler(){    
        if(this.currentPage < this.pagesAmount){
            this.currentPage++;
            this.paginateRecords();
            this.setNumbersButtonsAccessibility();
        }
    }

    get numbersButtonsArray(){
        let array = [];
        for(let i=1; i<=this.pagesAmount; i++){
            let numberButton = {number: i};
            array.push(numberButton);
        }
        return array;
    }

    numberButtonHandler(event){
        this.currentPage = event.target.dataset.buttonId;
        this.paginateRecords();
        this.setNumbersButtonsAccessibility();
    }

    setNumbersButtonsAccessibility(){
        for(let i=1; i<=this.pagesAmount; i++){
            const element = this.template.querySelector(`[data-button-id="${i}"]`);
            if(element.dataset.buttonId === this.currentPage){
                element.disabled = true;
            } else {
                element.disabled = false;
            }
        }
    }
}