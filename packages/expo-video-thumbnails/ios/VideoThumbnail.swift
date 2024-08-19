// Copyright 2024-present 650 Industries. All rights reserved.

import CoreImage
import CoreGraphics
import ExpoModulesCore

public class VideoThumbnail: SharedRef<CGImage> {
  var image: CGImage {
    return ref
  }
  var requestedTime: CMTime
  var actualTime: CMTime

  var savedImageUrl: URL?

  private var _uri: URL?

  var uri: URL? {
    get {
      if let _uri {
        return _uri
      }
      _uri = try? saveImage()
      return _uri
    }
  }

  public init(_ ref: CGImage, requestedTime: CMTime, actualTime: CMTime) {
    self.requestedTime = requestedTime
    self.actualTime = actualTime
    super.init(ref)
  }

  /**
   Saves the image as a file.
   */
  internal func saveImage() throws -> URL {
    let directory = appContext?.config.cacheDirectory?.appendingPathComponent("VideoThumbnails")
    let fileName = UUID().uuidString.appending(".jpg")
    let fileUrl = directory?.appendingPathComponent(fileName)

    FileSystemUtilities.ensureDirExists(at: directory)

    guard let fileUrl else {
      throw ImageWriteFailedException("Unrecognized url \(String(describing: fileUrl?.path))")
    }

    let imageContext = CIContext()
    let ciImage = CIImage(cgImage: image)
    let colorSpace = ciImage.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!

    do {
      try imageContext.writeJPEGRepresentation(of: ciImage, to: fileUrl, colorSpace: colorSpace)
    } catch let error {
      throw ImageWriteFailedException(error.localizedDescription)
    }

    return fileUrl
  }
}
