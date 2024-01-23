trigger JobAppTrigger on Opportunity (after update) {
     //this is basic trigger setup
     if (Trigger.isAfter && Trigger.isUpdate) {
        //create usecase
        JobAppTriggerHandler.taskAfterUpdate(Trigger.new, Trigger.oldMap);        
    }   
}