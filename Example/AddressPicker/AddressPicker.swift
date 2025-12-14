//
//  AddressPicker.swift
//  Example
//
//  Created by Ilya Belenkiy on 11/21/25.
//

import SwiftUI
import AsyncNavigation

enum AddressPicker {
   class ViewModel: BaseViewModel<Address> {
      let addresses: [Address] = Address.getAllAddresses()
   }
}
