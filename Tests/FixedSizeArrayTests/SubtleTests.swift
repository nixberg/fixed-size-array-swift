import Subtle
import XCTest

final class SubtleTests: XCTestCase {
    func testConstantTimeEquatable() throws {
        let a: Array3 = [1, 2, 3]
        let b: Array3 = [0, 1, 3]
        
        XCTAssertTrue(Bool(Choice(a == a)))
        XCTAssertFalse(Bool(Choice(a != a)))
        
        XCTAssertFalse(Bool(Choice(a == b)))
        XCTAssertTrue(Bool(Choice(a != b)))
    }
    
    func testConstantTimeSortable() throws {
        var a: Array3<UInt> = [3, 1, 2]
        a.sortInConstantTime()
        XCTAssertEqual(a, [1, 2, 3])
    }
    
    func testZeroizable() throws {
        var a: Array3 = [1, 2, 3]
        a.zeroize()
        XCTAssertEqual(a, .init(repeating: 0))
        
        var b: Array9<UInt8> = .init(repeating: 11)
        b.zeroize()
        XCTAssertEqual(b, .init(repeating: 0))
    }
}
