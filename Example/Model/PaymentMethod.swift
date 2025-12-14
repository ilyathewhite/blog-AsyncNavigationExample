//
//  PaymentMethod.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/13/25.
//

enum PaymentMethod: CaseIterable {
   case creditCard
   case applePay

   var title: String {
      switch self {
      case .creditCard:
         return "Credit Card"
      case .applePay:
         return "Apple Pay"
      }
   }
}
