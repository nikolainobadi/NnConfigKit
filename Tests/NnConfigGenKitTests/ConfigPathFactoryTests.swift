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
        let configFolderPath = sut.makeConfigListFolderPath()
        let projectConfigFolderPath = sut.makeProjectConfigFolderPath(projectName: projectName)
        let projectConfigFilePath = sut.makeProjectConfigFilePath(projectName: projectName)
        
        XCTAssertTrue(configFolderPath.contains(ConfigPathFactory.configListPathSuffix))
        XCTAssertFalse(configFolderPath.contains(projectName))
        XCTAssertTrue(projectConfigFolderPath.contains(projectName))
        XCTAssertFalse(projectConfigFolderPath.contains(projectName.withJSONExtension))
        XCTAssertTrue(projectConfigFilePath.contains(projectName.withJSONExtension))
    }
}


// MARK: - SUT
extension ConfigPathFactoryTests {
    func makeSUT() -> ConfigPathFactory.Type {
        return ConfigPathFactory.self
    }
}
