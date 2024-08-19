import { SharedRef } from 'expo';

/**
 * @deprecated Deprecated in favor of [`VideoThumbnail`](#videothumbnail).
 */
export type VideoThumbnailsResult = {
  /**
   * URI to the created image (usable as the source for an Image/Video element).
   */
  uri: string;
  /**
   * Width of the created image.
   */
  width: number;
  /**
   * Height of the created image.
   */
  height: number;
};

export type VideoThumbnailsOptions = {
  /**
   * A value in range `0.0` - `1.0` specifying quality level of the result image. `1` means no
   * compression (highest quality) and `0` the highest compression (lowest quality).
   */
  quality?: number;
  /**
   * The time position where the image will be retrieved in ms.
   * @deprecated Deprecated in favor of the new `times` option that allows requesting for multiple thumbnails.
   * Note that this new array is defined in seconds, the SI base unit for time.
   */
  time?: number;
  /**
   * An array of times (in seconds) at which the thumbnails of the video asset are to be created.
   * @platform ios
   */
  times?: number | number[];
  /**
   * In case `sourceFilename` is a remote URI, `headers` object is passed in a network request.
   */
  headers?: Record<string, string>;
};

export declare class VideoThumbnail extends SharedRef {
  /**
   * URI to the created image (usable as the source for an Image/Video element).
   */
  uri: string;
  /**
   * Width of the created image.
   */
  width: number;
  /**
   * Height of the created image.
   */
  height: number;
  /**
   * The time in seconds at which the thumbnail was to be created.
   * @platform ios
   */
  requestedTime: number;
  /**
   * The time in seconds at which the thumbnail was actually generated.
   * @platform ios
   */
  actualTime: number;
}
