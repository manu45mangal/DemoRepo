/**
 * Created by mmangal on 03.11.25.
 *
 * @description
 * Utility class that sending REST API responses.
 */
public with sharing class RestResponseUtil {

    /**
         * Sends a success response
         *
         * @param res   RestResponse object.
         * @param data  Response Body.
         * @param code  Response status code (Ex- 200).
         */
    public static void sendSuccess(RestResponse res, Object data, Integer code) {
        res.statusCode = code;
        res.addHeader('Content-Type', 'application/json');
        // Send Response in serialized form
        res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, Object>{
                'status' => 'success',
                'data' => data
        }));
    }

    /**
     * Sends an Error response
     *
        * @param res   RestResponse object.
         * @param message  Response Message.
         * @param code  Response status code (Ex - 400).
     */
    public static void sendError(RestResponse res, Integer code, String message) {
        res.statusCode = code;
        res.addHeader('Content-Type', 'application/json');
        res.responseBody = Blob.valueOf(JSON.serialize(new Map<String, Object>{
                'status' => 'error',
                'errorCode' => code,
                'message' => message
        }));
    }
}
