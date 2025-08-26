import Foundation

// swiftlint:disable all
extension Substring {
    func _rangeOfCharacter(from set: CharacterSet, options: String.CompareOptions) -> Range<Index>? {
        guard !isEmpty else { return nil }

        return unicodeScalars._rangeOfCharacter(anchored: options.contains(.anchored), backwards: options.contains(.backwards), matchingPredicate: set.contains)
    }
}

extension Substring.UnicodeScalarView {
    func _rangeOfCharacter(anchored: Bool, backwards: Bool, matchingPredicate predicate: (Unicode.Scalar) -> Bool) -> Range<Index>? {
        guard !isEmpty else { return nil }

        let fromLoc: String.Index
        let toLoc: String.Index
        let step: Int
        if backwards {
            fromLoc = index(before: endIndex)
            toLoc = anchored ? fromLoc : startIndex
            step = -1
        } else {
            fromLoc = startIndex
            toLoc = anchored ? fromLoc : index(before: endIndex)
            step = 1
        }

        var done = false
        var found = false

        var idx = fromLoc
        while !done {
            let ch = self[idx]
            if predicate(ch) {
                done = true
                found = true
            } else if idx == toLoc {
                done = true
            } else {
                formIndex(&idx, offsetBy: step)
            }
        }

        guard found else { return nil }
        return idx ..< index(after: idx)
    }
}

// swiftlint:enable all
