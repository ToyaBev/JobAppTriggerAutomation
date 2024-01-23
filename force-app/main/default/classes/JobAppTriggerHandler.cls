public with sharing class JobAppTriggerHandler {
    //create method for changed application status  
    public static void taskAfterUpdate(List<Opportunity> newApplications, Map<Id, Opportunity> oldApplications){
        List<Task> tasksList = new List<Task>();
        for (Opportunity opp : newApplications) {
            Opportunity oldOpp = oldApplications.get(opp.Id);

            if (opp.Status__c != oldOpp.Status__c) {
                //create the Task if the status do not equal                
                Task newTask = new Task();
                newTask.Subject = 'Updated Application';
                newTask.ActivityDate = Date.today(); 
                newTask.Priority = 'Low'; 
                newTask.OwnerId = opp.OwnerId;
                newTask.Description = 'Application status updated to:' + opp.Status__c;
                newTask.WhatId = opp.Id;
                //add Tasks to a list for DML operation
                tasksList.add(newTask);
            }
        }
        //this will insert the Task records into the system and associate them
        //with the opportunity by the Id
        //if (!tasksList.isEmpty()) {
           // insert tasksList;
      //  }
        
    }

    
}