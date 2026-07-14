import {LightningElement, track,api, wire} from 'lwc';
//import picklistLabel from '@salesforce/label/c.picklistLabel';
import getHourVal from '@salesforce/apex/ObjectPicklistController.getHourVal';
//import objectLabel from '@salesforce/label/c.objectLabel';
import getPicklistFields from '@salesforce/apex/ObjectPicklistController.getPicklistFields';
// import getObjectFieldValue from '@salesforce/apex/ObjectPicklistController.getObjectFieldValue';
import getObject from '@salesforce/apex/ObjectPicklistController.getObject';
import picklistValues from '@salesforce/apex/ObjectPicklistController.picklistValues';
import getRecordType from '@salesforce/apex/ObjectPicklistController.getRecordType';
import getAllcaserecord from '@salesforce/apex/averagetimechartcontrollerDuplicate.retriveAccs';
import retriveFilter from '@salesforce/apex/averagetimechartcontrollerDuplicate.retriveFilter';
import getAllcaserecord1 from '@salesforce/apex/averagetimechartcontroller.mapvalue';
import getBatchJobStatus from '@salesforce/apex/averagetimechartcontrollerDuplicate.getBatchJobStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLeadByStatus1 from '@salesforce/apex/averagetimechartcontrollerDuplicate.mapvalue';
import getcaseowner from '@salesforce/apex/averagetimechartcontrollerDuplicate.getcaseowner';
import ChartJS from '@salesforce/resourceUrl/ChartJs';
import {loadScript} from 'lightning/platformResourceLoader';
 import getLeadByStatus from '@salesforce/apex/averagetimechartcontrollerDuplicate.getLeadByStatus';
import pickListValueDynamically from '@salesforce/apex/averagetimechartcontrollerDuplicate.pickListValueDynamically';
//import getBusinessHours from '@salesforce/apex/ObjectPicklistController.getBusinessHours';
export default class Filter_LWCDuplicate extends LightningElement
{
   //label = {picklistLabel};
//label1 = {objectLabel};
    hourNameLabel;
    filterName;
    @track filterNameErr;
    picklistStr;
    objectStr;
    fieldStr;
    options;
    defaultValues=[];
    options1;
    defaultValues1=[];
    selectedVal;
    selectedVal1;
    startdate;
    enddate;
    @track isCheckFilter = true;
    @track clickedButtonLabelCheck;
    @track runchart=false;
    @track isFilterSave = false;
    @track picklistVal;
    @track picklistValueStr = false;
    @track objectVal;
    @track objectFieldVal;
    @track businessNameVal;
    @track objectFieldValueVal;
    @track objectRecordTypeVal;
    @track jobid;
    objValue;
    @track toggleValue;
     piechartsaved;
    requiredOptions;
    requiredOptions1;
    recordsList=[];
    message='';
    @track havingValue = false;
    errorMsg = 'Error Message - ';
    clickedButtonLabel;
    requiredField1 = false;
    requiredField2 = false;
    requiredField3 = false;
    requiredField4 = false;
    requiredField5 = false;
    @track myInterval;
    @track progress;
    jobinfo;


    connectedCallback(){
        getHourVal()
        .then((data)=>{
            this.hourNameLabel = data;
        })
       
    }
    get className()
    {
        return this.requiredField1 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
    get className1()
    {
        return this.requiredField2 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
    get className2()
    {
        return this.requiredField3 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
    get className3(){
        return this.requiredField4 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
    get filterNameClass(){
        return this.requiredField5 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
    get objVal(){
        if(this.objectVal!=null){
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1)+ " Field";
        }
        else{
            return "Object Field";
        }
    }
    get objFieldVal(){
        if(this.objectVal==null && this.objectField==null){
            return "Object Field Value";
        }
        if(this.objectVal!=null && this.objectField!=null){
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1)+' '+this.objectField + " Value";
        }
        if(this.objectVal!=null ){
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1)+" Field Value";
        }
    }
    get objRecordType(){
        if(this.objectVal!=null){
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1)+ " Record Type";
        }
        else{
        return "Object Record Type";
    }
    }

    constructor()
    {
        super();
        // console.log('label1 value --->',objectLabel);
        // this.picklistStr = picklistLabel.split(',');
        // this.objectStr = objectLabel.split(',');
    }

    selectPicklistValueChange(event)
    {   
        this.clickedButtonLabelCheck = false; 
        this.picklistVal = event.target.value;
        // console.log('picklistVal value-->',this.picklistVal);
        if(this.picklistVal == 'Custom Date')
        {
            this.picklistValueStr = true;
        }
        else
        {
            this.picklistValueStr = false;
        }
    }
  
onHandleObjectSearch(event){
    this.objectVal = event.target.value;
       getObject({searchObject:this.objectVal})
       .then((result)=>{
        if (result.length===0){
            this.recordsList = [];
            this.message = "No Object Found with "+this.objectVal+" name";
        } 
        else{
            this.recordsList = result;
            this.message = "";
        }
        })
        .catch((error) =>
        {
        this.recordsList = undefined;
        });
}
    selectObjectValueChange()
    {  
        console.log('selectObjectValueChange');
        this.objectField = 'Field';
        this.options = [];
        this.options1 = [];
        this.objectFieldVal = [];
        this.defaultValues1 = [];
        this.defaultValues = [];
       this.clickedButtonLabelCheck = false;  
       console.log('object value---->',this.objectVal);
       getPicklistFields({ sobjectValue: this.objectVal})
       .then((result) =>
        {
            console.log('result of object fields -->',result);
            this.objectFieldVal = result;
        })
       .catch((error) =>
        {
            this.error = error;
        });

       getRecordType({ objectName:  this.objectVal})
       .then((result) =>
       {
            if(result)
            {
                for(let key in result)
                {
                    console.log('options value -->',result[key]);
                    this.options1 = Object.keys(result).map(key => ({ label: result[key], value: result[key] }));
                    this.defaultValues1.push(result[key]);
                    console.log('defaultValues1 value---',this.defaultValues1);
                }
                this.selectedVal1 = this.defaultValues1;
            }
        })
        .catch((error) => 
        {
            this.error = error;
        });   
          
    }

    selectHourValueChange(event)
    {  
       this.clickedButtonLabelCheck = false;  
       this.businessNameVal = event.target.value;
    }

    objectField;
    selectObjectFieldChange(event)
    {   
        this.clickedButtonLabelCheck = false;   
        this.objectField = event.target.value;
        picklistValues({ objectName: this.objectVal, fieldName: event.target.value})
        .then((result) => 
        {
            if(result)
            {
                for(let key in result)
                {
                    this.options = Object.keys(result).map(key => ({ label: result[key], value: result[key] }));
                    this.defaultValues.push(result[key]);
                    console.log('defaultValues value---',this.defaultValues);
                }
                this.selectedVal = this.defaultValues;
            }
            
        })
        .catch((error) => 
        {
            this.error = error;
        });      
    }

    handleChange(event) 
    {  
        this.clickedButtonLabelCheck = false; 
        this.selectedVal = event.detail.value;
    }
    
    onHandleCheckBox(event){
        this.isFilterSave = event.target.checked;       
    }

    handleChange1(event) 
    {
        this.clickedButtonLabelCheck = false;  
        this.selectedVal1 = event.detail.value;
    }

   
    datehandle(event)
    {   
        this.clickedButtonLabelCheck = false; 
        this.startdate = event.detail.value;
    }

   
    datehandle1(event)
    {   
        this.clickedButtonLabelCheck = false;  
        this.enddate = event.detail.value;
    }
   
    onFilterName(event){
        this.filterName = event.target.value;
    }    
    handleClick(event) 
    {
        if(event.target.label === 'Save')
        {

            if(this.objectVal == undefined || this.objectVal == '')
            {
                // console.log('this.objectVal value in if',this.objectVal);
                this.requiredField1 = true;
                this.errorMsg += ' Please select the Object Type,';
            }
            else
            {
                console.log('this.objectVal value in else',this.objectVal);
                this.requiredField1 = false;
            }

            if(this.objectField == undefined || this.objectField == '')
            {
                // console.log('this.objectField value in if',this.objectField);
                this.requiredField2 = true;
                this.errorMsg += ' Please select the Object Field Type,';
            }
            else
            {
                console.log('this.objectFieldVal value in else',this.objectFieldVal);
                this.requiredField2 = false;
            }

            if(this.selectedVal == undefined || this.selectedVal == ' ')
            {
                // console.log('this.selectedVal value in if',this.selectedVal);
                this.errorMsg += ' Please select the Object Field Value Type,';
            }
            
            if(this.picklistVal == undefined || this.picklistVal == '')
            {
                console.log('this.picklistVal value in if',this.picklistVal);
                this.requiredField3 = true;
                this.errorMsg += ' Please select the Dates.';
            }
            else
            {
                console.log('this.picklistVal value in else',this.picklistVal);
                this.requiredField3 = false;
            }

            if(this.businessNameVal == undefined || this.businessNameVal == '')
            {
                this.requiredField4 = true;
                this.errorMsg += ' Please select the Business Hour.';
            }
            else
            {
                console.log('this.hourNameStr value in else',this.businessNameVal);
                this.requiredField4 = false;
            }

            if(this.errorMsg != 'Error Message - ')
            {
                const evt = new ShowToastEvent({
                    title: 'Error Message',
                    message: this.errorMsg,
                    variant: 'error',
                    mode: 'dismissable'
                });
                this.dispatchEvent(evt);
                this.errorMsg = 'Error Message - ';
            }

            if(this.requiredField1 == false && this.requiredField2 == false && this.requiredField3 == false && this.requiredField4 == false && this.selectedVal != undefined)
                {
                    if(this.isFilterSave==true && this.isCheckFilter == true)
                    {
                        console.log('this.isFilterSave==true');
                       
                            if(this.filterName == undefined || this.objectVal == '' ||this.filterName == '' || this.filterName == null)
                            {
                                this.requiredField5 = true;
                                console.log('Req 5 if - ',this.requiredField5); 
                                this.errorMsg += 'Please fill unique filter name';
                            }
                            else
                            {
                                this.requiredField5 = false;
                                console.log('Req 5 else - ',this.requiredField5);
                                this.checkFilter();
                            }
                    
                            if(this.errorMsg != 'Error Message - ')
                            {
                                const evt = new ShowToastEvent({
                                    title: 'Error Message',
                                    message: this.errorMsg,
                                    variant: 'error',
                                    mode: 'dismissable'
                                });
                                this.dispatchEvent(evt);
                                this.errorMsg = 'Error Message - ';
                            }
                    }
                    else if(this.isFilterSave == false){
                        console.log('this.isFilterSave==false');
                        this.getAllcaserecords();
                        //this.getcaseowner();
                    }
                }
          
            // console.log('clickedButtonLabel value--->',this.clickedButtonLabel);
            // console.log('this.objectVal',this.objectVal);
            // console.log('this.objectFieldVal',this.objectFieldVal);
            // console.log('this.selectedVal',this.selectedVal);
            // console.log('this.selectedVal1',this.selectedVal1);
            // console.log('this.picklistVal',this.picklistVal);
            // console.log('this.businessNameVal',this.businessNameVal);
            // console.log('this.startdate',this.startdate);
            // console.log('this.enddate',this.enddate);
            // console.log('filterName',this.filterName);
        }      
    }
  
    checkFilter(){
        console.log(' In checkFilter method\n Filter save =' ,this.isFilterSave + '\ncheck Filter = ', this.isCheckFilter);
        retriveFilter({objectVal: this.objectVal,Field: this.objectField,fieldValues: this.selectedVal,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh:this.isFilterSave,filterName:this.filterName})
        .then((data) => {
            console.log('data is null or not --',data);
            if(data!=null){
                this.isCheckFilter = true;
                this.filterNameErr = data;
                console.log('Error check filter--',data);
                const event = new ShowToastEvent({
                    title: 'ERROR',
                    message: data,
                    variant: 'error '+data,
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            }
            else{
                // console.log('Error data else of data null',this.isCheckFilter);
                this.isCheckFilter = false;
                if(this.filterName!=null && this.filterName!='' && this.filterName!=' ' && this.isCheckFilter == false ){
                    this.getAllcaserecords();
                }
                else{
                    this.requiredField5 = false;
                }
            }
        })
    }
   
    getAllcaserecords(){ 
        this.isCheckFilter = false;
        console.log(' In getAllcaserecords method\nFilter save =' ,this.isFilterSave + '\ncheck Filter = ', this.isCheckFilter + '\nhistorySwitch=',this.toggleValue);
            getAllcaserecord({objectVal: this.objectVal,Field: this.objectField,fieldValues: this.selectedVal,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh:this.isFilterSave,filterName:this.filterName,historySwitch:this.toggleValue})
            .then(result => {
            this.jobid = result;
        //     //   console.log('value of jobid',this.jobid);
            if(this.jobid!=null)
            {
                //    console.log('if');  
                var intervaldata =setInterval(function (jobid111,parentthis){   
                console.log('time halt started>>>'+jobid111);

                getBatchJobStatus({jobID: jobid111})
                .then(result => {
                        this.jobinfo = result;
                          console.log('value of jobinfo',result);
                })
                    if(jobinfo.Status=='Completed' )
                {
                    clearInterval(intervaldata);
                    //   console.log('passing');
                    alert('batch is Completed');
                    //this.myStopFunction();
                    parentthis.callOnRender();
                    //parentthis.runchart=true;      
                }
            }, 3000,this.jobid,this);
            this.myInterval=intervaldata;
            //    console.log('intervalid >>>>',this.myInterval);  
            }
            else{
                //   console.log('else');  
                alert('already saved');
                this.callOnRender(); 
            }
        })
        if(this.isCheckFilter == false){
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
   onobjectselection(event)
   {
   console.log('inside onobjectselection');
//    this.selectedValue = event.target.dataset.name;
   this.objectVal = event.target.dataset.name;
   this.recordsList = [];
   this.message = '';
   console.log(' this.selectedValue', this.selectedValue);
   console.log('this.objectVal',this.objectVal);
   this.selectObjectValueChange();  
   //this.onSeletedRecordUpdate();
   }
  caseownerdel;
// case owner execution
    getcaseowner()
    {   
  getcaseowner({objectVal: this.objectVal,Field: this.objectField,fieldValues: this.selectedVal,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh:this.isFilterSave,filterName:this.filterName})
    .then(result => {
    // this.caseownerdel = result;
    //  console.log('value of this.caseownerdel',this.caseownerdel);
})
    }
   ///chart functionalitiy
    @api chartConfiguration;
    @track chartAmtData = [];
    @track chartLabel = [];
    @track selectedOption='bar';
    @api checkRendredChild=false;
    @api checkRendred=false;
    @track clickedButtonLabel;
  
    callOnRender(){
    //   console.log('call on render');
      getLeadByStatus1({objectVal: this.objectVal,Field: this.objectField,fieldValues: this.selectedVal,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave})
		.then(data=>{
            //  console.log('value of render>>>>',data);
             this.chartLabel=[];
            this.chartAmtData=[]; 
			  if (data) {
            for (let key in data) 
        {
            this.chartLabel.push(key);
            this.chartAmtData.push(data[key]);
        }
        // console.log('eeeeeeeeee', this.selectedOption);
        this.chartConfiguration = {
            type: this.selectedOption,
        data: {
            datasets: [{
                     label: 'Tracking Based On Average Time',
                    backgroundColor:"green",//["red", "blue", "green", "orange", "black", "pink"],
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
        // console.log('no its becoming true>>>',this.chartConfiguration);
        
	 	})
 }

 backClick(event){
    console.log('Back Button is clicked');
    const childEvent = new CustomEvent("handleback", {detail: false});
    this.dispatchEvent(childEvent);
}


////////////////////////////////////////////

  @track dataSet;
    @track picklistVal12;
     @track chartAmtData = [];
    @track chartLabel = [];
    @wire(pickListValueDynamically, {customObjInfo: {'sobjectType' : 'Case'},
    selectPicklistApi: 'Status'}) selectTargetValues;
        
      selectOptionChanveValue(event){       
           this.picklistVal12 = event.target.value;
           var ctx = this.template.querySelector(".pie-chart").getContext('2d');
           console.log("picklistchangefunction");
           this.getcallby();
           //refreshApex(this.dataSet);
       }  

   getcallby()
   {
       console.log('ghdfhgdgdgh');
      getLeadByStatus({status: this.picklistVal12,objectVal: this.objectVal,Field: this.objectField,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave})
		.then(data=>{
             if (data) {

            console.log('resultdata',data);
            this.dataSet = data;
            //setInterval(refreshApex.bind(this, this.dataSet), 5e3);
                this.Initializechartjs();
         
         } else if (result.error) 
        {
            return result.error;
        }
        
	 	}) 
   }
    
    @api chartjsInitialized = false;
    renderedCallback() {
        if(this.recordsList != null && this.recordsList != undefined){
            this.havingValue = true;
        }
        if (this.chartjsInitialized) {
           
            return;
        }
        this.chartjsInitialized = true;
        Promise.all([
                loadScript(this, ChartJS)
            ])
            .then(() => {
                //this.Initializechartjs();
            })
            .catch(error => {
                console.log(error.message)
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
        console.log('>>>>>>>',window.bar);
        if(window.bar!=undefined){
                    window.bar.destroy();
                }
        //ctxx.destroy();
        console.log("loaded");
         console.log("dataSet',result.data",this.dataSet);
         console.log('Object.keys(this.dataSet',Object.keys(this.dataSet));
          console.log('Object.values(this.dataSet)',Object.values(this.dataSet));
          var labell = [];
          var count = [];

           for(let ownerLabel in Object.values(this.dataSet)){
              console.log('>>>>>>>>'+Object.values(this.dataSet)[ownerLabel]);
            labell.push(Object.values(this.dataSet)[ownerLabel].label);
            count.push(Object.values(this.dataSet)[ownerLabel].count);
          }
          console.log('labell',labell);
         console.log('count',count);
          
          arrayOfObj = labell.map(function(d, i) {
          return {
          label: d,
          data: count[i] || 0
          };
          });
          
          sortedArrayOfObj = arrayOfObj.sort(function(a, b) {
          return b.data>a.data;
          });
          
          newArrayLabel = [];
          newArrayData = [];
          sortedArrayOfObj.forEach(function(d){
          newArrayLabel.push(d.label);
          newArrayData.push(d.data);
          });
          console.log('Ravi',newArrayLabel);
          console.log('Pannu',newArrayData);


        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
         window.bar = new Chart(ctx, {
            type: 'bar',
            data: {
                
                labels: labell,  
                datasets: [{
                    label: 'Average Time Spent On Owner Leader Board Per Status',
                    data:count, 
                    backgroundColor:"green"//  ["#0074D9", "#FF4136", "#2ECC40", "#FF851B", "#7FDBFF", "#B10DC9", "#FFDC00", "#001F3F", "#39CCCC", "#01FF70", "#85144B", "#F012BE", "#3D9970", "#111111", "#AAAAAA"]
                }],
                },
                options: {
         
                   },
        });
         
    }

    toggleHandle(event){
            this.toggleValue = event.target.checked;
            console.log('toggleValue',this.toggleValue);
    }
}