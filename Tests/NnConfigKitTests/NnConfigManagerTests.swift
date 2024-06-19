//
//  NnConfigManagerTests.swift
//
//
//  Created by Nikolai Nobadi on 6/19/24.
//

import Files
import XCTest
import NnTestHelpers
@testable import NnConfigKit

final class NnConfigManagerTests: XCTestCase {
    override func setUpWithError() throws {
        try super.setUpWithError()
        try cleanConfigFolders()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        try cleanConfigFolders()
    }
}


// MARK: - Default Config Folder Tests
extension NnConfigManagerTests {
    func test_loadConfig_defaultConfigFolder_throwsErrorWhenMissingConfig() {
        saveConfig(CustomConfig())
        
        XCTAssertThrowsError(try NnConfigManager<DefaultConfig>().loadConfig())
    }
    
    func test_saveConfig_loadConfig_saveUpdated_defaultConfigFolder() throws {
        let customConfig = DefaultConfig()
        let updatedConfig = DefaultConfig(secondSetting: "newSetting")
        
        try runSaveLoadUpdateTest(for: customConfig, updatedConfig: updatedConfig)
    }
}


// MARK: - Custom Folder Tests
extension NnConfigManagerTests {
    func test_loadConfig_customConfigFolder_throwsErrorWhenMissingConfig() throws {
        saveConfig(DefaultConfig())
        
        XCTAssertThrowsError(try NnConfigManager<CustomConfig>().loadConfig())
    }
    
    func test_saveConfig_customConfigFolder() throws {
        let customConfig = CustomConfig()
        let updatedConfig = CustomConfig(secondSetting: "newSetting")
        
        try runSaveLoadUpdateTest(for: customConfig, updatedConfig: updatedConfig)
    }
}


// MARK: - Helper Classes
extension NnConfigManagerTests {
    class BaseConfig: Codable, Equatable {
        static func == (lhs: NnConfigManagerTests.BaseConfig, rhs: NnConfigManagerTests.BaseConfig) -> Bool {
            return lhs.firstSetting == rhs.firstSetting && lhs.secondSetting == rhs.secondSetting
        }
        
        var firstSetting: Int
        var secondSetting: String
        
        init(firstSetting: Int = 0, secondSetting: String = "something to remember") {
            self.firstSetting = firstSetting
            self.secondSetting = secondSetting
        }
    }
    
    class DefaultConfig: BaseConfig, NnConfig  {
        static var projectName: String = "DefaultNnConfigKitTestProject"
    }
    
    class CustomConfig: BaseConfig, NnConfig {
        static var projectName: String = "CustomNnConfigKitTestProject"
        static var configFolderPath: String {
            "\(Folder.temporary.path).testConfig/NnConfigList/\(projectName)"
        }
        
        static var configFileName: String {
            return "\(projectName)-custom.json"
        }
    }
}


// MARK: - Assertion Helpers
extension NnConfigManagerTests {
    func runSaveLoadUpdateTest<Config: NnConfig & Equatable>(for config: Config, updatedConfig: Config) throws {
        let sut = NnConfigManager<Config>()
        
        try sut.saveConfig(config)
        
        let loadedConfig = try sut.loadConfig()
        
        XCTAssertEqual(config, loadedConfig)
        XCTAssertNotEqual(config, updatedConfig)
        
        try sut.saveConfig(updatedConfig)
        
        let loadedUpdatedConfig = try sut.loadConfig()
        XCTAssertEqual(updatedConfig, loadedUpdatedConfig)
        XCTAssertNotEqual(loadedConfig, loadedUpdatedConfig)
    }
}


// MARK: - Helper Methods
private extension NnConfigManagerTests {
    func saveConfig<Config: NnConfig>(_ config: Config, file: StaticString = #filePath, line: UInt = #line) {
        assertNoErrorThrown(
            action: { try NnConfigManager<Config>().saveConfig(config) },
            file: file, line: line
        )
    }
    
    func cleanConfigFolders() throws {
        try deleteExistingFolder(path: CustomConfig.configFolderPath)
        try deleteExistingFolder(path: DefaultConfig.configFolderPath)
    }
    
    func deleteExistingFolder(path: String) throws {
        if let defaultFolder = try? Folder(path: path) {
            try defaultFolder.delete()
        }
    }
}
