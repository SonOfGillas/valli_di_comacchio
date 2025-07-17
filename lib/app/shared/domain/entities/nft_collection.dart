import 'dart:io';

class NftCollection {
  /// List of NFT file paths or identifiers.
  List<String> filePaths;

  List<File> get nftFiles => filePaths.map((path) => File(path)).toList();

  NftCollection({this.filePaths = const []});

  factory NftCollection.fromJson(Map<String, dynamic> json) {
    return NftCollection(
      filePaths: List<String>.from(json['filePaths'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filePaths': filePaths,
    };
  }

  NftCollection addFilePath(String filePath) {
    return NftCollection(filePaths: [...filePaths, filePath]);
  }
}
