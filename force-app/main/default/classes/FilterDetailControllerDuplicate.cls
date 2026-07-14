public class FilterDetailControllerDuplicate {
    @AuraEnabled(cacheable=true)
    public static List<BatchInfo__c> getFilterDetail(){
        List<BatchInfo__c> BI = [SELECT Id,Filter_Name__c,SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, WillRefresh__c, Businesshour__c,Dates__c, EndDate__c,StartDate__c  From BatchInfo__c where Filter_Name__c!=null AND willRefresh__c = true];
        return BI;
    }
    @AuraEnabled
    public static map<string,double> getFilterDetailFromName(String filterName,string timezone){
        System.debug('filterName'+filterName);
        System.debug('timezone'+timezone);
        string dataRepresentation; 
        string inputdata;
         map<string,double> valuestorepickliststage= new map<string,double>();
        List<BatchInfo__c> bi = [SELECT Id,dataRepresentation__c,willRefresh__c From BatchInfo__c where Filter_Name__c =: filterName LIMIT 1];
        if(bi != null && !bi.isEmpty())
        {
            dataRepresentation = bi[0].dataRepresentation__c;    
        } 
        inputdata = '['+dataRepresentation+']';
       List<Object> result = (List<Object>)JSON.deserializeUntyped(inputdata); 
        system.debug('>>>>>>>>>'+result);
        for(Object obj : result) { 
            Map<String,Object> map1 = (Map<String,Object>)obj; 
            System.debug('MAp1'+map1);
            for(String key : map1.keyset()) {
                if(timezone=='In Minutes' && map1.get(key)!=null)
                {
                   valuestorepickliststage.put(key,(decimal)map1.get(key));
                }
                if(timezone=='In Hours' && map1.get(key)!=null)
                {
                    System.debug('KeyHours -->> ' + key); 
                   System.debug('ValueHours -->> ' + (decimal)map1.get(key));
                   valuestorepickliststage.put(key,(decimal)map1.get(key)/60);  
                }
                if(timezone=='In Days' && map1.get(key)!=null)
                {
                   valuestorepickliststage.put(key,(decimal)map1.get(key)/1440);  
                }
                 
            }
        }
        system.debug('value  of  mapp>>>>>'+valuestorepickliststage);
        return valuestorepickliststage;
        
    }
     @AuraEnabled
    public static string deleteFilter(String filterName){
        String deleteMessage = 'Filter Deleted';
        List<BatchInfo__c> bi = [SELECT Id,Filter_Name__c,willRefresh__c From BatchInfo__c where Filter_Name__c =: filterName LIMIT 1];
         if (Schema.sObjectType.BatchInfo__c.fields.willRefresh__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.willRefresh__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.willRefresh__c.isAccessible()) 
                {
        bi[0].willRefresh__c = false;
                }
         if(bi!=null && Schema.sObjectType.BatchInfo__c.isAccessible()  && Schema.sObjectType.BatchInfo__c.isCreateable() && Schema.sObjectType.BatchInfo__c.isCreateable())
                {
        database.update(bi);  
                }
        return deleteMessage;
    }
     @AuraEnabled(cacheable=true)
    public static List<BatchInfo__c> getDetail(String name){
        List<BatchInfo__c> BI = [SELECT Id,Filter_Name__c,SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, WillRefresh__c, Businesshour__c,Dates__c, EndDate__c,StartDate__c  From BatchInfo__c where Filter_Name__c=:name];
        return BI;
    }
}