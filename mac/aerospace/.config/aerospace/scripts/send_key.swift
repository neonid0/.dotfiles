import CoreGraphics
import Foundation

let args = CommandLine.arguments
guard args.count == 3 else {
    print("Usage: send_key <keycode> <modifiers>")
    print("  modifiers: 0=none, 1048576=cmd, 524288=opt, 131072=shift, 262144=ctrl")
    exit(1)
}

let keycode = CGKeyCode(Int(args[1])!)
let modifiers = CGEventFlags(rawValue: UInt64(args[2])!)

let src = CGEventSource(stateID: .hidSystemState)
let down = CGEvent(keyboardEventSource: src, virtualKey: keycode, keyDown: true)!
let up   = CGEvent(keyboardEventSource: src, virtualKey: keycode, keyDown: false)!

down.flags = modifiers
up.flags   = modifiers

down.post(tap: .cghidEventTap)
up.post(tap: .cghidEventTap)
