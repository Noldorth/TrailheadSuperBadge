@IsTest
private class WarehouseCalloutServiceTest {
    // implement your mock callout test here



    @isTest static void responseProcessingTest() {
        String body = '['
            +'{'
            +'    "_id": "55d66226726b611100aaf73f",'
            +'    "replacement": false,'
            +'    "quantity": 10,'
            +'    "name": "UPS 2000 VA",'
            +'    "maintenanceperiod": 180,'
            +'    "lifespan": 60,'
            +'    "cost": 1350,'
            +'    "sku": "100001"'
            +'},'
            +'{'
            +'    "_id": "55d66226726b611100aaf740",'
            +'    "replacement": true,'
            +'    "quantity": 194,'
            +'    "name": "Fuse 8A",'
            +'    "maintenanceperiod": 0,'
            +'    "lifespan": 0,'
            +'    "cost": 5,'
            +'    "sku": "100002"'
            +'}'
        +']';

        HttpResponse response = new HttpResponse();
        response.setBody(body);

        Test.startTest();
            List<product2> result =  WarehouseCalloutService.responseProcessing(response);
        Test.stopTest();

        System.assertEquals(2, result.size());
    }


    @isTest static void runWarehouseEquipmentSync() {
        Map<String, String> mockHeader = new Map<String, String>();
        mockHeader.put('Content-Type', 'application/json');
        String body = '['
            +'{'
            +'    "_id": "55d66226726b611100aaf73f",'
            +'    "replacement": false,'
            +'    "quantity": 10,'
            +'    "name": "UPS 2000 VA",'
            +'    "maintenanceperiod": 180,'
            +'    "lifespan": 60,'
            +'    "cost": 1350,'
            +'    "sku": "100001"'
            +'},'
            +'{'
            +'    "_id": "55d66226726b611100aaf740",'
            +'    "replacement": true,'
            +'    "quantity": 194,'
            +'    "name": "Fuse 8A",'
            +'    "maintenanceperiod": 0,'
            +'    "lifespan": 0,'
            +'    "cost": 5,'
            +'    "sku": "100002"'
            +'}'
        +']';

        WarehouseCalloutServiceMock httpMock = new WarehouseCalloutServiceMock(200, 'OK', body, mockHeader);
        Test.setMock(HttpCalloutMock.class, httpMock);

        String urlTest = 'https://th-superbadge-apex.herokuapp.com/equipment';
        Map<String,String> testheader = new Map<String,String>();
        
        testheader.put('Content-Type', 'text/json;charset=UTF-8');

        Test.startTest();
            WarehouseCalloutService.runWarehouseEquipmentSync();
        Test.stopTest();


    }
}