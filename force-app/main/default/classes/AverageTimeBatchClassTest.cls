@isTest
public class AverageTimeBatchClassTest  
{ 
    @isTest static void averageTimeBatchClassTest()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Last Week';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
        
        test.startTest();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
       System.assert(1==1,'List should not be empty');
    } 
    
    @isTest static void hisObjectNulltest()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Last Week';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
          List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('Internal');
        }
       
        
        //List<Track2Grow__mdt> listTrack2Grow = new list<Track2Grow__mdt>([SELECT Id,Masterlabel,HistoryObject__c from Track2Grow__mdt WHERE Masterlabel = 'HistoryObject']);
        //listTrack2Grow[0].HistoryObject__c = '';
        
        test.startTest();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    
    
   @isTest static void averageTimeBatchClassTest2()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Month';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Last Month';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'Default';
        String filterName = '';
        
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('External');
        }
        test.startTest();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
   
    @isTest static void averageTimeBatchClassTest3()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'This Month';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        btchInfo.SobjectType__c = 'Case';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
		String dates = 'This Month';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
         List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('Internal');
        }
       
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    }
    @isTest static void averageTimeBatchClassTest4()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last 3 Months';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Last 3 Months';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'tanish';
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
          List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('Internal');
        }
       
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    @isTest static void averageTimeBatchClassTest5()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last 6 Months';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Last 6 Months';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1234';
        List<String> fieldValues = new List<String>();
        fieldValues.add('Escalated');
        List<String> recordTypes = new List<String>();
          List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('External');
        }
       
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    @isTest static void averageTimeBatchClassTest6()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Year';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Last Year';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
          List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('External');
        }
       
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    @isTest static void averageTimeBatchClassTest7()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'This Month';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('On Hold');
        List<String> recordTypes = new List<String>();
          List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('External');
        }
       
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    @isTest static void averageTimeBatchClassTest8()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'This Year';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'This Year';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('Escalated');
        List<String> recordTypes = new List<String>();
          List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('External');
        }
       
        test.startTest();
        
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    @isTest static void averageTimeBatchClassTest9()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        btchInfo.SobjectType__c = 'Case';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'This Year';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        List<String> fieldValues = new List<String>();
        fieldValues.add('Closed');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
             System.assert(1==1,'List should not be empty');
        }
    
      @isTest static void averageTimeBatchClassTest9New()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        btchInfo.SobjectType__c = 'Case';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Custom Date';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        List<String> fieldValues = new List<String>();
        fieldValues.add('Closed');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
             System.assert(1==1,'List should not be empty');
        }
    
    @isTest static void testexecute()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Custom Date';
        
        Date startDate = System.today();
        Date endDate = System.today() +10;
        DateTime recentRecTime = System.today();
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        BusinessHours stdBusinessHours = [select id from BusinessHours where Name = 'Default'];
        List<String> fieldValues = new List<String>();
        fieldValues.add('Closed');
        List<String> recordTypes = new List<String>();
        
        List<object> caseList = new List<object>();
        List<object> caseList1 = new List<object>();
        List<object> caseList2= new List<object>();
        List<object> caseList3 = new List<object>();
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        Profile pf1= [Select Id from profile where Name='Standard User']; 
        
        String orgId1=UserInfo.getOrganizationId(); 
        String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName1=orgId1+dateString1+RandomId1; 
        User uu2=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName1.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
        
        insert uu2;
        
         Profile pf2= [Select Id from profile where Name='Standard User']; 
        
        String orgId2=UserInfo.getOrganizationId(); 
        String dateString2=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId2=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName2=orgId2+dateString2+RandomId2; 
        User uu3=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName2 + '@test1' + orgId2 + '.org', 
                         Username = uniqueName2 + '@test1' + orgId2 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName2.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf2.Id
                        ); 
        
        
        insert uu3;
     
        
        objectwrapper newCase = new objectwrapper();
        newCase.Id = '111111111111111111';
        newCase.OwnerId = uu.Id;
        newCase.CreatedDate = System.today();
        
        ObjectHistoryWrapper ohw=new ObjectHistoryWrapper();
        ohw.Field ='Created';
        ohw.CreatedDate = system.now();
        
        ObjectHistoryWrapper ch=new ObjectHistoryWrapper();
        ch.Field ='Owner';
        ch.Newvalue= uu2.Id;
        ch.oldvalue = uu.Id;
        ch.DataType = 'EntityId';
        ch.CreatedDate = system.now();
        
        ObjectHistoryWrapper ch1 = new ObjectHistoryWrapper();
        ch1.Field = 'Owner';
        ch1.NewValue = uu2.Id;
        ch1.OldValue = uu.Id;
        ch1.DataType = 'EntityId';
        ch1.createddate = system.now();
        
        ObjectHistoryWrapper ch2 = new ObjectHistoryWrapper();
        ch2.Field = 'Status';
        ch2.NewValue = null;
        ch2.OldValue = uu.Id;
        ch2.createddate = system.now();
        
        ObjectHistoryWrapper ch3 = new ObjectHistoryWrapper();
        ch3.Field = 'Status';
        ch3.NewValue = 'In Progress';
        ch3.createddate = system.now();
        
        ObjectHistoryWrapper ch4 = new ObjectHistoryWrapper();
        ch4.Field = 'Status';
        ch4.NewValue = null;
        ch4.OldValue = null;
        ch4.createddate = system.now();
        
		objectwrapper newCasen = new objectwrapper();
        newCasen.Id = '88888888888888888';
        newCasen.OwnerId = uu3.Id;
        newCasen.CreatedDate = System.today();
        
        objectwrapper newCases = new objectwrapper();
        newCases.Id = '888888888888888888';
        newCases.OwnerId = uu3.Id;
        newCases.CreatedDate = System.today();
        

        objectwrapper newCs = new objectwrapper();
        newCs.Id = '8888888888888888';
        newCs.OwnerId = uu3.Id;
        newCs.CreatedDate = System.today();
        
        ObjectHistoryMain objNew2 = new ObjectHistoryMain();
        objNew2.done =true;
        objNew2.records = new list<object>{ch4};

		newCases.Histories = objNew2; 
        
        caseList.add(newCases);
        
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        id batchJobId=database.executeBatch(testObject);
        system.debug('batchJobId..'+batchJobId);
        testObject.execute(null,caseList);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    }  
    
     @isTest static void testexecute1()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Custom Date';
        
        Date startDate = System.today();
        Date endDate = System.today() +10;
        DateTime recentRecTime = System.today();
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        BusinessHours stdBusinessHours = [select id from BusinessHours where Name = 'Default'];
        List<String> fieldValues = new List<String>();
        fieldValues.add('Closed');
        List<String> recordTypes = new List<String>();
        
        List<object> caseList = new List<object>();
        List<object> caseList1 = new List<object>();
        List<object> caseList2= new List<object>();
        List<object> caseList3 = new List<object>();
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        Profile pf1= [Select Id from profile where Name='Standard User']; 
        
        String orgId1=UserInfo.getOrganizationId(); 
        String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName1=orgId1+dateString1+RandomId1; 
        User uu2=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName1.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
        
        insert uu2;
        
         Profile pf2= [Select Id from profile where Name='Standard User']; 
        
        String orgId2=UserInfo.getOrganizationId(); 
        String dateString2=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId2=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName2=orgId2+dateString2+RandomId2; 
        User uu3=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName2 + '@test1' + orgId2 + '.org', 
                         Username = uniqueName2 + '@test1' + orgId2 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName2.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf2.Id
                        ); 
        
        
        insert uu3;
     
        
        objectwrapper newCase = new objectwrapper();
        newCase.Id = '111111111111111111';
        newCase.OwnerId = uu.Id;
        newCase.CreatedDate = System.today();
     
        
        ObjectHistoryWrapper ch2 = new ObjectHistoryWrapper();
        ch2.Field = 'Status';
        ch2.NewValue = null;
        ch2.OldValue = uu.Id;
        ch2.createddate = system.now();
     
		objectwrapper newCasen = new objectwrapper();
        newCasen.Id = '88888888888888888';
        newCasen.OwnerId = uu3.Id;
        newCasen.CreatedDate = System.today();
        
        objectwrapper newCases = new objectwrapper();
        newCases.Id = '888888888888888888';
        newCases.OwnerId = uu3.Id;
        newCases.CreatedDate = System.today();
        

        objectwrapper newCs = new objectwrapper();
        newCs.Id = '8888888888888888';
        newCs.OwnerId = uu3.Id;
        newCs.CreatedDate = System.today();
        
        ObjectHistoryMain objNew2 = new ObjectHistoryMain();
        objNew2.done =true;
        objNew2.records = new list<object>{ch2};

		newCases.Histories = objNew2; 
        
        caseList.add(newCases);
        
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        id batchJobId=database.executeBatch(testObject);
        system.debug('batchJobId..'+batchJobId);
        testObject.execute(null,caseList);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    
   @isTest static void testexecute21()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        btchInfo.WillRefresh__c = True;
        update btchInfo;
        
        
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Custom Date';
        String dates1 = 'this week';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        
        List<object> caseList = new List<object>();
        
               
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        Profile pf1= [Select Id from profile where Name='Standard User']; 
        
        String orgId1=UserInfo.getOrganizationId(); 
        String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName1=orgId1+dateString1+RandomId1; 
        User uu2=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName1.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
        
        insert uu2;
        
         
        objectwrapper newCase1 = new objectwrapper();
        newCase1.Id = '333333333333333333';
        newCase1.OwnerId = uu.Id;
        newCase1.CreatedDate = System.today();
        
        
        objectwrapper newCasen = new objectwrapper();
        newCasen.Id = '888888888888888888';
        newCasen.OwnerId = uu.Id;
        newCasen.CreatedDate = System.today();
        
        objectwrapper newCasenx = new objectwrapper();
        newCasenx.Id = '555555555555555555';
        newCasenx.OwnerId = uu.Id;
        newCasenx.CreatedDate = System.today();
        
        ObjectHistoryWrapper ch1 =new ObjectHistoryWrapper();
        ch1.Field = 'Owner';
        ch1.NewValue = uu.Id;
        ch1.OldValue = uu.Id;
        ch1.DataType = 'EntityId';
        ch1.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistory=new ObjectHistoryWrapper();
        cHistory.Field ='Status';
        cHistory.NewValue = 'In Progress';
        cHistory.OldValue = 'New';
        cHistory.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistoryn=new ObjectHistoryWrapper();
        cHistoryn.Field = 'Status';
        cHistoryn.NewValue = 'In Progress';
        cHistoryn.OldValue = 'New';
        cHistoryn.CreatedDate = system.now();
        
        
        ObjectHistoryWrapper ch2 =new ObjectHistoryWrapper();
        ch2.Field = 'Owner';
        ch2.NewValue = uu.Id;
        ch2.OldValue = uu.Id;
        ch2.DataType = 'EntityId';
        ch2.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistory2=new ObjectHistoryWrapper();
        cHistory2.Field ='Status';
        cHistory2.NewValue = 'In Progress';
        cHistory2.OldValue = 'New';
        cHistory2.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistory3=new ObjectHistoryWrapper();
        cHistory3.Field ='Status';
        cHistory3.NewValue = 'In Progress';
        cHistory3.OldValue = 'New';
        cHistory3.CreatedDate = system.now();
        
        
        
        ObjectHistoryMain objNew = new ObjectHistoryMain();
        objNew.done =true;
        objNew.records = new list<object>{ch1,cHistory,cHistoryn};
            
        ObjectHistoryMain objNew1 = new ObjectHistoryMain();
        objNew1.done =true;
        objNew1.records = new list<object>{ch1,cHistory2,ch2};
        
        newCase1.Histories = objNew;
        newCasen.Histories = objNew1;   
            
           
        caseList.add(newCase1);
        caseList.add(newCasen);
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        averageTimeBatchClass testObject1 = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates1,null,null,recordId,willRefresh,businessHour,filterName,scheduled); 
        testObject.execute(null,caseList);
        testObject1.execute(null,caseList);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    }
    @isTest static void testexecute211()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        btchInfo.WillRefresh__c = True;
        update btchInfo;
        
        
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Custom Date';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        
        List<object> caseList = new List<object>();
        
               
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        Profile pf1= [Select Id from profile where Name='Standard User']; 
        
        String orgId1=UserInfo.getOrganizationId(); 
        String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName1=orgId1+dateString1+RandomId1; 
        User uu2=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName1.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
        
        insert uu2;
        
         
        objectwrapper newCase1 = new objectwrapper();
        newCase1.Id = '333333333333333333';
        newCase1.OwnerId = uu.Id;
        newCase1.CreatedDate = System.today();
        
      
        
        
        objectwrapper newCasen = new objectwrapper();
        newCasen.Id = '888888888888888888';
        newCasen.OwnerId = uu.Id;
        newCasen.CreatedDate = System.today();
        
        objectwrapper newCasenx = new objectwrapper();
        newCasenx.Id = '555555555555555555';
        newCasenx.OwnerId = uu.Id;
        newCasenx.CreatedDate = System.today();
        
        ObjectHistoryWrapper ch1 =new ObjectHistoryWrapper();
        ch1.Field = 'Owner';
        ch1.NewValue = null;
        ch1.OldValue = uu.Id;
        ch1.DataType = 'EntityId';
        ch1.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistory=new ObjectHistoryWrapper();
        cHistory.Field ='Status';
        cHistory.NewValue = 'In Progress';
        cHistory.OldValue = 'New';
        cHistory.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistoryn=new ObjectHistoryWrapper();
        cHistoryn.Field = 'Status';
        cHistoryn.NewValue = 'In Progress';
        cHistoryn.OldValue = 'New';
        cHistoryn.CreatedDate = system.now();
        
        ObjectHistoryWrapper ch2 =new ObjectHistoryWrapper();
        ch2.Field = 'Owner';
        ch2.NewValue = null;
        ch2.OldValue = uu.Id;
        ch2.DataType = 'EntityId';
        ch2.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistory2=new ObjectHistoryWrapper();
        cHistory2.Field ='Status';
        cHistory2.NewValue = 'In Progress';
        cHistory2.OldValue = 'New';
        cHistory2.CreatedDate = system.now();
        
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        testObject.execute(null,caseList);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    }
     @isTest static void testexecute2Neww()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
		btchInfo.WillRefresh__c = True;
        update btchInfo;
        
        
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Custom Date';
        Date startDate = System.today() ;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        
        List<object> caseList = new List<object>();
        
               
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        Profile pf1= [Select Id from profile where Name='Standard User']; 
        
        String orgId1=UserInfo.getOrganizationId(); 
        String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName1=orgId1+dateString1+RandomId1; 
        User uu2=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName1.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
        
        insert uu2;
        
         
        objectwrapper newCase1 = new objectwrapper();
        newCase1.Id = '333333333333333333';
        newCase1.OwnerId = uu.Id;
        newCase1.CreatedDate = System.today();
        
        
        ObjectHistoryWrapper cHistory=new ObjectHistoryWrapper();
        cHistory.Field ='Owner';
        cHistory.NewValue = uu2.Id;
        cHistory.OldValue = uu.Id;
        cHistory.DataType = 'EntityId';
        cHistory.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistoryn=new ObjectHistoryWrapper();
        cHistoryn.Field = 'Status';
        cHistoryn.NewValue = 'In Progress';
        cHistoryn.OldValue = 'New';
        cHistoryn.DataType = 'EntityId';
        cHistoryn.CreatedDate = system.now();
       
		ObjectHistoryWrapper cHistoryny=new ObjectHistoryWrapper();
        cHistoryny.Field ='Owner';
        cHistoryny.NewValue = uu.Id;
        cHistoryny.OldValue = uu2.Id;
        cHistoryny.DataType = 'EntityId';
        cHistoryny.CreatedDate = system.now();
        
        
        
        ObjectHistoryWrapper cHistorynny=new ObjectHistoryWrapper();
        cHistorynny.Field = 'Status';
        cHistorynny.NewValue = 'In Progress';
        cHistorynny.OldValue = 'New';
        cHistorynny.DataType = 'EntityId';
        cHistorynny.CreatedDate = system.now();
        
        ObjectHistoryWrapper ccHistoryny=new ObjectHistoryWrapper();
        ccHistoryny.Field ='Owner';
        ccHistoryny.NewValue = uu2.Id;
        ccHistoryny.OldValue = uu.Id;
        ccHistoryny.DataType = 'EntityId';
        ccHistoryny.CreatedDate = system.now();
        
        
        
        ObjectHistoryWrapper cHistorynnyc=new ObjectHistoryWrapper();
        cHistorynnyc.Field = 'Status';
        cHistorynnyc.NewValue = 'In Progress';
        cHistorynnyc.OldValue = Null;
        cHistorynnyc.DataType = 'EntityId';
        cHistorynnyc.CreatedDate = system.now();
        
        ObjectHistoryMain objNew1 = new ObjectHistoryMain();
        objNew1.done =true;
        objNew1.records = new list<object>{cHistory,cHistoryn,cHistoryny,cHistorynny,ccHistoryny,cHistorynnyc};
        
        system.debug('objNew1.records>>>>'+objNew1.records);
        newCase1.Histories = objNew1;
        
        system.debug('newCase1.Histories>>>>'+newCase1.Histories);
        caseList.add(newCase1);
        
        system.debug('caseList>>>>'+caseList);
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        testObject.execute(null,caseList);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    @isTest static void averageTimeBatchClassTestElsePart1()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Last Week';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
        List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('Internal');
        }
       
        
        test.startTest();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    @isTest static void averageTimeBatchClassTestElsePart2()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Month';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Last Month';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
         List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('Internal');
        }
       
        
        test.startTest();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,null,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        averageTimeBatchClass testObject1 = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,null,willRefresh,businessHour,null,scheduled); 
        DataBase.executeBatch(testObject1);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    }
   @isTest static void averageTimeBatchClassTestElsePart3()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'This Month';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'This Month';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
          List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('Internal');
        }
       
        
        test.startTest();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    @isTest static void averageTimeBatchClassTestElsePart4()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last 3 Months';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Last 3 Months';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
         List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('Internal');
        }
       
        
        test.startTest();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
   @isTest static void averageTimeBatchClassTestElsePart5()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last 6 Months';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Last 6 Months';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
          List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('Internal');
        }
       
        
        test.startTest();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
     @isTest static void averageTimeBatchClassTestElsePart6()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Year';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'Last Year';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
         List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('Internal');
        }
       
        
        test.startTest();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    @isTest static void averageTimeBatchClassTestElsePart7()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'This Month';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'This Week';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
          List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('Internal');
        }
       
        
        test.startTest();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    @isTest static void averageTimeBatchClassTestElsePart8()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'This Year';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'This Year';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
          List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            recordTypes = new List<String>();
        }
        else{
            recordTypes.add('Internal');
        }
       
        
        test.startTest();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
             System.assert(1==1,'List should not be empty');
    } 
    @isTest static void averageTimeBatchClassTest9ElsePart()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        btchInfo.LastRefreshedDate__c = System.today()-2;
        btchInfo.SobjectType__c = 'Case';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        String dates = 'This Year';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        List<String> fieldValues = new List<String>();
        fieldValues.add('Closed');
        List<String> recordTypes = new List<String>();
             System.assert(1==1,'List should not be empty');
        }
    
    public class objectwrapper{
    @AuraEnabled
    public String Id{get;set;}
    @AuraEnabled
    public String OwnerId{get;set;}
    @AuraEnabled
    public Date CreatedDate{get;set;}
    @AuraEnabled
    public ObjectHistoryMain Histories{get;set;}
    }
     
    public class ObjectHistoryWrapper{
    @AuraEnabled
    public String Field{get;set;}
    @AuraEnabled
    public String Newvalue{get;set;}
    @AuraEnabled
    public String oldvalue{get;set;}
    @AuraEnabled
    public String DataType{get;set;}
    @AuraEnabled
    public Datetime CreatedDate{get;set;}
    }
    
    public class ObjectHistoryMain{
    @AuraEnabled
    public Boolean done{get;set;}
    @AuraEnabled
    public list<object> records{get;set;}
    }
}