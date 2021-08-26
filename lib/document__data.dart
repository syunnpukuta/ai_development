import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DocumentData {
  String documentPath;
  String title;
  String summary;
  String name;
  String industry;

  DocumentData({
    this.name = "",
    this.documentPath = "",
    this.title = "",
    this.summary = "",
    this.industry = "",
  });

  Widget toWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 21,
              ),
            ),
            Container(
              height: 16,
            ),
            Row(
              children: [
                Text(
                  "業種: $industry",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                Expanded(child: Container()),
                Text(
                  "名前: $name",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            Container(
              height: 16,
            ),
            Text(
              "要約",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Text(
              summary,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            Container(
              height: 16,
            ),
            Image.asset(
              documentPath,
              height: 120,
              fit: BoxFit.contain,
            ),
          ],
        ),
      ),
    );
  }
}

class SampleDocumentData {
  static DocumentData result = DocumentData(
    name: "早川 勝",
    title: "R銀行の入金システム構築",
    summary: "R銀行の入金のシステムを構築。\n"
        "uuu, iii技術を活用。\n開発期間は6ヶ月、テスト期間4ヶ月、計10ヶ月で作成。",
    industry: "金融",
    documentPath: "images/pdf.png",
  );

  static List<DocumentData> searchResult = [
    DocumentData(
      name: "孫工 裕史",
      title: "G銀行の問い合わせチャットボットの作成",
      summary: "IBM Watson Assistant APIを使って予算1000万円でチャットボットを作成。",
      industry: "金融",
      documentPath: "images/word.png",
    ),
    DocumentData(
      name: "金井 正彦",
      title: "オープン・ソーシング戦略フレームワークの作成",
      summary: "オープン・ソーシング戦略フレームワーク 。\n"
          "日本IBMでは、「オープン・ソーシング戦略フレームワーク」を昨年6月に発表し、"
          "同フレームワークのソリューションを通じて多くの金融機関を支援してきました。\n"
          "- DX推進を加速するための戦略基盤としてDSPを導入 。",
      industry: "金融",
      documentPath: "images/pdf.png",
    ),
    DocumentData(
      name: "正木 達也",
      title: "オリコとIBMのDX",
      summary: ""
          "株式会社オリエントコーポレーションと日本アイ・ビー・エム株式会社は、オリコの"
          "持続的な成長に向けたデジタル・トランスフォーメーションの推進について共同で検討して"
          "いくことを決定しましたのでお知らせいたします。\n"
          "オリコは、デジタル・トランスフォーメーションを推進するにあたり、礎作りとしてIT組"
          "織の構造改革とシステム開発・運用の効率化に取り組み、IT関連の投資やコストを最適化していく予定です。\n"
          "具体的な取り組みとして、オリコが株式会社システムオリコに委託している業務を日本I"
          "BMへ移管することを共同で詳細検討する基本合意書を締結いたしました。",
      industry: "金融",
      documentPath: "images/powerpoint.png",
    ),
  ];
}
