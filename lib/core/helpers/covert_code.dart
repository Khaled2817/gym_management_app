String getTenDigit(String uid) {
  if (uid.length > 8) {
    uid = uid.substring(6);
  }
  // 1. Convert hex string to byte array (little-endian)
  List<int> bytes = hexToBytes(uid);
  // 2. Convert bytes to 32-bit integer (little-endian)
  int numericValue = bytesToInt32(bytes);
  // 3. Format as 10-digit string with leading zeros
  return numericValue.toString().padLeft(10, '0');
}

List<int> hexToBytes(String hexString) {
  hexString = hexString.replaceAll(RegExp(r'[^0-9a-fA-F]'), '');
  var result = <int>[];
  for (int i = 0; i < hexString.length; i += 2) {
    String hex = hexString.substring(i, i + 2);
    result.add(int.parse(hex, radix: 16));
  }
  return result;
}

int bytesToInt32(List<int> bytes) {
  // Interpret bytes as little-endian 32-bit integer
  return bytes[0] | (bytes[1] << 8) | (bytes[2] << 16) | (bytes[3] << 24);
}

extension StringExtension on String {
  String toTenDigit() {
    return getTenDigit(this);
  }
}