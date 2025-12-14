//
//  OrderFlowContainer.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/14/25.
//

import AsyncNavigation
import SwiftUI

struct OrderFlowContainer: View {
   let cart: Cart
   let availableCoupons: [Coupon]

   func adjustCart() -> RootNavigationNode<CartContainer> {
      .init(CartContainer.ViewModel(cart: cart))
   }

   var body: some View {
      NavigationFlow(adjustCart()) { cart, proxy in
         await OrderFlow(cart: cart, availableCoupons: availableCoupons, proxy: proxy).run()
      }
   }
}
