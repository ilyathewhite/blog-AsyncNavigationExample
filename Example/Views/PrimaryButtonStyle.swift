//
//  PrimaryButtonStyle.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/11/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
   @Environment(\.isEnabled) private var isEnabled
   var cornerRadius: CGFloat = 12
   var horizontalPadding: CGFloat = 16
   var verticalPadding: CGFloat = 8

   func makeBody(configuration: Configuration) -> some View {
      configuration.label
         .padding(.vertical, 3)
         .frame(minWidth: 200)
         .font(.headline)
         .foregroundStyle(isEnabled ? .white : .white.opacity(0.7))
         .padding(.vertical, verticalPadding)
         .padding(.horizontal, horizontalPadding)
         .background(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
               .fill(isEnabled ? Color.accentColor : Color.accentColor.opacity(0.5))
         )
         .opacity(configuration.isPressed && isEnabled ? 0.85 : 1.0)
         .scaleEffect(configuration.isPressed && isEnabled ? 0.99 : 1.0)
         .animation(.easeOut(duration: 0.12), value: configuration.isPressed && isEnabled)
   }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
   static var primary: PrimaryButtonStyle { .init() }
}
