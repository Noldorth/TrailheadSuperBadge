public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod
	public static void postOpportunityToPMS(List<Id> oppsId) {
        System.debug(oppsId);

        Opportunity opp = [SELECT Id ,Name, Account.Name, CloseDate, Amount FROM Opportunity WHERE Id = : oppsId[0]];

        String token = ServiceTokens__c.getValues('ProjectServiceToken').Token__c;

        String requestBody = '{'
            +'"opportunityId": "'+opp.Id+'",'
            +'"opportunityName": "'+opp.Name+'",'
            +'"accountName": "'+opp.Account.Name+'",'
            +'"closeDate": "'+opp.CloseDate+'",'
            +'"amount": '+opp.Amount+'}';
          
        System.enqueueJob(new QueueablePMSCall(token, requestBody, opp.Id));
    }

    private class QueueablePMSCall implements Queueable, Database.AllowsCallouts {
        private String body;
        private String token;
        private String oppId;

        public QueueablePMSCall(String token,  String body, String oppId) {
            this.token = token;
            this.body = body;
            this.oppId = oppId;
        }

        public void execute(QueueableContext context) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:ProjectService');
            request.setMethod('POST');

            request.setHeader('token', this.token);
            request.setHeader('Content-Type', 'application/json;charset=UTF-8');
            
            request.setBody(this.body); 

            HttpResponse response = http.send(request); 

            Opportunity opp = new Opportunity(Id = this.oppId);

            if(response.getStatusCode() == 201) {
                opp.StageName = 'Submitted Project';
            } else {
                opp.StageName = 'Resubmit Project';
            }
            
            update opp;
            
        }
    }
}