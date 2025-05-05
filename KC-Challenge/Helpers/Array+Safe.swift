//
//  Array+Safe.swift
//  KC-Challenge
//
//  Created by Nihed Majdoub on 04/05/2025.
//

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
