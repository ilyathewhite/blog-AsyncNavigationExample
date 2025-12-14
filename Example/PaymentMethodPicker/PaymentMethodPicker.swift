//
//  PaymentMethodPicker.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/13/25.
//

import Combine
import SwiftUI
import AsyncNavigation

enum PaymentMethodPicker {
   class ViewModel: BaseViewModel<PaymentMethod> {
      let methods = PaymentMethod.allCases
      @Published private(set) var selection: PaymentMethod?

      func updateSelection(_ value: PaymentMethod?) {
         selection = value
      }

      var nextButtonEnabled: Bool {
         selection != nil
      }

      func done() {
         guard let selection else { return }
         publish(selection)
      }
   }
}
