//
//  XCTestCase+AssertMemoryLeaks.swift
//  PlatzyChallenge
//
//  Created by Rafael Aviles Puebla on 11/07/23.
//

import Foundation
import XCTest

extension XCTestCase {
  
  func assertMemoryLeak(instance: AnyObject, file: StaticString, line: UInt) {
    addTeardownBlock { [weak instance] in
      XCTAssertNil(instance, "Expected \(String(describing:instance)) to be deallocated. ¡Potential memory leak!⚠️", file: file, line: line)
    }
  }
}
