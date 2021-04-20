@isTest
private class ProjectCalloutServiceTest {
  @TestSetup
  static void makeData(){

    Insert new ServiceTokens__c(Name = 'ProjectServiceToken' , Token__c='123456');
    Account acc1 = new Account(Name='TestAccount1');
    Account acc2 = new Account(Name='TestAccount2');

    List<Account> accs = new List<Account>();
    accs.add(acc1);
    accs.add(acc2);

    insert accs;

    List<Opportunity> opps = new List<Opportunity>();

    opps.add(new Opportunity(Name='TestOpportunity1',
                             AccountId=accs[0].Id,
                             StageName='Closed Won',
                             CloseDate = Date.newInstance(2021, 11, 1),
                             Amount = 9500 ));

    opps.add(new Opportunity(Name='TestOpportunity2',
                             AccountId = accs[1].Id,
                             StageName='Closed Won',
                             CloseDate = Date.newInstance(2022, 12, 2),
                             Amount = 15500 ));
    insert opps;

    System.debug(opps);
  }
  @isTest static void postOpportunityToPMSSucess() {
    ProjectCalloutServiceMock httpMockSuccess = new ProjectCalloutServiceMock();
        Test.setMock(HttpCalloutMock.class, httpMockSuccess);
    List<Id> idList = new List<Id>();
    for(Opportunity opp : [SELECT id FROM Opportunity ORDER BY Name ASC]){
      idList.add(opp.id);
    }

    Test.startTest();
      ProjectCalloutService.postOpportunityToPMS(idList);
    Test.stopTest();

    Opportunity resultOpp = [SELECT Name, StageName FROM Opportunity ORDER BY Name ASC LIMIT 1];
    System.assertEquals('Submitted Project', resultOpp.StageName);
  }
  @isTest static void postOpportunityToPMSFail() {
    ProjectCalloutServiceMockFailure httpMockFailure = new ProjectCalloutServiceMockFailure();
    Test.setMock(HttpCalloutMock.class, httpMockFailure);

    List<Id> idList = new List<Id>();
    for(Opportunity opp : [SELECT id FROM Opportunity ORDER BY Name ASC]){
      idList.add(opp.id);
    }

    Test.startTest();
      ProjectCalloutService.postOpportunityToPMS(idList);
    Test.stopTest();

    Opportunity resultOpp = [SELECT Name, StageName FROM Opportunity ORDER BY Name ASC LIMIT 1];
    System.assertEquals('Resubmit Project', resultOpp.StageName);
  }
}