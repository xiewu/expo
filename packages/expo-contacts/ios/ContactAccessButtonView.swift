// Copyright 2024-present 650 Industries. All rights reserved.

import ContactsUI
import SwiftUI
import ExpoModulesCore

class AccessButtonProps: ExpoSwiftUI.ViewProps {
  @Field var queryString: String = ""
  @Field var padding: CGFloat = 0
}

internal struct ContactAccessButtonView: ExpoSwiftUI.View {
  @EnvironmentObject var props: AccessButtonProps

  @State private var isPickerPresented = false

  var body: some View {
    if #available(iOS 18.0, *) {
      ContactAccessButton(queryString: props.queryString)
        .padding()
        .buttonStyle(.bordered)
        .border(.background)
        .contactAccessButtonStyle(.init(imageColor: .indigo))
        .contactAccessButtonCaption(.email)
        .contactAccessPicker(isPresented: $isPickerPresented)

      Button("Choose more contacts") {
        isPickerPresented.toggle()
      }
    } else {
      // Fallback on earlier versions
      EmptyView()
    }
  }
}
