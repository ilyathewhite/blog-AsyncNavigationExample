//
//  AddressForm.swift
//  Example
//
//  Created by Ilya Belenkiy on 11/21/25.
//

import Foundation
import SwiftUI
import Combine
import AsyncNavigation

enum AddressForm {
   class ViewModel: BaseViewModel<Address> {
      struct Environment {
         let getShouldSaveFromUI: () async throws -> Bool
      }

      @Published var name = "" { didSet { updateAddress() }}
      @Published var street = "" { didSet { updateAddress() }}
      @Published var city = "" { didSet { updateAddress() }}
      @Published var state = "" { didSet { updateAddress() }}
      @Published var zip = "" { didSet { updateAddress() }}

      let title: String
      var address: Address?
      var env: Environment?

      init(title: String) {
         self.title = title
      }

      var nextButtonEnabled: Bool {
         address != nil
      }

      func update(with address: Address) {
         name = address.name
         street = address.street
         city = address.city
         state = address.state
         zip = address.zip
         self.address = address
      }

      func updateAddress() {
         guard !name.isEmpty, !street.isEmpty, !city.isEmpty, !state.isEmpty, !zip.isEmpty else {
            address = nil
            return
         }
         address = Address(name: name, street: street, city: city, state: state, zip: zip)
      }

      func done() {
         guard let address else { return }
         guard let env else { return }
         if Address.isSaved(address) {
            publish(address)
         }
         else {
            Task {
               guard let shouldSave = try? await env.getShouldSaveFromUI() else { return }
               if shouldSave {
                  Address.save(address)
               }
               publish(address)
            }
         }
      }
   }
}
