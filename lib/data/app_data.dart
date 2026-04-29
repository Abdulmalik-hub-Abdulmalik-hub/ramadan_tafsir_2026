class TafsirModel {
  final String title;
  final String subtitle;
  final String audioUrl;
  final String fileName;
  final String imagePath;

  TafsirModel({
    required this.title,
    required this.subtitle,
    required this.audioUrl,
    required this.fileName,
    required this.imagePath,
  });
}

class AppData {
  // Cikakken Link din GitHub Pages dinka
  static const String baseUrl = "https://abdulmalik-hub-abdulmalik-hub.github.io/Ramadan-audio-/audio/";

  static final List<Map<String, String>> surahInfo = [
    {"sura": "Suratul Fathi", "aya": "4-6"},
    {"sura": "Suratul Fathi", "aya": "7-10"},
    {"sura": "Suratul Fathi", "aya": "10-11"},
    {"sura": "Suratul Fathi", "aya": "11-14"},
    {"sura": "Suratul Fathi", "aya": "15-17"},
    {"sura": "Suratul Fathi", "aya": "18-21"},
    {"sura": "Suratul Fathi", "aya": "22-26"},
    {"sura": "Suratul Fathi", "aya": "26-28"},
    {"sura": "Suratul Fathi", "aya": "28-29"},
    {"sura": "Suratul Fathi", "aya": "29"},
    {"sura": "Suratul Hujurat", "aya": "1-2"},
    {"sura": "Suratul Hujurat", "aya": "2-5"},
    {"sura": "Suratul Hujurat", "aya": "6-8"},
    {"sura": "Suratul Hujurat", "aya": "9-10"},
    {"sura": "Suratul Hujurat", "aya": "11-12"},
    {"sura": "Suratul Hujurat", "aya": "12"},
    {"sura": "Suratul Hujurat", "aya": "12-13"},
    {"sura": "Suratul Hujurat", "aya": "13"},
    {"sura": "Suratul Hujurat", "aya": "14-18"},
    {"sura": "Suratun Qaf", "aya": "1"},
    {"sura": "Suratun Qaf", "aya": "1-5"},
    {"sura": "Suratun Qaf", "aya": "6-11"},
    {"sura": "Suratun Qaf", "aya": "12-18"},
    {"sura": "Suratun Qaf", "aya": "18-21"},
    {"sura": "Suratun Qaf", "aya": "22-26"},
    {"sura": "Suratun Qaf", "aya": "27-35"},
    {"sura": "Suratun Qaf", "aya": "36-40"},
    {"sura": "Suratun Qaf", "aya": "41-45"},
  ];

  static List<TafsirModel> tafsirList = List.generate(28, (index) {
    int day = index + 1;
    int imgIndex = (index % 6) + 1;
    return TafsirModel(
      title: surahInfo[index]["sura"]!,
      subtitle: "Rana ta $day (Aya: ${surahInfo[index]["aya"]})",
      audioUrl: "${baseUrl}day$day.mp3",
      fileName: "day$day.mp3",
      imagePath: "assets/Image/students$imgIndex.jpg",
    );
  });

  static List<TafsirModel> muhadaroriList = [
    TafsirModel(
      title: "Mafita daga Jarrabawar Rayuwa",
      subtitle: "M. Sani Abdullahi & Dr Abba Ya'u Gido",
      audioUrl: "${baseUrl}lecture1.mp3",
      fileName: "lecture1.mp3",
      imagePath: "assets/Image/speakers1.jpg",
    ),
    TafsirModel(
      title: "Riko da Alkur'ani da Sunna",
      subtitle: "Mln. Abdullahi Husaini and Sheik Muhammad Sani Abdullahi Aja",
      audioUrl: "${baseUrl}lecture2.mp3",
      fileName: "lecture2.mp3",
      imagePath: "assets/Image/speakers2.jpg",
    ),
    TafsirModel(
      title: "Tabarbarewar Tarbiya Ina mafita",
      subtitle: "M. Shehu Usman Gumel & M. Yakubu Wambai",
      audioUrl: "${baseUrl}lecture3.mp3",
      fileName: "lecture3.mp3",
      imagePath: "assets/Image/speakers3.jpg",
    ),
  ];
}
