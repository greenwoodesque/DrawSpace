//
//  Persistance.swift
//  drawSpace-ios
//
//  Created by David Greenwood on 7/29/20.
//  Copyright © 2020 David Greenwood. All rights reserved.
//

import UIKit

final class Persistance {
    
    static let shared = Persistance()
    
    private let rootDirectoryName = "drawSpace"

    private var rootDirectory: URL? {
        guard let url = FileManager.default.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else {
                    return nil
        }
        return url.appendingPathComponent(rootDirectoryName)
    }
        
    func getAllDrawings(success: ([Drawing])->Void, failure: (Error)->Void) {
        var drawings: [Drawing] = []
        
        guard let rootDirectory = rootDirectory else {return}
        let rootPath = rootDirectory.absoluteString
        
        do {
            if !FileManager.default.fileExists(atPath: rootPath) {
                do {
                    try FileManager.default.createDirectory(at: rootDirectory, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    print("Error creating drawings directory.")
                    failure(error)
                    return
                }
            }
            let urls = try FileManager.default.contentsOfDirectory(at: rootDirectory, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            for url in urls {
                if let drawing = try? retrieveMetadata(at: url) {
                    drawings.append(drawing)
                }
            }
            success(drawings)
        } catch {
            failure(error)
        }
    }
    
    func save(drawing: Drawing, image: UIImage) throws {
        guard let drawingDir = rootDirectory?.appendingPathComponent(drawing.id) else {
            return
        }
        do {
            do {
                try FileManager.default.createDirectory(at: drawingDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("Error creating id directory.")
                return
            }
            try store(metadata: drawing)
            try store(image: image, forKey: drawing.id)
        }
    }

    func delete(drawing: Drawing) throws {
        if let path = rootFileUrl(key: drawing.id) {
            try FileManager.default.removeItem(at: path)
        }
    }
    
    private func store(metadata drawing: Drawing) throws {
        guard let url = metadataFileUrl(key: drawing.id) else {
            return
        }
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(drawing)
            try data.write(to: url)
        } catch {
            print(error)
        }
    }
    
    private func store(image: UIImage, forKey key: String) throws {
        guard let data = image.pngData(),
            let url = imageFileUrl(key: key) else {
                return
        }
        do {
            try data.write(to: url)
        } catch {
            print(error)
        }
    }
      
    private func retrieveMetadata(at url: URL) throws -> Drawing? {
        let file = url.appendingPathComponent("metadata")
        do {
            let data = try Data(contentsOf: file)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(Drawing.self, from: data)
            return jsonData
        } catch {
            print(error)
        }
        return nil
    }
    
    func retrieveImage(forKey key: String, completion: (UIImage)->Void) {
        if let path = imageFileUrl(key: key),
            let fileData = FileManager.default.contents(atPath: path.path),
            let image = UIImage(data: fileData) {
                completion(image)
            }
    }
    
    private func rootFileUrl(key: String) -> URL? {
        guard let url = rootDirectory else { return nil }
        return url.appendingPathComponent(key, isDirectory: true)
    }
    
    private func imageFileUrl(key: String) -> URL? {
        if let url = rootFileUrl(key: key) {
            return url.appendingPathComponent("image.png")
        }
        return nil
    }
    
    private func metadataFileUrl(key: String) -> URL? {
        if let url = rootFileUrl(key: key) {
            return url.appendingPathComponent("metadata")
        }
        return nil
    }
}

