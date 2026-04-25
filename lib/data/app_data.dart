class TafsirModel {
  final String title;
  final String subtitle;
  final String audioPath;
  final String imagePath;

  TafsirModel({
    required this.title,
    required this.subtitle,
    required this.audioPath,
    required this.imagePath,
  });
}

class AppData {
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
      audioPath: "audio/day$day.mp3", // Audioplayers doesn't need 'assets/' prefix here
      imagePath: "assets/images/students$imgIndex.jpg",
    );
  });

  static List<TafsirModel> muhadaroriList = [
    TafsirModel(
      title: "Mafita daga Jarrabawar Rayuwa",
      subtitle: "M. Sani Abdullahi & Dr Abba Ya'u Gido",
      audioPath: "audio/lecture1.mp3",
      imagePath: "assets/images/speakers1.jpg",
    ),
  ];
}
