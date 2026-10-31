import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_saver/file_saver.dart';

void main() {
  runApp(const ScienceQuestApp());
}

// ============================================================
// MODELS
// ============================================================

class QuizQuestion {
  final String question;
  final List<String> options;
  final String answer;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.answer,
    required this.explanation,
  });
}

class QuizResult {
  final String student;
  final String category;
  final DateTime date;
  final int score;
  final int total;
  final List<Map<String, dynamic>> answers;

  QuizResult({
    required this.student,
    required this.category,
    required this.date,
    required this.score,
    required this.total,
    required this.answers,
  });

  double get percentage => total == 0 ? 0 : score / total * 100;

  Map<String, dynamic> toJson() => {
        'app': 'Science Quest',
        'version': 1,
        'student': student,
        'category': category,
        'date': date.toIso8601String(),
        'score': score,
        'total': total,
        'percentage': percentage,
        'answers': answers,
      };

  factory QuizResult.fromJson(Map<String, dynamic> json) {
    return QuizResult(
      student: json['student']?.toString() ?? 'Unknown student',
      category: json['category']?.toString() ?? 'Unknown quiz',
      date: DateTime.tryParse(json['date']?.toString() ?? '') ??
          DateTime.now(),
      score: (json['score'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      answers: (json['answers'] as List? ?? [])
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
    );
  }
}

// ============================================================
// QUESTION BANK
// ============================================================

class ScienceQuestions {
  static final Random random = Random();

  static List<String> _options(
    String correct,
    List<String> alternatives,
  ) {
    final choices = <String>{correct};

    for (final item in alternatives) {
      if (item != correct) choices.add(item);
      if (choices.length == 4) break;
    }

    return choices.toList()..shuffle(random);
  }

  static QuizQuestion _question(
    String question,
    String answer,
    List<String> alternatives,
    String explanation,
  ) {
    return QuizQuestion(
      question: question,
      options: _options(answer, alternatives),
      answer: answer,
      explanation: explanation,
    );
  }

  // ----------------------------------------------------------
  // ELEMENTS: 100 QUESTIONS
  // ----------------------------------------------------------

  static const List<String> elements = [
    'Hydrogen', 'Helium', 'Lithium', 'Beryllium', 'Boron',
    'Carbon', 'Nitrogen', 'Oxygen', 'Fluorine', 'Neon',
    'Sodium', 'Magnesium', 'Aluminium', 'Silicon', 'Phosphorus',
    'Sulfur', 'Chlorine', 'Argon', 'Potassium', 'Calcium',
    'Scandium', 'Titanium', 'Vanadium', 'Chromium', 'Manganese',
    'Iron', 'Cobalt', 'Nickel', 'Copper', 'Zinc',
    'Gallium', 'Germanium', 'Arsenic', 'Selenium', 'Bromine',
    'Krypton', 'Rubidium', 'Strontium', 'Yttrium', 'Zirconium',
    'Niobium', 'Molybdenum', 'Technetium', 'Ruthenium', 'Rhodium',
    'Palladium', 'Silver', 'Cadmium', 'Indium', 'Tin',
    'Antimony', 'Tellurium', 'Iodine', 'Xenon', 'Caesium',
    'Barium', 'Lanthanum', 'Cerium', 'Praseodymium', 'Neodymium',
    'Promethium', 'Samarium', 'Europium', 'Gadolinium', 'Terbium',
    'Dysprosium', 'Holmium', 'Erbium', 'Thulium', 'Ytterbium',
    'Lutetium', 'Hafnium', 'Tantalum', 'Tungsten', 'Rhenium',
    'Osmium', 'Iridium', 'Platinum', 'Gold', 'Mercury',
    'Thallium', 'Lead', 'Bismuth', 'Polonium', 'Astatine',
    'Radon', 'Francium', 'Radium', 'Actinium', 'Thorium',
    'Protactinium', 'Uranium', 'Neptunium', 'Plutonium', 'Americium',
    'Curium', 'Berkelium', 'Californium', 'Einsteinium', 'Fermium'
  ];

  static List<QuizQuestion> elementQuestions() {
    final result = <QuizQuestion>[];

    for (int i = 0; i < 100; i++) {
      final index = i;
      final name = elements[index];

      final alternatives = [
        elements[(index + 1) % 100],
        elements[(index + 5) % 100],
        elements[(index + 11) % 100],
      ];

      result.add(_question(
        'Which element has atomic number ${index + 1}?',
        name,
        alternatives,
        '$name has atomic number ${index + 1}.',
      ));
    }

    return result;
  }

  // ----------------------------------------------------------
  // MOLECULES: 100 QUESTIONS
  // ----------------------------------------------------------

  static const List<List<String>> molecules = [
    ['Water', 'H₂O'],
    ['Carbon dioxide', 'CO₂'],
    ['Oxygen gas', 'O₂'],
    ['Hydrogen gas', 'H₂'],
    ['Nitrogen gas', 'N₂'],
    ['Ozone', 'O₃'],
    ['Ammonia', 'NH₃'],
    ['Methane', 'CH₄'],
    ['Ethane', 'C₂H₆'],
    ['Propane', 'C₃H₈'],
    ['Butane', 'C₄H₁₀'],
    ['Ethanol', 'C₂H₅OH'],
    ['Methanol', 'CH₃OH'],
    ['Glucose', 'C₆H₁₂O₆'],
    ['Sucrose', 'C₁₂H₂₂O₁₁'],
    ['Acetic acid', 'CH₃COOH'],
    ['Hydrochloric acid', 'HCl'],
    ['Sulfuric acid', 'H₂SO₄'],
    ['Nitric acid', 'HNO₃'],
    ['Phosphoric acid', 'H₃PO₄'],
    ['Sodium chloride', 'NaCl'],
    ['Calcium carbonate', 'CaCO₃'],
    ['Sodium bicarbonate', 'NaHCO₃'],
    ['Sodium hydroxide', 'NaOH'],
    ['Potassium hydroxide', 'KOH'],
    ['Calcium hydroxide', 'Ca(OH)₂'],
    ['Hydrogen peroxide', 'H₂O₂'],
    ['Carbon monoxide', 'CO'],
    ['Sulfur dioxide', 'SO₂'],
    ['Sulfur trioxide', 'SO₃'],
    ['Nitrous oxide', 'N₂O'],
    ['Nitrogen dioxide', 'NO₂'],
    ['Magnesium oxide', 'MgO'],
    ['Calcium oxide', 'CaO'],
    ['Aluminium oxide', 'Al₂O₃'],
    ['Iron oxide', 'Fe₂O₃'],
    ['Silicon dioxide', 'SiO₂'],
    ['Sodium carbonate', 'Na₂CO₃'],
    ['Potassium nitrate', 'KNO₃'],
    ['Sodium nitrate', 'NaNO₃'],
    ['Calcium chloride', 'CaCl₂'],
    ['Magnesium chloride', 'MgCl₂'],
    ['Potassium chloride', 'KCl'],
    ['Ammonium chloride', 'NH₄Cl'],
    ['Ammonium nitrate', 'NH₄NO₃'],
    ['Copper sulfate', 'CuSO₄'],
    ['Magnesium sulfate', 'MgSO₄'],
    ['Sodium sulfate', 'Na₂SO₄'],
    ['Potassium sulfate', 'K₂SO₄'],
    ['Calcium sulfate', 'CaSO₄'],
    ['Benzene', 'C₆H₆'],
    ['Toluene', 'C₇H₈'],
    ['Acetone', 'C₃H₆O'],
    ['Formaldehyde', 'CH₂O'],
    ['Urea', 'CH₄N₂O'],
    ['Citric acid', 'C₆H₈O₇'],
    ['Lactic acid', 'C₃H₆O₃'],
    ['Ascorbic acid', 'C₆H₈O₆'],
    ['Glycine', 'C₂H₅NO₂'],
    ['Alanine', 'C₃H₇NO₂'],
    ['Aspirin', 'C₉H₈O₄'],
    ['Caffeine', 'C₈H₁₀N₄O₂'],
    ['Uric acid', 'C₅H₄N₄O₃'],
    ['Cholesterol', 'C₂₇H₄₆O'],
    ['Fructose', 'C₆H₁₂O₆'],
    ['Maltose', 'C₁₂H₂₂O₁₁'],
    ['Lactose', 'C₁₂H₂₂O₁₁'],
    ['Ethene', 'C₂H₄'],
    ['Propene', 'C₃H₆'],
    ['Ethyne', 'C₂H₂'],
    ['Butene', 'C₄H₈'],
    ['Pentane', 'C₅H₁₂'],
    ['Hexane', 'C₆H₁₄'],
    ['Octane', 'C₈H₁₈'],
    ['Cyclohexane', 'C₆H₁₂'],
    ['Phenol', 'C₆H₅OH'],
    ['Aniline', 'C₆H₅NH₂'],
    ['Pyridine', 'C₅H₅N'],
    ['Chloroform', 'CHCl₃'],
    ['Carbon tetrachloride', 'CCl₄'],
    ['Sulfur hexafluoride', 'SF₆'],
    ['Phosphine', 'PH₃'],
    ['Hydrogen sulfide', 'H₂S'],
    ['Hydrogen fluoride', 'HF'],
    ['Hydrogen bromide', 'HBr'],
    ['Hydrogen iodide', 'HI'],
    ['Calcium phosphate', 'Ca₃(PO₄)₂'],
    ['Sodium phosphate', 'Na₃PO₄'],
    ['Potassium permanganate', 'KMnO₄'],
    ['Potassium dichromate', 'K₂Cr₂O₇'],
    ['Sodium hypochlorite', 'NaClO'],
    ['Calcium hypochlorite', 'Ca(ClO)₂'],
    ['Silver nitrate', 'AgNO₃'],
    ['Silver chloride', 'AgCl'],
    ['Copper oxide', 'CuO'],
    ['Zinc oxide', 'ZnO'],
    ['Lead oxide', 'PbO'],
    ['Iron chloride', 'FeCl₃'],
    ['Aluminium chloride', 'AlCl₃'],
    ['Barium sulfate', 'BaSO₄'],
    ['Sodium fluoride', 'NaF'],
    ['Calcium fluoride', 'CaF₂'],
  ];

  static List<QuizQuestion> moleculeQuestions() {
    final result = <QuizQuestion>[];

    for (int i = 0; i < 100; i++) {
      final item = molecules[i];
      final alternatives = [
        molecules[(i + 3) % 100][1],
        molecules[(i + 9) % 100][1],
        molecules[(i + 17) % 100][1],
      ];

      result.add(_question(
        'What is the chemical formula of ${item[0]}?',
        item[1],
        alternatives,
        '${item[0]} has the formula ${item[1]}.',
      ));
    }

    return result;
  }

  // ----------------------------------------------------------
  // BIOLOGY: 100 BEGINNER QUESTIONS
  // ----------------------------------------------------------

  static const List<List<String>> biologyFacts = [
    ['What is the basic unit of life?', 'The cell', 'The atom', 'The organ', 'The tissue'],
    ['Which organ pumps blood?', 'The heart', 'The lungs', 'The liver', 'The stomach'],
    ['Which organ helps us breathe?', 'The lungs', 'The kidneys', 'The brain', 'The heart'],
    ['Which organ controls the body?', 'The brain', 'The stomach', 'The skin', 'The lungs'],
    ['What carries oxygen in blood?', 'Red blood cells', 'White blood cells', 'Platelets', 'Plasma only'],
    ['Which cells help fight infection?', 'White blood cells', 'Red blood cells', 'Platelets', 'Nerve cells'],
    ['Which organ digests food?', 'The stomach', 'The heart', 'The brain', 'The lungs'],
    ['Where does most nutrient absorption occur?', 'Small intestine', 'Large intestine', 'Stomach', 'Esophagus'],
    ['Which organ produces bile?', 'The liver', 'The heart', 'The lungs', 'The kidney'],
    ['Which organs filter blood?', 'The kidneys', 'The lungs', 'The stomach', 'The eyes'],
    ['What do plants absorb during photosynthesis?', 'Carbon dioxide', 'Oxygen only', 'Nitrogen only', 'Helium'],
    ['What gas do plants release during photosynthesis?', 'Oxygen', 'Carbon dioxide', 'Hydrogen', 'Methane'],
    ['Which part of a plant absorbs water?', 'Roots', 'Flowers', 'Leaves', 'Fruits'],
    ['Which part of a plant usually makes food?', 'Leaves', 'Roots', 'Stem', 'Seeds'],
    ['What is the green pigment in plants?', 'Chlorophyll', 'Hemoglobin', 'Melanin', 'Keratin'],
    ['What do bees collect from flowers?', 'Nectar and pollen', 'Soil', 'Leaves', 'Tree bark'],
    ['What is a baby frog called?', 'Tadpole', 'Caterpillar', 'Larva of a bee', 'Cub'],
    ['What do caterpillars become?', 'Butterflies or moths', 'Fish', 'Birds', 'Frogs'],
    ['Which animal is a mammal?', 'Dolphin', 'Shark', 'Crocodile', 'Trout'],
    ['Which animal lays eggs?', 'Chicken', 'Cat', 'Dog', 'Cow'],
    ['What do fish use to breathe underwater?', 'Gills', 'Lungs only', 'Skin only', 'Wings'],
    ['What covers the body of most birds?', 'Feathers', 'Scales', 'Fur', 'Shells'],
    ['Which animal is an amphibian?', 'Frog', 'Eagle', 'Lion', 'Shark'],
    ['What is the largest organ of the human body?', 'Skin', 'Heart', 'Brain', 'Liver'],
    ['Which sense uses the eyes?', 'Sight', 'Hearing', 'Smell', 'Taste'],
  ];

  static List<QuizQuestion> biologyQuestions() {
    final result = <QuizQuestion>[];

    for (int i = 0; i < biologyFacts.length; i++) {
      final fact = biologyFacts[i];

      result.add(QuizQuestion(
        question: fact[0],
        answer: fact[1],
        options: _options(fact[1], fact.sublist(2)),
        explanation: 'The answer is ${fact[1]}.',
      ));

      final variations = [
        'Choose the correct answer: ${fact[0]}',
        'Which statement correctly answers this question: ${fact[0]}',
        'In basic biology, ${fact[0].toLowerCase()}',
      ];

      for (final variation in variations) {
        result.add(QuizQuestion(
          question: variation,
          answer: fact[1],
          options: _options(fact[1], fact.sublist(2)),
          explanation: 'The answer is ${fact[1]}.',
        ));
      }
    }

    return result.take(100).toList();
  }

  // ----------------------------------------------------------
  // MELTING AND BOILING: 100 QUESTIONS
  // ----------------------------------------------------------

  // Approximate values in degrees Celsius at standard pressure.
  // These values are educational approximations.

  static const List<List<dynamic>> substances = [
    ['Water', 0, 100],
    ['Ethanol', -114, 78],
    ['Oxygen', -219, -183],
    ['Nitrogen', -210, -196],
    ['Hydrogen', -259, -253],
    ['Mercury', -39, 357],
    ['Iron', 1538, 2862],
    ['Copper', 1085, 2562],
    ['Gold', 1064, 2856],
    ['Silver', 962, 2162],
    ['Aluminium', 660, 2470],
    ['Lead', 327, 1749],
    ['Tin', 232, 2602],
    ['Zinc', 420, 907],
    ['Sulfur', 115, 445],
    ['Carbon dioxide', -78.5, -78.5],
    ['Methane', -182, -162],
    ['Ammonia', -78, -33],
    ['Acetone', -95, 56],
    ['Benzene', 5.5, 80],
    ['Chloroform', -63, 61],
    ['Sodium chloride', 801, 1465],
    ['Magnesium', 650, 1091],
    ['Calcium', 842, 1484],
    ['Nickel', 1455, 2913],
    ['Cobalt', 1495, 2927],
    ['Titanium', 1668, 3287],
    ['Platinum', 1768, 3825],
    ['Tungsten', 3422, 5555],
    ['Helium', -272, -269],
    ['Neon', -249, -246],
    ['Argon', -189, -186],
    ['Krypton', -157, -153],
    ['Xenon', -112, -108],
    ['Iodine', 114, 184],
    ['Bromine', -7, 59],
    ['Phosphorus', 44, 280],
    ['Naphthalene', 80, 218],
    ['Glucose', 146, 146],
    ['Acetic acid', 16.6, 118],
    ['Glycerol', 18, 290],
    ['Formic acid', 8.4, 101],
    ['Toluene', -95, 111],
    ['Hexane', -95, 69],
    ['Octane', -57, 126],
    ['Propane', -188, -42],
    ['Butane', -138, -0.5],
    ['Calcium carbonate', 825, 825],
    ['Silicon', 1414, 3265],
    ['Lithium', 181, 1342],
  ];

  static List<QuizQuestion> phaseQuestions() {
    final result = <QuizQuestion>[];

    for (int i = 0; i < substances.length; i++) {
      final item = substances[i];
      final name = item[0] as String;
      final melting = item[1] as num;
      final boiling = item[2] as num;

      final otherMelting = substances
          .where((s) => s[0] != name)
          .map((s) => s[1].toString())
          .toList();

      final otherBoiling = substances
          .where((s) => s[0] != name)
          .map((s) => s[2].toString())
          .toList();

      result.add(_question(
        'What is the approximate melting point of $name in °C?',
        melting.toString(),
        otherMelting,
        '$name has an approximate melting point of $melting °C.',
      ));

      result.add(_question(
        'What is the approximate boiling point of $name in °C?',
        boiling.toString(),
        otherBoiling,
        '$name has an approximate boiling point of $boiling °C.',
      ));
    }

    return result;
  }

  // ----------------------------------------------------------
  // PHYSICS: 100 QUESTIONS
  // ----------------------------------------------------------

  static const List<List<dynamic>> densityMaterials = [
    ['Water', 1000],
    ['Ice', 917],
    ['Aluminium', 2700],
    ['Iron', 7874],
    ['Copper', 8960],
    ['Gold', 19300],
    ['Silver', 10490],
    ['Mercury', 13534],
    ['Lead', 11340],
    ['Wood', 700],
    ['Cork', 240],
    ['Glass', 2500],
    ['Concrete', 2400],
    ['Oil', 900],
    ['Air', 1.2],
    ['Oxygen gas', 1.43],
    ['Carbon dioxide gas', 1.98],
    ['Helium gas', 0.18],
    ['Hydrogen gas', 0.09],
    ['Ethanol', 789],
    ['Granite', 2700],
    ['Marble', 2700],
    ['Rubber', 1100],
    ['Plastic', 950],
    ['Salt water', 1025],
  ];

  static const List<List<String>> viscosityMaterials = [
    ['Water', 'Low'],
    ['Honey', 'High'],
    ['Olive oil', 'Medium'],
    ['Molasses', 'Very high'],
    ['Ketchup', 'High'],
    ['Milk', 'Low'],
    ['Shampoo', 'Medium'],
    ['Toothpaste', 'Very high'],
    ['Maple syrup', 'High'],
    ['Air', 'Very low'],
    ['Glycerol', 'Very high'],
    ['Petrol', 'Low'],
    ['Diesel', 'Medium'],
    ['Liquid soap', 'High'],
    ['Juice', 'Low'],
    ['Corn syrup', 'Very high'],
    ['Water vapor', 'Very low'],
    ['Motor oil', 'High'],
    ['Vinegar', 'Low'],
    ['Cream', 'Medium'],
    ['Chocolate syrup', 'High'],
    ['Liquid detergent', 'High'],
    ['Acetone', 'Low'],
    ['Gel', 'Very high'],
    ['Thin cooking oil', 'Medium'],
  ];

  static List<QuizQuestion> physicsQuestions() {
    final result = <QuizQuestion>[];

    for (int i = 0; i < densityMaterials.length; i++) {
      final item = densityMaterials[i];
      final name = item[0] as String;
      final density = item[1] as int;

      final alternatives = densityMaterials
          .where((s) => s[0] != name)
          .map((s) => '${s[1]} kg/m³')
          .toList();

      result.add(_question(
        'What is the approximate density of $name in kg/m³?',
        '$density kg/m³',
        alternatives,
        'The approximate density of $name is $density kg/m³.',
      ));

      result.add(_question(
        'Which property describes the mass contained in a given volume?',
        'Density',
        ['Viscosity', 'Temperature', 'Pressure'],
        'Density describes mass per unit volume.',
      ));
    }

    for (final item in viscosityMaterials) {
      final name = item[0];
      final level = item[1];

      result.add(_question(
        'What is the approximate viscosity level of $name?',
        level,
        ['Low', 'Medium', 'High', 'Very high']
            .where((x) => x != level)
            .toList(),
        'In this simplified educational classification, $name has $level viscosity.',
      ));

      result.add(_question(
        'Which material has $level viscosity in this simplified classification?',
        name,
        viscosityMaterials
            .where((x) => x[0] != name && x[1] != level)
            .map((x) => x[0])
            .toList(),
        '$name is classified as having $level viscosity in this quiz.',
      ));
    }

    return result.take(100).toList();
  }

  static Map<String, List<QuizQuestion>> all() {
    return {
      'Atomic Elements': elementQuestions(),
      'Molecule Formulas': moleculeQuestions(),
      'Easy Biology': biologyQuestions(),
      'Melting & Boiling Points': phaseQuestions(),
      'Physics: Density & Viscosity': physicsQuestions(),
    };
  }
}

// ============================================================
// APPLICATION
// ============================================================

class ScienceQuestApp extends StatelessWidget {
  const ScienceQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Science Quest',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF071426),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF38BDF8),
          brightness: Brightness.dark,
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFF10243D),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: const HomePage(),
    );
  }
}

// ============================================================
// HOME PAGE
// ============================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SCIENCE QUEST',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: selectedTab == 0
          ? const StudentSection()
          : const TeacherSection(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedTab,
        onDestinationSelected: (index) {
          setState(() => selectedTab = index);
        },
        backgroundColor: const Color(0xFF10243D),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school),
            label: 'Student',
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics),
            label: 'Teacher',
          ),
        ],
      ),
    );
  }
}

// ============================================================
// STUDENT SECTION
// ============================================================

class StudentSection extends StatefulWidget {
  const StudentSection({super.key});

  @override
  State<StudentSection> createState() => _StudentSectionState();
}

class _StudentSectionState extends State<StudentSection> {
  final TextEditingController nameController = TextEditingController();
  String? selectedCategory;

  final Map<String, IconData> icons = {
    'Atomic Elements': Icons.science,
    'Molecule Formulas': Icons.biotech,
    'Easy Biology': Icons.spa,
    'Melting & Boiling Points': Icons.thermostat,
    'Physics: Density & Viscosity': Icons.speed,
  };

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  void startQuiz() {
    final name = nameController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name first.')),
      );
      return;
    }

    if (selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a quiz category.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizPage(
          studentName: name,
          category: selectedCategory!,
          questions: ScienceQuestions.all()[selectedCategory!]!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Welcome, scientist!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Test your knowledge, earn your score, and save your results.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
        ),
        const SizedBox(height: 25),

        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'Student name',
            hintText: 'Enter your full name',
            prefixIcon: const Icon(Icons.person),
            filled: true,
            fillColor: const Color(0xFF10243D),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
        ),

        const SizedBox(height: 25),
        const Text(
          'Choose your subject',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 14),

        ...icons.entries.map((entry) {
          final selected = selectedCategory == entry.key;

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: CircleAvatar(
                radius: 25,
                backgroundColor: selected
                    ? Colors.lightBlue
                    : const Color(0xFF1B3858),
                child: Icon(entry.value, color: Colors.white),
              ),
              title: Text(
                entry.key,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('100 questions • 10 random questions'),
              trailing: Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? Colors.lightBlue : Colors.white54,
              ),
              onTap: () => setState(() => selectedCategory = entry.key),
            ),
          );
        }),

        const SizedBox(height: 20),
        SizedBox(
          height: 58,
          child: FilledButton.icon(
            onPressed: startQuiz,
            icon: const Icon(Icons.play_arrow),
            label: const Text(
              'START QUIZ',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}

// ============================================================
// QUIZ PAGE
// ============================================================

class QuizPage extends StatefulWidget {
  final String studentName;
  final String category;
  final List<QuizQuestion> questions;

  const QuizPage({
    super.key,
    required this.studentName,
    required this.category,
    required this.questions,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<QuizQuestion> selectedQuestions;

  int currentQuestion = 0;
  int score = 0;
  String? selectedAnswer;
  bool answered = false;
  bool finished = false;

  final List<Map<String, dynamic>> recordedAnswers = [];

  @override
  void initState() {
    super.initState();
    selectedQuestions = List<QuizQuestion>.from(widget.questions)
      ..shuffle(Random());
    selectedQuestions = selectedQuestions.take(10).toList();
  }

  QuizQuestion get question => selectedQuestions[currentQuestion];

  void selectAnswer(String answer) {
    if (answered) return;

    setState(() {
      selectedAnswer = answer;
      answered = true;

      final correct = answer == question.answer;
      if (correct) score++;

      recordedAnswers.add({
        'question': question.question,
        'selectedAnswer': answer,
        'correctAnswer': question.answer,
        'isCorrect': correct,
        'explanation': question.explanation,
      });
    });
  }

  void nextQuestion() {
    if (currentQuestion < selectedQuestions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
        answered = false;
      });
    } else {
      setState(() => finished = true);
    }
  }

  Future<void> saveResult() async {
    final result = QuizResult(
      student: widget.studentName,
      category: widget.category,
      date: DateTime.now(),
      score: score,
      total: selectedQuestions.length,
      answers: recordedAnswers,
    );

    final fileName =
        'ScienceQuest_${widget.studentName.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')}_${DateTime.now().millisecondsSinceEpoch}';

    try {
      final bytes = utf8.encode(
        const JsonEncoder.withIndent('  ').convert(result.toJson()),
      );

      await FileSaver.instance.saveFile(
        name: fileName,
        bytes: bytes,
        fileExtension: 'json',
        mimeType: MimeType.json,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quiz result saved successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save the file: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (finished) return resultScreen();

    final progress = (currentQuestion + 1) / selectedQuestions.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${currentQuestion + 1} of 10',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('Score: $score'),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: const Color(0xFF1B3858),
            ),
          ),
          const SizedBox(height: 35),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'YOUR QUESTION',
                    style: TextStyle(
                      color: Colors.lightBlue,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    question.question,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          ...question.options.map((option) {
            final isCorrect = option == question.answer;
            final isSelected = option == selectedAnswer;

            Color background = const Color(0xFF10243D);

            if (answered && isCorrect) {
              background = Colors.green.shade800;
            } else if (answered && isSelected && !isCorrect) {
              background = Colors.red.shade800;
            }

            return Card(
              color: background,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => selectAnswer(option),
                child: Padding(
                  padding: const EdgeInsets.all(19),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          option,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (answered && isCorrect)
                        const Icon(Icons.check_circle, color: Colors.white),
                      if (answered && isSelected && !isCorrect)
                        const Icon(Icons.cancel, color: Colors.white),
                    ],
                  ),
                ),
              ),
            );
          }),

          if (answered) ...[
            const SizedBox(height: 12),
            Card(
              color: const Color(0xFF183653),
              child: Padding(
                padding: const EdgeInsets.all(17),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedAnswer == question.answer
                          ? 'Correct!'
                          : 'Not quite!',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(question.explanation),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              height: 55,
              child: FilledButton(
                onPressed: nextQuestion,
                child: Text(
                  currentQuestion == 9 ? 'FINISH QUIZ' : 'NEXT QUESTION',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget resultScreen() {
    final percentage = score / selectedQuestions.length * 100;

    return Scaffold(
      appBar: AppBar(title: const Text('Quiz completed')),
      body: ListView(
        padding: const EdgeInsets.all(25),
        children: [
          const SizedBox(height: 20),
          const Icon(Icons.emoji_events, size: 85, color: Colors.amber),
          const SizedBox(height: 20),
          const Text(
            'Well done!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            widget.studentName,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 20, color: Colors.white70),
          ),
          const SizedBox(height: 30),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  Text(
                    '$score / 10',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${percentage.toStringAsFixed(0)}% accuracy',
                    style: const TextStyle(
                      fontSize: 19,
                      color: Colors.lightBlue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  LinearProgressIndicator(value: percentage / 100),
                  const SizedBox(height: 20),
                  Text('Correct answers: $score'),
                  Text('Incorrect answers: ${10 - score}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            height: 58,
            child: FilledButton.icon(
              onPressed: saveResult,
              icon: const Icon(Icons.download),
              label: const Text('SAVE RESULT AS JSON FILE'),
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('BACK TO STUDENT SECTION'),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// TEACHER SECTION
// ============================================================

class TeacherSection extends StatefulWidget {
  const TeacherSection({super.key});

  @override
  State<TeacherSection> createState() => _TeacherSectionState();
}

class _TeacherSectionState extends State<TeacherSection> {
  final List<QuizResult> results = [];
  String searchText = '';
  bool loading = false;

  Future<void> importResults() async {
    setState(() => loading = true);

    try {
      final selection = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: true,
        withData: true,
      );

      if (selection == null) {
        setState(() => loading = false);
        return;
      }

      int imported = 0;
      int rejected = 0;

      for (final file in selection.files) {
        try {
          final bytes = file.bytes;

          if (bytes == null) {
            rejected++;
            continue;
          }

          final decoded = jsonDecode(utf8.decode(bytes));

          if (decoded is! Map<String, dynamic> ||
              decoded['app'] != 'Science Quest') {
            rejected++;
            continue;
          }

          final result = QuizResult.fromJson(decoded);

          final duplicate = results.any((existing) =>
              existing.student == result.student &&
              existing.category == result.category &&
              existing.date.isAtSameMomentAs(result.date));

          if (!duplicate) {
            results.add(result);
            imported++;
          }
        } catch (_) {
          rejected++;
        }
      }

      setState(() => loading = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$imported result(s) imported. $rejected file(s) rejected.',
          ),
        ),
      );
    } catch (e) {
      setState(() => loading = false);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Import failed: $e')),
      );
    }
  }

  double get average {
    if (results.isEmpty) return 0;
    return results.map((r) => r.percentage).reduce((a, b) => a + b) /
        results.length;
  }

  int get totalCorrect =>
      results.fold(0, (sum, result) => sum + result.score);

  int get totalQuestions =>
      results.fold(0, (sum, result) => sum + result.total);

  List<QuizResult> get filteredResults {
    return results.where((r) {
      return r.student.toLowerCase().contains(searchText.toLowerCase()) ||
          r.category.toLowerCase().contains(searchText.toLowerCase());
    }).toList()
      ..sort((a, b) => b.date.compareTo(a.date));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          'Teacher dashboard',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Import student result files to analyze their performance.',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.65)),
        ),
        const SizedBox(height: 20),

        SizedBox(
          height: 58,
          child: FilledButton.icon(
            onPressed: loading ? null : importResults,
            icon: loading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.upload_file),
            label: Text(loading ? 'IMPORTING...' : 'IMPORT STUDENT FILES'),
          ),
        ),

        const SizedBox(height: 25),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
          children: [
            _statCard('Students / attempts', '${results.length}',
                Icons.people),
            _statCard('Average score',
                '${average.toStringAsFixed(1)}%', Icons.insights),
            _statCard('Correct answers', '$totalCorrect',
                Icons.check_circle),
            _statCard('Total questions', '$totalQuestions',
                Icons.quiz),
          ],
        ),

        const SizedBox(height: 25),

        const Text(
          'Student results',
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        TextField(
          decoration: InputDecoration(
            hintText: 'Search student or subject...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: const Color(0xFF10243D),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: (value) => setState(() => searchText = value),
        ),

        const SizedBox(height: 15),

        if (filteredResults.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                children: [
                  const Icon(Icons.folder_open, size: 55),
                  const SizedBox(height: 12),
                  const Text(
                    'No student results yet',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Import JSON result files to see student performance.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...filteredResults.map((result) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: CircleAvatar(
                  backgroundColor: Colors.lightBlue.shade800,
                  child: const Icon(Icons.person),
                ),
                title: Text(
                  result.student,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${result.category}\n'
                  '${result.date.toLocal().toString().substring(0, 16)}',
                ),
                isThreeLine: true,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${result.percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlue,
                      ),
                    ),
                    Text('${result.score}/${result.total}'),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StudentAnalysisPage(result: result),
                  ),
                ),
              ),
            );
          }),

        if (results.isNotEmpty) ...[
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () {
              setState(() => results.clear());
            },
            icon: const Icon(Icons.delete_outline),
            label: const Text('CLEAR IMPORTED RESULTS'),
          ),
        ],
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.lightBlue, size: 25),
            Text(
              value,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// INDIVIDUAL STUDENT ANALYSIS
// ============================================================

class StudentAnalysisPage extends StatelessWidget {
  final QuizResult result;

  const StudentAnalysisPage({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student analysis')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                children: [
                  const Icon(
                    Icons.account_circle,
                    size: 65,
                    color: Colors.lightBlue,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    result.student,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    result.category,
                    style: const TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    '${result.percentage.toStringAsFixed(1)}%',
                    style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                  Text('${result.score} correct out of ${result.total}'),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(
                    value: result.percentage / 100,
                    minHeight: 10,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _summaryCard(
                  'Correct',
                  '${result.score}',
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _summaryCard(
                  'Incorrect',
                  '${result.total - result.score}',
                  Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),
          const Text(
            'Question-by-question analysis',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...result.answers.asMap().entries.map((entry) {
            final index = entry.key;
            final answer = entry.value;
            final correct = answer['isCorrect'] == true;

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Question ${index + 1}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.lightBlue,
                            ),
                          ),
                        ),
                        Icon(
                          correct ? Icons.check_circle : Icons.cancel,
                          color: correct ? Colors.green : Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      answer['question']?.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('Student answer: ${answer['selectedAnswer']}'),
                    Text('Correct answer: ${answer['correctAnswer']}'),
                    if (answer['explanation'] != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        answer['explanation'].toString(),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _summaryCard(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}