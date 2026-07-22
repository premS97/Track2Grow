import { LightningElement,track,api } from 'lwc';
import avergetimesinglerecord from '@salesforce/apex/averagetimechartcontroller.avergetimesinglerecord';
import ChartJS from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
export default class RecordLevelSingleCaseChart extends LightningElement {

@api recordId;
@track dataSetSingleRec; 
mychart;
casevalueid;
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

connectedCallback() {
                console.log('Value of id',this.recordId);
                avergetimesinglerecord({ casevalueid: this.casevalueid,id:this.recordId  })
                .then((result) => {
                    this.dataSetSingleRec = result;
                    this.Initializechartjs();
                })
                 this.cardTitle = 'Average Time On Case Status(In Minutes)';
     }

     Initializechartjs() {
        if (this.mychart != undefined) {
            this.mychart.destroy();
        }
        var labell = [];
        var count = [];
            for (let key in this.dataSetSingleRec) {
                labell.push(key);
                count.push(this.dataSetSingleRec[key]);
                console.log('labell', labell);
                console.log('count', count);
            }

        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
        const t2gPalette = ['#6D5BF7', '#22C55E', '#F59E0B', '#EC4899', '#06B6D4', '#F43F5E', '#84CC16', '#A855F7', '#3B82F6', '#F97316'];
        const t2gColors = labell.map((_, i) => t2gPalette[i % t2gPalette.length]);
        this.mychart = new Chart(ctx, {
            type: 'bar',
            data: {

                labels: labell,
                datasets: [{

                    label: this.cardTitle,
                    data: count,
                    backgroundColor: t2gColors,
                    hoverBackgroundColor: t2gColors,
                    borderRadius: 8,
                    borderSkipped: false,
                    maxBarThickness: 46
                }],
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
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
                        ticks: {
                            // For a category axis, the val is the index so the lookup via getLabelForValue is needed
                            callback: function (val, index) {
                                // Hide every 2nd tick label
                                return index % 2 === 0 ? this.newArrayLabel(val) : '';
                            },
                            color: '#746E94',
                        }
                    },
                    yAxes: [{
                        display: true,
                        ticks: {
                            beginAtZero: true
                        }
                    }],
                    y: {
                        grid: { color: 'rgba(116, 110, 148, 0.12)' },
                        ticks: { color: '#746E94' }
                    }

                }
            },
        });
       // this.clickedButtonLabelCheck = true;
    }
}