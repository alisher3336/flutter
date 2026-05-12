import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:io';
import 'dart:convert';
import 'summary.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(child: Text("loading")),
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text("Wikipedia"),
          ),
        ),
      ),
    );
  }
}

class ArticleModel {
  Future<Summary> getRandomArticleSummary() async {
    final uri = Uri.https(
      "enwikipedia.org",
      "/api/rest_v1/page/random/summary",
    );

    final response = await get(uri);

    if (response.statusCode != 200) {
      throw const HttpException("Failed to recieve page summary");
    }
    return Summary.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }
}

class ArticleViewModel extends ChangeNotifier {
  final ArticleModel model;
  Summary? summary;
  Exception? error;
  bool isLoading = false;
  ArticleViewModel(this.model) {
    fetchArticle();
  }

  Future<void> fetchArticle() async {
    try {
      isLoading = true;
      notifyListeners();

      summary = await model.getRandomArticleSummary();
      error = null;
    } on HttpException catch (e) {
      error = e;
      summary = null;
    }
    isLoading = false;
    notifyListeners();
  }
}

class _ArticleViewState extends State<ArticleView> {
  final ArticleViewModel viewModel = ArticleViewModel(ArticleModel());

  @override
  void initState() {
    super.initState();
    viewModel.fetchArticle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Article")),
      body: Center(
        child: ListenableBuilder(
          listenable: viewModel,
          builder: (context, _) {
            return Container(); 
          },
        ),
      ),
    );
  }
}

class ArticleView extends StatefulWidget {
  const ArticleView({super.key});

  @override
  State<ArticleView> createState() => _ArticleViewState();
}

class ArticleWidget extends StatelessWidget {
  final Summary summary;
  final VoidCallback nextArticle;
  ArticleWidget({super.key, required this.summary, required this.nextArticle});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (summary.hasImage) Image.network(summary.originalImage!.source),

          SizedBox(height: 10),

          Text(summary.titles.normalized),

          SizedBox(height: 10),

          if (summary.description != null)
            Text(
              summary.description!,
              style: Theme.of(context).textTheme.displaySmall,
              overflow: TextOverflow.ellipsis,
            ),
          SizedBox(height: 10),

          Text(summary.extract),
        ],
      ),
    );
  }
}

class ArticlePage extends StatelessWidget {
  final Summary summary;
  final VoidCallback nextArticle;

  const ArticlePage({
    super.key,
    required this.summary,
    required this.nextArticle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ArticleWidget(summary: summary),
          ElevatedButton(
            onPressed: nextArticle,
            child: const Text('Next random article'),
          ),
        ],
      ),
    );
  }
}
