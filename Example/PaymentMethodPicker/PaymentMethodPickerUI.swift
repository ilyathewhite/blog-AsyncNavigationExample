//
//  PaymentMethodPickerUI.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/13/25.
//

import SwiftUI
import AsyncNavigation

extension PaymentMethodPicker: ViewModelUINamespace {
   struct ContentView: ViewModelContentView {
      @State private var selection: PaymentMethod? = nil
      @ObservedObject var viewModel: ViewModel

      init(_ viewModel: ViewModel) {
         self.viewModel = viewModel
      }

      var body: some View {
         VStack {
            RadioGroup(
               items: viewModel.methods,
               selection: Binding(
                  get: { viewModel.selection },
                  set: { viewModel.updateSelection($0) }
               ),
               labelForItem: { method in
                  Text(method.title)
               }
            )
            .padding()

            Spacer()

            // Next
            Button(action: { viewModel.done() }) {
               Text("Next")
            }
            .disabled(!viewModel.nextButtonEnabled)
            .buttonStyle(PrimaryButtonStyle())
         }
         .padding()
         .navigationTitle("Payment Method")
      }
   }
}

#Preview {
   NavigationStack {
      PaymentMethodPicker.ContentView(.init())
   }
}
