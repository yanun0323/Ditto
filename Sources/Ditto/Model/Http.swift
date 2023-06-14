import Foundation

@available(iOS 16, macOS 13, watchOS 9, *)
public struct Http {}

@available(iOS 16, macOS 13, watchOS 9, *)
extension Http {
    public enum Method: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case PATCH = "PATCH"
        case DELETE = "DELETE"
    }
}

@available(iOS 16, macOS 13, watchOS 9, *)
extension Http {
    /**
     Send a request and get structure response
     
     ```swift
     let url = "http://api/user"
     let user = Http.SendRequest(.GET, toUrl: url, type: User.self) { delegate in
     var request = delegate
     // do something ...
     return request
     }
     ```
     */
    public static func sendRequest<T>(_ method: Method = .GET, toUrl path: String, type: T.Type, action: @escaping (URLRequest) -> URLRequest) -> T? where T: Decodable {
        guard let url = URL(string: path) else {
            print("failed to generate url from string: \(path)")
            return nil
        }
        let channel = DispatchSemaphore(value: 0)
        var result: T? = nil
        
        var request = URLRequest(url: url, timeoutInterval: 30)
        request = action(request)
        request.httpMethod = method.rawValue
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            defer { channel.signal() }
            guard
                let data = data,
                error == nil ,
                let responce = responce as? HTTPURLResponse,
                responce.statusCode == 200 else {
                print("Failed to download data")
                return
            }
            print("complete download, data length: \(data.count)")
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                result = decoded
            } catch {
                print("decode data error, \(error)")
            }
            
        }.resume()
        channel.wait()
        return result
    }
    
    /**
     Send a request and get string response
     
     ```swift
     let url = "http://api/user"
     let body = Http.DumpRequest(.GET, toUrl: url, type: User.self) { delegate in
     var request = delegate
     // do something ...
     return request
     }
     ```
     */
    public static func dumpRequest(_ method: Method = .GET, toUrl path: String, action: @escaping (URLRequest) -> URLRequest) -> String {
        guard let url = URL(string: path) else {
            print("failed to generate url from string: \(path)")
            return ""
        }
        let channel = DispatchSemaphore(value: 0)
        var result: String = ""
        
        var request = URLRequest(url: url, timeoutInterval: 30)
        request = action(request)
        request.httpMethod = method.rawValue
        
        URLSession.shared.dataTask(with: request) { data, responce, error in
            defer { channel.signal() }
            guard
                let data = data,
                error == nil ,
                let responce = responce as? HTTPURLResponse,
                responce.statusCode == 200 else {
                print("Failed to download data")
                return
            }
            print("complete download, data length: \(data.count)")
            result = String(decoding: data, as: UTF8.self)
            
        }.resume()
        channel.wait()
        return result
    }
    
    /**
     Send a request and get status code
     
     ```swift
     let url = "http://api/user"
     let code = Http.RequestStatusCode(.GET, toUrl: url, type: User.self) { delegate in
     var request = delegate
     // do something ...
     return request
     }
     ```
     */
    public static func requestStatusCode(_ method: Method = .GET, toUrl path: String, action: @escaping (URLRequest) -> URLRequest) -> Int? {
        guard let url = URL(string: path) else {
            print("failed to generate url from string: \(path)")
            return nil
        }
        let channel = DispatchSemaphore(value: 0)
        var result: Int? = nil
        
        var request = URLRequest(url: url, timeoutInterval: 30)
        request = action(request)
        request.httpMethod = method.rawValue
        
        URLSession.shared.dataTask(with: request) { _, responce, error in
            defer { channel.signal() }
            guard
                error == nil ,
                let responce = responce as? HTTPURLResponse else {
                print("Failed to download data")
                return
            }
            result = responce.statusCode
            
        }.resume()
        channel.wait()
        return result
    }
}
