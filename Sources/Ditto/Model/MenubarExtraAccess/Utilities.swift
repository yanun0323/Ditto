//
//  Utilities.swift
//  MenuBarExtraAccess • https://github.com/orchetect/MenuBarExtraAccess
//  © 2023 Steffan Andrews • Licensed under MIT License
//

#if os(macOS)
import Foundation

extension String {
    /// Captures the output of `dump()` for the passed object instance.
    init(dump object: Any) {
        var dumpOutput = String()
        dump(object, to: &dumpOutput)
        self = dumpOutput
    }
}
#endif
