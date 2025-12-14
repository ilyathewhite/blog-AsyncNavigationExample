//
//  AddCouponUI.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/12/25.
//

import SwiftUI
import AsyncNavigation

extension AddCoupon: ViewModelUINamespace {
   struct ContentView: ViewModelContentView {
      @ObservedObject var viewModel: ViewModel

      init(_ viewModel: ViewModel) {
         self.viewModel = viewModel
      }

      var body: some View {
         VStack(spacing: 20) {
            VStack {
               // Add coupon
               TextField("Coupon", text: $viewModel.couponCodeText)
                  .onSubmit {
                     viewModel.addCoupon()
                  }
                  .font(.title)
                  .onChange(of: viewModel.couponCodeText) { oldValue, newValue in
                     viewModel.adjustCouponCodeText(newValue)
                  }
               // coupon feedback
               Text(viewModel.couponFeedback)
                  .font(.subheadline)

               // Total
               HStack {
                  Text("Total")
                  Spacer()
                  Text(viewModel.adjustedTotalText)
               }
               .font(.title3.weight(.semibold))
               .padding(.top, 40)

               Spacer()
            }
            .padding()

            // Next
            Button(action: { viewModel.done() }) {
               Text("Next")
            }
            .buttonStyle(PrimaryButtonStyle())
         }
         .padding()
         .navigationTitle("Add Coupon")
      }
   }
}

#Preview {
   let viewModel = AddCoupon.ViewModel(cart: .sampleCart, availableCoupons: Coupon.available)
   NavigationStack {
      AddCoupon.ContentView(viewModel)
   }
}
