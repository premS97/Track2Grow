import { LightningElement, track, api, wire } from 'lwc';
//import picklistLabel from '@salesforce/label/c.picklistLabel';
import getHourVal from '@salesforce/apex/ObjectPicklistController.getHourVal';
import getFD from '@salesforce/apex/averagetimechartcontroller.getFD';
import getFD1 from '@salesforce/apex/averagetimechartcontroller.getFD1';
//import objectLabel from '@salesforce/label/c.objectLabel';
import getPicklistFields from '@salesforce/apex/ObjectPicklistController.getPicklistFields';
import getObject from '@salesforce/apex/ObjectPicklistController.getObject';
import picklistValues from '@salesforce/apex/ObjectPicklistController.picklistValues';
import getRecordType from '@salesforce/apex/ObjectPicklistController.getRecordType';
import getAllcaserecord from '@salesforce/apex/averagetimechartcontroller.retriveAccs';
import retriveFilter from '@salesforce/apex/averagetimechartcontroller.retriveFilter';
import getBatchJobStatus from '@salesforce/apex/averagetimechartcontroller.getBatchJobStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLeadByStatus1 from '@salesforce/apex/averagetimechartcontroller.mapvalue';
import ChartJS from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
import getLeadByStatus from '@salesforce/apex/averagetimechartcontroller.getLeadByStatus';
import pickListValueDynamically from '@salesforce/apex/averagetimechartcontroller.pickListValueDynamically';
export default class Filter_LWC extends LightningElement {

    @track filterVal;
    @track filterNameErr;
    @track rDid;
    @track fnError = '';
    @track clickedButtonLabelCheck;
    @track picklistVal;
    @track objectVal;
    @track businessNameVal;
    @track objectFieldValueVal;
    @track objectRecordTypeVal;
    @track jobid;
    @track toggleValue;
    @track progress;
    @track dataSet;
    @track picklistVal12;
    @track selectedOption = 'bar';
    @track clickedButtonLabel;

    @track disableBtn = true;
    @track isAlreadySaved = false;
    @track isdateError = false;
    @track isfnError = false;
    @track isCheckFilter = true;
    @track runchart = false;
    @track isFilterSave = false;
    @track picklistValueStr = false;
    @track startDatecheck = false;
    @track enddatecheck = false;
    @track enableHandle = true;
    @track disableHandle = false;
    @track disableButton = false;

    @track chartAmtData = [];
    @track chartLabel = [];
    @track chartAmtData = [];
    @track chartLabel = [];

    @api chartConfiguration;
    @api chartjsInitialized = false;
    @api checkRendredChild = false;
    @api checkRendred = false;

    // label = { picklistLabel };
    // label1 = { objectLabel };
    hourNameLabel;
    filterName;
    myInterval;
    jobinfo;
    objectFieldValMessage;
    picklistStr;
    objectStr;
    fieldStr;
    options;
    options1;
    selectedVal;
    selectedVal1;
    startdate;
    minDate;
    enddate;
    dateError;
    objectFieldVal;
    objValue;
    piechartsaved;
    requiredOptions;
    requiredOptions1;
    clickedButtonLabel;
    defaultValues = [];
    defaultValues1 = [];
    recordsList = [];
    message = '';
    errorMsg = 'Error Message - Please Select ';

    havingValue = false;
    requiredField1 = false;
    requiredField2 = false;
    requiredFieldVal = false;
    requiredField3 = false;
    requiredField4 = false;
    requiredField5 = false;
    isObjFieldHistory = false;
    requiredCustomDate = false;
    batchStart = false;
    batchEnd = false;


    @wire(pickListValueDynamically, {
        customObjInfo: { 'sobjectType': 'Case' },
        selectPicklistApi: 'Status'
    }) selectTargetValues;


    connectedCallback() {
        getHourVal()
            .then((data) => {
                this.hourNameLabel = data;
            })
        var today = new Date();
        this.currentDate = today.toISOString();
        var defaultcurrent = new Date();
        this.minDate = defaultcurrent.toISOString();

    }
    get objVal() {
        if (this.objectVal != null && this.recordsList.length != 0) {
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1) + " Field";
        }
        else {
            return "Object Field";
        }
    }
    get objFieldVal() {
        if (this.objectVal == null && this.objectField == null) {
            return "Object Field Value";
        }
        if (this.objectVal != null && this.objectField != null && this.recordsList.length != 0) {
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1) + ' ' + this.objectField + " Value";
        }
        if (this.objectVal != null && this.recordsList.length != 0) {
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1) + " Field Value";
        }
        else {
            return "Object Field Value";
        }
    }
    get objRecordType() {
        if (this.objectVal != null && this.recordsList.length != 0) {
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1) + " Record Type";
        }
        else {
            return "Object Record Type";
        }
    }

    constructor() {
        super();
        // this.picklistStr = picklistLabel.split(',');
        //this.objectStr = objectLabel.split(',');


    }

    selectPicklistValueChange(event) {
        this.clickedButtonLabelCheck = false;
        this.picklistVal = event.target.value;
        if (this.picklistVal == 'Custom Date') {
            this.picklistValueStr = true;
            this.disableBtn = true;
        }
        else {
            this.picklistValueStr = false;
            this.startdate = null;
            this.enddate = null;
            this.requiredCustomDate = false;
        }
    }

    onHandleObjectSearch(event) {
        this.objectFieldValMessage = '';
        this.isObjFieldHistory = false;
        this.requiredField1 = false;
        this.objectVal = event.target.value;
        if (event.target.value == '') {
            this.recordsList = [];
            this.havingValue = false;
            this.objectFieldVal = [];
            this.selectedVal = [];
            this.options = [];
            this.defaultValues = [];
            this.selectedVal1 = [];
            this.options1 = [];
            this.defaultValues1 = [];
        }


        getObject({ searchObject: this.objectVal })
            .then((result) => {
                if (result.length === 0 && this.objectVal[0] != ' ') {
                    this.havingValue = true;
                    this.recordsList = [];
                    this.message = "No Object Found with " + this.objectVal + " name";
                }
                else if (result.length === 0 && this.objectVal[0] == ' ') {
                    this.havingValue = true;
                    this.recordsList = [];
                    this.message = "Please start the search with a valid alphabet";
                }
                else {
                    this.havingValue = false;
                    this.recordsList = result;
                    this.message = "";
                }
            })
            .catch((error) => {
                this.recordsList = undefined;
            });

    }

    selectObjectValueChange() {
        this.options = [];
        this.options1 = [];
        this.objectFieldVal = [];
        this.defaultValues1 = [];
        this.defaultValues = [];
        this.clickedButtonLabelCheck = false;
        if (this.objectVal == '' || this.objectVal == ' ' || this.objectVal == null) {
            this.selectedVal1 = [];
            this.options1 = [];
            this.defaultValues1 = [];
            this.objectFieldVal = [];
        }
        else {
            getPicklistFields({ sobjectValue: this.objectVal })
                .then((result) => {
                    if (result.length != 0) {
                        this.objectFieldVal = result;
                        this.isObjFieldHistory = false;
                        this.objectFieldValMessage = '';
                    }
                    else {
                        this.isObjFieldHistory = true;
                        this.objectFieldValMessage = 'History of ' + this.objectVal + ' field is not ON';
                    }
                })
                .catch((error) => {
                    this.error = error;
                });

            getRecordType({ objectName: this.objectVal })
                .then((result) => {
                    if (result.length != 0) {
                        for (let key in result) {
                            this.options1 = Object.keys(result).map(key => ({ label: result[key], value: result[key] }));
                            this.defaultValues1.push(result[key]);
                        }
                        this.defaultValues1.sort();

                        this.selectedVal1 = this.defaultValues1.sort();;
                    }
                    else {
                        this.selectedVal1 = [];
                        this.defaultValues1 = [];
                    }
                })
                .catch((error) => {
                    this.error = error;
                });
        }
    }

    selectHourValueChange(event) {
        this.clickedButtonLabelCheck = false;
        this.businessNameVal = event.target.value;
    }

    objectField;
    selectObjectFieldChange(event) {
        this.clickedButtonLabelCheck = false;
        this.objectField = event.target.value;
        if (this.objectField == '' || this.objectField == ' ' || this.objectField == null) {
            this.defaultValues = [];
            this.selectedVal = [];
            this.options = [];
        }
        else {
            picklistValues({ objectName: this.objectVal, fieldName: event.target.value })
                .then((result) => {
                    if (result.length != 0) {
                        this.defaultValues = [];
                        this.selectedVal = [];
                        for (let key in result) {
                            this.options = Object.keys(result).map(key => ({ label: result[key], value: result[key] }));
                            this.defaultValues.push(result[key]);
                        }
                        this.defaultValues.sort();
                        this.selectedVal = this.defaultValues.sort();
                    }
                    else {
                        this.defaultValues = [];
                        this.selectedVal = [];
                    }
                })
                .catch((error) => {
                    this.error = error;
                });
        }
    }

    handleChange(event) {

        this.clickedButtonLabelCheck = false;
        this.selectedVal = event.detail.value;
    }

    onHandleCheckBox(event) {
        this.isFilterSave = event.target.checked;
        if (this.isFilterSave == false) {
            this.filterName = undefined;
            this.requiredField5 = false;
        }
    }

    handleChange1(event) {
        this.clickedButtonLabelCheck = false;
        this.selectedVal1 = event.detail.value;
    }

    datehandle(event) {
        this.clickedButtonLabelCheck = false;
        this.startdate = event.detail.value;
        this.startDatecheck = false;
        if (this.startdate != null) {
            this.disableBtn = false;
        }
    }
    datehandle1(event) {
        this.clickedButtonLabelCheck = false;
        this.enddate = event.detail.value;
        this.enddatecheck = false;
    }

    datehandle2() {
        this.clickedButtonLabelCheck = false;
        if (this.startdate > this.enddate) {
            this.isdateError = true;
            this.dateError = 'End Date must be ' + this.startdate + ' or later.';
            this.enddate = '';
            this.enddatecheck = true;
            this.startDatecheck = true;

        }
        else {
            this.dateError = '';
            this.isdateError = false;
            this.enddate = this.enddate;
        }

    }

    onFilterName(event) {
        var FN = event.target.value;
        var str = FN.charAt(0).toUpperCase() + FN.slice(1);
        if (FN.charAt(0) == ' ') {
            this.requiredField5 = false;
            this.isfnError = true;
            this.fnError = "Please start the filter name with a valid alphabet";
        }
        else {
            this.isfnError = false;
            this.filterName = str;

        }
    }

    handleClick(event) {
        var isObjectVal = false;
        if (event.target.label === 'Save') {
            if (this.objectVal == undefined || this.objectVal == null || this.objectVal == '') {
                this.requiredField1 = true;
                this.errorMsg += ' Object Type,';
            }
            else {
                this.requiredField1 = false;
                if (this.message.includes('No Object Found with ') || this.isObjFieldHistory == true || this.message.includes("Please start the ")) {
                    isObjectVal = true;
                    this.requiredField1 = false;
                }
                else {
                    isObjectVal = false;
                    this.requiredField1 = false;
                }
                if (isObjectVal == true && (this.message.includes('No Object Found with ') || this.message.includes("Please start the "))) {
                    this.requiredField1 = false;
                    this.requiredField2 = false;
                    this.requiredField3 = false;
                    this.requiredField4 = false;
                    this.requiredField5 = false;
                    this.requiredFieldVal = false;
                    this.requiredCustomDate = false;
                    this.isObjFieldHistory = false;
                }
                if (isObjectVal == true && this.isObjFieldHistory == true) {
                    this.requiredField2 = false;
                    this.requiredFieldVal = false;
                    this.requiredField3 = false;
                    this.requiredField4 = false;
                    this.requiredField5 = false;
                    this.requiredCustomDate = false;
                    this.message = '';
                }
                if (isObjectVal == false && (this.objectField == undefined || this.objectField == '')) {
                    this.requiredField2 = true;
                    this.errorMsg += ' Object Field Type,';
                }
                else {
                    this.requiredField2 = false;
                }
                if(isObjectVal == false && (this.selectedVal.length==0||this.selectedVal==undefined||this.selectedVal==''||this.selectedVal==null)){
                    this.requiredFieldVal = true;
                    this.errorMsg += ' Object Field Value,';
                }
                else{
                    this.requiredFieldVal = false;
                }
                if (isObjectVal == false && (this.selectedVal == undefined || this.objectVal == ' ')) {
                    this.errorMsg += ' Object Field Value Type,';
                }

                if (isObjectVal == false && (this.picklistVal == undefined || this.picklistVal == '')) {
                    this.requiredField3 = true;
                    this.errorMsg += ' Time Period,';
                }
                else {
                    this.requiredField3 = false;
                }

                if (isObjectVal == false && (this.businessNameVal == undefined || this.objectVal == '' || this.businessNameVal == '')) {
                    this.requiredField4 = true;
                    this.errorMsg += ' Business Hours,';
                }
                else {
                    this.requiredField4 = false;
                }
                // custom date condition
                if (isObjectVal == false && (this.picklistValueStr == true)) {
                    if ((this.startdate != undefined || this.startdate != null) && (this.enddate != undefined || this.enddate != null) && this.isdateError == false) {
                        this.requiredCustomDate = false;
                    }
                    else {
                        this.requiredCustomDate = true;

                        if (this.enddatecheck == true) {
                            this.errorMsg += 'a valid End Date.';
                        }
                        if (this.startDatecheck == true) {
                            this.errorMsg += 'a valid Start Date.';
                        }
                        if (!Boolean(this.startdate) && !Boolean(this.enddate))
                            this.errorMsg += ' Start and End Date.';
                        else if (!Boolean(this.startdate) && this.startDatecheck == false)
                            this.errorMsg += ' Start Date.';
                        else if (!Boolean(this.enddate) && this.enddatecheck == false)
                            this.errorMsg += ' End Date.';

                    }
                }
                if (isObjectVal == false && this.requiredField1 == false && this.requiredField2 == false && this.requiredFieldVal == false && this.requiredField3 == false && this.requiredField4 == false && this.selectedVal != undefined && this.requiredCustomDate == false) {
                    if (this.isFilterSave == true && this.isCheckFilter == true) {
                        if (this.filterName == undefined || this.objectVal == '' || this.filterName == '' || this.filterName == null) {
                            this.requiredField5 = true;
                            this.errorMsg = 'Error Message - Please fill unique filter name';
                        }
                        else {
                            this.requiredField5 = false;
                            this.checkFilter();
                        }
                    }
                    else if (this.isFilterSave == false) {

                        this.getAllcaserecords();
                        const closeModal = new CustomEvent("saveclick", {
                            detail: false,
                        });
                        this.dispatchEvent(closeModal);
                    }
                }
            }

        }
    }

    checkFilter() {
        retriveFilter({ objectVal: this.objectVal, field: this.objectField, fieldValues: this.selectedVal.sort(), recordTypes: this.selectedVal1.sort(), businessHour: this.businessNameVal, dates: this.picklistVal, startDate: this.startdate, endDate: this.enddate, willRefresh: this.isFilterSave, filterName: this.filterName })
            .then((data) => {
                if (data != null) {
                    this.isCheckFilter = true;
                    this.filterNameErr = data;
                    const event = new ShowToastEvent({
                        title: 'ERROR',
                        message: data,
                        variant: 'error ' + data,
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(event);
                }
                else {
                    this.isCheckFilter = false;
                    if (this.filterName != null && this.filterName != '' && this.filterName != ' ' && this.isCheckFilter == false) {
                        const closeModal = new CustomEvent("saveclick", {
                            detail: false,
                        });
                        this.dispatchEvent(closeModal);
                        this.getAllcaserecords();
                    }
                    else {
                        this.requiredField5 = false;
                    }
                }
            })
    }

    getAllcaserecords() {
        this.isCheckFilter = false;
        getAllcaserecord({ objectVal: this.objectVal, field: this.objectField, fieldValues: this.selectedVal.sort(), recordTypes: this.selectedVal1, businessHour: this.businessNameVal, dates: this.picklistVal, startDate: this.startdate, endDate: this.enddate, willRefresh: this.isFilterSave, filterName: this.filterName, historySwitch: true })
            .then(result => {
                this.jobid = result;
                if (this.jobid != null) {
                    this.enableHandle = false;
                    this.disableHandle = true;
                    this.disableButton = true;
                    var intervaldata = setInterval(function (jobid111, parentthis) {
                        getBatchJobStatus({ jobID: jobid111 })
                            .then(result => {
                                this.jobinfo = result;
                                // console.log('Status22 = >', result.Status);
                                if (result.Status == 'Completed') {
                                    clearInterval(intervaldata);
                                    parentthis.checkCondition();
                                }
                                if (result.Status == 'Failed') {
                                    clearInterval(intervaldata);
                                    parentthis.failedDetail();
                                }
                            });
                    }, 3000, this.jobid, this);
                    this.myInterval = intervaldata;
                }
                else {
                    if (this.isFilterSave == false) {
                        alert('already saved');
                        getFD({ objectVal: this.objectVal, field: this.objectField, fieldValues: this.selectedVal.sort(), recordTypes: this.selectedVal1.sort(), businessHour: this.businessNameVal, dates: this.picklistVal, startDate: this.startdate, endDate: this.enddate, willRefresh: this.isFilterSave })
                            .then(data => {
                                this.filterVal = data;
                                this.rDid = data[0].Id;
                                this.callOnRender();
                            })
                    }

                    this.filterVal = '';
                    if (this.isFilterSave == true && this.filterName != null) {
                        getFD1({ objectVal: this.objectVal, field: this.objectField, fieldValues: this.selectedVal.sort(), recordTypes: this.selectedVal1.sort(), businessHour: this.businessNameVal, dates: this.picklistVal, startDate: this.startdate, endDate: this.enddate, willRefresh: this.isFilterSave, FN: this.filterName })
                            .then(data => {
                                this.filterVal = data;
                                this.rDid = data[0].Id;
                                this.callOnRender();
                            });
                    }

                }
            })
        if (this.isCheckFilter == false) {
            const event = new ShowToastEvent({
                title: 'Success Message',
                message: 'Data is sucessfully received',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
            this.isCheckFilter = true;
        }
    }
    failedDetail() {
        const event = new ShowToastEvent({
            title: 'Error',
            message: 'Batch is failed please contact your Admin',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
        alert('batch is Failed');
    }
    checkCondition() {
        if (this.isFilterSave == false || this.filterName == null || this.filterName == '' || this.filterName == undefined) {
            setTimeout((() => {
                this.onSaveUncheck();
                const event = new ShowToastEvent({
                    title: 'Success Message',
                    message: 'batch is Completed',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            }).bind(this), 8000)
        }
        else {
            setTimeout((() => {
                this.onSaveCheck();
                const event = new ShowToastEvent({
                    title: 'Success Message',
                    message: 'batch is Completed',
                    variant: 'success',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
                alert('batch is Completed');
            }).bind(this), 8000)
        }
    }
    onSaveUncheck() {
        this.filterVal = '';
        getFD({ objectVal: this.objectVal, field: this.objectField, fieldValues: this.selectedVal.sort(), recordTypes: this.selectedVal1, businessHour: this.businessNameVal, dates: this.picklistVal, startDate: this.startdate, endDate: this.enddate, willRefresh: this.isFilterSave })
            .then(data => {
                this.filterVal = data;
                this.rDid = data[0].Id;
                this.callOnRender();
            });

    }
    onSaveCheck() {
        this.filterVal = '';
        getFD1({ objectVal: this.objectVal, field: this.objectField, fieldValues: this.selectedVal.sort(), recordTypes: this.selectedVal1.sort(), businessHour: this.businessNameVal, dates: this.picklistVal, startDate: this.startdate, endDate: this.enddate, willRefresh: this.isFilterSave, FN: this.filterName })
            .then(data => {
                this.filterVal = data;
                this.rDid = data[0].Id;
                this.callOnRender();
            });

    }
    onobjectselection(event) {
        this.objectVal = event.target.dataset.name;
        this.recordsList = [];
        this.message = '';
        this.selectObjectValueChange();
    }
    caseownerdel;


    callOnRender() {
        const closeModal = new CustomEvent('batchcomplete', {
            detail:
            {
                recId: this.rDid,
                filterValDetail: this.filterVal,
            }
        });
        this.dispatchEvent(closeModal);
        this.enableHandle = true;
        this.disableHandle = false;
        this.disableButton = false;

        getLeadByStatus1({ objectVal: this.objectVal, Field: this.objectField, fieldValues: this.selectedVal.sort(), recordTypes: this.selectedVal1.sort(), businessHour: this.businessNameVal, dates: this.picklistVal, startDate: this.startdate, endDate: this.enddate, willRefresh: this.isFilterSave })
            .then(data => {

                this.chartLabel = [];
                this.chartAmtData = [];
                if (data) {
                    for (let key in data) {
                        this.chartLabel.push(key);
                        this.chartAmtData.push(data[key]);
                    }
                    this.chartConfiguration = {
                        type: this.selectedOption,
                        data: {
                            datasets: [{
                                label: 'Tracking Based On Average Time',
                                backgroundColor: "green",
                                data: this.chartAmtData,
                            },
                            ],
                            labels: this.chartLabel,
                        },

                        options: {},

                    };
                    this.checkRendred = false;
                    this.checkRendredChild = true;
                    this.clickedButtonLabelCheck = true;
                    this.error = undefined;
                }
                else if (error) {
                    this.error = error;
                    this.record = undefined;
                }
            })
    }

    backClick(event) {
        const childEvent = new CustomEvent("handleback", { detail: false });
        this.dispatchEvent(childEvent);
    }

    selectOptionChanveValue(event) {
        this.picklistVal12 = event.target.value;
        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
        this.getcallby();
    }

    getcallby() {
        getLeadByStatus({ status: this.picklistVal12, objectVal: this.objectVal, Field: this.objectField, recordTypes: this.selectedVal1, businessHour: this.businessNameVal, dates: this.picklistVal, startDate: this.startdate, endDate: this.enddate, willRefresh: this.isFilterSave })
            .then(data => {
                if (data) {

                    var dataArray = [];
                    dataArray = data;

                    let dataIndexes = dataArray.map((d, i) => i);
                    dataIndexes.sort((a, b) => {
                        return dataArray[a] - dataArray[b];
                    });

                    this.dataSet = dataArray;
                    this.Initializechartjs();

                } else if (result.error) {
                    return result.error;
                }

            })
    }


    renderedCallback() {
        if (this.recordsList != null && this.recordsList != undefined && this.recordsList.length > 0) {
            this.havingValue = true;
        }
        if (this.chartjsInitialized) {

            return;
        }
        this.chartjsInitialized = true;
        Promise.all([
            loadScript(this, ChartJS)
        ])
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading chartJs',
                        message: error.message,
                        variant: 'error'
                    })
                );
            });
    }
    Initializechartjs() {
        if (window.bar != undefined) {
            window.bar.destroy();
        }
        var labell = [];
        var count = [];
        for (let ownerLabel in Object.values(this.dataSet)) {

            labell.push(Object.values(this.dataSet)[ownerLabel].label);
            count.push(Object.values(this.dataSet)[ownerLabel].count);
        }

        var arrayOfObj = labell.map(function (d, i) {
            return {
                label: d,
                data: count[i] || 0
            };
        });


        var sortedArrayOfObj = arrayOfObj.sort(function (a, b) {
            return a.data - b.data;
        });


        var newArrayLabel = [];
        var newArrayData = [];
        sortedArrayOfObj.forEach(function (d) {
            newArrayLabel.push(d.label);
            newArrayData.push(d.data);
        });
        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
        window.bar = new Chart(ctx, {
            type: 'bar',
            data: {

                labels: newArrayLabel,
                datasets: [{
                    label: 'Average Time Spent On Owner Leader Board Per Status',
                    data: newArrayData,
                    backgroundColor: "green"
                }],
            },
            options: {

            },
        });

    }

    toggleHandle(event) {
        this.toggleValue = event.target.checked;
    }
}