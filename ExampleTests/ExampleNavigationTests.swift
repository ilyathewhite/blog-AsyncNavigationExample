//
//  ExampleTests.swift
//  ExampleTests
//
//  Created by Ilya Belenkiy on 1/10/26.
//

import Testing
import AsyncNavigation
@testable import Example

@MainActor
struct ExampleTests {
    let navigationProxy = TestNavigationProxy()
    let adjustCartVM = CartContainer.ViewModel(cart: .sampleCart)
    let adjustCart: ViewModelUI<CartContainer>
    let flow: OrderFlow

    init() {
        adjustCart = ViewModelUI<CartContainer>(adjustCartVM)
        _ = navigationProxy.push(adjustCart)
        flow = OrderFlow(
            cart: adjustCart.viewModel.cart,
            availableCoupons: Coupon.available,
            proxy: navigationProxy
        )
    }

    @Test func freeOrder() async throws {
        let flowTask = Task {
            await flow.run()
        }

        var timeIndex = 1

        // set shipping address
        let setAddressVM = try await navigationProxy.getViewModel(AddressForm.self, &timeIndex)
        await setAddressVM.publishOnRequest(.address1)

        // add 100% off coupon
        let addCouponVM = try await navigationProxy.getViewModel(AddCoupon.self, &timeIndex)
        let coupon = Coupon.available[0]
        #expect(coupon.discount == 1)
        await addCouponVM.publishOnRequest(coupon)

        // show order summary
        let orderSummaryVM = try await navigationProxy.getViewModel(OrderSummary.self, &timeIndex)
        #expect(orderSummaryVM.orderDetails.cart.total == adjustCartVM.cart.total)
        #expect(orderSummaryVM.orderDetails.coupon?.discount == 1)
        await orderSummaryVM.publishOnRequest(orderSummaryVM.orderDetails)

        // back to root
        let rootCartVM = try await navigationProxy.getViewModel(CartContainer.self, &timeIndex)
        #expect(rootCartVM == adjustCartVM)

        await flowTask.value
    }

    @Test func orderWithApplePay() async throws {
        let flowTask = Task {
            await flow.run()
        }

        var timeIndex = 1

        // set shipping address
        let setAddressVM = try await navigationProxy.getViewModel(AddressForm.self, &timeIndex)
        await setAddressVM.publishOnRequest(.address1)

        // add some coupon
        let addCouponVM = try await navigationProxy.getViewModel(AddCoupon.self, &timeIndex)
        let coupon = Coupon.available[1]
        #expect(coupon.discount != 1)
        await addCouponVM.publishOnRequest(coupon)

        // select Apple Pay as payment method
        let paymentMethodVM = try await navigationProxy.getViewModel(PaymentMethodPicker.self, &timeIndex)
        await paymentMethodVM.publishOnRequest(.applePay)

        // show order summary
        let orderSummaryVM = try await navigationProxy.getViewModel(OrderSummary.self, &timeIndex)
        #expect(orderSummaryVM.orderDetails.cart.total == adjustCartVM.cart.total)
        #expect(orderSummaryVM.orderDetails.coupon?.discount == coupon.discount)
        #expect(orderSummaryVM.orderDetails.paymentMethod == .applePay)
        await orderSummaryVM.publishOnRequest(orderSummaryVM.orderDetails)

        // back to root
        let rootCartVM = try await navigationProxy.getViewModel(CartContainer.self, &timeIndex)
        #expect(rootCartVM == adjustCartVM)

        await flowTask.value
    }

    @Test func orderWithCreditCard() async throws {
        let flowTask = Task {
            await flow.run()
        }

        var timeIndex = 1

        // set shipping address
        let setAddressVM = try await navigationProxy.getViewModel(AddressForm.self, &timeIndex)
        await setAddressVM.publishOnRequest(.address1)

        // add some coupon
        let addCouponVM = try await navigationProxy.getViewModel(AddCoupon.self, &timeIndex)
        let coupon = Coupon.available[1]
        #expect(coupon.discount != 1)
        await addCouponVM.publishOnRequest(coupon)

        // select credit card as payment method
        let paymentMethodVM = try await navigationProxy.getViewModel(PaymentMethodPicker.self, &timeIndex)
        await paymentMethodVM.publishOnRequest(.creditCard)

        // get billing address

        let setBillingAddressVM = try await navigationProxy.getViewModel(AddressForm.self, &timeIndex)
        await setBillingAddressVM.publishOnRequest(.address2)

        // get credit card details
        let creditCardDetilsVM = try await navigationProxy.getViewModel(CreditCardDetails.self, &timeIndex)
        let cardDetails = CreditCardInfo(
            cardHolderName: "Joe Smith",
            number: "1234567890123456",
            expDateMonth: 1,
            expDateYear: 2030,
            cvc: "132"
        )
        await creditCardDetilsVM.publishOnRequest(cardDetails)

        // show order summary
        let orderSummaryVM = try await navigationProxy.getViewModel(OrderSummary.self, &timeIndex)
        #expect(orderSummaryVM.orderDetails.cart.total == adjustCartVM.cart.total)
        #expect(orderSummaryVM.orderDetails.coupon?.discount == coupon.discount)
        #expect(orderSummaryVM.orderDetails.paymentMethod == .creditCard(cardDetails, .address2))
        await orderSummaryVM.publishOnRequest(orderSummaryVM.orderDetails)

        // back to root
        let rootCartVM = try await navigationProxy.getViewModel(CartContainer.self, &timeIndex)
        #expect(rootCartVM == adjustCartVM)

        await flowTask.value
    }
}
