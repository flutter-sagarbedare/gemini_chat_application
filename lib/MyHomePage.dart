import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gemini_chat_application/massage.dart';
// import 'package:gemini_chat_application/themes.dart';
import 'package:gemini_chat_application/themeNotifier.dart';
import 'package:google_generative_ai/google_generative_ai.dart';



// GOOGLE_API_KEY="AIzaSyAECTRAytfgC-w18mjQFKhNUiJHPtqsHf8"
/*
api key of gemini ai

AIzaSyAECTRAytfgC-w18mjQFKhNUiJHPtqsHf8
 */



class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState createState() => _MyHomePage();
}

class _MyHomePage extends ConsumerState<MyHomePage> {
  final TextEditingController _controller =  TextEditingController();

  final List<Message> _messages = [
                      Message(text: "Hii!!", isUser: true),
                      Message(text: "Hello!!", isUser: false),
                      // Message(text:"Kashi ahes Chandra??", isUser:true),
                      // Message(text:"Mi Mast...", isUser:false),
                      Message(text: "Your Question??", isUser: true),
                      Message(text: "I will answer...", isUser: false),
  ];
   bool checkTheme = false;
   bool _isLoading = false;
  // final apiKey = Platform.environment['AIzaSyAECTRAytfgC-w18mjQFKhNUiJHPtqsHf8'];
      
  // he function call hote ani data send hoto and output yet je ki screen varati show kel jat
  callGeminiModel()async{
    try{
      if(_controller.text.isNotEmpty){
        _messages.add(Message(text: _controller.text,isUser:true));
        setState((){});
        _isLoading=true;
      // _controller.clear();

      }
        final model = GenerativeModel(model:'gemini-2.0-flash',apiKey:dotenv.env['GOOGLE_API_KEY']!);
        // final model = GenerativeModel(model:'gemini-pro',apiKey:"AIzaSyAECTRAytfgC-w18mjQFKhNUiJHPtqsHf8");

      final prompt = _controller.text.trim();
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      setState((){
        _messages.add(Message(text:response.text!,isUser:false));
        _isLoading = false;
      });
      _controller.clear();
    }catch(ex){
      log("error : $ex");
    }
    }

  @override
  Widget build(BuildContext context) {
    // log();


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          backgroundColor:Theme.of(context).colorScheme.surface,


          // ha aahe appbar jyat name ahe image, and dark mode ahet


          appBar: AppBar(
            centerTitle: false,
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation:2,
            shadowColor: Colors.black,
            title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                     Image.asset('img/gpt-robot.png'),
                      const SizedBox(width: 15),
                      Text(
                        "Gemini Ai",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap:(){
                      if(checkTheme){
                        checkTheme = false;
                      }else{
                        checkTheme = true;
                      }
                      
                      ref.read(themeProvider.notifier).toggleTheme();
                    },
                    child:checkTheme ? const Icon(Icons.light_mode,
                    color:Colors.white
                    ) : const Icon(Icons.dark_mode
                    )),
                ]),
          ),


          // he ahe main UI chi body
          body: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      return ListTile(
                        title: Align(
                          alignment: message.isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: message.isUser
                                      ? 
                                      Colors.blue
                                      // Theme.of(context).colorScheme.primary
                                      :
                                      Colors.grey[300],

                                      // Theme.of(context).colorScheme.secondary,
                                  borderRadius: message.isUser
                                      ? const BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(20),
                                        )
                                      : const BorderRadius.only(
                                        topRight:Radius.circular(20),
                                          topLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          bottomLeft: Radius.circular(0),
                                        )),
                              child: Text(message.text,
                                  style: message.isUser
                                          ? Theme.of(context).textTheme.bodyMedium : Theme.of(context).textTheme.bodySmall
                                          
                                        )
                                      ),
                        ),
                      );
                    }),
              ),

              // user input
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 32.0, top: 16, left: 16, right: 16),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        )
                      ]),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style:Theme.of(context).textTheme.titleSmall,
                          decoration:  InputDecoration(
                            fillColor:Colors.red,
                            hintText: "Kay Vicharan Ashin te vichar",
                            hintStyle:Theme.of(context).textTheme.titleSmall!.copyWith(
                              color:Colors.grey
                            ),
                            border: InputBorder.none,
                            contentPadding:
                               const EdgeInsets.symmetric(horizontal: 20),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      _isLoading ? 
                      const Padding(
                        padding:EdgeInsets.all(8),
                        child:SizedBox(
                          width:20,
                          height:20,
                          child:CircularProgressIndicator()
                        )
                      ) :
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            callGeminiModel();
                          }, 
                          child:const Icon(Icons.send)
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
