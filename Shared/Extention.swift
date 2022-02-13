//
//  Extention.swift
//  URLSession_async_await
//
//  Created by Borna Libertines on 11/02/22.
//
import Foundation
import SwiftUI

extension View {
    func hideNavigationBar() -> some View {
        modifier(HideNavigationBarModifier())
    }
}
struct HideNavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationBarTitle("")
    }
}
