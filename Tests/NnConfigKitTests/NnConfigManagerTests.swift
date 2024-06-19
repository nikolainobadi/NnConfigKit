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
    let sampleTextLines = ["first", "second", "third"]
    
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
    
    func test_saveNestedConfigFile_deleteNestedConfigFile_defaultConfigFolder() throws {
        let nestedFilePath = "NestedFolder/NestedFile"
        let completeFilePath = "\(DefaultConfig.configFolderPath)/\(nestedFilePath)"
        let sut = NnConfigManager<DefaultConfig>()
        let contents = makeNestedContent()
        
        XCTAssertNil(try? File(path: completeFilePath))
        
        try sut.saveNestedConfigFile(contents: contents, nestedFilePath: nestedFilePath)
        
        XCTAssertNotNil(try? File(path: completeFilePath))
        
        try sut.deletedNestedConfigFile(nestedFilePath: nestedFilePath)
        
        XCTAssertNil(try? File(path: completeFilePath))
    }
    
    func test_nestedFileOperations_defaultConfigFolder() throws {
        let newLine = "new line"
        let contents = makeNestedContent()
        let existingLine = sampleTextLines[0]
        let nestedFilePath = "NestedFolder/NestedFile"
        let completeFilePath = "\(DefaultConfig.configFolderPath)/\(nestedFilePath)"
        let sut = NnConfigManager<DefaultConfig>()
        
        XCTAssertNil(try? File(path: completeFilePath))
        
        try sut.saveNestedConfigFile(contents: contents, nestedFilePath: nestedFilePath)
        try sut.appendTextToNestedConfigFileIfNeeded(text: existingLine, nestedFilePath: nestedFilePath, asNewLine: true)
        
        assertPropertyEquality(try? File(path: completeFilePath).readAsString(), expectedProperty: contents)
        
        try sut.appendTextToNestedConfigFileIfNeeded(text: newLine, nestedFilePath: nestedFilePath, asNewLine: true)
        
        assertProperty(try? File(path: completeFilePath).readAsString()) { newContents in
            XCTAssert(newContents.contains(newLine))
        }
        
        try sut.removeTextFromNestedConfigFile(text: existingLine, nestedFilePath: nestedFilePath)
        
        assertProperty(try? File(path: completeFilePath).readAsString()) { newContents in
            XCTAssert(newContents.contains(newLine))
            XCTAssertFalse(newContents.contains(existingLine))
        }
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
    func makeNestedContent() -> String {
        return sampleTextLines.joined(separator: "\n")
    }
    
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
