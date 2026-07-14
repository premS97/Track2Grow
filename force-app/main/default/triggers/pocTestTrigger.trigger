trigger pocTestTrigger on Case (after insert, after update) {
    
    List<testPOC__c> testPocInsertRecs = new List<testPOC__c>();
    //List<sObject> recData = new List<sObject>();
    List<String> allObjFields = new List<String>();
    List<String> updatedFields = new List<String>();
    List<Attachment> insertJson = new List<Attachment>(); 
    List<Attachment> tempJson = new List<Attachment>(); 
    Set<Id> recIdsIns = new Set<Id>();
    Set<Id> recIds = new Set<Id>();
    Map<string,Map<String,Object>> finalJson = new Map<string,Map<String,Object>>();
    String combinedJson;
    String allUpdatedJson;
    Map<String,Object> newJson = new Map<String,Object>();
    Map<String,Object> oldJson = new Map<String,Object>();
    Map<string,Object> dataIdMap = new Map<string,Object>();
    String Obj = 'Case';
    
    system.debug('in trigger');
    
    if(trigger.isafter && trigger.isinsert)
    {
        system.debug('after update');
        for(sObject rec : Trigger.new)
          {  
            recIdsIns.add(rec.Id);
          }
        
        String query = 'SELECT Id, CreatedBy.Name,CreatedDate,LastModifiedDate FROM '+Obj+ ' WHERE Id IN :recIdsIns';
            
        List<sObject> objList = Database.query(query);
        system.debug('objList..'+objList);
        
        for(sObject rec : objList)
        {      
               testPOC__c insRec = new testPOC__c();
               insRec.Object_Name__c = Obj;
               insRec.recID__c = rec.Id;
               testPocInsertRecs.add(insRec);
               
               dataIdMap.put('Field', 'Created');
               dataIdMap.put('Date/Time', rec.get('LastModifiedDate'));    
               dataIdMap.put('User', rec.getsObject('CreatedBy').get('Name'));
               dataIdMap.put('OldValue', null);
               dataIdMap.put('NewValue', null);
               
               finalJson.put(rec.Id, dataIdMap);
        }
         system.debug('finalJson..'+finalJson);
         insert testPocInsertRecs;
        
         for(testPOC__c rec : testPocInsertRecs)
           {
               Attachment jsonfile = new Attachment();
                if (Schema.sObjectType.Attachment.fields.ParentId.isCreateable())
                {
                    jsonfile.ParentId = rec.ID;
                }
                if (Schema.sObjectType.Attachment.fields.Name.isCreateable())
                {
                    jsonfile.Name = 'testAttachment';
                }
               if (Schema.sObjectType.Attachment.fields.ContentType.isCreateable())
                {
                    jsonfile.ContentType = 'text/plain';
                }
                if (Schema.sObjectType.Attachment.fields.Body.isCreateable())
                {
                    jsonfile.Body = Blob.valueOf(JSON.serialize(finalJson));
                }
                if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable()){
                    insertJson.add(jsonfile);
                }               
           }
        system.debug('insertJson...'+insertJson);
        insert insertJson;
    }
    
    
    if(trigger.isafter && trigger.isupdate)        
    {
        system.debug('in after update');
       
        allObjFields = customHistoryComponentController.getFields(Obj);
        system.debug('allObjFields..'+allObjFields);
        
        for(sObject rec : Trigger.new)
           {
               recIds.add(rec.Id);
               sObject oldRec = Trigger.oldMap.get(rec.ID);
               
               for(String fieldName : allObjFields)
               {
                   if(fieldName != 'LastModifiedDate' && fieldName != 'SystemModstamp')
                   {  
                   if(rec.get(fieldName) != oldRec.get(fieldName))
                   {
                      updatedFields.add(fieldName);
                   }
                   } 
               }
               system.debug('updatedFields..'+updatedFields);
           }
        
        
        String query = 'SELECT Id,CreatedById, CreatedBy.Name,CreatedDate,LastModifiedDate ';
        
        
        for(String updField : updatedFields)
        {
            query = query + ',' +updField;
        }
        
        query = query + ' FROM '+ Obj + ' WHERE Id IN :recIds';
        
        system.debug('query..'+query);
        
        List<sObject> objList = Database.query(query);
        
        system.debug('objList..'+objList);
        
        
        //List<Case> objList = [SELECT Id, CreatedBy.Name,CreatedDate,LastModifiedDate FROM Case WHERE Id IN :Trigger.new];
        
        for(sObject rec : objList)
        {
            sObject oldRec = Trigger.oldMap.get(rec.ID);
              
            for(String updField : updatedFields)
            {
               dataIdMap.put('Field', updField);            
               dataIdMap.put('Date/Time', rec.get('LastModifiedDate'));    
               dataIdMap.put('User', rec.getsObject('CreatedBy').get('Name'));
               dataIdMap.put('OldValue', oldRec.get(updField));
               dataIdMap.put('NewValue', rec.get(updField));
               system.debug('dataIdMap..'+dataIdMap);
               if(allUpdatedJson == null)
               {
                   allUpdatedJson = dataIdMap.toString();
               }
                else
               {   
                   allUpdatedJson = allUpdatedJson + ',' + dataIdMap.toString();
               }
               newJson.put(rec.Id, allUpdatedJson);
            }
        }
        system.debug('dataIdMap..'+dataIdMap);
        system.debug('newJson..'+newJson);
        
        List<testPOC__c> testPocRecs = [Select id, Name, Object_Name__c,recID__c From testPOC__c Where recID__c in : recIds];
        system.debug('testPocRecs>>'+testPocRecs);
        List<testPOC__c> InsRecsList = new List<testPOC__c>();
        if(testPocRecs == null || testPocRecs.isEmpty())
        {
            for(sObject rec : objList)
            {    
                system.debug('rec not found');
                testPOC__c insRec = new testPOC__c();
                insRec.Object_Name__c = Obj;
                insRec.recID__c = rec.Id;
                InsRecsList.add(insRec);
            }
            
            Insert InsRecsList;
            
            for(testPOC__c rec : InsRecsList)
           {
                Attachment jsonfile = new Attachment();
                if (Schema.sObjectType.Attachment.fields.ParentId.isCreateable())
                {
                    jsonfile.ParentId = rec.Id;
                }
                if (Schema.sObjectType.Attachment.fields.Name.isCreateable())
                {
                    jsonfile.Name = 'testAttachment';
                }
               if (Schema.sObjectType.Attachment.fields.ContentType.isCreateable())
                {
                    jsonfile.ContentType = 'text/plain';
                }
               if (Schema.sObjectType.Attachment.fields.Body.isCreateable())
                {
                    jsonfile.Body = Blob.valueOf(JSON.serialize(newJson));
                }
                if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable())
                {
                    tempJson.add(jsonfile);
                }
               Insert jsonfile;
           }
        }
      
        else if(testPocRecs != null && !testPocRecs.isEmpty())
        {   
        for(testPOC__c rec : testPocRecs)            
        {
            Attachment jsonfile = new Attachment();
            for(Attachment a : [SELECT Id,Body, Name FROM Attachment Where ParentId =: rec.Id])
               { 
                   system.debug('Body..'+a.Body.toString());
                   system.debug('Id..'+a.Id);
                   jsonfile.Id = a.ID;
                   oldJson = (Map<String,Object>)JSON.deserializeUntyped(a.Body.toString());
                   system.debug('oldJson..'+oldJson);
                   system.debug('oldJson.. value'+oldJson.get(rec.recID__c));
                   system.debug('newJson.. value'+newJson.get(rec.recID__c));
                   combinedJson = oldJson.get(rec.recID__c).toString() +','+ newJson.get(rec.recID__c).toString();
                   system.debug('combinedJson...'+combinedJson);
                   newJson.put(rec.recID__c, combinedJson);
               }
                system.debug('newJson..'+newJson);
                if (Schema.sObjectType.Attachment.fields.Name.isCreateable())
                {
                    jsonfile.Name = 'testAttachment';
                }
               if (Schema.sObjectType.Attachment.fields.ContentType.isCreateable())
                {
                    jsonfile.ContentType = 'text/plain';
                }
                if (Schema.sObjectType.Attachment.fields.Body.isCreateable())
                {
                    jsonfile.Body = Blob.valueOf(JSON.serialize(newJson));
                }
                if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable())
                {
                    insertJson.add(jsonfile);
                }  
        }
        system.debug('insertJson update'+insertJson);
        update insertJson;
    }
    }
}