extension StringUtility on String? {
  
  /// Returns true if the string is null or empty.
  bool get isNullOrWhiteSpace {
    if (this == null) {
      return true;
    }
    if (this!.trim().isEmpty) {
      return true;
    }
    return false;
  }

}

class Utils {

  static final _regMatchExp = RegExp(r'youtube\..+?/watch.*?v=(.*?)(?:&|/|$)');
  static final _shortMatchExp = RegExp(r'youtu\.be/(.*?)(?:\?|&|/|$)');
  static final _embedMatchExp = RegExp(r'youtube\..+?/embed/(.*?)(?:\?|&|/|$)');
  static final _shortsMatchExp =
      RegExp(r'youtube\..+/shorts/([A-Za-z0-9-_]+$)');

  static final _playlistRegMatchExp =
      RegExp(r'youtube\..+?/playlist.*?list=(.*?)(?:&|/|$)');
  static final _compositeMatchExp =
      RegExp(r'youtube\..+?/watch.*?list=(.*?)(?:&|/|$)');
  static final _shortCompositeMatchExp =
      RegExp(r'youtu\.be/.*?/.*?list=(.*?)(?:&|/|$)');
  static final _embedCompositeMatchExp =
      RegExp(r'youtube\..+?/embed/.*?/.*?list=(.*?)(?:&|/|$)');

  /// Returns true if the given [videoId] is valid.
  static bool validateVideoId(String videoId) {
    if (videoId.isNullOrWhiteSpace) {
      return false;
    }

    if (videoId.length != 11) {
      return false;
    }

    return !RegExp(r'[^0-9a-zA-Z_\-]').hasMatch(videoId);
  }

  /// Returns true if the given [playlistId] is valid.
  static bool validatePlaylistId(String playlistId) {
    playlistId = playlistId.toUpperCase();

    if (playlistId.isNullOrWhiteSpace) {
      return false;
    }

    // Watch later
    if (playlistId == 'WL') {
      return true;
    }

    // My mix playlist
    if (playlistId == 'RDMM') {
      return true;
    }

    if (!playlistId.startsWith('PL') &&
        !playlistId.startsWith('RD') &&
        !playlistId.startsWith('UL') &&
        !playlistId.startsWith('UU') &&
        !playlistId.startsWith('PU') &&
        !playlistId.startsWith('OL') &&
        !playlistId.startsWith('LL') &&
        !playlistId.startsWith('FL')) {
      return false;
    }

    if (playlistId.length < 13) {
      return false;
    }

    return !RegExp(r'[^0-9a-zA-Z_\-]').hasMatch(playlistId);
  }

  /// Parses a video id from url or if given a valid id as url returns itself.
  /// Returns null if the id couldn't be extracted.
  static String? parseVideoId(String? url) {
    if (url.isNullOrWhiteSpace) {
      return null;
    }

    if (validateVideoId(url!)) {
      return url;
    }

    // https://www.youtube.com/watch?v=yIVRs6YSbOM
    var regMatch = _regMatchExp.firstMatch(url)?.group(1);
    if (!regMatch.isNullOrWhiteSpace && validateVideoId(regMatch!)) {
      return regMatch;
    }

    // https://youtu.be/yIVRs6YSbOM
    var shortMatch = _shortMatchExp.firstMatch(url)?.group(1);
    if (!shortMatch.isNullOrWhiteSpace && validateVideoId(shortMatch!)) {
      return shortMatch;
    }

    // https://www.youtube.com/embed/yIVRs6YSbOM
    var embedMatch = _embedMatchExp.firstMatch(url)?.group(1);
    if (!embedMatch.isNullOrWhiteSpace && validateVideoId(embedMatch!)) {
      return embedMatch;
    }

    // https://www.youtube.com/shorts/yIVRs6YSbOM
    var shortsMatch = _shortsMatchExp.firstMatch(url)?.group(1);
    if (!shortsMatch.isNullOrWhiteSpace && validateVideoId(shortsMatch!)) {
      return shortsMatch;
    }
    return null;
  }

  /// Parses a playlist [url] returning its id.
  /// If the [url] is a valid it is returned itself.
  static String? parsePlaylistId(String? url) {
    if (url.isNullOrWhiteSpace) {
      return null;
    }

    if (validatePlaylistId(url!)) {
      return url;
    }

    var regMatch = _playlistRegMatchExp.firstMatch(url)?.group(1);
    if (!regMatch.isNullOrWhiteSpace && validatePlaylistId(regMatch!)) {
      return regMatch;
    }

    var compositeMatch = _compositeMatchExp.firstMatch(url)?.group(1);
    if (!compositeMatch.isNullOrWhiteSpace &&
        validatePlaylistId(compositeMatch!)) {
      return compositeMatch;
    }

    var shortCompositeMatch = _shortCompositeMatchExp.firstMatch(url)?.group(1);
    if (!shortCompositeMatch.isNullOrWhiteSpace &&
        validatePlaylistId(shortCompositeMatch!)) {
      return shortCompositeMatch;
    }

    var embedCompositeMatch = _embedCompositeMatchExp.firstMatch(url)?.group(1);
    if (!embedCompositeMatch.isNullOrWhiteSpace &&
        validatePlaylistId(embedCompositeMatch!)) {
      return embedCompositeMatch;
    }
    return null;
  }

  /// Get a video thumbnail from URL
  static String fetchVideoThumbnail(String url) {
    return 'http://img.youtube.com/vi/${parseVideoId(url)}/mqdefault.jpg';
  }

  /// Get a playlist thumbnail from URL
  static String fetchPlaylistThumbnail(String url) {
    return 'https://i.ytimg.com/vi/${parsePlaylistId(url)}/mqdefault.jpg';
  }

}