public with sharing class ObjectPicklistController
{
    static Map<String, SObjectType> objects = Schema.getGlobalDescribe();
    @AuraEnabled
    public static List<String> getObject(String searchObject)
    {
        List<String> stdObjectNames = new List<String>();
        String objectName = '';
        Map<String, Schema.SObjectType> gd =  Schema.getGlobalDescribe(); 
            //Loop through all the sObject types returned by Schema
            for(Schema.SObjectType stype: gd.values())
            {
                String sobjName = String.valueOf(stype).toLowerCase();
                if (!sobjName.contains('__c')) 
                {
                     if(sobjName.contains(searchObject.toLowerCase()))
                     {
                        stdObjectNames.add(sobjName);
                     }
                }
            }
       
        return stdObjectNames;
    }
    @AuraEnabled
    public static List<String> getPicklistFields(String sobjectValue) 
    {
        List<String> listobjvalues=new List<String>();
        sObjectType objType1 = Schema.getGlobalDescribe().get(sobjectValue);
        List<FieldDefinition> f1 = [SELECT label,QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName =:sobjectValue AND IsFieldHistoryTracked = true];
        Map<String,Schema.SObjectField> mfields = objType1.getDescribe().fields.getMap();
        for(FieldDefinition key : f1)
        {
            String sobjectname = sobjectValue; //object api name
            String fieldapiName = key.QualifiedApiName; //Field api name
            String fieldTypeName = Schema.getGlobalDescribe().get(sobjectname).getDescribe().fields.getMap().get(fieldApiName).getDescribe().getType().name().toupperCase(); 
            if(fieldTypeName=='Picklist')
            {
                if(fieldapiName.contains('__c')){
                    listobjvalues.add(key.label);
                }
                else{
                    listobjvalues.add(key.QualifiedApiName);
                }
            }
        }
        
        return listobjvalues;
    }
    
    @AuraEnabled
    public static String[] picklistValues(String objectName, String fieldName) 
    {   
        //String fieldN;
        //Map<String, Schema.SObjectField> M_Objects_Schema_Field = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
        /*for( String a_Field_Name : M_Objects_Schema_Field.keySet() ) {
            Schema.DescribeFieldResult a_Field_Description = M_Objects_Schema_Field.get( fieldName ).getDescribe();
            System.debug('-=-=Label:' +a_Field_Description.getLabel());
            fieldN=a_Field_Description.getLabel();
            //System.debug('-=-=Name:' +a_Field_Description.getName());
        }*/
        String[] values = new String[]{};
        if(objectName <> null){
                String[] types = new String[]{objectName};
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
                for(Schema.DescribeSobjectResult res : results) 
                {
                    for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) 
                    {
                        if (entry.isActive()) {values.add(entry.getValue());}
                    }
                }
                
            }
        return values;
    }
    
    @AuraEnabled
    public static List<String> getRecordType(String objectName)
    {
        List<String> strRecord = new list<String>();
        List <Sobject> strRecord1 =[SELECT name FROM RecordType where SobjectType=:objectName];
        if(!strRecord1.isEmpty()||strRecord1!=null){
            for(Sobject r:strRecord1)
            { 
                strRecord.add(String.valueOf(r.get('Name')));
            }
        }
        return strRecord;
    }
    
    @AuraEnabled
    public static List <BusinessHours> getBusinessHours() 
    {
        return [SELECT Id,Name,IsDefault FROM BusinessHours LIMIT 50000];
    }
    
    @AuraEnabled
    public static List <String> getTimeZoneId(String name)
    {
            List<Id> allOpts = new list<Id>();
            List<BusinessHours> businessHrs=[SELECT Id,Name FROM BusinessHours WHERE Name=:name];
            for(BusinessHours bhrs:businessHrs)
            {
                allOpts.add(bhrs.Id);
            }
            system.debug('allOpts > ' + allOpts);
            return allOpts;
        } 
    
    @AuraEnabled
    public static List<BusinessHours> getHourVal()
    {
        List<BusinessHours> businessStr =[SELECT name FROM BusinessHours];
        return businessStr;
    }
}