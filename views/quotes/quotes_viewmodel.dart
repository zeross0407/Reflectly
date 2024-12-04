import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/api_service.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:myrefectly/repository/sync.dart';

class Quote_viewmodel extends ChangeNotifier {
  bool loading = true;
  List<Quote> all_quotes = [];

  final apiService = ApiService(baseUrl: server_root_url);

  late Repository<String, Quote> _quotes_repo;
  late Repository<String, User> _user_repo;

  late User user;
  Set<String> heated = {};
  Map<String, Uint8List> image_cache = {};
  int cursor = 0;
  void like(String quote_id) {
    if (user.quote_hearted.contains(quote_id)) {
      user.quote_hearted.remove(quote_id);
      Data_Sync_Trigger().syncDataWithServer(Data_Sync(
          id: uuid.v1(),
          name: CollectionEnum.Heart.index,
          action: ActionEnum.Delete.index,
          jsonData: (quote_id),
          timeStamp: DateTime.now()));
    } else {
      user.quote_hearted.add(quote_id);
      Data_Sync_Trigger().syncDataWithServer(Data_Sync(
          id: uuid.v1(),
          name: CollectionEnum.Heart.index,
          action: ActionEnum.Create.index,
          jsonData: (quote_id),
          timeStamp: DateTime.now()));
    }
    user.save();
    notifyListeners();
  }

  Quote_viewmodel() {
    _init_data();
  }

  Future<void> _init_data() async {
    _quotes_repo = await Repository<String, Quote>(name: 'quote_box');
    await _quotes_repo.init();
    _user_repo = await Repository<String, User>(name: 'user_box');
    await _user_repo.init();
    user = await _user_repo.getAt(0);

/////////////////////////////////////////////////////////////////////////////////////
    all_quotes = await _quotes_repo.getAll();
    if (all_quotes.length > 0) {
      all_quotes.shuffle();
      notifyListeners();
    } else {
      try {
        final response = await dio.get(
          '${server_root_url}/api/Quotes/Quotes?type=${user.quote_category}',
          options: Options(
            headers: {
              'Authorization': 'Bearer $refresh_token',
            },
          ),
        );

        if (response.statusCode == 200) {
          List<QuoteRp> rs = quoteRpFromJson(response.data);
          rs.forEach((quote) async {
            Quote q = Quote(
              id: quote.id,
              content: quote.title,
              categoryId: quote.categoryid,
              like: false,
              author: quote.author,
            );
            await _quotes_repo.add(quote.id, q);
          });
        }
      } catch (e) {
        print('Error: $e');
      }
      all_quotes = await _quotes_repo.getAll();
      if (user.quote_category != 0)
        all_quotes = await all_quotes
            .where(
                (items) => items.categoryId == user.quote_category.toString())
            .toList();
      all_quotes.shuffle();

      final response = await dio.get(
        '${server_root_url}/api/Quotes/Heart',
        options: Options(
          headers: {
            'Authorization': 'Bearer $refresh_token',
            'Content-Type': 'application/json'
          },
        ),
      );

      if (response.statusCode == 200) {
        // Parse dữ liệu từ response
        List<String> hearted = [];
        if (response.data is String) {
          // Trường hợp dữ liệu trả về là chuỗi JSON
          hearted = (jsonDecode(response.data) as List<dynamic>)
              .map((item) => item.toString())
              .toList();
        } else if (response.data is List) {
          // Trường hợp dữ liệu trả về là danh sách JSON
          hearted = (response.data as List<dynamic>)
              .map((item) => item.toString())
              .toList();
        }

        // Thêm dữ liệu vào user.quote_hearted
        hearted.forEach((element) {
          user.quote_hearted.add(element);
        });
      } else {
        print('Failed to fetch hearted quotes: ${response.statusCode}');
      }

      heated = user.quote_hearted.toSet();
    }

    loading = await false;
    notifyListeners();
  }

  Future<void> SaveQuote(GlobalKey globalKey) async {
    try {
      RenderRepaintBoundary boundary =
          globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(pngBytes),
          quality: 100,
          name: "quotes_saved");
      print(result);
    } catch (e) {
      print("Error capturing widget: $e");
    }
  }
}

List<QuoteRp> quoteRpFromJson(String str) =>
    List<QuoteRp>.from(json.decode(str).map((x) => QuoteRp.fromJson(x)));

String quoteRpToJson(List<QuoteRp> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class QuoteRp {
  String id;
  String title;
  String author;
  String categoryid;

  QuoteRp({
    required this.id,
    required this.title,
    required this.author,
    required this.categoryid,
  });

  factory QuoteRp.fromJson(Map<String, dynamic> json) => QuoteRp(
        id: json["Id"],
        title: json["title"],
        author: json["author"],
        categoryid: json["categoryid"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "title": title,
        "author": author,
        "categoryid": categoryid,
      };
}
