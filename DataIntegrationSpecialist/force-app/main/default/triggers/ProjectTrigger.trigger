trigger ProjectTrigger on Project__c (after update) {
    if(Trigger.isAfter) {
        if(Trigger.isUpdate) {
            List<Id> prjsId = new List<Id>();
            for(Project__c prj : Trigger.new) {
                prjsId.add(prj.Id);
            }
            BillingCalloutService.callBillingService(prjsId);
        }
    }
}