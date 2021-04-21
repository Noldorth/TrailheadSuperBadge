@isTest
private class ProjectRESTServiceTest {
    @isTest static void postProjectDataTestSucess() {

        Account acc1 = new Account(Name='TestAccount1');
    
        List<Account> accs = new List<Account>();
        accs.add(acc1);
        insert accs;
    
        List<Opportunity> opps = new List<Opportunity>();
    
        opps.add(new Opportunity(Name='TestOpportunity1',
                                 AccountId=accs[0].Id,
                                 StageName='Closed Won',
                                 CloseDate = Date.newInstance(2021, 11, 1),
                                 Amount = 9500 ));
        insert opps;



        // Call the method to test
        String responseStrTest = ProjectRESTService.postProjectData(
            'TestRef', 'TestProject', opps[0].Id, Date.newInstance(2020, 10, 2),
            Date.newInstance(2021, 10, 2), 12000, 'Running');
        // Verify results
        System.assertEquals('OK', responseStrTest);

        List<Project__c> pjrs = [SELECT Name, Opportunity__c, ProjectRef__c,
                                Start_Date__c,End_Date__c, Billable_Amount__c,
                                Status__c FROM Project__c];

        System.assertEquals(1, pjrs.size());

        System.assertEquals('TestProject', pjrs[0].Name);

        Opportunity opp = [SELECT Id, DeliveryInstallationStatus__c FROM Opportunity WHERE Id =:opps[0].Id];

        System.assertEquals('In progress', opp.DeliveryInstallationStatus__c);
    }

    @isTest static void postProjectDataTestFail() {

        // Call the method to test
        String responseStrTest = ProjectRESTService.postProjectData(
            'TestRef', 'TestProject', '00909000008OvRRAA9', Date.newInstance(2020, 10, 2),
            Date.newInstance(2021, 10, 2), 12000, 'Running');
        // Verify results
        //System.assertNotEquals('OK', responseStrTest);

        List<Project__c> pjrs = [SELECT Name, Opportunity__c, ProjectRef__c,
                                Start_Date__c,End_Date__c, Billable_Amount__c,
                                Status__c FROM Project__c];

        System.assertEquals(0, pjrs.size());
        
        Test.startTest();
        List<Opportunity> opps = [SELECT Id, Name, DeliveryInstallationStatus__c FROM Opportunity WHERE Id ='00909000008OvRRAA9'];
        Test.stopTest();

        System.debug(opps);

        System.assertEquals(0, opps.size());
    }


}