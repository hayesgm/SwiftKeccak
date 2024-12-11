import Foundation
@testable import SwiftKeccak
import Testing

func fromHex(_ hex: String) -> Data? {
    var hex = hex
    
    // Remove "0x" prefix if present
    if hex.hasPrefix("0x") {
        hex.removeFirst(2)
    }
    
    // Ensure even-length string
    if hex.count % 2 != 0 {
        hex = "0" + hex
    }

    var data = Data()
    var index = hex.startIndex
    
    while index < hex.endIndex {
        let nextIndex = hex.index(index, offsetBy: 2)
        if let byte = UInt8(hex[index..<nextIndex], radix: 16) {
            data.append(byte)
        } else {
            return nil // Invalid hex string
        }
        index = nextIndex
    }
    return data
}

let cases: [(String, String)] = [
    ("hello", "0x1c8aff950685c2ed4bc3174f3472287b56d9517b9c948127319a09a7a36deac8")
]

@Test("Keccak Tests", arguments: cases)
func testKeccak(case: (String, String)) {
    for (input, expected) in cases {
        let hash: Data = keccak256(input)
        let expectedData = fromHex(expected)
        #expect(hash == expectedData, "Keccak256(\(input)) should be \(expected)")
    }
}
