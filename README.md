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

USAGE: fixed-size-array-generator <count> [--output-file <output-file>] [--visibility <visibility>]

ARGUMENTS:
  <count>                 The element count of the generated type.

OPTIONS:
  --output-file <output-file>
                          The output file.
  --visibility <visibility>
                          Generate a public type declaration. (default: internal)
  -h, --help              Show help information.


```

---

```console
> generate-fixed-size-array 3
```

```swift
import FixedSizeArray

extension Array3: Decodable where Element: AdditiveArithmetic & Decodable {}
extension Array3: Encodable where Element: Encodable {}
extension Array3: Equatable where Element: Equatable {}
extension Array3: ExpressibleByArrayLiteral where Element: AdditiveArithmetic {}
extension Array3: Hashable where Element: Hashable {}

struct Array3<Element>: FixedSizeArray {
    typealias Index = Int
    
    static var count: Int { 3 }
    
    private var storage: (Element, Element, Element)
    
    init(repeating element: Element) {
        storage = (element, element, element)
    }
    
    init(_ e0: Element, _ e1: Element, _ e2: Element) {
        storage = (e0, e1, e2)
    }
}
```

## Package Manager Plugin

```
MyPackage
 ├ Package.swift
 └ Sources
    └ MyTarget
       ├ fixed-size-arrays.json
       └ MyTarget.swift
```


```swift
// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "my-package",
    dependencies: [
        .package(
            url: "https://github.com/nixberg/fixed-size-array-swift",
            .upToNextMinor(from: "0.3.0")),
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
        "count": 3,
        "visibility": "internal"
    },
    {
        "count": 9,
        "visibility": "public"
    }
]
```
