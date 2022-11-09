import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:friendview/const/asset_path.dart';
import 'package:friendview/localization/app_localization.dart';
import 'package:friendview/localization/language_constants.dart';
import 'package:friendview/route/router.dart';
import 'package:friendview/utils/vscroll_behavior.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
        builder: ((context) {
          return this._locale == null
              ? Container(
            color: Colors.white,
            child: Center(
              child: Container(
                width: 240,
                height: 360,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('$assetIcon/google_logo.png'),
                    )),
              ),
            ),
          )
              : Container(
              color: Colors.white,
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                scrollBehavior: VScrollBehavior(),
                // title: "getTranslated(context, 'friend_view')",
                // locale: _locale,
                // supportedLocales: [
                //   Locale("en", "US"),
                //   // Locale("fa", "IR"),
                //   // Locale("ar", "SA"),
                //   // Locale("hi", "IN")
                // ],
                // localizationsDelegates: [
                //   AppLocalizations.delegate,
                //   GlobalMaterialLocalizations.delegate,
                //   GlobalWidgetsLocalizations.delegate,
                //   GlobalCupertinoLocalizations.delegate,
                // ],
                // localeResolutionCallback: (locale, supportedLocales) {
                //   for (var supportedLocale in supportedLocales) {
                //     if (supportedLocale.languageCode ==
                //         locale!.languageCode &&
                //         supportedLocale.countryCode == locale.countryCode) {
                //       return supportedLocale;
                //     }
                //   }
                //   return supportedLocales.first;
                // },
                routeInformationProvider: CoreRouter.coreRouter.routeInformationProvider,
                routeInformationParser: CoreRouter.coreRouter.routeInformationParser,
                routerDelegate: CoreRouter.coreRouter.routerDelegate,
              ));
        }));
  }
}