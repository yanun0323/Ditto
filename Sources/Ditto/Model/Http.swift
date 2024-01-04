import Foundation

public struct Http {
    #if DEBUG
    private static var mode = Mode.debug
    #else
    private static var mode = Mode.release
    #endif
}

extension Http {
    public enum Method: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case PATCH = "PATCH"
        case DELETE = "DELETE"
    }
}

extension Http {
    public enum Mode {
        case release, debug
    }
}

extension Http {
    public enum Error {
        case errParseURL(_ method: Method, _ url: String)
        case errDownloadData(_ method: Method, _ url: String, _ msg: String)
        case errDecodeData(_ method: Method, _ url: String, _ msg: String)
        
        public var message: String {
            switch self {
                case let .errParseURL(method, url):
                return "\(method.rawValue): \(url)\n parse URL error, please check your url path"
                case let .errDownloadData(method, url, msg):
                    return "\(method.rawValue): \(url)\ndownload data error, err: \(msg)"
                case let .errDecodeData(method, url, msg):
                    return "\(method.rawValue): \(url)\ndecode json data error, err: \(msg)"
            }
        }
    }
}

extension Http.Error: Error {}

extension Http {
    private static func debug(_ message: String) {
        if Http.mode == .debug {
            print(message)
        }
    }
}

extension Http {
    /**
     Set http mode. If mode is debug, print request log in console.
    - Default Value:
     ```
     #if DEBUG
     private static var mode = Mode.debug
     #else
     private static var mode = Mode.release
     #endif
     ```
     */
    public static func setMode(_ mode: Http.Mode) {
        Http.mode = mode
    }
    
    /**
     Get http mode.
     */
    public static func getMode() -> Http.Mode {
        return Http.mode
    }
    
    /**
     Send a request and get structure response
     
     ```swift
     let url = "http://api/user"
     let (user, statusCode, err) = Http.SendRequest(.GET, toUrl: url, type: User.self, debug: false) { request in
        // do something ...
     }
     ```
     - parameters:
        - method: The http method for this request. (GET, POST, PUT, PATCH, DELETE)
        - toUrl: The url to send request.
        - action: Use this to modify request, such as set cookies, add headers or add data.
     */
    public static func sendRequest<T>(_ method: Http.Method = .GET, toUrl path: String, type: T.Type, action: @escaping (inout URLRequest) -> Void = { _ in }) -> (T?, Int?, Http.Error?) where T: Decodable {
        guard let url = URL(string: path) else {
            debug("[sendRequest: debug] failed to generate url from string: \(path)")
            return (nil, nil, .errParseURL(method, path))
        }
        
        let channel = DispatchSemaphore(value: 0)
        var result: T? = nil
        var code: Int? = nil
        var err: Http.Error? = nil
        
        var request = URLRequest(url: url, timeoutInterval: 30)
        request.httpMethod = method.rawValue
        action(&request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { channel.signal() }
            guard error == nil else {
                err = .errDownloadData(method, path, String(describing: error))
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                err = .errDownloadData(method, path, "network connection error")
                return
            }
            
            code = res.statusCode
          
            guard let data = data else {
                err = .errDownloadData(method, path, "connection timeout")
                return
            }
            
            debug("[sendRequest: debug] complete download, data length: \(data.count)")
            debug("[sendRequest: debug] data: \n\(String(decoding: data, as: UTF8.self))")
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                result = decoded
            } catch {
                debug("[sendRequest: debug] decode data error, \(String(describing: error))")
                err = .errDecodeData(method, path, String(describing: error))
            }
            
        }.resume()
        
        channel.wait()
        return (result, code, err)
    }
    
    /**
     Send a request and get string response
     
     ```swift
     let url = "http://api/user"
     let (body, statusCode, err) = Http.sendRequest(.GET, toUrl: url, type: User.self) { request in
        // do something ...
     }
     ```
     - parameters:
        - method: The http method for this request. (GET, POST, PUT, PATCH, DELETE)
        - toUrl: The url to send request.
        - ignoreBody: It won't return the body if true. It helps increasing performance to ignore the body return.
        - action: Use this to modify request, such as set cookies, add headers or add data.
     */
    public static func sendRequestForString(_ method: Method = .GET, toUrl path: String, ignoreBody: Bool = false, action: @escaping (inout URLRequest) -> Void = { _ in }) -> (String, Int?, Http.Error?) {
        guard let url = URL(string: path) else {
            debug("[sendRequest: debug] failed to generate url from string: \(path)")
            return ("", nil, .errParseURL(method, path))
        }
        
        let channel = DispatchSemaphore(value: 0)
        var result: String = ""
        var code: Int? = nil
        var err: Http.Error? = nil
        
        var request = URLRequest(url: url, timeoutInterval: 30)
        request.httpMethod = method.rawValue
        action(&request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            defer { channel.signal() }
            guard error == nil else {
                err = .errDownloadData(method, path, String(describing: error))
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                err = .errDownloadData(method, path, "network connection error")
                return
            }
            
            code = res.statusCode
            
            guard let data = data else {
                err = .errDownloadData(method, path, "connection timeout")
                return
            }
            
            debug("[sendRequest: debug] complete download, data length: \(data.count)")
            
            if !ignoreBody {
                result = String(decoding: data, as: UTF8.self)
            }
            
        }.resume()
        channel.wait()
        
        return (result, code, err)
    }
}
