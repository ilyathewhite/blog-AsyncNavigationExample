//
//  AddressFormUI.swift
//  Example
//
//  Created by Ilya Belenkiy on 11/21/25.
//

import SwiftUI
import AsyncNavigation

extension AddressForm: ViewModelUINamespace {
   struct ContentView: ViewModelContentView {
      @ObservedObject var viewModel: ViewModel
      @State private var shouldSaveAlertResult:
          CheckedContinuation<Bool, Error>? = nil

      var addressPickerUI: ViewModelUI<AddressPicker>? { .init(viewModel.child()) }

      init(_ viewModel: ViewModel) {
         self.viewModel = viewModel
      }

      var body: some View {
         VStack {
            Form {
               // Address
               Section {
                  TextField("Name", text: $viewModel.name)
                  TextField("Street", text: $viewModel.street)
                  TextField("City", text: $viewModel.city)
                  HStack {
                     TextField("State", text: $viewModel.state)
                     TextField("ZIP", text: $viewModel.zip)
                        .keyboardType(.numbersAndPunctuation)
                  }
               }

               // Use Recent
               Button("Use Recent") {
                  Task {
                     let addressPicker = AddressPicker.ViewModel()
                     if let address = try? await viewModel.run(addressPicker) {
                        viewModel.update(with: address)
                     }
                  }
               }
               .listRowBackground(Color.clear)
               .frame(maxWidth: .infinity, alignment: .center)
               .font(.title3)
            }
            .padding(.top, 20)

            // Next
            Button("Next") {
               viewModel.done()
            }
            .buttonStyle(.primary)
            .disabled(!viewModel.nextButtonEnabled)
         }
         .background(Color(UIColor.secondarySystemBackground))
         .navigationTitle(viewModel.title)
         .sheet(self, \.addressPickerUI) { ui in
            ui.makeView()
               .presentationDetents([.medium, .large])
         }
         .taskAlert(
            "Save Address?",
            $shouldSaveAlertResult,
            actions: { complete in
               Button("Yes, save") {
                   complete(true)
               }
               Button("No, use one time only") {
                   complete(false)
               }
            },
            message: {
               Text("Add the address to recent?")
            }
         )
         .onAppear { // set enn
            guard viewModel.env == nil else { return }
            viewModel.env = .init(
               getShouldSaveFromUI: {
                  return try await withCheckedThrowingContinuation { continuation in
                     shouldSaveAlertResult = continuation
                  }
               }
            )
         }
      }
   }
}

#Preview {
   NavigationStack {
      AddressForm.ContentView(.init(title: "Shipping Address"))
   }
}

