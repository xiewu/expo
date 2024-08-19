// Copyright 2024-present 650 Industries. All rights reserved.

import AVFoundation

/**
 A replacement for the `AVAssetImageGenerator.images(for:)` async iterator that is available only as of iOS 16.
 */
struct VideoThumbnailGenerator: AsyncSequence, AsyncIteratorProtocol {
  typealias Element = VideoThumbnail

  let generator: AVAssetImageGenerator
  let times: [CMTime]
  var currentIndex: Int = 0

  mutating func next() async throws -> Element? {
    guard currentIndex < times.count, !Task.isCancelled else {
      return nil
    }
    let requestedTime = times[currentIndex]
    var actualTime: CMTime = .zero
    let image = try generator.copyCGImage(at: requestedTime, actualTime: &actualTime)

    currentIndex += 1

    return VideoThumbnail(image, requestedTime: requestedTime, actualTime: actualTime)
  }

  func makeAsyncIterator() -> Self {
    return self
  }

}
