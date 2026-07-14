import { LightningElement } from 'lwc';
import getObject from '@salesforce/apex/SAPOrdersSchedule.scheduleClass';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ConfigurationPage extends LightningElement {
       jobName='';
       frequencyValue = '';
       monthlyPriority='';
       preferredTime = '';
       value=[];
       days=[];
       isDay = false;
       isOrdinal = true;
       isWeekely = true;
       requireJobName = false;
       requireToSelectFrequency = false;
       requireToSelectWeekDays = false;
       requireStartDate = false;
       requireEndDate = false;
       requirePreferredTime = false;
       requireMonthlyPriority = false;
       preferredStartTime = [];
       startDate;
       endDate;
       get weekDay() {
        return [
            { label: 'Sunday', value: 'SUN' },
            { label: 'Monday', value: 'MON' },
            { label: 'Tuesday', value: 'TUE' },
            { label: 'Wednesday', value: 'WED' },
            { label: 'Thursday', value: 'THU' },
            { label: 'Friday', value: 'FRI' },
            { label: 'Saturday', value: 'SAT' },
        ];
    }
      get frqOption() {
        return [
            { label: 'Weekly', value: 'Weekly' },
            { label: 'Monthly', value: 'Monthly' },
        ];
    }
    get getOrdinalNumbers(){
         return ['the 1st','the 2nd','the 3rd','the 4th','the Last'];
    }
    get getMonthOption() {
        return [
            { label: 'On day', value: 'On day' },
            { label: 'On', value: 'On' },
        ];
    }

  connectedCallback(){
     console.log('config click');
     this.frequencyValue = 'Weekly';
     this.preferredStartTime = ['00','01','02','03','04','05','06','07','08','09','10','11','12','13','14','15','16','17','18','19','20','21','22','23'];
    for(var i=1;i<=31;i++){
            this.days.push(i);
        }
    this.days.push('Last');
    }

    onHandleJobNameChange(event){
        console.log('event.currentTarget.value;===>',event.currentTarget.value);
            this.jobName = event.currentTarget.value;
    }
    onSelectMonthlyPriority(event){
        this.monthlyPriority = event.currentTarget.value;
        console.log('onSelectMonthlyPriority change==>',event.currentTarget.value);
        if(this.monthlyPriority==='day'){
            this.isDay=false;
            this.isOrdinal=true;
        }
        else{
            this.isDay=true;
            this.isOrdinal=false;
        }
    }
    handleWeekChange(e){
        this.value =e.detail.value;
        console.log('Weeks==>',this.value);
    }
     onSelectDay(e){
        //this.value =e.detail.value;
        console.log('onSelectDay==>',e.target.value);
    }
     onSelectOrdinal(e){
          console.log('onSelectOrdinal==>',e.target.value);
        // this.value =e.detail.value;
        // console.log('Weeks==>',this.value);
    }
     onSelectWeek(e){
          console.log('onSelectWeek==>',e.target.value);
        // this.value =e.detail.value;
        // console.log('Weeks==>',this.value);
    }
    onHandleFrequencyChange(event){
        this.frequencyValue = event.currentTarget.value;
        console.log('frequency change==>',event.currentTarget.value);
        if(this.frequencyValue==='Weekly'){
            this.isWeekely=true;
        }
        else{
            this.isWeekely=false;
        }
    }
    onStartDateChange(e){
        this.startDate=e.currentTarget.value;
        console.log('startDate==>',this.startDate);
    }
     onEndDateChange(e){
        this.endDate=e.currentTarget.value;
        console.log('endDate==>',this.endDate);
    }
    selectPreferredTime(event){
        this.preferredTime = event.target.value;
    }
    onSaveClick(){
         console.log('Weeks==>',this.value);
          console.log('Weeks==>',this.value.length);
        if(this.jobName==''||this.jobName==null||this.jobName==undefined){
            this.requireJobName=true;
        }
        else{
            this.requireJobName=false;
        }
         if(this.frequencyValue==''||this.frequencyValue==null||this.frequencyValue==undefined){
            this.requireToSelectFrequency=true;
        }
        else{
            this.requireToSelectFrequency=false;
        }
        if(this.isWeekely && (this.value.length==0||this.value==undefined||this.value==null) ){
            this.requireToSelectWeekDays=true;
        }
        else{
            this.requireToSelectWeekDays=false;
        }
        if(this.startDate==undefined||this.startDate==null||this.startDate==''){
            this.requireStartDate = true;
        }
        else{
            this.requireStartDate = false;
        }
        if(this.endDate==undefined||this.endDate==null||this.endDate==''){
            this.requireEndDate = true;
        }
        else{
            this.requireEndDate = false;
        }
        if(this.preferredTime==undefined||this.preferredTime==null||this.preferredTime==''){
            this.requirePreferredTime = true;
        }
        else{
            this.requirePreferredTime = false;
        }
        if(this.isWeekely==false && this.monthlyPriority==''){
            this.requireMonthlyPriority = true;
        }
        else{
            this.requireMonthlyPriority = false;
        }

        console.log('requireToSelectWeekDays===',this.requireToSelectWeekDays);
        if(this.requireJobName==false&&this.requireToSelectFrequency==false&&this.requireMonthlyPriority==false&&this.requireStartDate==false&&this.requireEndDate==false&&this.requireToSelectWeekDays==false&&this.requirePreferredTime==false){
            getObject({jobName:this.jobName,weekday:this.value,startDate:this.startDate,endDate:this.endDate,preferredTime:this.preferredTime})
            .then(() => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Schedule configured successfully',
                variant: 'success'
            }));
            this.dispatchEvent(new CustomEvent('configsaved'));
        })
        .catch((error) => {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error saving configuration',
                message: error.body ? error.body.message : error.message,
                variant: 'error'
            }));
        });
        }
    }
}