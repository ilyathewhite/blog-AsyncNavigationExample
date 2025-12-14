//
//  CreditCardDetailsUI.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/13/25.
//

import SwiftUI
import AsyncNavigation

extension CreditCardDetails: ViewModelUINamespace {
   struct ContentView: ViewModelContentView {
      @ObservedObject var viewModel: ViewModel

      init(_ viewModel: ViewModel) {
         self.viewModel = viewModel
      }

      var body: some View {
         VStack(spacing: 20) {
            Form {
               Section {
                  // Name
                  TextField("Name on Card", text: $viewModel.cardHolderName)

                  // Card Number
                  TextField("Card Number", text: $viewModel.cardNumber)
                     .keyboardType(.numberPad)

                  // Month and Year
                  HStack {
                     TextField("Month", text: $viewModel.expDateMonthText)
                        .keyboardType(.numberPad)

                     TextField("Year", text: $viewModel.expDateYearText)
                        .keyboardType(.numberPad)
                  }

                  // CVV
                  TextField("CVV", text: $viewModel.cvv)
                     .keyboardType(.numberPad)
               }
            }
            .padding(.top, 20)

            // Next
            Button("Next") {
               viewModel.done()
            }
            .buttonStyle(.primary)
            .disabled(!viewModel.nextButtonEnabled)
         }
         .background(Color(UIColor.systemGroupedBackground))
         .navigationTitle("Credit Card")
      }
   }
}

#Preview {
   let viewModel = CreditCardDetails.ViewModel()
   NavigationStack {
      CreditCardDetails.ContentView(viewModel)
   }
}
