import Foundation

public struct Http {}

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
    public enum Error {
        case errParseURL
        case errDownloadData(String)
        case errDecodeData(String)
        
        public var message: String {
            switch self {
                case .errParseURL:
                    return "parse URL error, please check your url path"
                case let .errDownloadData(msg):
                    return "download data error, err: \(msg)"
                case let .errDecodeData(msg):
                    return "decode json data error, err: \(msg)"
            }
        }
    }
}

extension Http.Error: Error {}

extension Http {
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
            #if DEBUG
            print("[sendRequest: debug] failed to generate url from string: \(path)")
            #endif
            return (nil, nil, .errParseURL)
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
                err = .errDownloadData(String(describing: error))
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                err = .errDownloadData("network connection error")
                return
            }
            
            code = res.statusCode
          
            guard let data = data else {
                err = .errDownloadData("connection timeout")
                return
            }
            
            #if DEBUG
                print("[sendRequest: debug] complete download, data length: \(data.count)")
                print("[sendRequest: debug] data: \n\(String(decoding: data, as: UTF8.self))")
            #endif
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                result = decoded
            } catch {
                #if DEBUG
                print("[sendRequest: debug] decode data error, \(String(describing: error))")
                #endif
                err = .errDecodeData(String(describing: error))
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
    public static func sendRequest(_ method: Method = .GET, toUrl path: String, ignoreBody: Bool = false, action: @escaping (inout URLRequest) -> Void = { _ in }) -> (String, Int?, Http.Error?) {
        guard let url = URL(string: path) else {
            #if DEBUG
            print("[sendRequest: debug] failed to generate url from string: \(path)")
            #endif
            return ("", nil, .errParseURL)
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
                err = .errDownloadData(String(describing: error))
                return
            }
            
            guard let res = response as? HTTPURLResponse else {
                err = .errDownloadData("network connection error")
                return
            }
            
            code = res.statusCode
            
            guard let data = data else {
                err = .errDownloadData("connection timeout")
                return
            }
            
            #if DEBUG
                print("[sendRequest: debug] complete download, data length: \(data.count)")
            #endif
            
            if !ignoreBody {
                result = String(decoding: data, as: UTF8.self)
            }
            
        }.resume()
        channel.wait()
        
        return (result, code, err)
    }
}
