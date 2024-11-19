//
//  APIManager.swift
//  ToDoList
//
//  Created by Murat Çimen on 25.10.2024.
//

import Foundation

class APIManager {

    private let apiKey = "AIzaSyAhWfbg7zpjT7PgNtIqss6V4Fjnzl2JjsQ"

    func fetchGeminiContent(prompt: String, completion: @escaping (Result<String, Error>) -> Void) {
        
        let urlString = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=\(apiKey)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let parameters: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        [

                            "text": "Here’s your reminder: \(prompt). Provide a friendly and motivating suggestion to make this task easier, more enjoyable, or healthier. Share practical, activity-specific tips that are relevant and helpful. Don't forget to respond in the same language the user wrote in. Give the answer maximum 100 words."

                        ]
                    ]
                ]
            ]
        ]
        
//        "text": "here is my reminder: \(prompt). I want you to write a brief text to remind person what to do according to it. make it sound casual and friendly. Also stay in context. Also make sure that your answer must be in same language as the reminder."
        
        do {
            
            let httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = httpBody
            
           
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(.failure(NSError(domain: "Invalid Response", code: 0, userInfo: nil)))
                    return
                }
                
                if httpResponse.statusCode != 200 {
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("HTTP \(httpResponse.statusCode): \(responseString)")
                    }
                    completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(NSError(domain: "No Data", code: 0, userInfo: nil)))
                    return
                }
                
                do {
    
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("API JSON Yanıtı: \(json)")
                        
                        if let candidates = json["candidates"] as? [[String: Any]],
                           let content = candidates.first?["content"] as? [String: Any],
                           let parts = content["parts"] as? [[String: Any]],
                           let resultText = parts.first?["text"] as? String {
                            completion(.success(resultText))  
                        } else {
                            completion(.failure(NSError(domain: "Invalid Response Structure", code: 0, userInfo: nil)))
                        }
                    } else {
                        completion(.failure(NSError(domain: "Invalid JSON", code: 0, userInfo: nil)))
                    }
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
            
        } catch {
            completion(.failure(NSError(domain: "Invalid Parameters", code: 0, userInfo: nil)))
        }
    }
}
