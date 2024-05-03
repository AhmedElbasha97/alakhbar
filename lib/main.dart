import 'package:alakhbar/services/connection_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io';

import 'Utils/localization_services.dart';
import 'Utils/memory.dart';
import 'Utils/transelation/app_transelation.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Get.putAsync(() => StorageService.init(), permanent: true);
  Get.put(LocalizationService.init(), permanent: true);
  await Get.putAsync(() => ConnectionService.init(), permanent: true);


  runApp(  const MyApp());
}



class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }
  // This widget is the root of your application.
  AppUpdateInfo? _updateInfo;

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  bool _flexibleUpdateAvailable = false;

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {
      showSnack(e.toString());
    });
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text(text)));
    }
  }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      translations: AppTranslations(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          systemOverlayStyle: SystemUiOverlayStyle( //<-- SEE HERE
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
      ),

      locale:  Get.find<LocalizationService>().activeLocale,
      supportedLocales: SupportedLocales.all,
      fallbackLocale: SupportedLocales.english,
      localizationsDelegates:  const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),

    );
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}