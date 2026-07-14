import { LightningElement, track, api, wire } from 'lwc';
import getFilterDetailFromName from '@salesforce/apex/FilterDetailController.getFilterDetailFromName';
import getFilterDetails from '@salesforce/apex/FilterDetailController.getFilterDetails';
import ChartJS from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
import { refreshApex } from '@salesforce/apex';
export default class Filter3Component extends LightningElement {

    @track dataSet;
    @track title = '';
    @track TrackingBasedOnAverageTimeZonePickval = 'In Hours';
    @track isModalOpen = false;

    @api isCreateFilter = false;
    @api selectedFilterName;
    @api saveFilterId;

    chartjsInitialized = true;
    myChart;
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
        this.getcallby();
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        this.title = 'Tracking Based On Average Time(In Hours)';
        this.TrackingBasedOnAverageTimeZonePickval = 'In Hours';
        this.getcallby();
    }
    submitDetails() {
        this.isModalOpen = false;
    }

    connectedCallback() {
        this.title = 'Tracking Based On Average Time(In Hours)';
        this.TrackingBasedOnAverageTimeZonePickval = 'In Hours';
        this.getcallby();
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;
        Promise.all([
            loadScript(this, ChartJS)
        ])
            .then(() => {
            })
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

    TrackingBasedOnAverageTimeZonePick(event) {
        this.TrackingBasedOnAverageTimeZonePickval = event.target.value;
        if (this.TrackingBasedOnAverageTimeZonePickval == 'In Minutes') {
            this.title = 'Tracking Based On Average Time(In Minutes)';
            this.getcallby();
        }
        else if (this.TrackingBasedOnAverageTimeZonePickval == 'In Hours') {
            this.title = 'Tracking Based On Average Time(In Hours)';
            this.getcallby();
        }
        else if (this.TrackingBasedOnAverageTimeZonePickval == 'In Days') {
            this.title = 'Tracking Based On Average Time(In Days)';
            this.getcallby();
        }
    }

    getcallby() {
        if (this.selectedFilterName != null) {
            getFilterDetailFromName({ filterName: this.selectedFilterName, timezone: this.TrackingBasedOnAverageTimeZonePickval })
                .then(data => {
                    if (data) {
                        this.dataSet = data;
                        this.Initializechartjs();
                    }
                    else if (result.error) {
                        return result.error;
                    }
                })
        }
        else {
            getFilterDetails({ saveFilterId: this.saveFilterId, timezone: this.TrackingBasedOnAverageTimeZonePickval })
                .then(data => {
                    if (data) {
                        this.dataSet = data;
                        this.Initializechartjs();
                    }
                    else if (result.error) {
                        return result.error;
                    }
                })
        }
    }

    Initializechartjs() {
        if (this.myChart != undefined) {
            this.myChart.destroy();
        }
        var labell = [];
        var count = [];
        for (let key in this.data) {
            this.labell.push(key);
            this.count.push(data[key]);
        }

        var ctx = this.template.querySelector(".pie-chart2").getContext('2d');
        this.myChart = new Chart(ctx, {
            type: 'bar',
            data: {

                labels: Object.keys(this.dataSet),
                datasets: [{
                    label: 'Tracking Based On Average Time',
                    data: Object.values(this.dataSet),
                    backgroundColor: "green"
                }],
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
    }


    renderedCallback() {
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;
        Promise.all([
            loadScript(this, ChartJS)
        ])
            .then(() => {
            })
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

}