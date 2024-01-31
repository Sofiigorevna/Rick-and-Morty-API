//
//  ViewMoel.swift
//  Rick and Morty API
//
//  Created by 1234 on 19.01.2024.
//

import Foundation

class ViewModel {
    var isLoading: Dynamic<Bool> = Dynamic(false)
    var dataSource: [Characters] = []
    var cellDataSource: Dynamic<[Characters]> = Dynamic(nil)
    
    func getData(_ valueForFilter: String?) {
        isLoading.value = true
        
        APIFetchHandler.sharedInstance.fetchAPIData(queryItemValue: valueForFilter ){ [weak self] apiData in
            guard let self else {return}
            self.isLoading.value = false
            self.dataSource = apiData
            self.mapCellData()
        }
    }
    
    func mapCellData() {
        cellDataSource.value = dataSource
    }
}
