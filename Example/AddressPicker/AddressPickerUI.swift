//
//  AddressPickerUI.swift
//  Example
//
//  Created by Ilya Belenkiy on 11/21/25.
//

import SwiftUI
import AsyncNavigation

extension AddressPicker: ViewModelUINamespace {
   struct ContentView: ViewModelContentView {
      @State private var selection: Address? = nil
      @ObservedObject var viewModel: ViewModel

      init(_ viewModel: ViewModel) {
         self.viewModel = viewModel
      }

      var body: some View {
         List(selection: $selection) {
            ForEach(viewModel.addresses, id: \.self) { address in
               AddressView(address: address)
                  .contentShape(Rectangle())
                  .onTapGesture {
                     selection = address
                     viewModel.publish(address)
                  }
            }
         }
      }
   }
}

#Preview {
   AddressPicker.ContentView(.init())
}
