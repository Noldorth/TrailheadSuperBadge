@isTest
public class MaintenanceRequestHelperTest {

    @TestSetup
    static void makeData(){
        
    }


    
   

    @isTest static void getMaintenanceItemModifyTest() {
        
        Case oldCase1 = new Case();
        Case oldCase2 = new Case();

        List<Case> cases = new List<Case>();

        cases.add(oldCase1);
        cases.add(oldCase2);
        
        insert cases;

        Case newCase = new Case(Old_Case_Id__c = cases[0].Id);

        insert newCase;

        Product2 pr = new Product2(Name='TestPR');

        insert pr;

        System.debug(cases);

        List<Equipment_Maintenance_Item__c> listEq = new List<Equipment_Maintenance_Item__c>();
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[0].Id, Equipment__c=pr.Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[0].Id, Equipment__c=pr.Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[0].Id, Equipment__c=pr.Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[1].Id, Equipment__c=pr.Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[1].Id, Equipment__c=pr.Id));
        

        Test.startTest();
            List<Equipment_Maintenance_Item__c> results = MaintenanceRequestHelper.getMaintenanceItemModify(newCase ,listEq);
        Test.stopTest();


        System.assertEquals(3, results.size());

        for(Equipment_Maintenance_Item__c item : results) {
            System.assertEquals(newCase.Id, item.Maintenance_Request__c);
        }
    }

    @isTest static void getDueDateTest() {

        Case oldCase1 = new Case();
        Case oldCase2 = new Case();

        List<Case> cases = new List<Case>();

        cases.add(oldCase1);
        cases.add(oldCase2);
        
        insert cases;

        List<Product2> prs = new List<Product2>();

        prs.add(new Product2(Name='TestPR1', Maintenance_Cycle__c=10, Replacement_Part__c =true));
        prs.add(new Product2(Name='TestPR2', Maintenance_Cycle__c=20, Replacement_Part__c =true));
        prs.add(new Product2(Name='TestPR3', Maintenance_Cycle__c=30, Replacement_Part__c =true));
        prs.add(new Product2(Name='TestPR4', Maintenance_Cycle__c=40, Replacement_Part__c =true));
        prs.add(new Product2(Name='TestPR5', Maintenance_Cycle__c=50, Replacement_Part__c =true));

        insert prs;

        

        List<Equipment_Maintenance_Item__c> listEq = new List<Equipment_Maintenance_Item__c>();
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[0].Id, Equipment__c=prs[0].Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[0].Id, Equipment__c=prs[1].Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[0].Id, Equipment__c=prs[2].Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[1].Id, Equipment__c=prs[3].Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[1].Id, Equipment__c=prs[4].Id));

        insert listEq;

        Test.startTest();
            Map<String,Integer> result = MaintenanceRequestHelper.getDueDate(cases);
        Test.stopTest();

        System.assertEquals(true, result.containsKey(cases[0].Id));
        System.assertEquals(true, result.containsKey(cases[1].Id));

        System.assertEquals(10, result.get(cases[0].Id));

        System.assertEquals(40, result.get(cases[1].Id));

    }

    @isTest static void updateWorkOrdersTest() {

        Vehicle__c vh = new Vehicle__c();

        insert vh;

        List<Product2> prs = new List<Product2>();

        prs.add(new Product2(Name='TestPR1', Maintenance_Cycle__c=10, Replacement_Part__c =true));
        prs.add(new Product2(Name='TestPR2', Maintenance_Cycle__c=20, Replacement_Part__c =true));
        prs.add(new Product2(Name='TestPR3', Maintenance_Cycle__c=30, Replacement_Part__c =true));
        prs.add(new Product2(Name='TestPR4', Maintenance_Cycle__c=40, Replacement_Part__c =true));
        prs.add(new Product2(Name='TestPR5', Maintenance_Cycle__c=50, Replacement_Part__c =true));

        insert prs;


        Case case1 = new Case(Status = 'Closed', Type = 'Repair', Origin='WEB', ProductId = prs[0].Id, Vehicle__c = vh.Id);
        Case case2 = new Case(Status = 'Closed', Type = 'Routine Maintenance', Origin='WEB', ProductId = prs[1].Id, Vehicle__c = vh.Id);
        Case case3 = new Case(Status = 'Closed', Origin='WEB');
        Case case4 = new Case(Type = 'Repair');
        Case case5 = new Case(Type = 'Routine Maintenance');

        List<Case> cases = new List<Case>();

        cases.add(case1);
        cases.add(case2);
        cases.add(case3);
        cases.add(case4);
        cases.add(case5);
        
        insert cases;


        List<Equipment_Maintenance_Item__c> listEq = new List<Equipment_Maintenance_Item__c>();
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[0].Id, Equipment__c=prs[0].Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[0].Id, Equipment__c=prs[1].Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[3].Id, Equipment__c=prs[2].Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[3].Id, Equipment__c=prs[3].Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[2].Id, Equipment__c=prs[4].Id));

        insert listEq;


        Test.StartTest();
            MaintenanceRequestHelper.updateWorkOrders(cases);
        Test.stopTest();

        List<Case> resultCase = [SELECT Id, Type, Date_Due__c, Origin, Vehicle__c, Status, ProductId FROM Case WHERE Type = 'Routine Maintenance' AND Subject = 'New Routine Maintenance' ];

        System.assertEquals(2, resultCase.size());

        for(Case cs : resultCase) {
            System.assertEquals( 'Web', cs.Origin);
            System.assertEquals( vh.Id, cs.Vehicle__c);
        }
    }

    @isTest static void MaintenanceRequestTest() {
        Vehicle__c vh = new Vehicle__c();

        insert vh;

        List<Product2> prs = new List<Product2>();

        prs.add(new Product2(Name='TestPR1', Maintenance_Cycle__c=10, Replacement_Part__c =true));
        prs.add(new Product2(Name='TestPR2', Maintenance_Cycle__c=20, Replacement_Part__c =true));
        prs.add(new Product2(Name='TestPR3', Maintenance_Cycle__c=30, Replacement_Part__c =true));
        prs.add(new Product2(Name='TestPR4', Maintenance_Cycle__c=40, Replacement_Part__c =true));
        prs.add(new Product2(Name='TestPR5', Maintenance_Cycle__c=50, Replacement_Part__c =true));

        insert prs;


        Case case1 = new Case(Type = 'Repair', Origin='WEB', ProductId = prs[0].Id, Vehicle__c = vh.Id);
        Case case2 = new Case(Type = 'Routine Maintenance', Origin='WEB', ProductId = prs[1].Id, Vehicle__c = vh.Id);
        Case case3 = new Case(Status = 'Closed', Origin='WEB');
        Case case4 = new Case(Type = 'Repair');
        Case case5 = new Case(Type = 'Routine Maintenance');

        List<Case> cases = new List<Case>();

        cases.add(case1);
        cases.add(case2);
        cases.add(case3);
        cases.add(case4);
        cases.add(case5);
        
        insert cases;


        List<Equipment_Maintenance_Item__c> listEq = new List<Equipment_Maintenance_Item__c>();
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[0].Id, Equipment__c=prs[0].Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[0].Id, Equipment__c=prs[1].Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[3].Id, Equipment__c=prs[2].Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[3].Id, Equipment__c=prs[3].Id));
        listEq.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = cases[2].Id, Equipment__c=prs[4].Id));

        insert listEq;


        Test.StartTest();
            cases[0].Status = 'Closed';
            cases[1].Status = 'Closed';

            update cases;
        Test.stopTest();

        List<Case> resultCase = [SELECT Id, Type, Date_Due__c, Origin, Vehicle__c, Status, ProductId FROM Case WHERE Type = 'Routine Maintenance' AND Subject = 'New Routine Maintenance' ];

        System.assertEquals(2, resultCase.size());

        for(Case cs : resultCase) {
            System.assertEquals( 'Web', cs.Origin);
            System.assertEquals( vh.Id, cs.Vehicle__c);
        }
    }
}

