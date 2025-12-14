//
//  Currency.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/13/25.
//

import Foundation

struct DollarCurrency: CustomStringConvertible {
   static let code = "USD"
   static let formatter = {
      let formatter = NumberFormatter()
      formatter.numberStyle = .currency
      formatter.currencyCode = code
      return formatter
   }()

   var amount: Decimal

   var description: String {
      return Self.formatter.string(from: amount as NSDecimalNumber) ?? ""
   }

   static func ==(lhs: DollarCurrency, rhs: DollarCurrency) -> Bool {
      return lhs.amount == rhs.amount
   }

   static func +(lhs: DollarCurrency, rhs: DollarCurrency) -> DollarCurrency {
      return DollarCurrency(amount: lhs.amount + rhs.amount)
   }

   static func *(lhs: Decimal, rhs: DollarCurrency) -> DollarCurrency {
      var decimal = rhs.amount
      var multiplier = lhs
      var result: Decimal = 0
      NSDecimalMultiply(&result, &decimal, &multiplier, .plain)
      return DollarCurrency(amount: result)
   }

   static func *(lhs: Int, rhs: DollarCurrency) -> DollarCurrency {
      return Decimal(lhs) * rhs
   }
}

extension DollarCurrency: ExpressibleByFloatLiteral {
   init(floatLiteral value: Double) {
      self.amount = Decimal(value)
   }
}

extension DollarCurrency: ExpressibleByIntegerLiteral {
   init(integerLiteral value: IntegerLiteralType) {
      self.amount = Decimal(value)
   }
}
