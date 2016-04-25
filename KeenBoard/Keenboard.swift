//
//  Keenboard.swift
//  KeenBoard
//
//  Created by Daniel Visan Levine on 4/25/16.
//  Copyright © 2016 D-Line. All rights reserved.
//

import UIKit

// The view controller will adopt this protocol (delegate)
// and thus must contain the keyWasTapped method
protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
}

class Keenboard: NSObject {

}
