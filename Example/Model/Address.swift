//
//  Address.swift
//  Example
//
//  Created by Ilya Belenkiy on 11/21/25.
//

struct Address: Equatable, Hashable {
   private static var allAddresses: [Address] = [
      .address1,
      .address2,
      .address3
   ]

   static func isSaved(_ address: Address) -> Bool {
      allAddresses.contains(address)
   }

   static func save(_ address: Address) {
      allAddresses.insert(address, at: 0)
   }

   static func getAllAddresses() -> [Address] {
      allAddresses
   }

   let name: String
   let street: String
   let city: String
   let state: String
   let zip: String
}

extension Address {
   static let address1: Address = .init(
      name: "John Doe",
      street: "742 Redwood Crest",
      city: "San Mateo",
      state: "CA",
      zip: "94403"
   )

   static let address2: Address = .init(
      name: "Jane Smith",
      street: "315 Whispering Pines Way",
      city: "Saratoga Springs",
      state: "NY",
      zip: "12866"
   )

   static let address3: Address = .init(
      name: "Alex Johnson",
      street: "1840 Copper Kettle Lane",
      city: "Austin",
      state: "TX",
      zip: "78704"
   )
}

