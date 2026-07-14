import { LightningElement ,api, track} from 'lwc';
import getHistoryData from '@salesforce/apex/customHistoryComponentController.getHistoryData';
import getSearchHistoryData from '@salesforce/apex/customHistoryComponentController.getSearchHistoryData';
export default class CustomHistoryComponent extends LightningElement {

@api recordId;
@track records;
@track recHis;
@track searchVal = [];
@track noDataFound;
@track field;
@track fieldLabel;
@track message;
@track recordsAll;
@track totalRecountCount;
@track totalPage;
@track page = 1; 
@track result;
@track startingRecord = 1;
@track endingRecord = 0; 
@track pageSize = 2;
@track searchValMap = [];
@track allKeys = [];

connectedCallback(){
    console.log('connectedCallback..');
    console.log('this.recordId>>',this.recordId);
    
getHistoryData({
                 recid: this.recordId,
               })
.then(result => {
    this.records = result;
    this.recordsAll = result;
    console.log('records..',this.records);
    this.totalRecountCount = result.length; console.log('count',this.totalRecountCount); 
    this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); console.log('tot page',this.totalPage); 
    this.result = this.records.slice(0,this.pageSize); console.log('res',this.result); 
    this.endingRecord = this.pageSize;console.log('end',this.endingRecord); 
})  
}

handleChange(event) {
        this.searchVal = event.target.value;
        this.fieldLabel = event.target.label;
        console.log('this.searchVal..'+this.searchVal);
        console.log('this.fieldLabel..'+this.fieldLabel);
        console.log('this.searchValMap>>',this.searchValMap);
        console.log('this.searchValMap.length>>',this.searchValMap.length);

  if(this.searchValMap.length == 0)
  {
        if(this.fieldLabel=='Date/Time'){
         console.log('this...'+this.fieldLabel); 
         this.field = 'timestamp';
         this.searchValMap.push({timestamp : this.searchVal});
         }
        else if(this.fieldLabel=='Field'){
        this.field = 'field';
        this.searchValMap.push({field : this.searchVal});
        }
        else if(this.fieldLabel=='User'){
        this.field = 'user';
        this.searchValMap.push({user : this.searchVal});
        }
        else if(this.fieldLabel=='Original Value'){
        this.field = 'oldVal';
        this.searchValMap.push({oldVal : this.searchVal});
        }
        else if(this.fieldLabel=='New Value'){
        this.field = 'newVal';
        this.searchValMap.push({newVal : this.searchVal});
        }
        console.log('this.searchValMap>>',this.searchValMap);
}

 else
 {
     let allKeys = [];
                if(this.fieldLabel=='Date/Time'){
                this.field = 'timestamp';
                }
                else if(this.fieldLabel=='Field'){
                this.field = 'field';
                }
                else if(this.fieldLabel=='User'){
                this.field = 'user';
                }
                else if(this.fieldLabel=='Original Value'){
                this.field = 'oldVal';
                }
                else if(this.fieldLabel=='New Value'){
                this.field = 'newVal';
                }

        for (var key in this.searchValMap) 
        {
         //console.log('value', this.searchValMap[key]);
         for(var i in this.searchValMap[key])
         {
            console.log('i', i);console.log('this.searchValMap[key][i]', this.searchValMap[key][i]);
            allKeys.push(i);
            if(this.field == i)
            {
               console.log('contains key...');
               this.searchValMap[key][i] = this.searchVal;
            }
         }
        }

        console.log('allKeys',allKeys);
        console.log('includes>>',allKeys.includes(this.field));

            if(!allKeys.includes(this.field))
            {
                if(this.fieldLabel=='Date/Time'){
                console.log('this...'+this.fieldLabel); 
                this.field = 'timestamp';
                this.searchValMap.push({timestamp : this.searchVal});
                }
                else if(this.fieldLabel=='Field'){
                this.field = 'field';
                this.searchValMap.push({field : this.searchVal});
                }
                else if(this.fieldLabel=='User'){
                this.field = 'user';
                this.searchValMap.push({user : this.searchVal});
                }
                else if(this.fieldLabel=='Original Value'){
                this.field = 'oldVal';
                this.searchValMap.push({oldVal : this.searchVal});
                }
                else if(this.fieldLabel=='New Value'){
                this.field = 'newVal';
                this.searchValMap.push({newVal : this.searchVal});
                }
        }
    console.log('this.searchValMap>>',this.searchValMap);
 }
        
        if (this.searchValMap != []) {
            console.log('JSON.stringify(this.searchValMap)>>',JSON.stringify(this.searchValMap));
            getSearchHistoryData({ recid: this.recordId , searchVal: JSON.stringify(this.searchValMap), data: this.recordsAll})
                .then(data => {
                    console.log('data>>>',data);
                    if (data.length > 0) {
                        this.records = data; console.log('records..',this.records);
                        this.result = this.records.slice(0,this.pageSize); console.log('res',this.result); 
                        this.totalRecountCount = data.length; console.log('count',this.totalRecountCount); 
                        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); console.log('tot page',this.totalPage); 
                        this.page = 1;
                        this.startingRecord = 1;
                        this.endingRecord = this.pageSize;console.log('end',this.endingRecord); 
                        //this.noDataFound = false;
                    }
                    else {
                        this.result = data;
                        this.message = "No data found with searchkey " + this.searchVal +' for '+ this.field+ ' field.';
                        //alert(this.message);
                        //this.noDataFound = true;
                    }
                })
        }
        else if(this.searchVal == '' || this.searchVal == null)
        {
            getHistoryData({
                            recid: this.recordId
                            })
                    .then(result => {
                    this.records = result; console.log('records..',this.records);
                    this.result = this.records.slice(0,this.pageSize); console.log('res',this.result); 
                    this.totalRecountCount = result.length; console.log('count',this.totalRecountCount); 
                    this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); console.log('tot page',this.totalPage); 
                    this.endingRecord = this.pageSize;console.log('end',this.endingRecord); 
                })
        }
    }


    changeHandler(event){
            console.log("HERE");
            var value = event.target.value;
            console.log("selected"+value);
            this.pageSize = value;
            console.log("page size"+this.pageSize);
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); console.log('tot page',this.totalPage); 
            this.displayRecords(this.pageSize);
}

displayRecords(pageSize){
        this.startingRecord = ((this.page -1) * pageSize) ;
        this.endingRecord = (pageSize * this.page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
        ? this.totalRecountCount : this.endingRecord; 

        this.result = this.records.slice(this.startingRecord, this.endingRecord);
        console.log('new records',this.result);
        this.startingRecord = this.startingRecord + 1;
}  


displayRecordPerPage(page){

        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) ? this.totalRecountCount : this.endingRecord; 

        this.result = this.records.slice(this.startingRecord, this.endingRecord);
        console.log('new records',this.result);
        this.startingRecord = this.startingRecord + 1;
}

previousHandler() {
        console.log("prev");
        this.isPageChanged = true;
        if (this.page > 1) {
        this.page = this.page - 1; //decrease page by 1
        this.displayRecordPerPage(this.page);
        }
}

nextHandler() {
            console.log("next");
            this.isPageChanged = true;
            if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);            
        }
}
}