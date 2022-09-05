import Foundation
import Combine

protocol NetworkController: AnyObject {
    func getData<T: Decodable>(endpoint: String,
                               type: T.Type) -> Future<T, Error>
}

final class DefaultNetworkController: NetworkController {
    
    static let shared = DefaultNetworkController()
    
    private init() { }
    
    private var subscribers = Set<AnyCancellable>()
    
    func getData<T>(endpoint: String,
                    type: T.Type) -> Future<T, Error> where T : Decodable {
        
        return Future<T, Error> { [weak self] promise in
            guard let self = self, let url = URL(string: endpoint) else {
                return promise(.failure(NetworkError.invalidURL))
            }
            
            print("URL is \(url.absoluteString)")
            URLSession.shared.dataTaskPublisher(for: url)
                .tryMap { (data, response) -> Data in
                    guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                        throw NetworkError.responseError
                    }
                    return data
                }
                .decode(type: T.self, decoder: JSONDecoder())
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: { (completion) in
                    if case let .failure(error) = completion {
                        switch error {
                        case let decodingError as DecodingError:
                            promise(.failure(decodingError))
                        case let apiError as NetworkError:
                            promise(.failure(apiError))
                        default:
                            promise(.failure(NetworkError.unknown))
                        }
                    }
                }, receiveValue: { promise(.success($0)) })
                .store(in: &self.subscribers)
        }
    }
}
