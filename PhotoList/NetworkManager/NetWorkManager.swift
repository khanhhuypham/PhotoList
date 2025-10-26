//
//  ConnectionManager.swift
//  aloline-phamkhanhhuy
//
//  Created by Pham Khanh Huy on 16/02/2024.
//



import UIKit
//import AlertToast

let networkManager = NetworkManager.self

enum NetworkManager{

    //MARK: authentication
    case getPhotoList(limit:Int, page:Int)
  
}
  
////==================================================================================================================================================================


extension NetworkManager{
    
    static func makeQueryItems(from parameters: [String: Any]) -> [URLQueryItem] {
        var queryItems: [URLQueryItem] = []
        
        for (key, value) in parameters {
            let stringValue: String
            
            switch value {
                case let v as String:
                    stringValue = v
                case let v as CustomStringConvertible:
                    stringValue = v.description
                default:
                    continue // Skip values that can't be converted to String
            }
            
            queryItems.append(URLQueryItem(name: key, value: stringValue))
        }
        
        return queryItems
    }
    
    static func makeRequest(from netWorkManger: NetworkManager, url: URL) throws -> URLRequest {
        var request = URLRequest(url: url)

        // Set HTTP method
        request.httpMethod = netWorkManger.method.description
        // Set headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        for (key, value) in netWorkManger.headers ?? [:] {
            request.setValue(value, forHTTPHeaderField: key)
        }

        // Set body for POST, PUT, PATCH
        if [.POST, .PUT, .PATCH].contains(netWorkManger.method) {
            
            let jsonData = try JSONSerialization.data(withJSONObject: netWorkManger.task.body, options: [.prettyPrinted])
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                dLog("JSON String: \(jsonString)")
            }
            
            request.httpBody = jsonData
        }

        return request
    }
    
  
}


extension NetworkManager{
    
    static func callAPIAsync<T: Decodable>(logRequest: Bool = true,netWorkManger: NetworkManager,timeout: TimeInterval = 15) async -> Result<T, Error>
    {
        Loading.show()
        defer { Loading.hide() }

        var components = URLComponents(string: environmentMode.baseUrl)
        components?.scheme = "https"
        components?.path = netWorkManger.path

        if ![.POST, .PUT, .PATCH].contains(netWorkManger.method),
           let query = netWorkManger.task.query {
            components?.queryItems = makeQueryItems(from: query)
        }

        guard let url = components?.url else {
            return .failure(NetworkError.invalidURL)
        }

        let request: URLRequest
        do {
            request = try makeRequest(from: netWorkManger, url: url)
        } catch {
            return .failure(error)
        }

        // Custom session with timeout
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout * 2
        let session = URLSession(configuration: config)

        if logRequest {
            dLog("📡 Method: \(netWorkManger.method.description)")
            request.allHTTPHeaderFields?.forEach { dLog("\($0.key): \($0.value)") }
            dLog("🌐 URL: \(url.absoluteString)")
        }

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(NetworkError.unknown)
            }

            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    return .success(decoded)
                } catch {
                    return .failure(NetworkError.decodingError(error))
                }
            case 400:
                let message = String(data: data, encoding: .utf8) ?? "Bad Request"
                return .failure(NetworkError.badRequest(message: message))
            case 404:
                let message = String(data: data, encoding: .utf8) ?? "Not Found"
                return .failure(NetworkError.badRequest(message: message))
            default:
                let message = String(data: data, encoding: .utf8)
                return .failure(NetworkError.serverError(statusCode: httpResponse.statusCode, message: message))
            }
        } catch let error as URLError where error.code == .timedOut {
            return .failure(NetworkError.networkError(error))
        } catch {
            return .failure(NetworkError.unknown)
        }
    }


}

enum NetworkError: Error {
    case invalidURL
    case badRequest(message: String)
    case notFound(message: String)
    case networkError(Error)
    case decodingError(Error)
    case serverError(statusCode: Int, message: String?)
    case unknown
    
    var description: String {
        switch self {
            case .invalidURL:
                return "Invalid URL"
            
            case .badRequest(message: let message):
                return "Bad Request: \(message)"
            
            case .notFound(message: let message):
                return "Not Found: \(message)"
            
            case .networkError(let underlyingError):
                return "Network Error: \(underlyingError)"
            
            case .decodingError(let error):
                return error.localizedDescription
            
            case .serverError(statusCode: let statusCode, message: let message):
                return message ?? "Server Error (\(statusCode))"
            
            case .unknown:
                return "Unknown Error"
        }
    }
}
