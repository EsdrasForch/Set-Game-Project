//
//  Array+Identifiable.swift
//  Set
//
//  Created by Esdras Forch on 11/12/21.
//

import Foundation

extension Array where Element: Identifiable {
    func firstIndex(matching item: Element) -> Int? {
        if let index = self.firstIndex(where: {item.id == $0.id}) {
            return index
        }
        return nil
    }
}
