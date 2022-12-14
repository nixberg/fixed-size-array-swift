[![Swift](https://github.com/nixberg/fixed-size-array-swift/actions/workflows/swift.yaml/badge.svg)](
https://github.com/nixberg/fixed-size-array-swift/actions/workflows/swift.yaml)

# fixed-size-array-swift

This package provides a code generation tool, a runtime library and a SPM plugin for working with
fixed-size arrays in Swift.

## Example

## Code Generation

```consols
> generate-fixed-size-array --help
OVERVIEW: Generate a fixed-size array implementation for Swift.

USAGE: fixed-size-array-generator <count> [--element <element>] [--name <name>] [--conformance <conformance> ...] [--output-file <output-file>] [--public]

ARGUMENTS:
  <count>                 The element count of the generated type.

OPTIONS:
  --element <element>     The element type of the generated type. By default, the type is generic.
  --name <name>           The name of the generated type. (default: "Array\(count)")
  --conformance <conformance>
                          A protocol the generated type will conform to. Ignored when the type is
                          generic.
  --output-file <output-file>
                          The output file.
  --public                Generate a public type declaration.
  --version               Show the version.
  -h, --help              Show help information.
```

---

```console
> generate-fixed-size-array 3
```

```swift
import FixedSizeArray

struct Array3<Element>: FixedSizeArray {

    typealias Index = Int
    
    private var storage: (
        Element, Element, Element
    )
    
    @inline(__always)
    static var indices: Range<Index> {
        0..<3
    }
    
    @inline(__always)
    init(repeating element: Element) {
        storage = (
            element, element, element
        )
    }
    
    @inline(__always)
    init(
        _ e0: Element,
        _ e1: Element,
        _ e2: Element
    ) {
        storage = (
            e0,
            e1,
            e2
        )
    }
}

extension Array3: Decodable where Element: AdditiveArithmetic & Decodable {}

extension Array3: Encodable where Element: Encodable {}

extension Array3: Equatable where Element: Equatable {}

extension Array3: ExpressibleByArrayLiteral where Element: AdditiveArithmetic {}

extension Array3: Hashable where Element: Hashable {}

extension Array3: Sendable where Element: Sendable {}

#if canImport(Subtle)
import Subtle

extension Array3: ConstantTimeEquatable where Element: ConstantTimeEquatable {}
        
extension Array3: ConstantTimeSortable
where Element: ConstantTimeGreaterThan & ConditionallyReplaceable {}

extension Array3: Zeroizable where Element: Zeroizable {}
#endif
```

---

```console
> generate-fixed-size-array --conformance Hashable --conformance MyProtocol --element UInt8 --name MyType --public 3
```

```swift
@_exported import FixedSizeArray

public struct MyType: FixedSizeArray {
    
    public typealias Element = UInt8

    public typealias Index = Int
    
    private var storage: (
        Element, Element, Element
    )
    
    @inline(__always)
    public static var indices: Range<Index> {
        0..<3
    }
    
    @inline(__always)
    public init(repeating element: Element) {
        storage = (
            element, element, element
        )
    }
    
    @inline(__always)
    public init(
        _ e0: Element,
        _ e1: Element,
        _ e2: Element
    ) {
        storage = (
            e0,
            e1,
            e2
        )
    }
}

extension MyType: Hashable {}

extension MyType: MyProtocol {}
```

## Package Manager Plugin

```
MyPackage
 ??? Package.swift
 ??? Sources
    ??? MyTarget
       ??? fixed-size-arrays.json
       ??? MyTarget.swift
```


```swift
// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "my-package",
    platforms: [
        .macOS(.v13),
    ],
    dependencies: [
        .package(url: "https://github.com/nixberg/fixed-size-array-swift", "0.1.0"..<"0.2.0"),
    ],
    targets: [
        .target(
            name: "MyTarget",
            dependencies: [
                .product(name: "FixedSizeArray", package: "fixed-size-array-swift"),
            ],
            exclude: ["fixed-size-arrays.json"],
            plugins: [
                .plugin(name: "FixedSizeArrayGeneratorPlugin", package: "fixed-size-array-swift"),
            ]),
    ]
)
```

```json
[
    {
        "count": 3
    },
    {
        "count": 9,
        "visibility": "public"
    }
]
```
