//
//  ContentView.swift
//  Example
//
//  Created by Ilya Belenkiy on 11/21/25.
//

import SwiftUI
import AsyncNavigation

struct ContentView: View {
   var body: some View {
      OrderFlowContainer(cart: .sampleCart, availableCoupons: Coupon.available)
   }
}

#Preview {
   ContentView()
}
