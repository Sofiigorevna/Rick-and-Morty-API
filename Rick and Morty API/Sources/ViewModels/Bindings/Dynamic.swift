//
//  Dynamic.swift
//  Rick and Morty API
//
//  Created by 1234 on 19.01.2024.
//

import Foundation

class Dynamic<T> {
    
    typealias Listener = (T?) -> Void
    
    private var listener: Listener?
    
    var value: T? {
        didSet{
            DispatchQueue.main.async {
                self.listener?(self.value)
            }
        }
    }
    
    init(_ value: T?) {
        self.value = value
    }
    
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
}
