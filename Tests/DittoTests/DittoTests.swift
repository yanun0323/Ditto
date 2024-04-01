import XCTest
import Combine
@testable import Ditto

final class DittoTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertNotEqual(Date.zero, Date(2024, 1, 23, 0, 0, 0))
    }
    
    func testAVLTree() throws {
        let avl = AVLTree<Int, Int>()
    
        let elem = [Int](Array(1...10))
        elem.forEach { i in
            avl.insert(key: i)
        }
        
        var acendResult = [Int]()
        var descendResult = [Int]()
        
        avl.ascend { i, _ in
            acendResult.append(i)
        }
        
        avl.descend { i, _ in
            descendResult.append(i)
        }
        
        XCTAssertEqual(elem, acendResult)
        XCTAssertEqual(elem.reversed(), descendResult)
    }
    
    #if os(macOS)
    func testCommand() throws {
        var count = 0
        let limitation = 3
        System.shell("/usr/local/bin/ollama 123") { err in
            print("err: \(err)")
        } receive: { msg in
            print("msg: \(msg)")
        }
        
        while count < limitation {
            count += 1
            sleep(1)
        }
    }
    #endif
}
