//
//  OrderSummary.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/13/25.
//

import Foundation
import Combine
import AsyncNavigation

enum OrderSummary {
   enum PaymentMethod {
      case creditCard(CreditCardInfo, Address)
      case applePay
   }

   struct OrderDetails {
      let cart: Cart
      let coupon: Coupon?
      let shippingAddress: Address
      let paymentMethod: PaymentMethod?
   }

   struct Environment {
      let placeOrder: (_ orderDetails: OrderDetails) async throws -> String
   }

   class ViewModel: BaseViewModel<OrderDetails?> {
      let orderDetails: OrderDetails

      var totalString: String {
         let coupon = orderDetails.coupon
         let value = orderDetails.cart.total(coupon: coupon)
         return value.description
      }

      init(cart: Cart, coupon: Coupon?, shippingAddress: Address, paymentMethod: PaymentMethod?) {
         orderDetails = .init(
            cart: cart,
            coupon: coupon,
            shippingAddress: shippingAddress,
            paymentMethod: paymentMethod
         )
      }

      func done() {
         publish(orderDetails)
      }

      func cancelOrder() {
         publish(nil)
      }
   }
}
