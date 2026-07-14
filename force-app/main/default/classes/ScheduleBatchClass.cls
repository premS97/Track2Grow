global class ScheduleBatchClass implements Schedulable {
    public String field;
    public String fieldValues;
    public list<String> fieldValue;
    public list<String> recordType;
    public string recordTypes;
    public string recordTypeids;
    public String objectVal;
    public string dates;
    public date startDate;
    public date endDate;
    public Id recordId;
    public boolean scheduled;
    public boolean willRefresh=false;
    public string businessHour;
    public string filterName;
    global void execute(SchedulableContext sc){
        List<BatchInfo__c> BIList = [select id,Businesshour__c, Dates__c, EndDate__c, Filter_Name__c, SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, StartDate__c, DataRepresentation__c, WillRefresh__c from BatchInfo__c where WillRefresh__c = true];
        for(BatchInfo__c bi:BIList){
            List<String> lstString = bi.SobjectFieldValue__c.split(',');
            List<String> recordTyp = bi.SobjectRecordType__c.split(',');
            fieldValue = lstString;
            field = bi.SobjectFieldType__c;
            objectVal = bi.SobjectType__c;
            RecordType = recordTyp;
            dates = bi.Dates__c;
            startDate = bi.StartDate__c;
            endDate = bi.EndDate__c;
            recordId = bi.id;
            willRefresh = bi.WillRefresh__c;
            businessHour = bi.Businesshour__c;
            filterName = bi.Filter_Name__c;
            scheduled = true;
            averageTimeBatchClass batch = new averageTimeBatchClass(fieldValue, field, objectVal, recordType, dates,startDate,endDate, recordId,willRefresh, businessHour, filterName, scheduled);
            Database.executebatch(batch, 200);
        }
    }
   
}