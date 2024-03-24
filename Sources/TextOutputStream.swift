import Foundation

struct TextOutputStream {
  static let fileURL = URL(fileURLWithPath: "/home/blendzior/projects/mrowki/output/log.md")

  static func deleteLog() {
    if FileManager.default.fileExists(atPath: fileURL.path) {
      do {
        // Delete the file
        try FileManager.default.removeItem(at: fileURL)
        print("Successfully deleted file!")
      } catch {
        print("Error deleting file: \(error)")
      }
    }
  }

  static func createLog(_ str: String) {
    // Convert your string to Data
    if let data = str.data(using: .utf8) {
      do {
        // Open the file for writing
        if let fileHandle = try? FileHandle(forWritingTo: fileURL) {
          // Seek to the end of the file
          fileHandle.seekToEndOfFile()
          // Write the new content
          fileHandle.write(data)
          // Close the file
          fileHandle.closeFile()
        } else {
          // If the file doesn't exist, create it and write the new content
          try data.write(to: fileURL, options: .atomic)
        }
      } catch {
        print("Error writing to file: \(error)")
      }
    }

  }
}
