//
//  CreditCardNumber.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/13/25.
//

struct CreditCardInfo: Codable {
   let cardHolderName: String
   let number: String
   let expDateMonth: Int
   let expDateYear: Int
   let cvc: String
}
