@istest
public class ObjectPicklistControllertesttest
{
    @istest
    public static void ObjectPicklistControllertesttest2()
    {
	    id BusinessHourid =[select id from BusinessHours where name = 'Default' Limit 1][0].id;
        
        ObjectPicklistController.getPicklistFields('Case');
        ObjectPicklistController.picklistValues('Case','Status');
        ObjectPicklistController.getRecordType('Case');
        ObjectPicklistController.getObject('test665ff__c');
        ObjectPicklistController.getBusinessHours();
        ObjectPicklistController.getTimeZoneId('Default');
        ObjectPicklistController.getTimeZoneId('');
        ObjectPicklistController.getHourVal();
        ObjectPicklistController.getObject('Case');
        System.assert(!BusinessHourid.equals(null),'List should not be empty');
           
    }

}