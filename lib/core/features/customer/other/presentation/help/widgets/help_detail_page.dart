import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class HelpDetailPage extends StatelessWidget {
  final String title;
  final List<String> paragraphs;
  final List<String>? orderedSteps;
  final List<String>? unorderedSteps;
  final String? closingNote;
  final List<String>? description;

  const HelpDetailPage({
    super.key,
    required this.title,
    required this.paragraphs,
    this.orderedSteps,
    this.unorderedSteps,
    this.closingNote,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        leading: IconButton(
          icon: SvgPicture.asset(
            "assets/images/icons/arrow_back.svg",
            width: 15,
            height: 15,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),
            ...paragraphs.map((p) => HelpParagraph(p)),
            if (orderedSteps != null && description != null) ...[
            const SizedBox(height: 16),
            ...orderedSteps!.asMap().entries.map((e) {
              final index = e.key;
              final step = e.value;
              final desc = (index < description!.length)
                  ? description![index]
                  : null;

              return HelpOrderedList(
                index: index + 1, 
                text: step, 
                description: desc);
            }),
          ],

            if (unorderedSteps != null) ...[
              const SizedBox(height: 20),
              const Text(
                'Status yang biasanya ditampilkan:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...unorderedSteps!.map((e) => HelpUnorderedList(text: e)),
            ],
            if (closingNote != null) ...[
              const SizedBox(height: 16),
              HelpParagraph(closingNote!),
            ],
          ],
        ),
      ),
    );
  }
}

// Komponen paragraf umum
class HelpParagraph extends StatelessWidget {
  final String text;

  const HelpParagraph(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(text, style: const TextStyle(fontSize: 14, height: 1.5)),
    );
  }
}

// Komponen list bernomor
class HelpOrderedList extends StatelessWidget {
  final int index;
  final String text;
  final String? description;

  const HelpOrderedList({super.key, required this.index, required this.text, this.description});

  @override
  Widget build(BuildContext context) {
    return Padding( 
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$index. ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            TextSpan(
              text: text,
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
            ),
            if (description != null && description!.isNotEmpty)
              const TextSpan(text: '\n'), // ⬅️ Ganti baris
            if (description != null && description!.isNotEmpty)
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, top: 4),
                  child: Text(
                    description!,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// Komponen list tak bernomor (bullet)
class HelpUnorderedList extends StatelessWidget {
  final String text;

  const HelpUnorderedList({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(fontSize: 16)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
