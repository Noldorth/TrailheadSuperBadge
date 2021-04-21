public class BillingCalloutService {

    @future(callout=true)
    public static void callBillingService(List<Id> projectsId) {

        List<Project__c> pjrs = [SELECT Id, ProjectRef__c, Billable_Amount__c, Status__c FROM Project__c WHERE Id IN :projectsId AND Status__c='Billable'];

        List<Project__c> pjrsToUpdate = new List<Project__c>();
        //gets the custom settings values.
        ServiceCredentials__c servCredential = ServiceCredentials__c.getValues('BillingServiceCredential');
        //creating the project object to be passed in argument below.
        for(Project__c pjr : pjrs) {
            BillingServiceProxy.project project = new BillingServiceProxy.project();
            project.username = servCredential.Username__c;
            project.password = servCredential.Password__c;
            project.projectid = pjr.ProjectRef__c;
            project.billAmount = pjr.Billable_Amount__c;

            BillingServiceProxy.InvoicesPortSoap11 invCall = new BillingServiceProxy.InvoicesPortSoap11();
            String response = invCall.billProject(project);

            if(response != null && response == 'OK') {
                pjrsToUpdate.add(new Project__c(Id=pjr.Id, Status__c='Billed'));
            }
            
        }

        update pjrsToUpdate;
        


    }
   
}