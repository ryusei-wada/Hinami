//
//  Hidden.swift
//  Hinami
//
//  Created by Ryusei Wada on 2021/11/27.
//

import Foundation
import SwiftUI

struct Hidden: ViewModifier {
    let hidden: Bool

    func body(content: Content) -> some View {
        VStack {
            if !hidden {
                content
            }
        }
    }
}

extension View {
    /**
     引数にBool型をとり、Viewの表示・非表示を変更する
     
     非表示の場合は存在そのものがなくなる
     */
    func isHidden(_ isHidden: Bool) -> some View {
        ModifiedContent(content: self, modifier: Hidden(hidden: isHidden))
    }
}
