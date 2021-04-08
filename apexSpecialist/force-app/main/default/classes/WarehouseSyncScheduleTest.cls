@isTest
public class WarehouseSyncScheduleTest {
    @IsTest
    static void test(){

        String CRON_EXP = '0 0 23 * * ?'; 

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
        
        Test.startTest();
        
        WarehouseSyncSchedule test1 = new WarehouseSyncSchedule();       
        system.schedule('Test Sched', CRON_EXP, test1);
        Test.stopTest();

        List<Product2> result = [SELECT Id, Name FROM Product2 WHERE Name = 'UPS 2000 VA' OR Name = 'Fuse 8A'];

        System.assertEquals(2, result.size());
    }
}