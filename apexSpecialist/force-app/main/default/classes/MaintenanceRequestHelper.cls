public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> caseList) {

        List<Case> newCases = new List<Case>();

        Map<String,Integer> result = getDueDate(caseList);
        for(Case c : caseList) {
            if(c.Status == 'Closed') {
                if(c.Type == 'Repair' || c.Type =='Routine Maintenance') {
                    Case newCase = new Case();

                    newCase.Type = 'Routine Maintenance';
                    newCase.Vehicle__c = c.Vehicle__c;
                    newCase.Origin = c.Origin;
                    newCase.Status = 'New';
                    newCase.ProductId = c.ProductId;
                    newCase.Subject = 'New Routine Maintenance';
                    newCase.Old_Case_Id__c = c.Id;
                    newCase.Date_Reported__c = Date.today();
                    if(result.get(c.Id) != null) {
                        newCase.Date_Due__c = Date.today() + result.get(c.Id);
                    } else {
                        newCase.Date_Due__c = Date.today();
                    }
                    newCases.add(newCase);
                }
            }
        }
        insert newCases;

        List<Equipment_Maintenance_Item__c> tmpItems = new List<Equipment_Maintenance_Item__c>();
        List<Equipment_Maintenance_Item__c> oldItems = [SELECT Maintenance_Request__c, Id, Equipment__c FROM Equipment_Maintenance_Item__c];

        for(Case c : newCases) {
            tmpItems.addAll(getMaintenanceItemModify(c, oldItems));
        }

        insert tmpItems;
        
    }



    public static List<Equipment_Maintenance_Item__c> getMaintenanceItemModify(Case c, List<Equipment_Maintenance_Item__c> oldItems) {
        
        List<Equipment_Maintenance_Item__c> tmpItems = new List<Equipment_Maintenance_Item__c>();

        for(Equipment_Maintenance_Item__c item : oldItems) {
            if(item.Maintenance_Request__c == c.Old_Case_Id__c) {
                tmpItems.add(new Equipment_Maintenance_Item__c(Maintenance_Request__c = c.Id, Equipment__c=item.Equipment__c));
            }
        }
        return tmpItems;
    }

     
    
    public static  Map<String,Integer> getDueDate(List<case> cases){       
        Map<String,Integer> result = new Map<String,Integer>();

        Map<Id,Case> caseIds = new Map<Id,Case>(cases);

        List<AggregateResult> maintenanceResult = [SELECT Maintenance_Request__r.Id mrId,
                         min(Equipment__r.Maintenance_Cycle__c) eqCycle 
                    FROM Equipment_Maintenance_Item__c
                    WHERE  Maintenance_Request__r.Id IN :caseIds.keySet()
                    GROUP BY Maintenance_Request__r.Id];
        for(AggregateResult agr : maintenanceResult) {
            Integer addDay = 0;
            if(agr.get('eqCycle') != null) {
                addDay = Integer.valueOf(agr.get('eqCycle'));
            }
            result.put((String) agr.get('mrId') , addDay);
        }
        return result;
    }
    
}
