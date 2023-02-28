import 'dart:convert';

import 'package:example/student.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simp_cache/simp_cache.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final simp = SimpCache.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: onCacheItemTap,
              child: const Text(
                'Cache Item!',
              ),
            ),
            TextButton(
              onPressed: onGetItemTap,
              child: const Text(
                'Get Item By Key!',
              ),
            ),
            TextButton(
              onPressed: onRemoveItemTap,
              child: const Text(
                'Remove Item By Key!',
              ),
            ),
            TextButton(
              onPressed: onShowCacheTap,
              child: const Text(
                'Show Cached Items!',
              ),
            ),
            TextButton(
              onPressed: onGetItemSyncTap,
              child: const Text(
                'Get Item By Key Sync!',
              ),
            ),
            TextButton(
              onPressed: onClearCacheTap,
              child: const Text(
                'Clear Cache!',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> onCacheItemTap() async {
    final Student student = Student(
      id: 1,
      name: 'Yazan',
      marks: [
        Marks(
          english: [9, 30, 42],
          arabic: [7, 28, 37],
        ),
        Marks(
          english: [10, 36, 45],
          arabic: [5, 31, 40],
        ),
      ],
    );

    await simp.cacheItem(student.id.toString(), student);
  }

  Future<void> onGetItemTap() async {
    //showSource -> Shows if the item is retrieved from RAM or SharedPreferences
    final result = await simp.getItemByKey('1', showSource: true);

    //Convert JSON to Student class
    final Student student = Student.fromJson(jsonDecode(result));

    debugPrint(student.name);

    //OUTPUT : Yazan
  }

  Future<void> onShowCacheTap() async {
    //If kDebugMode it will print all cached items.
    await simp.showCachedItems(showSource: true);
  }

  Future<void> onRemoveItemTap() async {
    await simp.removeItemByKey('1');
  }

  Future<void> onGetItemSyncTap() async {
    //Checks RAM only (Not Future).
    simp.getItemByKeySync('1');
  }

  Future<void> onClearCacheTap() async {
    await simp.clearCache();
  }
}
