public class FilterDetailController  
{
     @AuraEnabled(cacheable=true)
    public static List<BatchInfo__c> getSearchFilterDetail(String searchVal)
	{
        String j= searchVal+'%';
        System.debug('J=='+j);
        List<BatchInfo__c> BI = [SELECT Id,Filter_Name__c,SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, WillRefresh__c, Businesshour__c,Dates__c, EndDate__c,StartDate__c  From BatchInfo__c where Filter_Name__c  LIKE :j  AND willRefresh__c = true];
        return BI;
    }
    @AuraEnabled(cacheable=true)
    public static List<BatchInfo__c> getFilterDetail()
	{
        List<BatchInfo__c> BI = [SELECT Id,Filter_Name__c, CreatedDate,SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, WillRefresh__c, Businesshour__c,Dates__c, EndDate__c,StartDate__c  From BatchInfo__c where Filter_Name__c!=null AND willRefresh__c = true order by CreatedDate desc];
        System.debug('BI get Filter = '+BI);
        return BI;
    }
     @AuraEnabled
    public static map<string,double> getFilterDetails(String saveFilterId,string timezone)
	{
        string dataRepresentation; 
        string inputdata;
        map<string,double> valuestorepickliststage= new map<string,double>();
        List<BatchInfo__c> bi = [SELECT Id,name,dataRepresentation__c,willRefresh__c From BatchInfo__c where ID=:saveFilterId];
        
        if(bi != null && !bi.isEmpty())
        {
            system.debug('bi..'+bi);
            dataRepresentation = bi[0].dataRepresentation__c;   
            system.debug('dataRepresentation....'+dataRepresentation);
        } 
        inputdata = '['+dataRepresentation+']';
		List<Object> result = (List<Object>)JSON.deserializeUntyped(inputdata); 
        system.debug('>>>>>>>>>'+result);
        for(Object obj : result) 
		{ 
            Map<String,Object> map1 = (Map<String,Object>)obj; 
            for(String key : map1.keyset()) 
			{
                 if(timezone=='In Minutes' && map1.get(key)!=null)
                {
                    decimal temp = (decimal)map1.get(key);
                    temp = temp.setScale(2);
                   valuestorepickliststage.put(key,temp);
                }
                if(timezone=='In Hours' && map1.get(key)!=null)
                {
                    decimal temp = (decimal)map1.get(key)/60;
                    temp = temp.setScale(2);
                   valuestorepickliststage.put(key,temp);  
                }
                if(timezone=='In Days' && map1.get(key)!=null)
                {
                    decimal temp = (decimal)map1.get(key)/1440;
                    temp = temp.setScale(2);
                   valuestorepickliststage.put(key,temp);  
                }
                 
            }
        }
        system.debug('value  of  mapp>>>>>'+valuestorepickliststage);
        return valuestorepickliststage;
        
    }
    @AuraEnabled
    public static map<string,double> getFilterDetailFromName(String filterName,string timezone)
	{
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
        for(Object obj : result) 
		{ 
            Map<String,Object> map1 = (Map<String,Object>)obj; 
            for(String key : map1.keyset()) 
			{
                 if(timezone=='In Minutes' && map1.get(key)!=null)
                {
                    decimal temp = (decimal)map1.get(key);
                    temp = temp.setScale(2);
                   valuestorepickliststage.put(key,temp);
                }
                if(timezone=='In Hours' && map1.get(key)!=null)
                {
                    decimal temp = (decimal)map1.get(key)/60;
                    temp = temp.setScale(2);
                   valuestorepickliststage.put(key,temp);  
                }
                if(timezone=='In Days' && map1.get(key)!=null)
                {
                    decimal temp = (decimal)map1.get(key)/1440;
                    temp = temp.setScale(2);
                   valuestorepickliststage.put(key,temp);  
                }
                 
            }
        }
        system.debug('value  of  mapp>>>>>'+valuestorepickliststage);
        return valuestorepickliststage;
        
    }
    @AuraEnabled
    public static string deleteFilter(String filterName)
	{
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
    public static List<BatchInfo__c> getDetail(String name)
	{
        List<BatchInfo__c> BI = [SELECT Id,Filter_Name__c,SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, WillRefresh__c, Businesshour__c,Dates__c, EndDate__c,StartDate__c  From BatchInfo__c where Filter_Name__c=:name];
        return BI;
    }
     @AuraEnabled(cacheable=true)
    public static List<BatchInfo__c> getFDetail(String FN) 
    {
        List<BatchInfo__c> BI = new List<BatchInfo__c>();
        if(FN==null){
        	BI = [SELECT Id,name,Filter_Name__c,SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, WillRefresh__c, Businesshour__c,Dates__c, EndDate__c,StartDate__c  From BatchInfo__c ORDER BY name desc LIMIT 1];
           
        }
        else{
			BI = [SELECT Id,name,Filter_Name__c,SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, WillRefresh__c, Businesshour__c,Dates__c, EndDate__c,StartDate__c  From BatchInfo__c where Filter_Name__c =:FN ORDER BY name desc LIMIT 1];
        }
        System.debug('BI getFD ========'+BI);
        return BI;
    }
}