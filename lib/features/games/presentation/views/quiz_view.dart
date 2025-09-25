import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  final String langueChoisie;
  final String niveau;

  const QuizPage({
    super.key,
    required this.langueChoisie,
    required this.niveau,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late List<Map<String, dynamic>> _questions;
  final Map<int, int> _answers = {}; // indexQuestion -> choixUtilisateur

  final List<Map<String, dynamic>> _questionsEwondo = [
    {
      'question': "Comment dit-on 'Bonjour' en Ewondo ?",
      'options': ["Mbembe", "Mbolo", "Seka", "Wambo"],
      'correctIndex': 1,
    },
    {
      'question': "Quel est le mot Ewondo pour 'Merci' ?",
      'options': ["Akeva", "Mbom", "Bita", "Sanga"],
      'correctIndex': 0,
    },
    {
      'question': "En Ewondo, 'Ngul' veut dire :",
      'options': ["Chien", "Arbre", "Feu", "Lune"],
      'correctIndex': 0,
    },
    {
      'question': "En Ewondo, 'Nsôh' signifie :",
      'options': ["Chanson", "Ciel", "Pagne", "Main"],
      'correctIndex': 0,
    },
    {
      'question': "Le mot 'Zok' en Ewondo désigne :",
      'options': ["Forêt", "Vent", "Soleil", "Arbre"],
      'correctIndex': 0,
    },
  ];

  final List<Map<String, dynamic>> _questionsBafang = [
    {
      'question': "Dans la langue Bafang, quel mot signifie 'Eau' ?",
      'options': ["Meya", "Ndè", "Nka", "Saa"],
      'correctIndex': 0,
    },
    {
      'question': "Comment traduit-on 'Maison' en Bafang ?",
      'options': ["Ndem", "Nta’a", "Mbam", "Sika"],
      'correctIndex': 1,
    },
    {
      'question': "Quel mot Bafang signifie 'Manger' ?",
      'options': ["Sô", "Kwi", "Tchouo", "Lem"],
      'correctIndex': 2,
    },
    {
      'question': "Le mot 'Fô' en Bafang désigne :",
      'options': ["Chef", "Chien", "Roi", "Femme"],
      'correctIndex': 0,
    },
    {
      'question': "En Bafang, 'Ngwe' veut dire :",
      'options': ["Feu", "Etoile", "Lait", "Arbre"],
      'correctIndex': 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    if (widget.langueChoisie.toLowerCase() == "ewondo") {
      _questions = _questionsEwondo;
    } else {
      _questions = _questionsBafang;
    }
  }

  void _validerQuiz() {
    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_answers[i] == _questions[i]['correctIndex']) {
        score++;
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Résultat du quiz"),
        content: Text(
          "Tu as obtenu $score / ${_questions.length} !\n"
          "${score >= 4 ? "Bravo 🎉" : "Continue à t’entraîner 💪"}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz - ${widget.langueChoisie}"),
        backgroundColor: Colors.green.shade700,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final q = _questions[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Q${index + 1}. ${q['question']}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ...List.generate(q['options'].length, (optIndex) {
                    return RadioListTile<int>(
                      value: optIndex,
                      groupValue: _answers[index],
                      onChanged: (value) {
                        setState(() {
                          _answers[index] = value!;
                        });
                      },
                      title: Text(q['options'][optIndex]),
                    );
                  }),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          onPressed: _validerQuiz,
          child: const Text(
            "Valider le quiz",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
