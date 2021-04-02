public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';




    public static void runWarehouseEquipmentSync() {
        System.enqueueJob(new RequestHttp(WAREHOUSE_URL));
    }


    private class RequestHttp implements Queueable, Database.AllowsCallouts {
        private String url;

        public RequestHttp(String url) {
            this.url = url;
        }

        public void execute(QueueableContext context) {
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setEndpoint(this.url);
            request.setMethod('GET'); 
            HttpResponse response = http.send(request); //Exécution la requête

            if(response.getStatusCode() == 200)
            {
                List<Product2> results = responseProcessing(response); //get list of products from Http callout response

                if(results.size() > 0) {
                    upsert results Warehouse_SKU__c;
                }
            
            }
            
        }
    }

    public static List<Product2> responseProcessing(HttpResponse response) {
        List<Object> externalProducts = (List<Object>) JSON.deserializeUntyped(response.getBody()); //desrialize the json response
            List<Product2> newProducts = new List<Product2>();
            
            for(Object p : externalProducts)
            {
                Map<String, Object> productMap = (Map<String, Object>) p;
                Product2 pr = new Product2();
            	//Map the fields in the response to the appropriate fields in the Equipment object
                pr.Replacement_Part__c = (Boolean)productMap.get('replacement');
                pr.Cost__c = (Integer)productMap.get('cost');
                pr.Current_Inventory__c = (Integer)productMap.get('quantity');
                pr.Lifespan_Months__c = (Integer)productMap.get('lifespan') ;
                pr.Maintenance_Cycle__c = (Integer)productMap.get('maintenanceperiod');
                pr.Warehouse_SKU__c = (String)productMap.get('sku');
                pr.ProductCode = (String)productMap.get('_id');
                pr.Name = (String)productMap.get('name');
                
            
                newProducts.add(pr);
            }

            return newProducts;
    }   
}

