//
//  AddressView.swift
//  Example
//
//  Created by Ilya Belenkiy on 11/21/25.
//

import SwiftUI

struct AddressView: View {
   let address: Address

   var line1: some View {
      Text(address.name).font(.headline)
   }

   var line2: some View {
      Text(address.street)
   }

   var line3: some View {
      Text("\(address.city), \(address.state) \(address.zip)")
   }

   var body: some View {
      VStack(alignment: .leading) {
         line1
         line2
         line3
      }
   }
}

#Preview {
   AddressView(address: .address1)
}
