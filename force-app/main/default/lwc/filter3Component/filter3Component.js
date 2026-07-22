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
        const t2gPalette = ['#6D5BF7', '#22C55E', '#F59E0B', '#EC4899', '#06B6D4', '#F43F5E', '#84CC16', '#A855F7', '#3B82F6', '#F97316'];
        const t2gLabels = Object.keys(this.dataSet);
        const t2gColors = t2gLabels.map((_, i) => t2gPalette[i % t2gPalette.length]);
        this.myChart = new Chart(ctx, {
            type: 'bar',
            data: {

                labels: t2gLabels,
                datasets: [{
                    label: 'Tracking Based On Average Time',
                    data: Object.values(this.dataSet),
                    backgroundColor: t2gColors,
                    hoverBackgroundColor: t2gColors,
                    borderRadius: 8,
                    borderSkipped: false,
                    maxBarThickness: 52
                }],
            },
            options: {
                responsive: true,
                maintainAspectRatio: true,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: '#1c1b2e',
                        padding: 10,
                        cornerRadius: 8
                    }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { color: '#746E94', font: { weight: '500' } }
                    },
                    yAxes: [{
                        display: true,
                        ticks: {
                            beginAtZero: true
                        }
                    }],
                    y: {
                        grid: { color: 'rgba(116, 110, 148, 0.12)' },
                        ticks: { color: '#746E94' },
                        beginAtZero: true
                    }

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