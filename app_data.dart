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
  // Jerin Sunayen Surori da Ayoyi da ka turo
  static final List<Map<String, String>> surahInfo = [
    {"sura": "Suratul Fathi", "aya": "4-6"},   // Day 1
    {"sura": "Suratul Fathi", "aya": "7-10"},  // Day 2
    {"sura": "Suratul Fathi", "aya": "10-11"}, // Day 3
    {"sura": "Suratul Fathi", "aya": "11-14"}, // Day 4
    {"sura": "Suratul Fathi", "aya": "15-17"}, // Day 5
    {"sura": "Suratul Fathi", "aya": "18-21"}, // Day 6
    {"sura": "Suratul Fathi", "aya": "22-26"}, // Day 7
    {"sura": "Suratul Fathi", "aya": "26-28"}, // Day 8
    {"sura": "Suratul Fathi", "aya": "28-29"}, // Day 9
    {"sura": "Suratul Fathi", "aya": "29"},    // Day 10
    {"sura": "Suratul Hujurat", "aya": "1-2"}, // Day 11
    {"sura": "Suratul Hujurat", "aya": "2-5"}, // Day 12
    {"sura": "Suratul Hujurat", "aya": "6-8"}, // Day 13
    {"sura": "Suratul Hujurat", "aya": "9-10"},// Day 14
    {"sura": "Suratul Hujurat", "aya": "11-12"},// Day 15
    {"sura": "Suratul Hujurat", "aya": "12"},   // Day 16
    {"sura": "Suratul Hujurat", "aya": "12-13"},// Day 17
    {"sura": "Suratul Hujurat", "aya": "13"},   // Day 18
    {"sura": "Suratul Hujurat", "aya": "14-18"},// Day 19
    {"sura": "Suratun Qaf", "aya": "1"},       // Day 20
    {"sura": "Suratun Qaf", "aya": "1-5"},     // Day 21
    {"sura": "Suratun Qaf", "aya": "6-11"},    // Day 22
    {"sura": "Suratun Qaf", "aya": "12-18"},   // Day 23
    {"sura": "Suratun Qaf", "aya": "18-21"},   // Day 24
    {"sura": "Suratun Qaf", "aya": "22-26"},   // Day 25
    {"sura": "Suratun Qaf", "aya": "27-35"},   // Day 26
    {"sura": "Suratun Qaf", "aya": "36-40"},   // Day 27
    {"sura": "Suratun Qaf", "aya": "41-45"},   // Day 28
  ];

  static List<TafsirModel> tafsirList = List.generate(28, (index) {
    int day = index + 1;
    // Wannan layin zai raba hotuna 6 a kwanaki 28 (1,2,3,4,5,6,1,2,3...)
    int imgIndex = (index % 6) + 1; 
    
    return TafsirModel(
      title: surahInfo[index]["sura"]!,
      subtitle: "Rana ta $day (Aya: ${surahInfo[index]["aya"]})",
      audioPath: "assets/audio/day$day.mp3",
      imagePath: "assets/images/students$imgIndex.jpg",
    );
  });

  static List<TafsirModel> muhadaroriList = [
    TafsirModel(
      title: "Mafita daga Jarrabawar Rayuwa",
      subtitle: "M. Sani Abdullahi & Dr Abba Ya'u Gido",
      audioPath: "assets/audio/lecture1.mp3",
      imagePath: "assets/images/speakers1.jpg",
    ),
    TafsirModel(
      title: "Riko da Alkur'ani da Sunna",
      subtitle: "M. Abdullahi Husaini & Sheikh Sani Aja",
      audioPath: "assets/audio/lecture2.mp3",
      imagePath: "assets/images/speakers2.jpg",
    ),
    TafsirModel(
      title: "Tabarbarewar Tarbiya Ina Mafita",
      subtitle: "M. Shehu Usman Gumel & M. Yakubu Wambai",
      audioPath: "assets/audio/lecture3.mp3",
      imagePath: "assets/images/speakers3.jpg",
    ),
  ];
}
