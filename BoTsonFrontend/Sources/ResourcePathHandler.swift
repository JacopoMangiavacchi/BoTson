//
//  ResourcePathHandler.swift
//  ResourcePathHandler
//
//  Created by Jacopo Mangiavacchi on 10/3/16.
//  Cloned by Kitura
//

import Foundation
import Kitura
import LoggerAPI



class ResourcePathHandler {
    static private let separatorCharacter: Character = "/"
    static private let separator = String(separatorCharacter)
    
    static func getAbsolutePath(for path: String) -> String {
        var path = path
        if path.hasSuffix(separator) {
            path = String(path.characters.dropLast())
        }
        
        // If we received a path with a tilde (~) in the front, expand it.
        path = NSString(string: path).expandingTildeInPath
        
        if isAbsolute(path: path) {
            return path
        }
        
        
        let fileManager = FileManager()
        
        let absolutePath = fileManager.currentDirectoryPath + separator + path
        if fileManager.fileExists(atPath: absolutePath) {
            return absolutePath
        }
        
        // the file does not exist on a path relative to the current working directory
        // return the path relative to the original repository directory
        guard let originalRepositoryPath = getOriginalRepositoryPath() else {
            return absolutePath
        }
        
        return originalRepositoryPath + separator + path
    }
    
    static private func getOriginalRepositoryPath() -> String? {
        // this file is at
        // <original repository directory>/Sources/Kitura/staticFileServer/ResourcePathHandler.swift
        // the original repository directory is four path components up
        let currentFilePath = #file
        
        var pathComponents =
            currentFilePath.characters.split(separator: separatorCharacter).map(String.init)
        let numberOfComponentsFromKituraRepositoryDirectoryToThisFile = 4
        
        guard pathComponents.count >= numberOfComponentsFromKituraRepositoryDirectoryToThisFile else {
            Log.error("unable to get original repository path for \(currentFilePath)")
            return nil
        }
        
        pathComponents.removeLast(numberOfComponentsFromKituraRepositoryDirectoryToThisFile)
        pathComponents = removePackagesDirectory(pathComponents: pathComponents)
        
        return separator + pathComponents.joined(separator: separator)
    }
    
    static private func removePackagesDirectory(pathComponents: [String]) -> [String] {
        var pathComponents = pathComponents
        let numberOfComponentsFromKituraPackageToDependentRepository = 2
        let packagesComponentIndex = pathComponents.endIndex - numberOfComponentsFromKituraPackageToDependentRepository
        if pathComponents.count > numberOfComponentsFromKituraPackageToDependentRepository &&
            pathComponents[packagesComponentIndex] == "Packages" {
            pathComponents.removeLast(numberOfComponentsFromKituraPackageToDependentRepository)
        }
        return pathComponents
    }
    static private func isAbsolute(path: String) -> Bool {
        return path.hasPrefix(separator)
    }
    
    static private func isSeparator(_ string: String) -> Bool {
        return string == separator
    }
}
