//
//  File.swift
//  
//
//  Created by Nikolai Nobadi on 5/5/24.
//

import XCTest
@testable import NnConfigGenKit

final class ConfigPathFactoryTests: XCTestCase {
    func test_makeConfigFilePath() {
        let projectName = "project"
        let sut = makeSUT()
        let filePath = sut.makeConfigFilePath(projectName: projectName)
        let filePathWithHomeDirectory = sut.makeConfigFilePath(projectName: projectName, withHomeDirectory: true)
        
        XCTAssertNotEqual(filePath, filePathWithHomeDirectory)
        XCTAssertTrue(filePath.contains(projectName.withJSONExtension))
        XCTAssertTrue(filePathWithHomeDirectory.contains(projectName.withJSONExtension))
    }
}


// MARK: - SUT
extension ConfigPathFactoryTests {
    func makeSUT() -> ConfigPathFactory.Type {
        return ConfigPathFactory.self
    }
}
