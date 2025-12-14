//
//  Coupon.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/13/25.
//

struct Coupon {
   let code: String
   let discount: Double

   static let available: [Coupon] = [
      .init(code: "TRA", discount: 1.0),
      .init(code: "MVVM", discount: 0.75),
      .init(code: "TCA", discount: 0.1),
   ]
}
