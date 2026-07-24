public with sharing class averagetimechartcontroller 
{
    @AuraEnabled
    public static ID retriveAccs(String objectVal, String field,List<String> fieldValues, List<String> recordTypes, String businessHour, String dates, date startDate, date endDate, boolean willRefresh, String filterName) 
    {
        String fieldVal = String.join(fieldValues,', '); 
        String recordType=null;
        if(recordTypes == null||recordTypes.isEmpty()){
            recordType=null;
        }
        else{
            recordType = String.join(recordTypes,', ');
        }
        Id recordId;
        Id batchJobId;
        String errorName;
        system.debug('params>>'+objectVal+field+fieldVal+recordType+businessHour+dates+startDate+endDate+willRefresh+filterName);
        
        List<BatchInfo__c> bi = new List<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectFieldValue__c =: fieldVal AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal LIMIT 1]);
        system.debug('bi==='+bi);
        
        if(bi != null && !bi.isEmpty())
        {
            recordId = bi[0].Id;
            if(bi[0].LastRefreshedDate__c == null || bi[0].LastRefreshedDate__c != system.today())
            {
                system.debug('in LastRefreshedDate');
                averageTimeBatchClass atbc = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,false);
                batchJobId=database.executeBatch(atbc);
            }
            else
            {
                system.debug('in LastRefreshedDate elsee');
                BatchInfo__c bInfo = new BatchInfo__c();
                if (Schema.sObjectType.BatchInfo__c.fields.Id.isAccessible()) 
                {
                    bInfo.Id = recordId;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.willRefresh__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.willRefresh__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.willRefresh__c.isAccessible()) 
                {
                    bInfo.willRefresh__c = willRefresh;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isAccessible() && filterName != null) 
                {
                    system.debug('filtername....'+filterName);
                    bInfo.Filter_Name__c = filterName;
                }
                if(bInfo!=null && Schema.sObjectType.BatchInfo__c.isAccessible()  && Schema.sObjectType.BatchInfo__c.isCreateable() && Schema.sObjectType.BatchInfo__c.isCreateable())
                {
                    database.update(bInfo);
                }
                System.debug('--BatchInfo__c Datat ='+bInfo);
            }
            
        }
        else
        {
            averageTimeBatchClass atbc = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,false);
            batchJobId=database.executeBatch(atbc);
        }
        return batchJobId;        
    }
    
    @AuraEnabled
    public static String retriveFilter(String objectVal, String field,List<String> fieldValues, List<String> recordTypes, String businessHour, String dates, date startDate, date endDate, boolean willRefresh, String filterName) 
    {
        String fieldVal = String.join(fieldValues,', '); 
        String recordType = String.join(recordTypes,', ');
        Id recordId;
        Id batchJobId;
        String errorName;
        List<BatchInfo__c> bi = new List<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and SobjectFieldValue__c =:fieldVal and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: field AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal AND willRefresh__c = true LIMIT 1]);
        if(bi != null && !bi.isEmpty())
        {
            recordId = bi[0].Id;  
            // if(bi[0].willRefresh__c == true)
            //{
            if(bi[0].Filter_Name__c!=filterName)
            {
                errorName = 'Filter already exists as a '+bi[0].Filter_Name__c;
            }
            //}
        }
        for(BatchInfo__c b : [SELECT id, Filter_Name__c, willRefresh__c FROM BatchInfo__c WHERE willRefresh__c = true])
        {
            if(b.Filter_Name__c == filterName)
            {
                errorName = 'Filter name already exists';
            }
        }
        return errorName;
    }
    
    @AuraEnabled
    public static AsyncApexJob getBatchJobStatus(List<String> jobID)
    {
        AsyncApexJob jobInfo = [SELECT Status FROM AsyncApexJob WHERE Id =:jobID];
        return jobInfo;
    }
    
    @AuraEnabled
    public static List<AsyncApexJob> getBatchJobStatusValue(List<String> jobID)
    {
        List<AsyncApexJob> statsList = new List<AsyncApexJob>();
        for(AsyncApexJob a :[SELECT Status FROM AsyncApexJob WHERE Id In :jobID])
        {
            statsList.add(a);
        }
        return statsList;
    }
    
    @AuraEnabled
    public static map<string,double> mapvalue(String objectVal, String Field,List<String> fieldValues, List<String> recordTypes, String businessHour, String dates, date startDate, date endDate, boolean willRefresh, String filterName) 
    {
        String dataRepresentation; 
        String fieldVal = String.join(fieldValues,', '); 
        String recordType = String.join(recordTypes,', ');
        List<BatchInfo__c> ctendays = new List<BatchInfo__c>();
        List<BatchInfo__c> bi = new List<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectFieldValue__c =: fieldVal AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal LIMIT 1]);
        system.debug('bi...'+bi);
        if(bi != null && !bi.isEmpty())
        {
            dataRepresentation = bi[0].dataRepresentation__c;    
            system.debug('dataRepresentation>>'+dataRepresentation);
        }
        else
        {
            ctendays = [select id, DataRepresentation__c from BatchInfo__c order by createddate desc limit 1];
        }        
        String inputdata;  
        map<String,double> valuestorepickliststage= new map<String,double>();
        if(dataRepresentation == null){
            inputdata = '['+ctendays[0].DataRepresentation__c+']'; 
        }
        else
        {
            inputdata = '['+dataRepresentation+']';
        }
        List<Object> result = (List<Object>)JSON.deserializeUntyped(inputdata); 
        for(Object obj : result) 
        { 
            Map<String,Object> map1 = (Map<String,Object>)obj;
            if(map1!=null)
            {
                for(String key : map1.keyset()) 
                {
                    valuestorepickliststage.put(key,(decimal)map1.get(key));
                }
            }
        }
        return valuestorepickliststage;
    }
    
    //fetch picklist values from custom object in lwc
    @AuraEnabled(cacheable=true)
    public static List < customValueWrapper > pickListValueDynamically(sObject customObjInfo, String selectPicklistApi) 
    {
        System.debug('customObjInfo - '+customObjInfo);
        System.debug('selectPicklistApi - '+selectPicklistApi);
        Schema.DescribeSObjectResult objDescribe = customObjInfo.getSObjectType().getDescribe();   
        map < String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap();      
        List < Schema.PicklistEntry > custPickValues = customFieldMap.get(selectPicklistApi).getDescribe().getPickListValues();
        List < customValueWrapper > customObjWrapper = new List < customValueWrapper > ();
        for (Schema.PicklistEntry myCustPick: custPickValues) 
        {
            customValueWrapper selectOptionValueWrapper = new customValueWrapper();
            selectOptionValueWrapper.custFldlabel = myCustPick.getLabel();
            selectOptionValueWrapper.custFldvalue = myCustPick.getValue();
            customObjWrapper.add(selectOptionValueWrapper);
        }
        return customObjWrapper;
    }
    // wrapper class 
    public with sharing class customValueWrapper 
    {
        @auraEnabled public String custFldlabel {get;set;}
        @auraEnabled public String custFldvalue {get;set;}
    }
    // get owner information
    @AuraEnabled(cacheable = true)
    public static List<DataSet> getLeadByStatus(String status,String objectVal, String Field, List<String> recordTypes, String businessHour, String dates, date startDate, date endDate, boolean willRefresh,String selectedName)
    {
        System.debug('value of getLeadByStatus');
        map<String,String> usermap = new map<String,String>();
        
        List<DataSet> dataSet = new List<DataSet>();
        String status_val = status;
        String dataRepresentation;
        String recordType = String.join(recordTypes,', ');
        List<BatchInfo__c> ctendays = new List<BatchInfo__c>();
        List<BatchInfo__c> bi = new list<BatchInfo__c>();
        if(selectedName != null){
            bi = [SELECT Id,OwnerDataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Filter_Name__c=:selectedName];
        }
        else{
            bi=[SELECT Id,OwnerDataRepresentation__c,LastRefreshedDate__c,willRefresh__c From BatchInfo__c  order by createddate desc limit 1];
        }
        system.debug('value of bii'+bi);
        
        List<Attachment> doc = [SELECT Id,body  FROM Attachment where ParentId=:bi[0].id];
        system.debug('value of doc'+doc);
        map<String,map<String,decimal>> ownertostagetotime=new map<String,map<String,decimal>>();
        if(bi != null && !bi.isEmpty())
        {
            dataRepresentation = doc[0].body.toString(); 
        }
        else
        {
            ctendays = [select id, OwnerDataRepresentation__c from BatchInfo__c order by createddate desc limit 1];
        }
        String inputdata;  
        map<String,double> valuestorepickliststage= new map<String,double>();
        
        if(dataRepresentation != null)
        {
            inputdata = '['+dataRepresentation+']';
        }
        system.debug('inputdata'+inputdata);
        List<Object> result = (List<Object>)JSON.deserializeUntyped(inputdata);
        system.debug('result...'+result);
        String ss;
        for(object sst: result)
        {
            
            Map<String,object> data=(Map<String,object>)sst;
            for(String ownerstage:data.keySet())
            {
                List<String> ownerstagearray=ownerstage.split(':');
                system.debug('containssss...'+ownertostagetotime.containsKey(ownerstagearray[1]));
                
                if(ownertostagetotime.containsKey(ownerstagearray[1]) && ownertostagetotime!=null)
                {
                    ownertostagetotime.get(ownerstagearray[1]).put(ownerstagearray[0],decimal.valueOf(String.valueOf(data.get(ownerstage))));
                }
                else
                {
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
            for(User u:[Select id,Name from User where id IN:ownertostagetotime.get(status_val).keySet()])
            {
                usermap.put(u.id,u.Name);
            }
        }
        if(ownertostagetotime.containskey(status_val))
        {
            for(String owneriddata:ownertostagetotime.get(status_val).keySet())
            {
                dataSet.add(new DataSet(usermap.get(owneriddata) ,ownertostagetotime.get(status_val).get(owneriddata)));
            }
        }
        System.debug('value of dataset'+dataset);
        return dataSet ;
    }
    @AuraEnabled
    public static List<BatchInfo__c> getFD(String objectVal, String field,List<String> fieldValues, List<String> recordTypes, String businessHour, String dates, date startDate, date endDate, boolean willRefresh)
    {
        String fieldVal = String.join(fieldValues,', '); 
        String recordType = String.join(recordTypes,', ');
        Id recordId;
        Id batchJobId;
        String errorName;
        System.debug('Businesshour------->'+businessHour+'\nDates------->'+dates+'\nSobjectFieldValue__c--------->'+fieldVal+'\nSobjectRecordType__c----------------->'+recordType+'\nSobjectType__c------->'+objectVal+'\nSobjectFieldType__c---------->'+Field);
        List<BatchInfo__c> BI = new List<BatchInfo__c>();
        system.debug('Query --->'+[SELECT Id,Businesshour__c, Dates__c, SobjectFieldValue__c, EndDate__c, StartDate__c, SobjectFieldType__c, SobjectRecordType__c, SobjectType__c,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c From BatchInfo__c LIMIT 1]);
        List<BatchInfo__c> BIs = [SELECT Id,Businesshour__c, Dates__c, Filter_Name__c, SobjectFieldValue__c, EndDate__c, StartDate__c, SobjectFieldType__c, SobjectRecordType__c, SobjectType__c,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectFieldValue__c =: fieldVal AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal  LIMIT 1];
        System.debug('BIs getFD FN null ========'+BIs);
        BI = BIs;
        System.debug('BI getFD FN null ========'+BI);
        return BI;
    }
    @AuraEnabled
    public static List<BatchInfo__c> getFD1(String objectVal, String field,List<String> fieldValues, List<String> recordTypes, String businessHour, String dates, date startDate, date endDate, boolean willRefresh, String FN)
    {
        System.debug(LoggingLevel.INFO,
            '\n===== getFD1 Parameters =====' +
            '\nobjectVal     : ' + objectVal +
            '\nfield         : ' + field +
            '\nfieldValues   : ' + fieldValues +
            '\nrecordTypes   : ' + recordTypes +
            '\nbusinessHour  : ' + businessHour +
            '\ndates         : ' + dates +
            '\nstartDate     : ' + startDate +
            '\nendDate       : ' + endDate +
            '\nwillRefresh   : ' + willRefresh +
            '\nFN            : ' + FN +
            '\n============================'
        );        String fieldVal = String.join(fieldValues,', '); 
        String recordType = String.join(recordTypes,', ');
        List<BatchInfo__c> BI = new List<BatchInfo__c>();
        List<BatchInfo__c> BIs = [SELECT Id,Filter_Name__c, Businesshour__c, Dates__c, SobjectFieldValue__c, EndDate__c, StartDate__c, SobjectFieldType__c, SobjectRecordType__c, SobjectType__c,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectFieldValue__c =: fieldVal AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal  LIMIT 1];
        System.debug('BI getFD ========'+BIs);
        BI = BIs;
        System.debug('BI getFD ========'+BI);
        return BI;
    }
    
    ////////////owner based on average time
    @AuraEnabled(cacheable = true)
    public static List<DataSet> ownerbasedonaveragetime(String status,String objectVal, String Field, List<String> recordTypes, String businessHour, String dates, date startDate, date endDate, boolean willRefresh,String selectedName,string ownerpicklist)
    {
        map<String,String> usermap = new map<String,String>();
        List<DataSet> dataSet = new List<DataSet>();
        status = status.replace(' ', '');
        list<string> status_val=status.split(',');
        String dataRepresentation;
        String recordType = String.join(recordTypes,', ');
        List<BatchInfo__c> ctendays = new List<BatchInfo__c>();
        List<BatchInfo__c> bi = new list<BatchInfo__c>();
        if(selectedName != null){
            bi = [SELECT Id,OwnerDataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Filter_Name__c=:selectedName];
        }
        else{
            bi=[SELECT Id,OwnerDataRepresentation__c,LastRefreshedDate__c,willRefresh__c From BatchInfo__c  order by createddate desc limit 1];
        }
        system.debug('value of bii'+bi);
        
        List<Attachment> doc = [SELECT Id,body  FROM Attachment where ParentId=:bi[0].id];
        system.debug('value of doc'+doc);
        map<String,map<String,decimal>> ownertostagetotime=new map<String,map<String,decimal>>();
        if(bi != null && !bi.isEmpty())
        {
            dataRepresentation = doc[0].body.toString(); 
        }
        else
        {
            ctendays = [select id, OwnerDataRepresentation__c from BatchInfo__c order by createddate desc limit 1];
        }
        String inputdata;  
        map<String,double> valuestorepickliststage= new map<String,double>();
        
        if(dataRepresentation != null)
        {
            inputdata = '['+dataRepresentation+']';
        }
        system.debug('inputdata'+inputdata);
        List<Object> result = (List<Object>)JSON.deserializeUntyped(inputdata);
        system.debug('result...'+result);
        String ss;
        for(object sst: result)
        {
            
            Map<String,object> data=(Map<String,object>)sst;
            for(String ownerstage:data.keySet())
            {
                List<String> ownerstagearray=ownerstage.split(':');
                if(ownertostagetotime.containsKey(ownerstagearray[1]) && ownertostagetotime!=null)
                {
                    ownertostagetotime.get(ownerstagearray[1]).put(ownerstagearray[0],decimal.valueOf(String.valueOf(data.get(ownerstage))));
                }
                else
                {
                    if(data.get(ownerstage)!=null)
                    {
                        ownertostagetotime.put(ownerstagearray[1], new map<String,decimal>{ownerstagearray[0]=>decimal.valueOf(String.valueOf(data.get(ownerstage)))}) ;
                    }
                }
            }
        }
        
        List<user> listOfUser=[Select id from User where name=:ownerpicklist];
        list<case> getCaseBasedOwner=[select CaseNumber from case where owner.name=:ownerpicklist];
        system.debug('value of ><><>'+listOfUser[0].id);
        map<string,decimal> MapOfOwnerBasedOnAverageTime= new map<string,decimal>();
        for(string str:ownertostagetotime.keyset())
        {
            map<string,decimal> MapOfKeyOwnerToStageToTime=ownertostagetotime.get(str);
            for(string fg:ownertostagetotime.get(str).keyset())  
            {
                
                if(listOfUser[0].id!=null && listOfUser[0].id==fg){
                    MapOfOwnerBasedOnAverageTime.put(str,MapOfKeyOwnerToStageToTime.get(fg));
                   for(string statu:status_val)
                   {
                       if(str==statu)
                       {
                           dataSet.add(new DataSet(str,MapOfKeyOwnerToStageToTime.get(fg)));
                       }
                   }
                   // dataSet.add(new DataSet(str,MapOfKeyOwnerToStageToTime.get(fg)));
                }
            }	  
        } 
        System.debug('value of dataset'+dataset);
        return dataSet ;
    }
    //////////////////////////////////////
    @AuraEnabled
    public static list<String> getUserList(){
        
        list<String> userr= new list<String>();
        List<user> acc=[Select name from User];
        system.debug('acc==>'+acc);
        for(user us:acc)
        {
            userr.add(string.valueof(us.name));
        }
        return userr;
    }
    
    ////// average time case single record
    @AuraEnabled
    public static map<string,decimal> avergetimesinglerecord(string casevalueid,string id){
        system.debug('id'+id);
        system.debug('casevalueid'+casevalueid);
        map<string,decimal> pickvalmap = new map<string,decimal>();
        map<string,decimal> pickvalmapglobal = new map<string,decimal>();
         list<case> caserecord;
        if(casevalueid!=null)
        {
            caserecord=[select id,CaseNumber,createddate,OwnerId,Status,(select Caseid,NewValue,OldValue,createddate,Field from Histories order by CreatedDate) from Case where CaseNumber=:casevalueid];
        
        }
        else if(id!=null)
        {
            caserecord=[select id,CaseNumber,createddate,OwnerId,Status,(select Caseid,NewValue,OldValue,createddate,Field from Histories order by CreatedDate) from Case where id=:id];
        }
         for(case c : caserecord){
           system.debug('c'+c); 
            boolean firsttime = true;
            datetime recentRecTime;
            if(c.Histories != null && !(c.Histories).isEmpty()){
                for(CaseHistory ch : c.Histories){
                    if(ch.field == 'Status'){
                        if(firsttime){
                            decimal timee = BusinessHours.diff(System.Label.Default_Business_Hours_Id,c.CreatedDate,ch.CreatedDate);
                            timee = (timee/1000)/60;
                            timee = timee.setScale(2);
                            if(!pickvalmap.containskey(string.valueof(ch.OldValue))){
                                pickvalmap.put(string.valueof(ch.OldValue),timee);
                            }
                            else{
                                pickvalmap.put(string.valueof(ch.OldValue),pickvalmap.get(string.valueof(ch.OldValue))+timee);
                            }
                            if(!pickvalmapglobal.containskey(string.valueof(ch.OldValue))){
                                pickvalmapglobal.put(c.id + ',' + ch.OldValue,timee);
                            }
                            else{
                                pickvalmapglobal.put(c.id + ',' + ch.OldValue,pickvalmapglobal.get(string.valueof(ch.OldValue))+timee);
                            }
                            firsttime = false;
                        }
                        else{
                            
                            decimal timee = BusinessHours.diff(System.Label.Default_Business_Hours_Id,recentRecTime,ch.CreatedDate);
                            timee = (timee/1000)/60;
                            timee = timee.setScale(2);
                            if(!pickvalmap.containskey(string.valueof(ch.OldValue))){
                                pickvalmap.put(string.valueof(ch.OldValue),timee);
                            }
                            else{
                                pickvalmap.put(string.valueof(ch.OldValue),pickvalmap.get(string.valueof(ch.OldValue))+timee);
                            }
                            if(!pickvalmapglobal.containskey(string.valueof(ch.OldValue))){
                                pickvalmapglobal.put(c.id + ',' + ch.OldValue,timee);
                            }
                            else{
                                pickvalmapglobal.put(c.id + ',' + ch.OldValue,pickvalmapglobal.get(string.valueof(ch.OldValue))+timee);
                            }
                        }
                        recentRecTime = ch.CreatedDate; 
                    }
                }
            }
            system.debug('value off pickvalmap'+pickvalmap);
        } 
        if(!pickvalmap.isEmpty()){
            return pickvalmap;
        }
        else {
            return null;
        }
    }
    //////
    
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
