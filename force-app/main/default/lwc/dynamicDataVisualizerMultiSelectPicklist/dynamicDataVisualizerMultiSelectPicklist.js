import { LightningElement, track, api } from 'lwc';

export default class DynamicDataVisualizerMultiSelectPicklist extends LightningElement {
    @api disabled = false;
    @api label = '';
    @api name;
    @api options = [];
    @api placeholder = 'Select an Option';
    @api readOnly = false;
    @api required = false;
    @api singleSelect = false;
    @api showPills = false;
    @api selectedValuesRetain;
    @track currentOptions = [];

    selectedItems = 'Select an Field';
    selectedOptions = [];
    isInitialized = false;
    isLoaded = false;
    isVisible = false;
    isDisabled = false;
    connectedCallback() {
        if(this.options.length > 0 && this.selectedValuesRetain.length > 0){
            this.setInitialSelectedValues(JSON.parse(JSON.stringify(this.selectedValuesRetain)));
        }
        this.isDisabled = this.disabled || this.readOnly;
        this.hasPillsEnabled = this.showPills && !this.singleSelect;
    }

    @api 
    get selectedValues(){
        return this.selectedOptions;
    }
    set selectedValues(val){
        if(val && val.length > 0){
            this.setInitialSelectedValues(val);
        }
    }
    @api 
    get selectableOptions(){
        return this.options;
    }
    set selectableOptions(val){
        if(val && val.length > 0){
            this.options = JSON.parse(JSON.stringify(val));
            this.setInitialSelectedValues(this.selectedValuesRetain);
        }
    }
    setInitialSelectedValues(val){
        if (this.options?.length) {
            this.currentOptions = JSON.parse(JSON.stringify(this.options));
            this.currentOptions.forEach(item => {
                if(val && val.includes(item.value)){
                    item.selected = true;
                }else{
                    item.selected = false;
                }
            
            })
            this.setSelection();
        }
    }
    renderedCallback() {
        if (!this.isInitialized) {
        this.template.querySelector('.multi-select-combobox__input').addEventListener('click', (event) => {
            this.handleClick(event.target);
            event.stopPropagation();
        });
        this.template.addEventListener('click', (event) => {
            event.stopPropagation();
        });
        document.addEventListener('click', () => {
            this.close();
        });
        this.isInitialized = true;
        this.setSelection();
        }
    }
    handleChange(event) {
        this.change(event);
    }
    handleRemove(event) {
        this.selectedOptions.splice(event.detail.index, 1);
        this.change(event);
    }
    handleClick() {
        // initialize picklist options on first click to make them editable
        if ((this.isLoaded === false || (this.currentOptions?.length !== this.options?.length)) && !this.selectedValues?.length) {
            this.currentOptions = JSON.parse(JSON.stringify(this.options));
            this.isLoaded = true;
        }
        if (this.template.querySelector('.slds-is-open')) {
        this.close();
        } else {
        this.template.querySelectorAll('.multi-select-combobox__dropdown').forEach((node) => {
            node.classList.add('slds-is-open');
        });
        }
    }
    change(event) {
        // set selected items
        this.currentOptions
        .filter((item) => item.value === event.detail.item.value)
        .forEach((item) => (item.selected = event.detail.selected));
        this.setSelection();
        const selection = this.getSelectedItems();
        this.dispatchEvent(new CustomEvent('change', { detail: this.singleSelect ? selection[0] : selection }));
        // for single select picklist close dropdown after selection is made
        if (this.singleSelect) {
        this.close();
        }
    }
    close() {
        this.template.querySelectorAll('.multi-select-combobox__dropdown').forEach((node) => {
        node.classList.remove('slds-is-open');
        });
        this.dispatchEvent(new CustomEvent('selectionchange', { detail : {
            selectedOptions : this.selectedOptions
        }}));
        this.dispatchEvent(new CustomEvent('close'));
    }
    setSelection() {
        const selectedItems = this.getSelectedItems();
        let selection = '';
        if (selectedItems.length < 1) {
            selection = this.placeholder;
            this.selectedOptions = [];
        } else if (selectedItems.length > 2) {
            selection = `${selectedItems.length} Options Selected`;
            this.selectedOptions = this.getSelectedItems();
        } else {
            selection = selectedItems.map((selected) => selected.label).join(', ');
            this.selectedOptions = this.getSelectedItems();
        }
        this.selectedItems = selection;
        this.isVisible = this.selectedOptions && this.selectedOptions.length > 0;
    }

    getSelectedItems() {
        return this.currentOptions.filter((item) => item.selected);
    }
}