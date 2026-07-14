public with sharing class averagetimechartcontrollerDuplicate 
{
    @AuraEnabled
    public static ID retriveAccs(String objectVal, String Field,list<String> fieldValues, list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName,boolean historySwitch) {
        System.debug('retriveAccs');
        System.debug('historySwitch value'+historySwitch);
        string fieldVal = string.join(fieldValues,', '); 
        string recordType = string.join(recordTypes,', ');
        Id recordId;
        Id batchJobId;
        String errorName;
        list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectFieldValue__c =: fieldVal AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal LIMIT 1]);
        if(bi != null && !bi.isEmpty())
        {
            recordId = bi[0].Id;
            if(bi[0].LastRefreshedDate__c == null || bi[0].LastRefreshedDate__c != system.today()){
                system.debug('BATCH EXECUTED'); 
                //duplicateaveragebatch atbc = new duplicateaveragebatch(fieldValues,Field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,false,historySwitch);
                //batchJobId=database.executeBatch(atbc);
            }
            else{
                system.debug('BATCH NOT EXECUTED');
                BatchInfo__c bInfo = new BatchInfo__c();
                if (Schema.sObjectType.BatchInfo__c.fields.Id.isUpdateable()  && Schema.sObjectType.BatchInfo__c.fields.id.isAccessible()) 
                {
                    bInfo.Id = recordId;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.willRefresh__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.willRefresh__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.willRefresh__c.isAccessible()) 
                {
                    bInfo.willRefresh__c = willRefresh;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isAccessible()) 
                {
                    bInfo.Filter_Name__c = filterName;
                }
                if(bInfo!=null && Schema.sObjectType.BatchInfo__c.isAccessible()  && Schema.sObjectType.BatchInfo__c.isCreateable() && Schema.sObjectType.BatchInfo__c.isCreateable())
                {
                    database.update(bInfo);
                }
            }
        }
        else
        {
            system.debug('BATCH EXECUTED');
            //duplicateaveragebatch atbc = new duplicateaveragebatch(fieldValues,Field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,false,historySwitch);
            //batchJobId=database.executeBatch(atbc);
        }
        return batchJobId;        
    }
    
    @AuraEnabled
    public static String retriveFilter(String objectVal, String Field,list<String> fieldValues, list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName) {
        system.debug('Filter Name'+filterName);
        string fieldVal = string.join(fieldValues,', '); 
        string recordType = string.join(recordTypes,', ');
        Id recordId;
        Id batchJobId;
        String errorName;
        list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectFieldValue__c =: fieldVal AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal LIMIT 1]);
        if(bi != null && !bi.isEmpty())
        {
            recordId = bi[0].Id;            
            if(bi[0].willRefresh__c == true)
            {
                if(bi[0].Filter_Name__c!=filterName)
                {
                    errorName = 'Filter already exists as a '+bi[0].Filter_Name__c;
                }
            }
            for(BatchInfo__c b : [SELECT id, Filter_Name__c, willRefresh__c FROM BatchInfo__c WHERE willRefresh__c = true]){
                if(b.Filter_Name__c == filterName)
                {
                    errorName = 'Filter name already exists';
                }
            }
        }
        return errorName;
    }
    
    @AuraEnabled
    public static AsyncApexJob getBatchJobStatus(Id jobID){
        AsyncApexJob jobInfo = [SELECT Status FROM AsyncApexJob WHERE Id = :jobID];
        return jobInfo;
    }
    
    @AuraEnabled
    public static void getcaseowner(String objectVal, String Field,list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName) 
    {
        System.debug('objectVal = '+objectVal);
        System.debug('Field = '+Field);
        System.debug('recordTypes = '+recordTypes);
        System.debug('businessHour = '+businessHour);
        System.debug('endDate = '+endDate);
        System.debug('dates = '+dates);
        System.debug('startDate = '+startDate);
        System.debug('willRefresh = '+willRefresh);
        System.debug('filterName = '+filterName);
    }
    
    
    @AuraEnabled
    public static map<string,double> mapvalue(String objectVal, String Field,list<String> fieldValues, list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName) {
        string dataRepresentation; 
        // DateTime start = System.Now();
        system.debug('>>>>>in');
        //system.debug('value of biRec'+biRec);
        //while(System.Now().getTime()< start.getTime()+3000){}
        string fieldVal = string.join(fieldValues,', '); 
        string recordType = string.join(recordTypes,', ');
        list<BatchInfo__c> ctendays = new list<BatchInfo__c>();
        list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectFieldValue__c =: fieldVal AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal LIMIT 1]);
        list<Attachment> doc = [SELECT Id,body  FROM Attachment where parentid=:bi[0].id];
        if(bi != null && !bi.isEmpty())
        {
            //if(bi[0].LastRefreshedDate__c == system.today())
            //{
            dataRepresentation = bi[0].dataRepresentation__c;    
            //}
            
        }
        else
        {
            ctendays = [select id, DataRepresentation__c from BatchInfo__c order by createddate desc limit 1];
            
        }        
        string inputdata; //= '[{"Closed":null,"OnHold":null,"Escalated":1.0,"InProgress":0.5,"New":34499.5}]';
        map<string,double> valuestorepickliststage= new map<string,double>();
        if(dataRepresentation == null){
            inputdata = '['+ctendays[0].DataRepresentation__c+']'; 
        }
        else
        {
            system.debug('dataRepresentation'+dataRepresentation);
            inputdata = '['+dataRepresentation+']';
        }
        system.debug('ddfffff' +inputdata);
        List<Object> result = (List<Object>)JSON.deserializeUntyped(inputdata); 
        system.debug('>>>>>>>>>'+result);
        for(Object obj : result) 
        { 
            Map<String,Object> map1 = (Map<String,Object>)obj;
            if(map1!=null)
            {
                for(String key : map1.keyset()) 
                {
                    valuestorepickliststage.put(key,(decimal)map1.get(key));
                    System.debug('Key -->> ' + key); 
                    System.debug('Value -->> ' + (decimal)map1.get(key)); 
                }
            }
        }
        system.debug('value  of  mapp>>>>>'+valuestorepickliststage);
        return valuestorepickliststage;
    }
    
    //fetch picklist values from custom object in lwc
    @AuraEnabled(cacheable=true)
    public static List < customValueWrapper > pickListValueDynamically(sObject customObjInfo, string selectPicklistApi) 
    {
        system.debug('customObjInfo' +customObjInfo);
        system.debug('selectPicklistApi' +selectPicklistApi);
        Schema.DescribeSObjectResult objDescribe = customObjInfo.getSObjectType().getDescribe();   
        map < String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap();      
        list < Schema.PicklistEntry > custPickValues = customFieldMap.get(selectPicklistApi).getDescribe().getPickListValues();
        list < customValueWrapper > customObjWrapper = new list < customValueWrapper > ();
        for (Schema.PicklistEntry myCustPick: custPickValues) 
        {
            customValueWrapper selectOptionValueWrapper = new customValueWrapper();
            selectOptionValueWrapper.custFldlabel = myCustPick.getLabel();
            selectOptionValueWrapper.custFldvalue = myCustPick.getValue();
            system.debug('objDescribe' +selectOptionValueWrapper.custFldvalue);
            customObjWrapper.add(selectOptionValueWrapper);
        }
        system.debug('customObjWrapperdddddddd' +customObjWrapper);
        return customObjWrapper;
    }
    // wrapper class 
    public with sharing class customValueWrapper 
    {
        @auraEnabled public string custFldlabel {get;set;}
        @auraEnabled public string custFldvalue {get;set;}
    }
    // get owner information
     @AuraEnabled(cacheable = true)
    public static List<DataSet> getLeadByStatus(String status,String objectVal, String Field, List<String> recordTypes, String businessHour, String dates, date startDate, date endDate, boolean willRefresh, String filterName,String selectedName)
    {
        System.debug('filterNameselectrd>>> = '+selectedName);
        map<String,String> usermap = new map<String,String>();
        
        List<DataSet> dataSet = new List<DataSet>();
        String status_val = status;
        String dataRepresentation;
        String recordType = String.join(recordTypes,', ');
        List<BatchInfo__c> ctendays = new List<BatchInfo__c>();
        List<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,OwnerDataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Filter_Name__c=:selectedName]);
        system.debug('value of bii'+bi);
        List<Attachment> doc = [SELECT Id,body  FROM Attachment where parentid=:bi[0].id];
        map<String,map<String,decimal>> ownertostagetotime=new map<String,map<String,decimal>>();
        if(bi != null && !bi.isEmpty())
        {
            
           // dataRepresentation = bi[0].OwnerDataRepresentation__c;
            dataRepresentation = doc[0].body.toString(); 
            
        }
        else
        {
            //ctendays = [select id, OwnerDataRepresentation__c from BatchInfo__c order by createddate desc limit 1];
        }
        String inputdata;  
        map<String,double> valuestorepickliststage= new map<String,double>();
        if(dataRepresentation == null)
        {
           // inputdata = '['+ctendays[0].OwnerDataRepresentation__c+']';
        }
        else
        {
            inputdata = '['+dataRepresentation+']';
        }
        List<Object> result = (List<Object>)JSON.deserializeUntyped(inputdata);
        String ss;
        for(object sst: result)
        {
           
            Map<String,object> data=(Map<String,object>)sst;
            System.debug('datakey'+data.keySet());
            System.debug('datavalues'+data.values());
               for(String ownerstage:data.keySet()){
                System.debug('>>>>>>>>.'+ ownerstage);
                List<String> ownerstagearray=ownerstage.split(':');
                System.debug('ownerstagearray'+ownerstagearray);
                System.debug('ownerstagearray'+ownerstagearray[1]);
                System.debug('ownerstagearray'+ownerstagearray[0]);

                if(ownertostagetotime.containsKey(ownerstagearray[1]) && ownertostagetotime!=null)
                {
                    ownertostagetotime.get(ownerstagearray[1]).put(ownerstagearray[0],decimal.valueOf(String.valueOf(data.get(ownerstage))));
                }
                else
				{
                    System.debug('ownerstagearray[1]'+ownerstagearray[1]);
                    System.debug('ownerstagearray[0]'+ownerstagearray[0]);
                   // System.debug('data.get(ownerstage)'+data.get(ownerstage));
                    //System.debug('ownerstagearray[decimal.valueOf(String.valueOf(data.get(ownerstage)))]'+decimal.valueOf(String.valueOf(data.get(ownerstage))));
                        if(data.get(ownerstage)!=null)
                        {
                            ownertostagetotime.put(ownerstagearray[1], new map<String,decimal>{ownerstagearray[0]=>decimal.valueOf(String.valueOf(data.get(ownerstage)))}) ;
						}
                }
            }
        }
        set<id> ownerid;
        if(ownertostagetotime.containskey(status_val))
        {
            /*for(CustomUser__c u:[Select id,Name from CustomUser__c where id IN:ownertostagetotime.get(status_val).keySet()])
            {
                usermap.put(u.id,u.Name);
            }*/
        }
        if(ownertostagetotime.containskey(status_val))
        {
            for(String owneriddata:ownertostagetotime.get(status_val).keySet())
			{
                dataSet.add(new DataSet(usermap.get(owneriddata) ,ownertostagetotime.get(status_val).get(owneriddata)));
            }
        }
        return dataSet ;
    }
    public class DataSet
    {
        public DataSet(String label ,decimal count)
        {
            this.label = label ;
            this.count = count ;
        }
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public decimal count {get;set;}
    }
}