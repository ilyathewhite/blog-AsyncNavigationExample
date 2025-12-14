//
//  RadioGroup.swift
//  Example
//
//  Created by Ilya Belenkiy on 12/13/25.
//

import SwiftUI

struct RadioButtonRow<Label: View>: View {
    let isSelected: Bool
    let action: () -> Void
    @ViewBuilder var label: () -> Label

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                     .foregroundStyle(Color.accentColor)
                    .imageScale(.large)

                label()
                    .foregroundStyle(.primary)

                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .padding(.vertical, 6)
    }
}

struct RadioGroup<Item: Hashable, Label: View>: View {
    let items: [Item]
    @Binding var selection: Item?
    let labelForItem: (Item) -> Label

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(items, id: \.self) { item in
                RadioButtonRow(isSelected: selection == item, action: {
                    selection = item
                }) {
                    labelForItem(item)
                }
            }
        }
    }
}

#Preview("RadioGroup Preview") {
   struct DemoItem: Hashable {
      let id = UUID()
      let title: String
   }
   @Previewable @State var items: [DemoItem] =
      ["Visa", "Mastercard", "Amex", "PayPal"].map { DemoItem(title: $0) }
   @Previewable @State var selection: DemoItem? = nil

    return NavigationStack {
        VStack(alignment: .leading, spacing: 16) {
            Text("Choose a payment method")
                .font(.headline)

            RadioGroup(items: items, selection: $selection) { item in
                Text(item.title)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Preview")
    }
}
