import { LightningElement, track, api, wire } from 'lwc';
import chartjs from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
import getAllUser from '@salesforce/apex/CaseComparison.getAllUser';
import getAllCasesForUser from '@salesforce/apex/CaseComparison.getAllCasesForUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CaseComparisonComponent extends LightningElement {
    @api selectedFilterName;
    @api isManagePackage;
    @api filterDetailVal;

    @track user1 = [];
    @track user2 = [];
    graphTitle='';
    objectField='';
    objectField1='';
    @track caseUser1;
    @track caseUser2;
    @track chartLabel = [];
    @track chartUser1 = [];
    @track chartUser2 = [];
    @track chartConfigurationChart = false;
    chartLoaded = false;
    isUser2 = true;
    isChartJsInitialized;
    mychart;
    SobjectFieldType;
    SobjectFieldvalue;
    picklistVal;
    @wire(getAllUser) USE(result) {
        if (result.data != null || result.data != undefined) {
            this.user1 = result.data;
        }
    }
    connectedCallback() {
         console.log('Connected callback');
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
        }
        console.log('value of case SobjectFieldvalue', this.SobjectFieldvalue);
    }
    graph() {
        this.graphTitle='Case comparison based On Average Time(In Minutes) between '+this.objectField+' and '+this.objectField1;
        if (this.mychart != undefined) {
            this.mychart.destroy();
        }
        Promise.all([loadScript(this, chartjs)])
            .then(() => {
                var ctx = this.template.querySelector('canvas.barChart').getContext('2d');
                this.isChartJsInitialized = true;
                this.mychart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        datasets: [
                            {
                                label: this.objectField,
                                backgroundColor: "green",
                                data: this.chartUser1,
                            },
                            {
                                label: this.objectField1,
                                backgroundColor: "orange",
                                data: this.chartUser2,
                            },
                        ],
                        labels: this.chartLabel,
                    },
                    options: {
                        scales: {

                            yAxes: [{
                                display: true,
                                ticks: {
                                    beginAtZero: true
                                }
                            }]
                        }
                    },
                });
                this.chartConfigurationChart = true;
            })
        this.chartLoaded = true;
    }
    selectObjectFieldChange(event) {
        this.user2 = [];
        if (this.objectField1 != null || this.objectField1 != undefined) {
            if (this.objectField1 != event.target.value) {
                this.objectField = event.target.value;
            }
            else {
                 const evt = new ShowToastEvent({
                            title: this._title,
                            message: "Please Select differnt User 2",
                            variant: 'Warning',
                        });
                        this.dispatchEvent(evt);
                        this.objectField = '';
                        this.objectField1 = '';

               // alert("Please Select differnt User");
            }
        }
        this.objectField = event.target.value;
        if (this.objectField != null || this.objectField != undefined) {
            this.caseUser1 = [];
            getAllCasesForUser({ ownerName: this.objectField, selectedName: this.selectedFilterName,status:this.SobjectFieldvalue})
                .then((data) => {
                    this.caseUser1 = data;
                });
        }
        this.user1.map(val => {
            if (val != this.objectField) {
                this.user2.push(val);
                this.isUser2 = false;
            }
        });
    }
    selectObjectFieldChange1(event) {
        this.objectField1 = event.target.value;
        if (this.objectField1 != null || this.objectField1 != undefined) {
            this.caseUser2 = [];
            getAllCasesForUser({ ownerName: this.objectField1, selectedName: this.selectedFilterName,status:this.SobjectFieldvalue })
                .then((data) => {
                    this.caseUser2 = data;
                });
        }
    }
    chartConfig() {
              if((this.objectField==''|| this.objectField==undefined) || (this.objectField1==''||this.objectField1==undefined)){           
                const evt = new ShowToastEvent({
                                title: this._title,
                                message: "Please Select User",
                                variant: 'Error',
                            });
                            this.dispatchEvent(evt);
              }
        else{
            this.chartUser1 = [];
            this.chartUser2 = [];
            this.chartLabel = [];
            var obj = this.caseUser1[this.objectField];
            var obj1 = this.caseUser2[this.objectField1];
            for (var key in obj) {
                if (!this.chartLabel.includes(key)) {
                    this.chartLabel.push(key);
                }
            }
            for (var key1 in obj1) {
                if (!this.chartLabel.includes(key1)) {
                    this.chartLabel.push(key1);
                }
            }
            for (var key1 in this.chartLabel) {
                if (obj[this.chartLabel[key1]] != null) {
                    this.chartUser1.push(obj[this.chartLabel[key1]]);
                }
                else {
                    this.chartUser1.push(0.0);
                }
                if (obj1[this.chartLabel[key1]] != null) {
                    this.chartUser2.push(obj1[this.chartLabel[key1]]);
                }
                else {
                    this.chartUser2.push(0.0);
                }
            }
            this.chartConfigurationChart = true;
            this.error = undefined;
            this.graph();
        }
       
    }
}