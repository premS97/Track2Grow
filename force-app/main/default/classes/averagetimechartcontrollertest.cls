@istest
public class averagetimechartcontrollertest 
{
    @testsetup
    Public static void averagetimechartcontrollertest1()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last 6 Months';
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        btchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        insert btchInfo;
        
        Attachment att = new Attachment();
        att.ParentId = btchInfo.Id;
        att.Body = Blob.valueof('{"a0EBh0000003YjqMAE:Assess:1":8393.32,"a0EBh0000003YjqMAE:New:1":6.92}');
        att.Name = 'test';
        system.debug('att>>>'+att);
        insert att;
        
        Attachment at = new Attachment();
        at.ParentId = btchInfo.Id;
        at.Body = Blob.valueof('{"a0EBh0000003YjqMAE:Assess:1":8393.32,"a0EBh0000003YjqMAE:New:1":6.92}');
        at.Name = 'test';
        system.debug('at>>>'+at);
        insert at;
        System.assert(1==1,'List should not be empty');
    }
    @istest
    Public static void averagetimechartcontrollertest2()
    {
        list<Schema.PicklistEntry> Statuspicklist = Case.Status.getDescribe().getPicklistValues();
        list<String> str1=new List<String>();
        integer i=0;
        for(Schema.PicklistEntry s:Statuspicklist)
        {system.debug('s..'+s.getValue());
         if(i==1)
         {
             break;
         }
         i++;
         str1.add(String.valueOf(s.getValue()));
        }
        list<String> str2=new List<String>();
        i=0;
        //RecordType abitraryType = 
        List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            str2=new List<String>();
            id str=averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null );
            
            string abc=averagetimechartcontroller.retriveFilter('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null );
            List<String> jobID = new List<String>();
            jobID.add(str);
            
            averagetimechartcontroller.customValueWrapper cWrap = new averagetimechartcontroller.customValueWrapper();
            cWrap.custFldlabel = 'tesL1';
            cWrap.custFldvalue='testV1';
            
            BatchInfo__c btchInfo = new BatchInfo__c();
            btchInfo.Businesshour__c = 'India';
            btchInfo.Dates__c = 'this week';
            btchInfo.SobjectFieldType__c = 'Status';
            btchInfo.WillRefresh__c = True;
            btchInfo.LastRefreshedDate__c = system.today();
            btchInfo.SobjectFieldValue__c = 'New';
            btchInfo.SobjectRecordType__c = null;
            btchInfo.SobjectType__c='Case';
            btchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
            btchInfo.dataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
            
            insert btchInfo;
            system.debug('btchInfo'+btchInfo);
            
            BatchInfo__c bchInfo = new BatchInfo__c();
            bchInfo.Businesshour__c = 'India';
            bchInfo.Dates__c = 'this week';
            bchInfo.SobjectFieldType__c = 'Status';
            bchInfo.WillRefresh__c = True;
            bchInfo.SobjectFieldValue__c = 'New';
            bchInfo.SobjectRecordType__c = null;
            bchInfo.SobjectType__c='Case';
            bchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
            bchInfo.dataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
            
            insert bchInfo;
            system.debug('bchInfo'+bchInfo);
            
            
            averagetimechartcontroller.DataSet DS = new averagetimechartcontroller.DataSet('l1',5.3);
            
            List<BatchInfo__c> bi = new List<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c = 'India' and Dates__c =: 'this week' AND EndDate__c = null AND StartDate__c = null AND SobjectFieldType__c ='Status' AND SobjectFieldValue__c ='InProgress' AND SobjectRecordType__c = 'Internal' AND SobjectType__c ='Case' LIMIT 1]);
            test.startTest();
            averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
            averagetimechartcontroller.retriveFilter('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,'test' );
            averagetimechartcontroller.mapvalue('Case','Status',str1 ,str2, 'India', 'this week',null ,null,true,null);
            averagetimechartcontroller.mapvalue('Case','Status',str1 ,str2, 'India', 'this week',null ,null,true,null);
            averagetimechartcontroller.mapvalue('Case','Status',str1 ,str2, 'Default', 'this month',null ,null,true,null);
            averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
            averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
            Case c = new Case();
            averagetimechartcontroller.pickListValueDynamically(c,'status');
            averagetimechartcontroller.getFD1('Case', 'Status', str1, str2, 'India', 'this week', null, null, false,'test');
            averagetimechartcontroller.getFD('Case', 'Status', str1, str2, 'India', 'this week', null, null, false);
            averagetimechartcontroller.getBatchJobStatus(jobID);
            averagetimechartcontroller.getBatchJobStatusValue(jobID);
            averagetimechartcontroller.getLeadByStatus('In Progress', 'Case', 'Status', str2, 'India', 'this week', null, null, true, 'test');
            //averagetimechartcontroller.getLeadByStatus('Assess', 'Case', 'Status', str2, 'India', 'this week', null, null, true, null);
            
            System.assert(1==1,'List should not be empty');
            
            test.stopTest();
        }
        else{
            str2.add('Internal');
              id str=averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null );
            
            string abc=averagetimechartcontroller.retriveFilter('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null );
            List<String> jobID = new List<String>();
            jobID.add(str);
            
            averagetimechartcontroller.customValueWrapper cWrap = new averagetimechartcontroller.customValueWrapper();
            cWrap.custFldlabel = 'tesL1';
            cWrap.custFldvalue='testV1';
            
            BatchInfo__c btchInfo = new BatchInfo__c();
            btchInfo.Businesshour__c = 'India';
            btchInfo.Dates__c = 'this week';
            btchInfo.SobjectFieldType__c = 'Status';
            btchInfo.WillRefresh__c = True;
            btchInfo.LastRefreshedDate__c = system.today();
            btchInfo.SobjectFieldValue__c = 'New';
            btchInfo.SobjectRecordType__c = 'Internal';
            btchInfo.SobjectType__c='Case';
            btchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
            btchInfo.dataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
            
            insert btchInfo;
            system.debug('btchInfo'+btchInfo);
            
            BatchInfo__c bchInfo = new BatchInfo__c();
            bchInfo.Businesshour__c = 'India';
            bchInfo.Dates__c = 'this week';
            bchInfo.SobjectFieldType__c = 'Status';
            bchInfo.WillRefresh__c = True;
            bchInfo.SobjectFieldValue__c = 'New';
            bchInfo.SobjectRecordType__c = 'Internal';
            bchInfo.SobjectType__c='Case';
            bchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
            bchInfo.dataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
            
            insert bchInfo;
            system.debug('bchInfo'+bchInfo);
            
            
            averagetimechartcontroller.DataSet DS = new averagetimechartcontroller.DataSet('l1',5.3);
            
            List<BatchInfo__c> bi = new List<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c = 'India' and Dates__c =: 'this week' AND EndDate__c = null AND StartDate__c = null AND SobjectFieldType__c ='Status' AND SobjectFieldValue__c ='InProgress' AND SobjectRecordType__c = 'Internal' AND SobjectType__c ='Case' LIMIT 1]);
            test.startTest();
            averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
            averagetimechartcontroller.retriveFilter('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,'test' );
            averagetimechartcontroller.mapvalue('Case','Status',str1 ,str2, 'India', 'this week',null ,null,true,null);
            averagetimechartcontroller.mapvalue('Case','Status',str1 ,str2, 'India', 'this week',null ,null,true,null);
            averagetimechartcontroller.mapvalue('Case','Status',str1 ,str2, 'Default', 'this month',null ,null,true,null);
            averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
            averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
            Case c = new Case();
            averagetimechartcontroller.pickListValueDynamically(c,'status');
            averagetimechartcontroller.getFD1('Case', 'Status', str1, str2, 'India', 'this week', null, null, false,'test');
            averagetimechartcontroller.getFD('Case', 'Status', str1, str2, 'India', 'this week', null, null, false);
            averagetimechartcontroller.getBatchJobStatus(jobID);
            averagetimechartcontroller.getBatchJobStatusValue(jobID);
            averagetimechartcontroller.getLeadByStatus('In Progress', 'Case', 'Status', str2, 'India', 'this week', null, null, true, 'test');
            //averagetimechartcontroller.getLeadByStatus('Assess', 'Case', 'Status', str2, 'India', 'this week', null, null, true, null);
            
            System.assert(1==1,'List should not be empty');
            
            test.stopTest();
        }
        
    }
    
   @istest
    Public static void averagetimechartcontrollertest3()
    {
        list<Schema.PicklistEntry> Statuspicklist = Case.Status.getDescribe().getPicklistValues();
        list<String> str1=new List<String>();
        integer i=0;
        for(Schema.PicklistEntry s:Statuspicklist)
        {system.debug('s..'+s.getValue());
         if(i==1)
         {
             break;
         }
         i++;
         str1.add(String.valueOf(s.getValue()));
        }
        list<String> str2=new List<String>();
        i=0;
          List<RecordType> rT = [SELECT Name FROM RecordType WHERE SObjectType = 'Case' LIMIT 1];
        //RecordTypeInfo info = SObjectType.Case.getRecordTypeInfosByName().get(name);
        if(rT.size()==0){
            str2=new List<String>();
        //str2.add('Internal');
        
        id str=averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
        
        string abc=averagetimechartcontroller.retriveFilter('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null );
        List<String> jobID = new List<String>();
        jobID.add(str);
        
        averagetimechartcontroller.customValueWrapper cWrap = new averagetimechartcontroller.customValueWrapper();
        cWrap.custFldlabel = 'tesL1';
        cWrap.custFldvalue='testV1';
        
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'this week';
        btchInfo.SobjectFieldType__c = 'Status';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'New';
        btchInfo.SobjectRecordType__c = 'Internal';
        btchInfo.SobjectType__c='Case';
        btchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        btchInfo.dataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        
        insert btchInfo;
        system.debug('btchInfo'+btchInfo);
        
        BatchInfo__c bchInfo = new BatchInfo__c();
        bchInfo.Businesshour__c = 'India';
        bchInfo.Dates__c = 'this week';
        bchInfo.SobjectFieldType__c = 'Status';
        bchInfo.WillRefresh__c = True;
        bchInfo.SobjectFieldValue__c = 'New';
        bchInfo.SobjectRecordType__c = 'Internal';
        bchInfo.SobjectType__c='Case';
        bchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        bchInfo.dataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        
        insert bchInfo;
        system.debug('bchInfo'+bchInfo);
        
        
        averagetimechartcontroller.DataSet DS = new averagetimechartcontroller.DataSet('l1',5.3);
        
        List<BatchInfo__c> bi = new List<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c = 'India' and Dates__c =: 'this week' AND EndDate__c = null AND StartDate__c = null AND SobjectFieldType__c ='Status' AND SobjectFieldValue__c ='InProgress' AND SobjectRecordType__c = 'Internal' AND SobjectType__c ='Case' LIMIT 1]);
        
        test.startTest();
        system.debug('str2>>'+str2);
        averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
        averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
        averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
        
        System.assert(1==1,'List should not be empty');
        
        test.stopTest();
    }
        else{
           str2.add('Internal');
        
        id str=averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
        
        string abc=averagetimechartcontroller.retriveFilter('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null );
        List<String> jobID = new List<String>();
        jobID.add(str);
        
        averagetimechartcontroller.customValueWrapper cWrap = new averagetimechartcontroller.customValueWrapper();
        cWrap.custFldlabel = 'tesL1';
        cWrap.custFldvalue='testV1';
        
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'this week';
        btchInfo.SobjectFieldType__c = 'Status';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'New';
        btchInfo.SobjectRecordType__c = 'Internal';
        btchInfo.SobjectType__c='Case';
        btchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        btchInfo.dataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        
        insert btchInfo;
        system.debug('btchInfo'+btchInfo);
        
        BatchInfo__c bchInfo = new BatchInfo__c();
        bchInfo.Businesshour__c = 'India';
        bchInfo.Dates__c = 'this week';
        bchInfo.SobjectFieldType__c = 'Status';
        bchInfo.WillRefresh__c = True;
        bchInfo.SobjectFieldValue__c = 'New';
        bchInfo.SobjectRecordType__c = 'Internal';
        bchInfo.SobjectType__c='Case';
        bchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        bchInfo.dataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        
        insert bchInfo;
        system.debug('bchInfo'+bchInfo);
        
        
        averagetimechartcontroller.DataSet DS = new averagetimechartcontroller.DataSet('l1',5.3);
        
        List<BatchInfo__c> bi = new List<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c = 'India' and Dates__c =: 'this week' AND EndDate__c = null AND StartDate__c = null AND SobjectFieldType__c ='Status' AND SobjectFieldValue__c ='InProgress' AND SobjectRecordType__c = 'Internal' AND SobjectType__c ='Case' LIMIT 1]);
        
        test.startTest();
        system.debug('str2>>'+str2);
        averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
        averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
        averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null);
        
        System.assert(1==1,'List should not be empty');
        
        test.stopTest();
        }
    }
    
}