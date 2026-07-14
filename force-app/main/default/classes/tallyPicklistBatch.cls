public class tallyPicklistBatch implements Database.Batchable<sObject>, Database.Stateful {
     map<string,decimal> pickvalmap = new map<string,decimal>();
    public string query;
    public string fieldVal='Research';
    public map<string,decimal> pickvalmapglobal = new map<string,decimal>();
    public integer recordsProcessed = 0;
    public tallyPicklistBatch(list<id> recordid/*, string fieldVal, list<id> recordIdSet */){
        this.fieldVal = fieldVal;
        system.debug('string,string');
        string query;
        //if(recordIdSet!=null && !recordIdSet.isempty())
            //query = 'select id,createddate,OwnerId,Status,(select Caseid,NewValue,OldValue,createddate,Field from Histories WHERE Field = \'Status\' OR Field = \'Owner\' order by CreatedDate) from Case where id in '+'(\'' + string.join(recordIdSet, '\',\'') + '\')';
        if(recordid!=null)
            query = 'select id,createddate,OwnerId,Status,(select Caseid,NewValue,OldValue,createddate,Field from Histories WHERE Field = \'Status\' OR Field = \'Owner\' order by CreatedDate) from Case where id in '+'(\'' + string.join(recordid, '\',\'') + '\')';
        this.query = query;
        system.debug('QUERY > '+this.query);
    }
  /*  public tallyPicklistBatch(string fieldVal, list<String> recordTypes, string dates){
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
                query = query + ' CreatedDate = LAST_WEEK';
            else if(dates == 'Last Month')
                query = query + ' CreatedDate = LAST_MONTH';
            else if(dates == 'This Month')
                query = query + ' CreatedDate = THIS_MONTH';
            else if(dates == 'Last 3 Months')
                query = query + ' CreatedDate = LAST_N_MONTHS:3';
            else if(dates == 'Last 6 Months')
                query = query + ' CreatedDate = LAST_N_MONTHS:6';
            else if(dates == 'Last Year')
                query = query + ' CreatedDate = LAST_YEAR';
            else if(dates == 'This Week')
                query = query + ' CreatedDate = THIS_WEEK';
            else if(dates == 'This Year')
                query = query + ' CreatedDate = THIS_YEAR';
        }
        this.query = query;
        system.debug('QUERY > '+this.query);
    } */
    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(query); 
    }
    public void execute(Database.BatchableContext bc, List<case> records){
        system.debug('value of records'+records);
        for(case c : records){
           
            boolean firsttime = true;
            datetime recentRecTime;
            if(c.Histories != null && !(c.Histories).isEmpty()){
            for(CaseHistory ch : c.Histories){
                system.debug('value of CaseHistory'+ch);
                if(ch.field == 'Status'){
                    if(firsttime){
                        system.debug('value of c.CreatedDate'+c.CreatedDate);
                        system.debug('value of ch.CreatedDate'+ch.CreatedDate);
                        decimal timee = BusinessHours.diff('01m2w000000o9EfAAI',c.CreatedDate,ch.CreatedDate);
                        system.debug('value of timee'+timee);
                        timee = (timee/1000)/60;
                        timee = timee.setScale(2);
                         system.debug('value of timee>>'+timee);
                        System.debug('FieldValue-->'+ this.fieldVal);
                        if(ch.OldValue == this.fieldVal){
                            system.debug('inside if');
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
                        firsttime = false;
                    }
                    else{
                        system.debug('enter else');
                        system.debug('value of c.recentRecTime'+recentRecTime);
                        system.debug('value of ch.CreatedDate'+ch.CreatedDate);
                        decimal timee = BusinessHours.diff('01m2w000000o9EfAAI',recentRecTime,ch.CreatedDate);
                        system.debug('value of timee else'+timee);
                        timee = (timee/1000)/60;
                        timee = timee.setScale(2);
                          system.debug('value of timee else>>'+timee);
                        if(ch.OldValue == fieldVal){
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
                    }
                    recentRecTime = ch.CreatedDate;
                }
            }
            }
            system.debug('value off pickvalmap'+pickvalmap);
        }
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
       /* for(string s : ownerTimeMap.keySet())
        {
            Decimal avg;
            if(ownerTimeMap.get(s)!=null && ownerTimeMap.get(s)!=0)
            {
                avg = ownerTimeMap.get(s)/recordcountperowner.get(s);
                avg = avg.setScale(2);
            }
            if(avg==null || avg==0.00)
            {
                ownerTimeMap.put(s+':'+recordcountperowner.get(s),null);
            }
            else
            {
                ownerTimeMap.put(s+':'+recordcountperowner.get(s),avg);
            }
        } */
        SYSTEM.debug('VALUE OF pickValMap>>'+pickValMap);
        //SYSTEM.debug('VALUE OF ownerTimeMap>>'+ownerTimeMap);
    }
}

//tallyPicklistBatch rs = new tallyPicklistBatch(); 
//database.executeBatch(rs);