import 'package:flutter/material.dart';

class SentencePickerPage extends StatefulWidget {
  final Function(String)?
      onSelect; // Callback function to handle sentence selection

  SentencePickerPage({Key? key, this.onSelect}) : super(key: key);

  @override
  _SentencePickerPageState createState() => _SentencePickerPageState();
}

class _SentencePickerPageState extends State<SentencePickerPage> {
  final List<String> allSentences = [
    'This is sentence 1.',
    'This is sentence 2.',
    'This is sentence 3.',
    'Another sentence for category A.',
    'Yet another sentence for category A.',
    'Sentence for category B.',
    'Another sentence for category B.',
  ];

  List<String> filteredSentences = [];
  String selectedCategory = '';

  @override
  void initState() {
    super.initState();
    // Initially, display all sentences
    filteredSentences = List.from(allSentences);
  }

  void filterSentencesByCategory(String category) {
    setState(() {
      selectedCategory = category;
      filteredSentences = allSentences
          .where((sentence) => sentence.contains(category))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sentence Picker'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            children: [
              ChoiceChip(
                label: Text('Category A'),
                selected: selectedCategory == 'A',
                onSelected: (selected) {
                  filterSentencesByCategory(selected ? 'A' : '');
                },
              ),
              ChoiceChip(
                label: Text('Category B'),
                selected: selectedCategory == 'B',
                onSelected: (selected) {
                  filterSentencesByCategory(selected ? 'B' : '');
                },
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSentences.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredSentences[index]),
                  onTap: () {
                    // Call the onSelect callback with the selected sentence
                    if (widget.onSelect != null) {
                      widget.onSelect!(filteredSentences[index]);
                    }
                    Navigator.pop(context, filteredSentences[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
