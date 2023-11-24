//
//  NetworkManager.swift
//  TestProject
//
//  Created by Nana Jimsheleishvili on 23.11.23.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case noData
}

final class NetworkManager {
    // Singleton პატერნის არსიდან გამომდინარე shared უნდა იყოს სტატიკური და კლასს უნდა ჰქონდეს private ინიციალიზატორი, რადგან მხოლოდ ერთი ინსტანსის შექმნა შეიძლებოდეს.
    static let shared = NetworkManager()

    private init() {}

    func get<T: Decodable>(urlString: String, completion: @escaping ((Result<T, Error>) -> Void)) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }

            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
        // აქ .resume() აკლდა
    }
}
