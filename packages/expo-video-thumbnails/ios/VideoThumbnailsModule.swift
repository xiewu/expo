import ExpoModulesCore
import AVFoundation
import UIKit
import CoreGraphics

public class VideoThumbnailsModule: Module {
  public func definition() -> ModuleDefinition {
    Name("ExpoVideoThumbnails")

    AsyncFunction("getThumbnail", getVideoThumbnail)
    AsyncFunction("getThumbnails", getVideoThumbnails)

    Class(VideoThumbnail.self) {
      Property("uri", \.uri?.absoluteString)
      Property("width", \.image.width)
      Property("height", \.image.height)
      Property("requestedTime", \.requestedTime.seconds)
      Property("actualTime", \.actualTime.seconds)
    }
  }

  internal func getVideoThumbnails(sourceFilename: URL, options: VideoThumbnailsOptions) async throws -> [VideoThumbnail] {
    if sourceFilename.isFileURL {
      guard FileSystemUtilities.permissions(appContext, for: sourceFilename).contains(.read) else {
        throw FileSystemReadPermissionException(sourceFilename.absoluteString)
      }
    }

    let asset = AVURLAsset.init(url: sourceFilename, options: ["AVURLAssetHTTPHeaderFieldsKey": options.headers])
    let generator = AVAssetImageGenerator.init(asset: asset)

    generator.appliesPreferredTrackTransform = true
    generator.requestedTimeToleranceAfter = CMTime.zero

    let time = CMTimeMake(value: options.time, timescale: 1000)

    // `requestedTimeToleranceBefore` can only be set if `time` is less
    // than the video duration, otherwise it will fail to generate an image.
    if time < asset.duration {
      generator.requestedTimeToleranceBefore = .zero
    }
    return try await generateThumbnails(generator: generator, at: [time])
  }

  internal func getVideoThumbnail(sourceFilename: URL, options: VideoThumbnailsOptions) async throws -> VideoThumbnail {
    return try await getVideoThumbnails(sourceFilename: sourceFilename, options: options).first!
  }
}

fileprivate func generateThumbnails(generator: AVAssetImageGenerator, at times: [CMTime]) async throws -> [VideoThumbnail] {
  if #available(iOS 16, *) {
    return try await generator
      .images(for: times)
      .reduce(into: [VideoThumbnail]()) { thumbnails, result in
        let thumbnail = try VideoThumbnail(result.image, requestedTime: result.requestedTime, actualTime: result.actualTime)
        thumbnails.append(thumbnail)
      }
  }
  return try await VideoThumbnailGenerator(generator: generator, times: times)
    .reduce(into: [VideoThumbnail]()) { thumbnails, thumbnail in
      thumbnails.append(thumbnail)
    }
}
