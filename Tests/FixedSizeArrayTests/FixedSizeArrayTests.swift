import XCTest

public typealias TestVisibilty = Array9

final class FixedArrayTests: XCTestCase {
    func testArray3() throws {
        var a: Array3<Int> = [1, 2, 3]
        var b = Array3(4, 2, 3)
        
        XCTAssertEqual(Array3<Int>.count, 3)
        
        XCTAssertEqual(a.startIndex, 0)
        XCTAssertEqual(a.endIndex, 3)
        XCTAssertEqual(a.indices, 0..<3)
        XCTAssertEqual(a.count, 3)
        
        XCTAssertEqual(a.hashValue, Array(a).hashValue)
        a[0] = 4
        b[2] = 9
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
        
        // TODO: ....
    }
}
