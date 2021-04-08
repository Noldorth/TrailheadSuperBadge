@isTest
global class WarehouseCalloutServiceMock implements HttpCalloutMock {
    protected Integer code;
    protected String status;
    protected String bodyAsString;
    protected Map<String, String> responseHeaders;

    public WarehouseCalloutServiceMock(Integer code, String status, String bodyAsString, Map<String, String> responseHeaders) {
        this.code = code;
        this.status = status;
        this.bodyAsString = bodyAsString;
        this.responseHeaders = responseHeaders;    
    }

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse resp = new HttpResponse();
        resp.setStatusCode(this.code);
        resp.setStatus(this.status);
        resp.setBody(this.bodyAsString);
    
        
        if (this.responseHeaders != null) {
             for (String key : this.responseHeaders.keySet()) {
                resp.setHeader(key, this.responseHeaders.get(key));
             }
        }
        return resp;
    }
}