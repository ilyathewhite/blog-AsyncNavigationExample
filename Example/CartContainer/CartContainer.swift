//
//  CartContainer.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/11/25.
//

import Foundation
import Combine
import AsyncNavigation

enum CartContainer {
   class ViewModel: BaseViewModel<Cart> {
      @Published private(set) var cart: Cart

      init(cart: Cart) {
         self.cart = cart
      }

      func itemIndex(_ itemID: UUID) -> Int? {
         guard let index = cart.items.firstIndex(where: { $0.id == itemID }) else {
            assertionFailure()
            return nil
         }
         return index
      }

      func incrementCount(itemID: UUID) {
         guard let index = itemIndex(itemID) else { return }
         cart.items[index].quantity += 1
      }

      func canRemove(itemID: UUID) -> Bool {
         guard let index = itemIndex(itemID) else { return false }
         return cart.items[index].quantity > 0
      }

      func decrementCount(itemID: UUID) {
         guard let index = itemIndex(itemID) else { return }
         cart.items[index].quantity -= 1
      }

      func done() {
         publish(cart)
      }
   }
}
