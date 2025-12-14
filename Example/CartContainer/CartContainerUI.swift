//
//  CartContainerUI.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/11/25.
//

import SwiftUI
import AsyncNavigation

extension CartContainer: ViewModelUINamespace {
   struct ContentView: ViewModelContentView {
      @ObservedObject var viewModel: ViewModel

      init(_ viewModel: ViewModel) {
         self.viewModel = viewModel
      }

      var body: some View {
         VStack(spacing: 20) {
            // Cart content
            ForEach(viewModel.cart.items, id: \.id) { item in
               HStack(alignment: .firstTextBaseline) {
                  // title
                  Text(item.product.name)
                     .font(.body.weight(.light))
                     .fontDesign(.rounded)
                  Spacer()
                  // count
                  Text(String(item.quantity))
                     .padding(.horizontal)

                  // +
                  Button(action: { viewModel.incrementCount(itemID: item.id) }) {
                     Image(systemName: "plus.circle")
                        .font(.title3)
                  }

                  // -
                  Button(action: { viewModel.decrementCount(itemID: item.id) }) {
                     Image(systemName: "minus.circle")
                        .font(.title3)
                  }
                  .disabled(!viewModel.canRemove(itemID: item.id))
               }
            }

            // Total
            HStack {
               Text("Total")
               Spacer()
               Text(viewModel.cart.total.description)
            }
            .font(.title3.weight(.semibold))
            .padding(.top, 15)

            Spacer()

            // Next
            Button(action: { viewModel.done() }) {
               Text("Next")
            }
            .buttonStyle(PrimaryButtonStyle())
         }
         .padding()
         .navigationTitle("Your Cart")
      }
   }
}

#Preview {
   let viewModel = CartContainer.ViewModel(cart: .sampleCart)
   NavigationStack {
      CartContainer.ContentView(viewModel)
   }
}
