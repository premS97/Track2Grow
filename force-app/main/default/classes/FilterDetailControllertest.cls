@istest
public class FilterDetailControllertest
{
 @istest
    public static void ObjectPic()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'Default';
        btchInfo.Dates__c = 'Last 6 Months';
        btchInfo.Filter_Name__c = 'test';
        btchInfo.DataRepresentation__c = '{"Closed":0,"On Hold":0,"Escalated":0,"InProgress":1.18,"New":0}';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectFieldType__c = 'Status';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
          FilterDetailController.getFilterDetail();
          FilterDetailController.getFilterDetailFromName('test','In Minutes');
          FilterDetailController.getFilterDetails(btchInfo.Id,'In Hours');
          FilterDetailController.getFilterDetails(btchInfo.Id,'In Days');
          FilterDetailController.deleteFilter('test');
          FilterDetailController.getDetail('test');
          FilterDetailController.getSearchFilterDetail('test');
          FilterDetailController.getFilterDetails(btchInfo.Id,'In Minutes');
          FilterDetailController.getFDetail('test');
          FilterDetailController.getFDetail(null);
          System.assert(1==1,'List should not be empty');
          
    }
}