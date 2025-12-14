//
//  AddCoupon.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/12/25.
//

import Foundation
import Combine
import AsyncNavigation
import SwiftUI

enum AddCoupon {
   class ViewModel: BaseViewModel<Coupon?> {
      let cart: Cart
      @Published private(set) var coupon: Coupon?
      @Published var couponCodeText = "" { didSet { couponFeedback = " " } }
      @Published private(set) var couponFeedback = "Add your coupon above"

      let availableCoupons: [Coupon]

      init(cart: Cart, availableCoupons: [Coupon]) {
         self.cart = cart
         self.availableCoupons = availableCoupons
      }

      var adjustedTotalText: String {
         let value = cart.total(coupon: coupon)
         return value.description
      }

      private func findCoupon(_ code: String) -> Coupon? {
         availableCoupons.first { $0.code == code.uppercased() }
      }

      func addCoupon() {
         guard let coupon = findCoupon(couponCodeText) else {
            couponFeedback = "Coupon not found."
            return
         }
         self.coupon = coupon
         couponFeedback = "Coupon added!"
      }

      func adjustCouponCodeText(_ value: String) {
         couponCodeText = value.uppercased()
         coupon = findCoupon(couponCodeText)
         if coupon != nil {
            couponFeedback = "Coupon added!"
         }
      }

      func done() {
         if coupon != nil {
            publish(coupon)
         }
         else if !couponCodeText.isEmpty {
            addCoupon()
            if coupon != nil {
               Task { @MainActor in
                  try? await Task.sleep(for: .seconds(0.1))
                  publish(coupon)
               }
            }
         }
         else {
            publish(coupon)
         }
      }
   }
}
