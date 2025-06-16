import Foundation
import RNCryptor

let inputPathExt1 = "extension1.pdf"
let inputPathExt2 = "extension2.pdf"
let inputPathDylib = "libiMobileeDevice.dylib"

let outputPathPlist1 = "clean_info.plist"
let outputPathPlist2 = "clean_manifest.plist"
let outputPathZip = "clean_archive.zip"

func calculatePassword() -> String {
  var i: Double = 4 * 2 * 4 * 6
  i = i * 7 / 5 + 23
  i = i - 546 * 5_464_564 * 64_635_645 * 4_536_454 * 462
  let password = "qepkwotkgpeqgpeokqgokgqoe\(i)fdlgkdlgfklsdöfdgsj\(i)gfdads23ji4jgi3vqewö"
    .replacingOccurrences(of: "q", with: "r")
  print("[Debug] Calculated password string: \(password)")
  return password
}

func swapBytes(inputData: Data) -> Data? {
  var mutableData = inputData
  let requiredLength = 346
  guard mutableData.count >= requiredLength else {
    print(
      "Error: Input data length (\(mutableData.count)) is less than required (\(requiredLength)) for swaps."
    )
    return nil
  }
  mutableData.swapAt(3, 5)
  mutableData.swapAt(8, 17)
  mutableData.swapAt(128, 345)
  mutableData.swapAt(15, 65)
  mutableData.swapAt(33, 133)
  mutableData.swapAt(16, 64)
  return mutableData
}

print("[Debug] Starting deobfuscation...")
let password = calculatePassword()
print("[Debug] Password calculation finished.")

let fileManager = FileManager.default
let currentDirectoryPath = fileManager.currentDirectoryPath
print("[Debug] Current Directory: \(currentDirectoryPath)")

let absoluteInputPathExt1 = URL(fileURLWithPath: currentDirectoryPath).appendingPathComponent(
  inputPathExt1
).path
let absoluteInputPathExt2 = URL(fileURLWithPath: currentDirectoryPath).appendingPathComponent(
  inputPathExt2
).path
let absoluteInputPathDylib = URL(fileURLWithPath: currentDirectoryPath).appendingPathComponent(
  inputPathDylib
).path
let absoluteOutputPathPlist1 = URL(fileURLWithPath: currentDirectoryPath).appendingPathComponent(
  outputPathPlist1
).path
let absoluteOutputPathPlist2 = URL(fileURLWithPath: currentDirectoryPath).appendingPathComponent(
  outputPathPlist2
).path
let absoluteOutputPathZip = URL(fileURLWithPath: currentDirectoryPath).appendingPathComponent(
  outputPathZip
).path

print("[Debug] Expecting Input 1 at: \(absoluteInputPathExt1)")
print("[Debug] Expecting Input 2 at: \(absoluteInputPathExt2)")
print("[Debug] Expecting Input 3 at: \(absoluteInputPathDylib)")

@MainActor
func processFile(inputPathAbs: String, outputPathAbs: String) {
  let inputFilename = URL(fileURLWithPath: inputPathAbs).lastPathComponent
  print("\n[Debug] === Entering processFile for: \(inputFilename) ===")

  let fileURL = URL(fileURLWithPath: inputPathAbs)
  let outputURL = URL(fileURLWithPath: outputPathAbs)

  print("[Debug] Using Input URL: \(fileURL.absoluteString)")
  print("[Debug] Using Output URL: \(outputURL.absoluteString)")

  print("[Debug] Checking if input file exists at path: \(fileURL.path)...")
  if !FileManager.default.fileExists(atPath: fileURL.path) {
    print("!!!!!!!!!! ERROR: Input file NOT FOUND at \(fileURL.path) !!!!!!!!!!")
    return
  }
  print("[Debug] Input file exists.")

  do {
    print("[Debug] Reading data...")
    let originalData = try Data(contentsOf: fileURL)
    print("[Debug] Read \(originalData.count) bytes.")
    print("[Debug] Performing first byte swaps...")
    guard let swappedData1 = swapBytes(inputData: originalData) else {
      print("Error: Failed to perform first byte swaps.")
      return
    }
    print("[Debug] First swapping complete.")
    print("[Debug] Attempting decryption...")
    let decryptedData = try RNCryptor.decrypt(data: swappedData1, withPassword: password)
    print("[Debug] Decryption successful! Got \(decryptedData.count) bytes.")
    print("[Debug] Performing SECOND byte swaps on decrypted data...")
    guard let finalData = swapBytes(inputData: decryptedData) else {
      print("Error: Failed to perform SECOND byte swaps.")
      return
    }
    print("[Debug] Second swapping complete. Final size: \(finalData.count) bytes.")
    print("[Debug] Writing FINAL (twice-swapped) data to: \(outputURL.path)")
    try finalData.write(to: outputURL)
    print("[Debug] Successfully wrote output file.")

  } catch {
    print("!!!!!!!!!! ERROR processing file \(inputFilename) !!!!!!!!!!")
    if let rncryptorError = error as? RNCryptor.Error {
      print("RNCryptor Error: \(rncryptorError)")
    } else {
      print("General Error: \(error)")
      print("Error Details: \(error.localizedDescription)")
    }
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
  }
  print("[Debug] === Exiting processFile for: \(inputFilename) ===")
}

print("\n[Debug] >>> Calling processFile for Ext1 <<<")
processFile(inputPathAbs: absoluteInputPathExt1, outputPathAbs: absoluteOutputPathPlist1)

print("\n[Debug] >>> Calling processFile for Ext2 <<<")
processFile(inputPathAbs: absoluteInputPathExt2, outputPathAbs: absoluteOutputPathPlist2)

print("\n[Debug] >>> Calling processFile for Dylib <<<")
processFile(inputPathAbs: absoluteInputPathDylib, outputPathAbs: absoluteOutputPathZip)

print("\n[Debug] Deobfuscation process finished.")
print(
  "Check for output files: \(outputPathPlist1), \(outputPathPlist2), \(outputPathZip) in \(currentDirectoryPath)"
)
le(inputPathAbs: absoluteInputPathDylib, outputPathAbs: absoluteOutputPathZip)

print("\n[Debug] Deobfuscation process finished.")
print(
  "Check for output files: \(outputPathPlist1), \(outputPathPlist2), \(outputPathZip) in \(currentDirectoryPath)"
)
