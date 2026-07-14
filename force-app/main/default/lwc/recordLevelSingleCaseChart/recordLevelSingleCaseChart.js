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
       // this.clickedButtonLabelCheck = true;
    }
}