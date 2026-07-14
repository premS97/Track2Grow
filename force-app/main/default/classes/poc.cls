public  with sharing  class poc {
    @AuraEnabled(cacheable=true)
    public static List<String> getAllUser(){
        List<case> caseList =[SELECT id,OwnerId,Owner.Name from Case];
        List<String> UserName=new List<String>();
        
        for(Integer i=0;i<caseList.size();i++){
            if(caseList.size()!=(i+1)){
                if(caseList[i].Owner.Id!=caseList[i+1].Owner.Id){
                    system.debug('CaseList==>'+caseList[i].Owner.name);
                    UserName.add(caseList[i].Owner.Name);
                }
            }
        }
        return UserName;
    }
    
    @AuraEnabled(cacheable = true)
    public static Map<String,Map<String,Decimal>> getAllCasesForUser1(String ownerName,String selectedName)
    {
        Map<String,Decimal> ownerDetailMap = new Map<String,Decimal>();
        Map<String,Map<String,Decimal>> ownerData = new Map<String,Map<String,Decimal>>();
        String dataRepresentation;
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
        
        List<user> acc=[Select id from User where name=:ownerName];
        system.debug('value of ><><>'+acc[0].id);
        map<string,decimal> fn= new map<string,decimal>();
        for(string str:ownertostagetotime.keyset())
        {
            map<string,decimal> yes=ownertostagetotime.get(str);
            for(string fg:ownertostagetotime.get(str).keyset())  
            {
                if(acc[0].id!=null && acc[0].id==fg){
                    fn.put(str,yes.get(fg));
                }
            }	  
        }
        ownerData.put(ownerName,fn);
        // System.debug('value of dataset'+ dataset);
        // return dataSet ;
        return ownerData;
    }
     @AuraEnabled(cacheable = true)
    public static Map<String,Map<String,Decimal>> getAllCasesForUser2(String ownerName,String selectedName)
    {
        Map<String,Decimal> ownerDetailMap = new Map<String,Decimal>();
        Map<String,Map<String,Decimal>> ownerData = new Map<String,Map<String,Decimal>>();
        String dataRepresentation;
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
        for(object sst: result){
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
        
        List<user> acc=[Select id from User where name=:ownerName];
        system.debug('value of ><><>'+acc[0].id);
        map<string,decimal> fn= new map<string,decimal>();
        for(string str:ownertostagetotime.keyset())
        {
            map<string,decimal> yes=ownertostagetotime.get(str);
            for(string fg:ownertostagetotime.get(str).keyset())  
            {
                
                if(acc[0].id!=null && acc[0].id==fg){
                    fn.put(str,yes.get(fg));
                    
                    // dataSet.add(new DataSet(str,yes.get(fg)));
                }
            }	  
        }
        ownerData.put(ownerName,fn);
        // System.debug('value of dataset'+dataset);
        // return dataSet ;
        return ownerData;
    }
}