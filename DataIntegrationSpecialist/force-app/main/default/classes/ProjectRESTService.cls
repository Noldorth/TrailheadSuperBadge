@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    //Implement service logic here
    @HttpPost
    global static String postProjectData(String projectRef, String projectName, String opportunityId,
                                    Date startDate, Date endDate, Double amount, String status) {

        String responseMessage = 'OK';
        Savepoint spt = Database.setSavepoint();
        try {
            Project__c prj = new Project__c(Name=projectName, Opportunity__c=opportunityId, ProjectRef__c=projectRef,
                                        Start_Date__c=startDate,End_Date__c=endDate, Billable_Amount__c=amount,
                                        Status__c=status);
            upsert prj;


            Opportunity opp = new Opportunity(Id=opportunityId);

            opp.DeliveryInstallationStatus__c = 'In progress';

            update opp;
        } catch (Exception e) {
            responseMessage = e.getMessage();
        }

        if(responseMessage != 'OK') {
            DataBase.rollback(spt);
        }

        return responseMessage;
    }
}