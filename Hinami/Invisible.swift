//
//  Invisible.swift
//  Hinami
//
//  Created by Ryusei Wada on 2021/11/27.
//

import Foundation

import SwiftUI

struct Invisible: ViewModifier {
    let invisible: Bool

    func body(content: Content) -> some View {
        VStack {
            if invisible {
                content
                    .opacity(0)
                    .contentShape(Rectangle())
            } else {
                content.opacity(100)
            }
        }
    }
}

extension View {
    /**
     引数にBool型をとり、Viewの表示・非表示を変更する
     
     非表示の場合は画面上に表示されなくなる（存在は残る）
     */
    func isInvisible(_ isInvisible: Bool) -> some View {
        ModifiedContent(content: self, modifier: Invisible(invisible: isInvisible))
    }
}
