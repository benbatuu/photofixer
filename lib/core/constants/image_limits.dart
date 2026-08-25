/// Client-side image limits for MVP (project.md §9).
abstract final class ImageLimits {
  static const int maxInputBytes = 12 * 1024 * 1024; // 12 MB
  static const int maxDimension = 4096;
  static const int processMaxLongEdge = 2048;
  static const int jpegQuality = 85;
}
