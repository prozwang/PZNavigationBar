//
//  PZNavigator.swift
//  Navigator
//
//  Created by CIB on 2021/12/22.
//

import Foundation
import UIKit

public struct Navigation<Base> {
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

public protocol NavigationCompatible: AnyObject {
    associatedtype CompatibleType
    var navigation: CompatibleType { get }
}

public extension NavigationCompatible {
    var navigation: Navigation<Self> {
        return Navigation(self)
    }
}
