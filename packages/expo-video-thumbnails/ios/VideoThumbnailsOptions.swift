import ExpoModulesCore

internal struct VideoThumbnailsOptions: Record {
  // Deprecated.
  @Field var quality: Double = 1.0

  // Deprecated, in milliseconds.
  @Field var time: Int64 = 0

  // New option for generating multiple thumbnails in one request.
  // Standardized to follow our rule to prefer using SI base units.
  @Field var times: [CMTime] = [.zero]

  // HTTP headers to pass in case the source is a remote URI.
  @Field var headers: [String: String] = [String: String]()
}

extension CMTime: Convertible {
  public static func convert(from value: Any?, appContext: ExpoModulesCore.AppContext) throws -> CMTime {
    if let seconds = value as? Double {
      return CMTime(seconds: seconds, preferredTimescale: .max)
    }
    throw Conversions.ConvertingException<CMTime>(value)
  }
}
