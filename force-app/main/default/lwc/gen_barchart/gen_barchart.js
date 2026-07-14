// import { LightningElement, api } from 'lwc';
// import chartjs from '@salesforce/resourceUrl/ChartJs';
// import { loadStyle,loadScript } from 'lightning/platformResourceLoader';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 
// export default class Gen_barchart extends LightningElement {
//     @api chartConfig;
//     @api checkifRecordIsRendered= false;
//     isChartJsInitialized;
//     connectedCallback() {
//         console.log('this.chartConfig98',this.chartConfig);
//         //location.reload();

//     }
//     @api chartConfig1;
//     res;

//     @api chartConfig2;
//     res2;
//     result;

//     set chartConfig1(value){
//         this.res = value;
//         console.log('chartConfig1 value after call:-',this.res);
        
//     }
//     get chartConfig1(){
//         return this.res;
//     }

//     set chartConfig2(value){
//         this.res2 = value;
//         //this.chartConfig = this.res2;
//         console.log('chartConfig2 value after call:-',this.res2);
        
//     }
//     get chartConfig2(){
//         return this.res2;
//     }

//     renderedCallback() {
//         console.log('OUTPUT : ',this.checkifRecordIsRendered);
//         if(this.checkifRecordIsRendered){
//          console.log('this.chartConfig1',this.chartConfig);
//         if (this.isChartJsInitialized) {
//             console.log('this.chartConfig',this.chartConfig);
//             return;
//         }
//         // load chartjs from the static resource
//         loadScript(this, chartjs)
//             .then(() => {
//                 console.log('In');
//                 this.isChartJsInitialized = true;
//                 console.log('this.this.isChartJsInitialized',this.isChartJsInitialized);
//                 const ctx = this.template.querySelector('canvas.barChart').getContext('2d');
//                 console.log('this.chart',ctx);
//                 console.log('checking json:',JSON.parse(JSON.stringify(this.chartConfig)));
//                 this.chart = new window.Chart(ctx, JSON.parse(JSON.stringify(this.chartConfig)));
//                 console.log('this.chart',this.chart);
//             })
//             .catch(error => {
//                 console.log('this.error',this.error);
//                 this.dispatchEvent(
//                     new ShowToastEvent({
//                         title: 'Error loading Chart',
//                         message: error.message,
//                         variant: 'error',
//                     })
//                 );
//             });
//             //this.checkifRecordIsRendered = false;
//         }
//         else
//         {
//             console.log('else part after render');
//         }
//         //this.checkifRecordIsRendered= true;
        
//     }

//     rerenderedCallback() {
//         console.log('OUTPUT : ',this.checkifRecordIsRendered);
//         if(this.checkifRecordIsRendered){
//          console.log('this.chartConfig1',this.chartConfig);
//         if (this.isChartJsInitialized) {
//             console.log('this.chartConfig',this.chartConfig);
//             return;
//         }
//         // load chartjs from the static resource
//         loadScript(this, chartjs)
//             .then(() => {
//                 console.log('In');
//                 this.isChartJsInitialized = true;
//                 console.log('this.this.isChartJsInitialized',this.isChartJsInitialized);
//                 const ctx = this.template.querySelector('canvas.barChart').getContext('2d');
//                 console.log('this.chart',ctx);
//                 console.log('checking json:',JSON.parse(JSON.stringify(this.chartConfig)));
//                 this.chart = new window.Chart(ctx, JSON.parse(JSON.stringify(this.chartConfig)));
//                 console.log('this.chart',this.chart);
//             })
//             .catch(error => {
//                 console.log('this.error',this.error);
//                 this.dispatchEvent(
//                     new ShowToastEvent({
//                         title: 'Error loading Chart',
//                         message: error.message,
//                         variant: 'error',
//                     })
//                 );
//             });
//             //this.checkifRecordIsRendered = false;
//         }
//         else
//         {
//             console.log('else part after render');
//         }
//         //this.checkifRecordIsRendered= true;
        
//     }
// }