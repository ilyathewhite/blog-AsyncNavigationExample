//
//  OrderFlow.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/13/25.
//

import AsyncNavigation

struct OrderFlow {
   let cart: Cart
   let availableCoupons: [Coupon]
   let proxy: NavigationProxy

   func getShippingAddress() -> NavigationNode<AddressForm> {
      .init(AddressForm.ViewModel(title: "Shipping Address"), proxy)
   }

   func addCoupon(cart: Cart) -> NavigationNode<AddCoupon> {
      .init(AddCoupon.ViewModel(cart: cart, availableCoupons: availableCoupons), proxy)
   }

   func pickPaymentMethod() -> NavigationNode<PaymentMethodPicker> {
      .init(PaymentMethodPicker.ViewModel(), proxy)
   }

   func getBillingAddress() -> NavigationNode<AddressForm> {
      .init(AddressForm.ViewModel(title: "Billing Address"), proxy)
   }

   func getCreditCardDetails() -> NavigationNode<CreditCardDetails> {
      .init(CreditCardDetails.ViewModel(), proxy)
   }

   func showOrderSummary(
      cart: Cart,
      coupon: Coupon?,
      shippingAddress: Address,
      paymentMethod: OrderSummary.PaymentMethod?
   )
   -> NavigationNode<OrderSummary> {
      .init(OrderSummary.ViewModel(
         cart: cart,
         coupon: coupon,
         shippingAddress: shippingAddress,
         paymentMethod: paymentMethod
         ),
         proxy
      )
   }

   func run() async {
      await getShippingAddress().then { shippingAddress, _ in
         await addCoupon(cart: cart).then { coupon, _ in
            if let coupon, cart.total(coupon: coupon) == 0 {
               await finishFreeOrder(cart: cart, coupon: coupon, shippingAddress: shippingAddress)
            }
            else {
               await finishRegularOrder(cart: cart, coupon: coupon, shippingAddress: shippingAddress)
            }
         }
      }
   }

   func finishFreeOrder(cart: Cart, coupon: Coupon, shippingAddress: Address) async {
      await showOrderSummary(
         cart: cart,
         coupon: coupon,
         shippingAddress: shippingAddress,
         paymentMethod: nil
      )
      .then { _, _ in
         proxy.popToRoot()
      }
   }

   func finishRegularOrder(cart: Cart, coupon: Coupon?, shippingAddress: Address) async {
      await pickPaymentMethod().then { paymentMethod, _ in
         switch paymentMethod {
         case .creditCard:
            await getBillingAddress().then { billingAddress, _ in
               await getCreditCardDetails().then { cardDetails, _ in
                  await showOrderSummary(
                     cart: cart,
                     coupon: coupon,
                     shippingAddress: shippingAddress,
                     paymentMethod: .creditCard(cardDetails, billingAddress)
                  )
                  .then { _, _ in
                     proxy.popToRoot()
                  }
               }
            }

         case .applePay:
            await showOrderSummary(
               cart: cart,
               coupon: coupon,
               shippingAddress: shippingAddress,
               paymentMethod: .applePay
            )
            .then { _, _ in
               proxy.popToRoot()
            }
         }
      }
   }
}
