@IsTest
global class ProjectCalloutServiceMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(201);
        resp.setStatus('OK');
        resp.setHeader('Content-Type', 'application/json');
    
        return resp;
    }
}