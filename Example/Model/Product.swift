//
//  Product.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/11/25.
//

import Foundation

struct Product: Identifiable {
   let id: UUID
   let name: String
   let unitPrice: DollarCurrency

}

extension Product {
   static let book1 = Product(
      id: UUID(),
      name: "The C++ Programming Language",
      unitPrice: 39.95
   )
   static let book2 = Product(
      id: UUID(),
      name: "Design Patterns: Elements of Reusable Object-Oriented Software",
      unitPrice: 49.95
   )
   static let book3 = Product(
      id: UUID(),
      name: "Clean Code: A Handbook of Agile Software Craftsmanship",
      unitPrice: 27.99
   )
   static let sampleBooks: [Product] = [book1, book2, book3]
}
