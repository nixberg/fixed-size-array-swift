import XCTest

final class FixedArrayTests: XCTestCase {
    func test() throws {
        var a: Array3<Int> = [1, 2, 3]
        var b: Array3<Int> = .init(4, 2, 3)
        
        a.first = 4
        b.last = 9
        XCTAssertEqual(a.first, 4)
        XCTAssertEqual(a.last, 3)
        
        let c = a
        
        // TODO: Test Mirror.
        
        XCTAssertEqual(a.description, "[4, 2, 3]")
        XCTAssertEqual(a.debugDescription, "[4, 2, 3]")
        
        // TODO: Codable.
        
        XCTAssertEqual(a, c)
        XCTAssertNotEqual(a, b)
        
        XCTAssertEqual(a.hashValue, Array(a).hashValue)
        XCTAssertEqual(a.hashValue, c.hashValue)
        XCTAssertNotEqual(a.hashValue, b.hashValue)
        
        // TODO: ...
    }
}
