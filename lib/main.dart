import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_chat_application/MyHomePage.dart';
import 'package:gemini_chat_application/themes.dart';
import 'package:gemini_chat_application/themeNotifier.dart';
void main() async{
  await dotenv.load(fileName:".env");

  runApp(
   const ProviderScope(child:MainApp())
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});



  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    print("sagar");

    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title:"Flutter demo",
      theme:lightMode,
      darkTheme:darkMode,
      themeMode:themeMode,
      home:const MyHomePage()
    );
  }
}









