//
//  ApiFetch.swift
//  Rick and Morty API
//
//  Created by 1234 on 18.01.2024.
//

import Foundation
import Alamofire

class APIFetchHandler {
    static let sharedInstance = APIFetchHandler()
    private var isStarting = false
    private var callback: (([Characters]) -> Void)?
    private var cashed: [Characters]?
    
    private func createURL(baseURL: String, path: String?, queryItems: [URLQueryItem]? = nil) -> URL? {
        // Проверяем, есть ли путь (path)
        if let path = path, !path.isEmpty {
            // Если путь существует и не пуст, создаем URL с полным путем
            var components = URLComponents(string: baseURL)
            components?.path = path
            components?.queryItems = queryItems
            return components?.url
        } else {
            // Если путь отсутствует или пуст, используем базовый URL
            return URL(string: baseURL)
        }
    }
    
    func fetchAPIData(queryItemValue: String?,
                      handlerMain: (([Characters]) -> Void)?) {
        let baseURL = "https://rickandmortyapi.com"
        let urlPath = "/api/character"
        let queryItem = [URLQueryItem(name: "name", value: queryItemValue)]
        
        let urlRequest = createURL(baseURL: baseURL, path: urlPath, queryItems: queryItem)
        
        /*
         Чтобы ячейка не загружалась каждый раз при прокрутке вверх/вниз используем переменную, которая будет хранить загруженные данные
         */
        
        if let data = cashed {
            handlerMain?(data)
            return
        }
        
        // следим,чтобы функция fetchAPIData не стала неприрывной, т.е. во время зарузки не запускалась снова
        
        guard !isStarting else {
            self.callback = handlerMain
            return
        }
        
        isStarting = true
        
        guard let url = urlRequest else {return}
        
        AF.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil, interceptor: nil)
            .response{ resp in
                switch resp.result{
                case .success(let data):
                    do{
                        if let data = data {
                            let jsonData = try JSONDecoder().decode(Results.self, from: data)
                            let result = jsonData.results
                            self.cashed = result
                            self.callback?(result)
                            self.callback = nil
                            handlerMain?(result)
                        }
                    } catch {
                        print(String(describing: error))
                    }
                case .failure(let error):
                    print(String(describing: error))
                }
            }
    }
}
