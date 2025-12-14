//
//  OrderSummaryUI.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/13/25.
//

import SwiftUI
import AsyncNavigation

extension OrderSummary: ViewModelUINamespace {
   struct ContentView: ViewModelContentView {
      @ObservedObject var viewModel: ViewModel

      init(_ viewModel: ViewModel) {
         self.viewModel = viewModel
      }

      var body: some View {
         VStack(spacing: 0) {
            ScrollView {
               VStack(spacing: 15) {
                  // Cart content
                  ForEach(viewModel.orderDetails.cart.items, id: \.id) { item in
                     HStack(alignment: .firstTextBaseline) {
                        // title
                        Text(item.product.name)
                           .font(.body.weight(.light))
                           .fontDesign(.rounded)
                        Spacer()
                        // count
                        Text(String(item.quantity))
                     }
                  }
               }
               // .border(Color.red)

               // Total
               HStack {
                  Text("Total")
                  Spacer()
                  Text(viewModel.totalString)
               }
               .font(.title3.weight(.semibold))
               .padding(.top, 10)

               // Shipping Address
               VStack(alignment: .leading, spacing: 10) {
                  Text("Shipping Address")
                  AddressView(address: viewModel.orderDetails.shippingAddress)
               }
               .frame(maxWidth: .infinity, alignment: .leading)
               .padding(.top, 20)

               Spacer()
            }

            Divider()

            // Place Order
            Button(action: { viewModel.done() }) {
               Text("Place Order")
            }
            .buttonStyle(PrimaryButtonStyle())
            .padding(.top, 20)

            // Cancel
            Button(action: { viewModel.cancelOrder() }) {
               Text("Cancel")
            }
            .padding(.top, 20)
         }
         .padding(.horizontal, 25)
         .padding(.top, 40)
         .navigationTitle(Text("Order Summary"))
      }
   }
}

#Preview {
   let viewModel = OrderSummary.ViewModel(
      cart: .sampleCart,
      coupon: nil,
      shippingAddress: .address1,
      paymentMethod: .applePay
   )
   NavigationStack {
      OrderSummary.ContentView(viewModel)
   }
}
