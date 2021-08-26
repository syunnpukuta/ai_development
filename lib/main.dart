import 'dart:async';
import 'dart:ui';

import 'package:ai_development/document__data.dart';
import 'package:ai_development/talk_data.dart';
import 'package:bubble/bubble.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Locale locale = const Locale("ja", "JP");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI発展演習　チームB',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Apple',
        textTheme: TextTheme(

        )
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
      locale: locale,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        locale,
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  final _focusNode = FocusNode();
  List<TalkData> data = [
    TalkData(Speaker.ai, "こんにちは！\n資料の検索や追加ができます", face: FacialExpression.normal)
  ];
  String asset = "images/normal.png";
  ScrollController _scrollController = ScrollController();
  bool enableKeyBord = true;

  int currentMode = 0;
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 400), curve: Curves.bounceInOut);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          "images/watson.png",
          height: 50,
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus!.unfocus();
          }
        },
        child: Column(
          children: [
            Expanded(
              child: ListView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                children: [
                  ...data.map((e) => talkToWidget(e)).toList(),
                  Container(
                    height: 8,
                  )
                ],
              ),
            ),
            textForm(),
          ],
        ),
      ),
    );
  }

  Widget talkToWidget(TalkData data) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.face != null)
          Column(
            children: [
              Container(
                padding: EdgeInsets.only(left: 8.0, top: 2),
                alignment: Alignment.topCenter,
                child: Image.asset(
                  "images/${data.face.toString().split(".")[1]}.png",
                  height: 55,
                  width: 55,
                ),
              ),
            ],
          ),
        Flexible(
          child: Align(
            alignment: data.isAI ? Alignment.centerLeft : Alignment.centerRight,
            child: GestureDetector(
              child: Bubble(
                color:
                    data.isAI ? Color.fromARGB(255, 6, 112, 190) : Colors.white,
                margin: BubbleEdges.only(top: 10, right: 8, left: 8),
                radius: Radius.circular(16),
                nip: data.isAI ? BubbleNip.leftTop : BubbleNip.rightTop,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, left: 8),
                  child: Column(
                    children: [
                      Text(
                        data.text,
                        style: TextStyle(
                          fontSize: 17,
                          color: data.isAI ? Colors.white : Colors.black,
                        ),
                      ),
                      if (data.type == TalkType.addDocument)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.post_add,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                      if (data.type == TalkType.searchResult)
                        ...data.documentDataList!
                            .map((e) => e.toWidget())
                            .toList(),
                    ],
                  ),
                ),
              ),
              onTap: () async {
                if (data.type == TalkType.talk) return;

                if (data.type == TalkType.addDocument &&
                    currentMode == 1 &&
                    currentStep == 2) {
                  FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    PlatformFile file = result.files.first;

                    setState(() {
                      this.data.add(TalkData(
                          Speaker.user, "${file.name}\n${file.size}byte"));
                      nextStep("");
                    });
                  } else {
                    // User canceled the picker
                  }
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget iconText(IconData icon, String text) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 60,
        ),
        Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget textForm() {
    return Container(
      margin: EdgeInsets.all(8),
      padding: EdgeInsets.only(left: 8, right: 8, top: 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black38)),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              enabled: enableKeyBord,
              controller: controller,
              focusNode: _focusNode,
              maxLines: null,
              onTap: () async {
                await Future.delayed(Duration(milliseconds: 300));
                _scrollController.jumpTo(
                  _scrollController.position.maxScrollExtent + 30,
                );
              },
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 18),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Color.fromARGB(255, 6, 112, 190),
            ),
            onPressed: () async {
              String text = controller.text;
              setState(() {
                data.add(TalkData(Speaker.user, text));
                controller.text = "";
              });
              await Future.delayed(Duration(milliseconds: 100));
              scrollBottom();
              if (text.contains("追加")) currentMode = 1;
              if (text.contains("検索")) currentMode = 2;
              if (text.contains("キャンセル")) currentMode = 3;
              await nextStep(text);
            },
          )
        ],
      ),
    );
  }

  Future<void> nextStep(String text) async {
    await Future.delayed(Duration(seconds: 1));
    if (currentMode == 0) {
      setState(() {
        data.add(TalkData(Speaker.ai, text, face: FacialExpression.smile));
      });
    } else if (currentMode == 1) {
      addMode(currentStep, text);
    } else if (currentMode == 2) {
      searchMode(currentStep, text);
    } else if (currentMode == 3) {
      currentMode = 0;
      currentStep = 0;
      setState(() {
        data.add(TalkData(Speaker.ai, "中断しました", face: FacialExpression.sad));
      });
    }
    await Future.delayed(Duration(milliseconds: 100));
    scrollBottom();
  }

  DocumentData _documentData =
      DocumentData(name: "堀田 太郎", documentPath: "images/pdf.png");

  Future<void> addMode(int step, String text) async {
    switch (step) {
      case 0:
        currentStep++;
        setState(() {
          data.add(TalkData(
              Speaker.ai,
              "資料の投稿ですね。\n"
              "タイトルを入力してください",
              face: FacialExpression.smile));
        });
        break;
      case 1:
        currentStep++;
        enableKeyBord = false;
        _documentData.title = text;
        setState(() {
          data.add(TalkData(
              Speaker.ai,
              "「${_documentData.title}」ですね。\n次に、"
              "このチャットをタップして資料を選択してください",
              type: TalkType.addDocument,
              face: FacialExpression.normal));
        });
        break;
      case 2:
        currentStep++;
        setState(() {
          data.add(
              TalkData(Speaker.ai, "文字の認識中です", face: FacialExpression.sad));
        });
        scrollBottom();
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          data.add(TalkData(Speaker.ai, "これは金融業界の事例ですか？",
              face: FacialExpression.normal));
          enableKeyBord = true;
          _focusNode.requestFocus();
          _documentData.industry = "金融";
        });
        break;
      case 3:
        currentStep++;
        enableKeyBord = false;
        setState(() {
          data.add(TalkData(Speaker.ai, "資料の要約を作成中です",
              face: FacialExpression.angry));
        });
        scrollBottom();
        await Future.delayed(Duration(seconds: 2));
        _documentData.summary = "〇〇銀行の送金システムを1000万で行う。\n"
            "IBMの技術としてxxx、yyyを使う。\n"
            "開発期間は6ヶ月、テスト期間2ヶ月、計8ヶ月で作成。";
        setState(() {
          data.add(TalkData(
              Speaker.ai,
              "要約が作成できました。\n${_documentData.summary}\n\n"
              "これでよければそのまま送信。修正があれば修正後の要約を送信してください。",
              face: FacialExpression.inspiration));
          controller.text = _documentData.summary;
          enableKeyBord = true;
        });
        scrollBottom();
        break;
      case 4:
        currentMode = 0;
        currentStep = 0;
        setState(() {
          data.add(TalkData(
            Speaker.ai,
            "登録完了しました",
            face: FacialExpression.love,
            type: TalkType.searchResult,
            documentDataList: [_documentData],
          ));
        });
        break;
    }
  }

  Future<void> searchMode(int step, String text) async {
    switch (step) {
      case 0:
        currentStep++;
        setState(() {
          data.add(TalkData(
              Speaker.ai,
              "資料の検索ですね。\n"
              "キーワードを入力してください",
              face: FacialExpression.smile));
        });
        break;
      case 1:
        currentStep++;
        enableKeyBord = false;
        setState(() {
          data.add(
              TalkData(Speaker.ai, "検索中です", face: FacialExpression.normal));
        });
        await Future.delayed(Duration(seconds: 3));
        setState(() {
          data.add(TalkData(
            Speaker.ai,
            "検索できました。こちらの資料がみつかりました。",
            face: FacialExpression.inspiration,
            type: TalkType.searchResult,
            documentDataList: [SampleDocumentData.result],
          ));
        });
        scrollBottom();
        await Future.delayed(Duration(milliseconds: 200));
        setState(() {
          data.add(TalkData(
            Speaker.ai,
            "いくつか金融業界の類似資料もどうぞ。",
            face: FacialExpression.love,
            type: TalkType.searchResult,
            documentDataList: SampleDocumentData.searchResult,
          ));
          enableKeyBord = true;
        });
        currentMode = 0;
        currentStep = 0;
        break;
    }
  }

  void scrollBottom() async {
    await Future.delayed(Duration(milliseconds: 100));
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400), curve: Curves.ease);
  }
}
