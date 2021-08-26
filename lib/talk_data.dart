import 'package:ai_development/document__data.dart';

class TalkData {
  Speaker speaker;
  String text;
  FacialExpression? face;
  TalkType type;
  List<DocumentData>? documentDataList;

  bool get isUser => speaker == Speaker.user;

  bool get isAI => speaker == Speaker.ai;

  TalkData(
    this.speaker,
    this.text, {
    this.face,
    this.type = TalkType.talk,
    this.documentDataList,
  });
}

enum Speaker {
  user,
  ai,
}

enum TalkType {
  talk,
  addDocument,
  searchResult,
}

enum FacialExpression {
  normal,
  smile,
  surprise,
  sad,
  love,
  angry,
  inspiration,
}
