//
//  CreditCardDetails.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/13/25.
//

import Foundation
import Combine
import AsyncNavigation

enum CreditCardDetails {
   class ViewModel: BaseViewModel<CreditCardInfo> {
      @Published var cardHolderName = "" { didSet { updateResult() } }
      @Published var cardNumber = "" { didSet { updateResult() } }
      @Published var expDateMonthText = "" { didSet { updateResult() } }
      @Published var expDateYearText = "" { didSet { updateResult() } }
      @Published var cvv = "" { didSet { updateResult() } }

      var result: CreditCardInfo?

      func updateResult() {
         guard !cardHolderName.isEmpty else {
            result = nil
            return
         }
         guard !cardNumber.isEmpty else {
            result = nil
            return
         }
         guard let expDateMonth = Int(expDateMonthText), (1...12).contains(expDateMonth) else {
            result = nil
            return
         }
         guard let expDateYear = Int(expDateYearText), (1000...9999).contains(expDateYear) else {
            result = nil
            return
         }
         guard !cvv.isEmpty else {
            result = nil
            return
         }

         result = .init(
            cardHolderName: cardHolderName,
            number: cardNumber,
            expDateMonth: expDateMonth,
            expDateYear: expDateYear,
            cvc: cvv
         )
      }

      var nextButtonEnabled: Bool {
         result != nil
      }

      func done() {
         guard let result else { return }
         publish(result)
      }
   }
}

