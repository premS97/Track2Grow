import { LightningElement, track, api } from 'lwc';
import pickListValueDynamically from '@salesforce/apex/averagetimechartcontroller.pickListValueDynamically';
import getLeadByStatus from '@salesforce/apex/averagetimechartcontroller.ownerbasedonaveragetime';
import getUserList from '@salesforce/apex/averagetimechartcontroller.getUserList';
import avergetimesinglerecord from '@salesforce/apex/averagetimechartcontroller.avergetimesinglerecord';
import ChartJS from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class OwnerBasedAverageChart extends LightningElement {

    @track options = [];
    casenumber = [];
    picklistVal;
    casevalue;
    showchart = false;
    onlycase = false
    secondchart = true;
    textValue = '';
    id;

    ///////////////list
    handleInputChange(event) {
        this.textValue = event.detail.value;
        console.log('value of >>>?', this.textValue)
    }
    //////////////////

    dynmic() {
        getUserList()
            .then(result => {
                if (result) {
                    console.log('result', result);
                    // this.selectTargetValues = data;
                    for (let key in result) {
                        this.options = Object.keys(result).map(key => ({ label: result[key], value: result[key] }));
                    }
                }
                else if (result.error) {
                    return result.error;
                }
            })
        console.log('hdghdf', this.dataSet)
    }
    handlePicklistChange(event) {
        this.picklistVal = event.target.value;
        this.cardTitle = 'Owner Based On Average Time(In Minutes) for '+this.picklistVal;
        this.secondchart = true;
        this.textValue = '';
        this.getcallby();
        this.showchart = true;
     }
  handlePicklistcase() {
        //this.casevalue = event.target.label;
        this.casevalue = this.textValue;
        console.log('value hjghj', this.casevalue);
        if(this.casevalue.length>0)
        {
           this.showchart = true;
          this.secondchart = false;
         this.cardTitle = 'Average Time On Case Status(In Minutes) for Case number:'+ this.casevalue;
         //this.getcallby();
         this.singlecasenumber();
        this.picklistVal = '';
         this.dynmic();
        }
        else{
            const evt = new ShowToastEvent({
                            title: this._title,
                            message: "Please enter a case number",
                            variant: this.variant,
                        });
                        this.dispatchEvent(evt);
        }
       
    }

    ////////////////
    //@track isModalOpen = false;
    @track picklistVal;
    @track cardTitle;
    @track SobjectFieldType;
    @track SobjectType;
    @track dataSet;
    @track SobjectFieldvalue = [];
    @track sentences = [];
    @track none = '1';
    @api isManagePackage;
    @api selectedFilterName;
    @api filterDetailVal;
    @api isCreateFilter;
    @track dataSetSingleRec;

    mychart;
    // picklistValRight = 'Max 50';


    // openModal() {
    //     this.isModalOpen = true;
    //     this.getcallby();
    // }
    // closeModal() {
    //     this.isModalOpen = false;
    //     this.getcallby();
    // }
    // submitDetails() {
    //     this.isModalOpen = false;
    // }

    connectedCallback() {
        console.log('Connected callback');
        this.dynmic();
        var fieldType;
        var fieldValue;
        var arr = [];
        if (this.filterDetailVal != undefined || this.filterDetailVal != null || this.filterDetailVal.length > 0) {
            if (!this.isManagePackage) {
                this.filterDetailVal.map((val) => {
                    this.SobjectType = val.SobjectType__c;
                    fieldType = val.SobjectFieldType__c;
                    fieldValue = val.SobjectFieldValue__c;
                });
            }
            else {
                this.filterDetailVal.map(val => {
                    this.SobjectType = val.Track2Grow__SobjectType__c;
                    fieldType = val.Track2Grow__SobjectFieldType__c;
                    fieldValue = val.Track2Grow__SobjectFieldValue__c;
                });
            }
            this.SobjectFieldType = fieldType;
            this.SobjectFieldvalue = fieldValue;
            if (this.SobjectFieldvalue != undefined) {


                arr.push(this.SobjectFieldvalue.split(','));
                this.picklistVal = arr[0][0];
                this.dynamic();
                this.getcallby();
            }
            else {
                // window.location.reload();
            }
        }
        else {
            // window.location.reload();
        }
        console.log('value of case object', this.SobjectType);
         if (this.SobjectType == 'case') {
            this.onlycase = true;
        }
    }

    dynamic() {
        pickListValueDynamically({
            customObjInfo: { 'sobjectType': this.SobjectType },
            selectPicklistApi: this.SobjectFieldType
        })
            .then(data => {
                this.selectTargetValues = data;
            })
    }
    selectOptionChanveValue(event) {
        this.picklistVal = event.target.value;
        this.cardTitle = 'Average Time Spent On Owner Leader Board Per ' + this.SobjectFieldType + ':' + this.picklistVal + ' (In Minutes)';
        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
        this.getcallby();
    }
    selectOptionChanveValueRight(event) {
        this.picklistValRight = event.target.value;
        this.getcallby();
    }
    getcallby() {
        if (this.secondchart) {
            getLeadByStatus({ status: this.SobjectFieldvalue, maxNum: this.picklistValRight, objectVal: this.objectVal, Field: this.objectField, recordTypes: this.selectedVal1, businessHour: this.businessNameVal, dates: this.picklistVal, startDate: this.startdate, endDate: this.enddate, willRefresh: this.isFilterSave, selectedName: this.selectedFilterName, ownerpicklist: this.picklistVal })
                .then(data => {
                    if (data) {
                        console.log('value of >>>', data);
                        this.dataSet = data;
                        this.Initializechartjs();
                    }
                    else if (result.error) {
                        return result.error;
                    }
                })
        }
        // else {
        //     avergetimesinglerecord({ casevalueid: this.casevalue, id:this.id })
        //         .then((result) => {
        //             this.dataSetSingleRec = result;

        //             console.log('RESULT===?',result);
        //             if (result!=null) {
        //                 console.log('value of case number', result);
        //                 this.Initializechartjs();
        //                 console.log('value dataSetSingleRec', this.dataSetSingleRec);
        //             }
        //             else {
        //                 console.log('value of case number in else', result);
        //                 const evt = new ShowToastEvent({
        //                     title: this._title,
        //                     message: "Please enter a valid case number",
        //                     variant: this.variant,
        //                 });
        //                 this.dispatchEvent(evt);
        //             }
        //         })

        // }
    }

    singlecasenumber()
    {
        avergetimesinglerecord({ casevalueid: this.casevalue, id:this.id })
                .then((result) => {
                    this.dataSetSingleRec = result;
                    this.secondchart=false;
                    //console.log('RESULT===?',result.size);
                    if (result!=null) {
                        console.log('value of case number', result);
                        this.Initializechartjs();
                        console.log('value dataSetSingleRec', this.dataSetSingleRec);
                    }
                    else {
                        console.log('value of case number in else', result);
                        const evt = new ShowToastEvent({
                            title: this._title,
                            message: "Please enter a valid case number",
                            variant: this.variant,
                        });
                        this.dispatchEvent(evt);
                        this.Initializechartjs();
                    }
                })
    }

    Initializechartjs() {
        if (this.mychart != undefined) {
            this.mychart.destroy();
        }
        var labell = [];
        var count = [];

        if (this.secondchart) {
            for (let ownerLabel in Object.values(this.dataSet)) {
                labell.push(Object.values(this.dataSet)[ownerLabel].label);
                count.push(Object.values(this.dataSet)[ownerLabel].count);
            }
        }
        else {
            console.log('in else');
            for (let key in this.dataSetSingleRec) {
                labell.push(key);
                count.push(this.dataSetSingleRec[key]);
                console.log('labell', labell);
                console.log('count', count);
            }
        }


        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
        this.mychart = new Chart(ctx, {
            type: 'bar',
            data: {

                labels: labell,
                datasets: [{

                    label: this.cardTitle,
                    data: count,
                    backgroundColor: "green"
                }],
            },
            options: {
                scales: {
                    x: {
                        ticks: {
                            // For a category axis, the val is the index so the lookup via getLabelForValue is needed
                            callback: function (val, index) {
                                // Hide every 2nd tick label
                                return index % 2 === 0 ? this.newArrayLabel(val) : '';
                            },
                            color: 'red',
                        }
                    },
                    yAxes: [{
                        display: true,
                        ticks: {
                            beginAtZero: true
                        }
                    }]

                }
            },
        });
        this.clickedButtonLabelCheck = true;
    }

    renderedCallback() {
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
    ////////////////

}