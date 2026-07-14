public class tallyOwnerLeaderboard implements Database.Batchable<sObject> {
    map<string,decimal> pickvalmap = new map<string,decimal>();
    public string query;
    public string fieldVal;
    public string field;
    public integer recordsProcessed = 0;
    public map<string,decimal> ownermap = new map<string,decimal>();
    public map<string,decimal> ownerTimeMap = new map<string,decimal>();
    public map<string,decimal> pickvalmapglobal = new map<string,decimal>();
    public map<string,integer> recordcountperowner = new map<string,integer>();
    public tallyOwnerLeaderboard(string fieldVal, list<String> recordTypes, string dates, string ownerId){
        ownermap.put(ownerId+','+fieldVal,0.0);
        string query;
        this.fieldVal = fieldVal;
        query = 'select id,createddate,OwnerId,Status,(select Caseid,NewValue,OldValue,createddate,Field from Histories WHERE Field = \'Status\' OR Field = \'Owner\' order by CreatedDate) from Case';
        if(recordTypes != null && !recordTypes.isEmpty()){
            string recordtypenames = '(\'' + string.join(recordTypes, '\',\'') + '\')';
            query = query + ' WHERE recordType.name in ' + recordtypenames;
        }
        if(dates != null && dates != 'Custom Date'){
            if(recordTypes == null || recordTypes.isEmpty()){
                query = query + ' WHERE ';
            }
            else if(recordTypes != null && !recordTypes.isEmpty()){
                query = query + ' AND ';
            }
            if(dates == 'Last Week')
                query = query + ' CreatedDate__c = LAST_WEEK';
            else if(dates == 'Last Month')
                query = query + ' CreatedDate__c = LAST_MONTH';
            else if(dates == 'This Month')
                query = query + ' CreatedDate__c = THIS_MONTH';
            else if(dates == 'Last 3 Months')
                query = query + ' CreatedDate__c = LAST_N_MONTHS:3';
            else if(dates == 'Last 6 Months')
                query = query + ' CreatedDate__c = LAST_N_MONTHS:6';
            else if(dates == 'Last Year')
                query = query + ' CreatedDate__c = LAST_YEAR';
            else if(dates == 'This Week')
                query = query + ' CreatedDate__c = THIS_WEEK';
            else if(dates == 'This Year')
                query = query + ' CreatedDate__c = THIS_YEAR';
        }
        this.query = query;
    }
    
    /////single record  constructor
    public tallyOwnerLeaderboard(list<id> recordid){
        // this.fieldVal = fieldVal;
        string query;
        if(recordid!=null)
            query = 'select id,createddate,OwnerId,Status,(select Caseid,NewValue,OldValue,createddate,Field,DataType from Histories WHERE Field = \'Status\' OR Field = \'Owner\' order by CreatedDate) from Case where id in '+'(\'' + string.join(recordid, '\',\'') + '\')';
        this.query = query;
    }
    
    
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query); 
    }
    public void execute(Database.BatchableContext bc, List<case> records){
        for(case c : records){
            
            boolean firsttime = true;
            boolean ownerfirstTime = true;
            datetime recentRecTime;
            string newValue;
            string oldValue;
            dateTime subtime;
            // boolean firstTime = true;
            map<id,decimal> ownerChangeMap = new map<id,decimal>();
            set<string> ownerset = new set<string>();
            
            for(CaseHistory ch : c.Histories)
            {
                if(ch.Field == 'Owner' && ch.DataType=='EntityId')
                {
                    oldValue = (ID)string.valueOf(ch.OldValue);
                    break;
                }
            }
            
            for(CaseHistory ch : c.Histories)
            {
                dateTime dt;
                if(ch.field == 'Owner' && ch.DataType=='EntityId')
                {
                    if(ownerfirstTime)
                    {
                        decimal ownersubtime = BusinessHours.diff('01m2w000000o9EfAAI',c.CreatedDate,ch.CreatedDate);
                        ownersubtime = (ownersubtime/1000)/60;  
                        if(!ownerChangeMap.containskey((ID)string.valueOf(ch.OldValue)))
                        {
                            ownerChangeMap.put((ID)string.valueOf(ch.OldValue),ownersubtime);
                        }
                        else
                        {
                            ownerChangeMap.put((ID)string.valueOf(ch.OldValue),ownerChangeMap.get((ID)string.valueOf(ch.OldValue))+ownersubtime);    
                        }
                    }
                    else
                    {
                        decimal ownersubtime = BusinessHours.diff('01m2w000000o9EfAAI',recentRecTime,ch.CreatedDate);                      
                        ownersubtime = (ownersubtime/1000)/60;  
                        if(!ownerChangeMap.containskey((ID)string.valueOf(ch.OldValue)))
                        {
                            ownerChangeMap.put((ID)string.valueOf(ch.OldValue),ownersubtime);
                        }
                        else
                        {
                            ownerChangeMap.put((ID)string.valueOf(ch.OldValue),ownerChangeMap.get((ID)string.valueOf(ch.OldValue))+ownersubtime);    
                        }
                    }
                    newValue = (ID)string.valueOf(ch.NewValue);
                }
                
                
                if(ch.Field == 'Status')
                {
                    if(firstTime)
                    {
                        dt = ch.CreatedDate;
                        subtime = dt;
                        dt =c.CreatedDate;
                        decimal timee = BusinessHours.diff('01m2w000000o9EfAAI',c.CreatedDate,ch.CreatedDate);
                        timee = (timee/1000)/60;
                        if(ownerChangeMap != null && !ownerChangeMap.isEmpty())
                        {
                            for(string s : ownerChangeMap.keyset())
                            {
                                ownerset.add(s+':'+string.valueOf(ch.OldValue));
                                if(!ownerTimeMap.containskey(s+':'+string.valueOf(ch.OldValue)))
                                {
                                    ownerTimeMap.put(s+':'+string.valueOf(ch.OldValue),ownerChangeMap.get(s));
                                }
                                else
                                {
                                    ownerTimeMap.put(s+':'+string.valueOf(ch.OldValue),ownerTimeMap.get(s+':'+string.valueOf(ch.OldValue))+ownerChangeMap.get(s));
                                }
                            }
                            ownerset.add(newValue+':'+string.valueOf(ch.OldValue));
                            if(!ownerTimeMap.containsKey(newValue+':'+string.valueOf(ch.OldValue)))
                            {
                                ownerTimeMap.put(newValue+':'+string.valueOf(ch.OldValue),(BusinessHours.diff('01m2w000000o9EfAAI',recentRecTime,ch.CreatedDate)/1000)/60);
                            }
                            else
                            {
                                ownerTimeMap.put(newValue+':'+string.valueOf(ch.OldValue),ownerTimeMap.get(newValue+':'+string.valueOf(ch.OldValue))+(BusinessHours.diff('01m2w000000o9EfAAI',recentRecTime,ch.CreatedDate)/1000)/60);
                            }
                        }
                        else
                        {
                            if(oldValue != null && newValue == null){
                                ownerset.add(oldValue+':'+string.valueOf(ch.OldValue));
                                if(!ownerTimeMap.containskey(oldValue+':'+string.valueOf(ch.OldValue)))
                                {
                                    ownerTimeMap.put(oldValue+':'+string.valueOf(ch.OldValue),timee);
                                }
                                else
                                {
                                    ownerTimeMap.put(oldValue+':'+string.valueOf(ch.OldValue),ownerTimeMap.get(oldValue+':'+string.valueOf(ch.OldValue))+timee);
                                }
                                
                            }
                            if(newValue!=null)
                            {
                                ownerset.add(newValue+':'+string.valueOf(ch.OldValue));
                                if(!ownerTimeMap.containskey(newValue+':'+string.valueOf(ch.OldValue)))
                                {
                                    ownerTimeMap.put(newValue+':'+string.valueOf(ch.OldValue),timee);
                                }
                                else
                                {
                                    ownerTimeMap.put(newValue+':'+string.valueOf(ch.OldValue),ownerTimeMap.get(newValue+':'+string.valueOf(ch.OldValue))+timee);
                                }
                                
                            }
                            if(oldValue == null && newValue == null)
                            {
                                ownerset.add(string.valueOf(c.OwnerId)+':'+string.valueOf(ch.OldValue));
                                if(!ownerTimeMap.containskey(string.valueOf(c.OwnerId)+':'+string.valueOf(ch.OldValue)))
                                {
                                    ownerTimeMap.put(string.valueOf(c.OwnerId)+':'+string.valueOf(ch.OldValue),timee);
                                }
                                else
                                {
                                    ownerTimeMap.put(string.valueOf(c.OwnerId)+':'+string.valueOf(ch.OldValue),ownerTimeMap.get(string.valueOf(c.OwnerId)+':'+string.valueOf(ch.OldValue))+timee);
                                }
                                
                            }
                            
                        }
                        if (pickValMap.containsKey(string.valueOf(ch.OldValue)))
                        {system.debug('here');
                            if(pickValMap.get(string.valueOf(ch.OldValue)) == null)
                            {system.debug('here');
                                pickValMap.put(string.valueOf(ch.OldValue),timee);
                            }
                            else
                            {system.debug('here');
                                pickValMap.put(string.valueOf(ch.OldValue),pickValMap.get(string.valueOf(ch.OldValue))+timee);
                            }
                        }
                    }
                    else
                    {
                        dt = ch.CreatedDate;
                        decimal timee = BusinessHours.diff('01m2w000000o9EfAAI' ,subtime,dt);
                        subtime = dt;
                        timee = (timee/1000)/60;
                        if(ownerChangeMap != null && !ownerChangeMap.isEmpty())
                        {
                            for(string s : ownerChangeMap.keyset())
                            {
                                ownerset.add(s+':'+string.valueOf(ch.OldValue));
                                if(!ownerTimeMap.containskey(s+':'+string.valueOf(ch.OldValue)))
                                {
                                    ownerTimeMap.put(s+':'+string.valueOf(ch.OldValue),ownerChangeMap.get(s));
                                }
                                else
                                {
                                    ownerTimeMap.put(s+':'+string.valueOf(ch.OldValue),ownerTimeMap.get(s+':'+string.valueOf(ch.OldValue))+ownerChangeMap.get(s));
                                }
                            }
                            ownerset.add(newValue+':'+string.valueOf(ch.OldValue));
                            if(!ownerTimeMap.containsKey(newValue+':'+string.valueOf(ch.OldValue)))
                            {
                                ownerTimeMap.put(newValue+':'+string.valueOf(ch.OldValue),(BusinessHours.diff('01m2w000000o9EfAAI',recentRecTime,ch.CreatedDate)/1000)/60);
                            }
                            else
                            {
                                ownerTimeMap.put(newValue+':'+string.valueOf(ch.OldValue),ownerTimeMap.get(newValue+':'+string.valueOf(ch.OldValue))+(BusinessHours.diff('01m2w000000o9EfAAI',recentRecTime,ch.CreatedDate)/1000)/60);
                            }
                            
                        }
                        else
                        {
                            if(oldValue != null && newValue == null)
                            {
                                ownerset.add(oldValue+':'+string.valueOf(ch.OldValue));
                                if(!ownerTimeMap.containskey(oldValue+':'+string.valueOf(ch.OldValue)))
                                {
                                    ownerTimeMap.put(oldValue+':'+string.valueOf(ch.OldValue),timee);
                                }
                                else
                                {
                                    ownerTimeMap.put(oldValue+':'+string.valueOf(ch.OldValue),ownerTimeMap.get(oldValue+':'+string.valueOf(ch.OldValue))+timee);
                                }
                            }
                            else if(newValue!=null)
                            {
                                ownerset.add(newValue+':'+string.valueOf(ch.OldValue));
                                if(!ownerTimeMap.containskey(newValue+':'+string.valueOf(ch.OldValue)))
                                {
                                    ownerTimeMap.put(newValue+':'+string.valueOf(ch.OldValue),timee);
                                }
                                else
                                {
                                    ownerTimeMap.put(newValue+':'+string.valueOf(ch.OldValue),ownerTimeMap.get(newValue+':'+string.valueOf(ch.OldValue))+timee);
                                }
                            }
                            else if(oldValue == null && newValue == null)
                            {
                                ownerset.add(string.valueOf(ch.OldValue)+':'+string.valueOf(ch.OldValue));
                                if(!ownerTimeMap.containskey(string.valueOf(ch.OldValue)+':'+string.valueOf(ch.OldValue)))
                                {
                                    ownerTimeMap.put(string.valueOf(ch.OldValue)+':'+string.valueOf(ch.OldValue),timee);
                                }
                                else
                                {
                                    ownerTimeMap.put(string.valueOf(ch.OldValue)+':'+string.valueOf(ch.OldValue),ownerTimeMap.get(string.valueOf(ch.OldValue)+':'+string.valueOf(ch.OldValue))+timee);
                                }
                            }
                        }
                        if (pickValMap.containsKey(string.valueOf(ch.OldValue)))
                        {system.debug('here');
                            if(pickValMap.get(string.valueOf(ch.OldValue)) != null)
                            {system.debug('here');
                                pickValMap.put(string.valueOf(ch.OldValue),pickValMap.get(string.valueOf(ch.OldValue))+timee);
                            }
                            else
                            {system.debug('here');
                                pickValMap.put(string.valueOf(ch.OldValue),timee);
                            }
                        }
                    }
                    firstTime = false;
                    ownerChangeMap.clear();
                }
                ownerfirstTime = false;
               // system.debug('ownerTimeMap = '+ownerTimeMap);
                if(ch.Field == 'Created' ||ch.Field == 'status' || (ch.Field == 'Owner' && ch.DataType == 'EntityId'))
                {
                    recentRecTime = ch.CreatedDate;
                }
            }
            
            for(string os : ownerset)
            {
                if(!recordcountperowner.containsKey(os))
                {
                    recordcountperowner.put(os,1);
                }
                else
                {
                    recordcountperowner.put(os,recordcountperowner.get(os)+1);
                }
            }
            
            
        }
        
         SYSTEM.debug('VALUE OF pickValMap>> execute '+pickValMap);
        SYSTEM.debug('VALUE OF ownerTimeMap>> execute'+ownerTimeMap);
        recordsProcessed=recordsProcessed+records.size();
    }
    public void finish(Database.BatchableContext bc){
        
        for(string s : pickValMap.keyset())
        {
            Decimal avg;
            if(pickValMap.get(s) != null && pickValMap.get(s)!=0)
            {
                avg = pickValMap.get(s)/recordsProcessed;
                avg = avg.setScale(2);
            }
            if(avg==null || avg==0.00)
            {
                pickValMap.put(s,0.00);
            }
            else
            {
                pickValMap.put(s,avg);
            }
            
        } 

        system.debug('here>>>>'+ownerTimeMap.keyset());
        for(string s : ownerTimeMap.keyset())
        {system.debug('here');
            Decimal avg;
            if(ownerTimeMap.get(s)!=null && ownerTimeMap.get(s)!=0)
            {system.debug('here'+avg);
                avg = ownerTimeMap.get(s)/recordcountperowner.get(s);
                avg = avg.setScale(2);
            }
            if(avg==null || avg==0.00)
            {system.debug('here'+avg);
                ownerTimeMap.put(s+':'+recordcountperowner.get(s),null);
            }
            else
            {system.debug('here'+avg);
                ownerTimeMap.put(s+':'+recordcountperowner.get(s),avg);
            }
        }
        SYSTEM.debug('VALUE OF pickValMap>>'+pickValMap);
        SYSTEM.debug('VALUE OF ownerTimeMap>>'+ownerTimeMap);
    }
}