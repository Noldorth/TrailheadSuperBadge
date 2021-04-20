@IsTest
global class ProjectCalloutServiceMockFailure implements HttpCalloutMock {

   global HTTPResponse respond(HTTPRequest req) {
       HttpResponse resp = new HttpResponse();
       resp.setStatusCode(500);
       resp.setStatus('Error');
       resp.setHeader('Content-Type', 'application/json');
   
       return resp;
   }
}