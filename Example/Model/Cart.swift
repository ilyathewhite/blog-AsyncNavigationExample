//
//  Cart.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/11/25.
//

import Foundation

struct Cart {
   struct Item: Identifiable {
      let product: Product
      var quantity: Int

      var id: UUID { product.id }

      var price: DollarCurrency {
         Decimal(quantity) * product.unitPrice
      }
   }

   var items: [Item]
   var total: DollarCurrency {
      items.reduce(0) { $0 + $1.price }
   }

   func total(coupon: Coupon?) -> DollarCurrency {
      guard let coupon else { return total }
      return Decimal(1.0 - coupon.discount) * total
   }

   init(_ itemsArg: [Item]) {
      items = []
      for item in itemsArg {
         if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index].quantity += item.quantity
         }
         else {
            items.append(item)
         }
      }
   }
}

extension Cart {
   static let sampleCart: Cart = .init([
      .init(product: .book1, quantity: 2),
      .init(product: .book2, quantity: 1),
      .init(product: .book3, quantity: 1)
   ])
}
