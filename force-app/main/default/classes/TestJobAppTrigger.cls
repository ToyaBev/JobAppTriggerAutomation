/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestJobAppTrigger {

    @isTest
    static void testTaskCreation() {
        // Create a test opportunity with an old status
        Opportunity oldOpportunity = new Opportunity(
            Name = 'Old Opportunity',
            CloseDate = Date.today() - 5,
            StageName = 'Prospecting',
            Status__c = 'Applying',
            OwnerId = UserInfo.getUserId()
        );
        insert oldOpportunity;

        // Create a test opportunity with a new status
        Opportunity newOpportunity = new Opportunity(
            Name = 'New Opportunity',
            CloseDate = Date.today() + 5,
            StageName = 'Negotiation',
            Status__c = 'Interviewing',
            OwnerId = UserInfo.getUserId()
        );
        insert newOpportunity;

        // Call the logic manually to simulate a status change
        Test.startTest();
        List<Task> tasksList = new List<Task>();
        if (newOpportunity.Status__c != oldOpportunity.Status__c) {
            Task newTask = new Task();
            newTask.Subject = 'Updated Application';
            newTask.ActivityDate = Date.today();
            newTask.Priority = 'Low';
            newTask.OwnerId = newOpportunity.OwnerId;
            newTask.Description = 'Application status updated to:' + newOpportunity.Status__c;
            newTask.WhatId = newOpportunity.Id;
            tasksList.add(newTask);
        }
        Test.stopTest();

        // Verify that a task was created
        List<Task> tasks = [SELECT Id FROM Task WHERE WhatId = :newOpportunity.Id];
        System.assertEquals(1, tasks.size(), 'Expected one task to be created');
      
    }
}