

//api key : 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

import 'package:ai_voice_assistant/chat_screen.dart';
import 'package:ai_voice_assistant/featuresBox.dart';
import 'package:ai_voice_assistant/openai_serices.dart';
import 'package:ai_voice_assistant/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:animate_do/animate_do.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechtoText = SpeechToText();
  String lastWords = '';
  bool isLoading = false;
  int start = 200;
  int delay = 200;

  final OpenAIService  openAIService = OpenAIService();
  FlutterTts flutterTts = FlutterTts();

  String? generatedContent;
  String? generatedImageUrl;







  @override
  void initState(){
    // TODO: implement initState
    super.initState();

     initSpeechToText();
     initTextToSpeech();
  }

  Future<void> initSpeechToText() async {
    await speechtoText.initialize();
    setState(() {});
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }


  Future<void> startListening() async {
    await speechtoText.listen(onResult: onSpeechResult);
    setState(() {});
  }

 
  Future<void> stopListening() async {
    await speechtoText.stop();
    setState(() {});
  }

  
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }


  Future<void> systemSpeak(String content)
  async{
    await flutterTts.speak(content);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    speechtoText.stop();
    flutterTts.stop();
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text("Allen")),
        //leading: const Icon(Icons.menu),
        actions: [

          IconButton(onPressed: (){


            Navigator.push(context, MaterialPageRoute(builder: (context){


              return ChatScreen();
            }));



          }, icon: Icon(Icons.chat_outlined)),


        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //virtual Assistant picture

            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: 120,
                      width: 120,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                          color: Pallete.assistantCircleColor,
                          shape: BoxShape.circle),
                    ),
                  ),
                  Container(
                    height: 123,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/virtualAssistant1.png'))),
                  )
                ],
              ),
            ),

            FadeInRight(
              child: Visibility(
                visible:generatedImageUrl == null ,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
                  decoration: BoxDecoration(
                      border: Border.all(color: Pallete.borderColor),
                      borderRadius:
                          BorderRadius.circular(20).copyWith(topLeft: Radius.zero)),
                  child:  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                     generatedContent == null ? "Welcome , what task can I do for you? " : generatedContent!,
                      style: TextStyle(
                          color: Pallete.mainFontColor,
                          fontFamily: 'Cera Pro',
                          fontSize: generatedContent == null ? 20 : 18 ),
                    ),
                  ),
                ),
              ),
            ),


          

            if(generatedImageUrl != null ) Padding(
              padding: const EdgeInsets.all(10.0),


              
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20)
                
                ,child: Image.network(generatedImageUrl!)),
                ),

            SlideInLeft(
              child: Visibility(
                visible: generatedContent == null && generatedImageUrl == null,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(top: 10, left: 22),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Here are a few features',
                    style: TextStyle(
                        fontFamily: 'Cera Pro',
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

            //features list

            Visibility
          (
              visible: generatedContent == null && generatedImageUrl == null ,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child:const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: 'ChatGPT',
                      descriptionText:
                          'A smarter way to stay organized and informed with ChatGPT',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child:const FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headerText: 'Dall-E',
                      descriptionText:
                          'Get inspired and stay creative with your personal assistant powered by Dall-E',
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2*delay),
                    child: const FeatureBox(
                      color: Pallete.thirdSuggestionBoxColor,
                      headerText: 'Smart Voice Assistant',
                      descriptionText:
                          'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT ',
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: ZoomIn(
        child: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
      
      
            if(await speechtoText.hasPermission && speechtoText.isNotListening)
            {
              await startListening();
            }
            else if(speechtoText.isListening)
            {
              final speech = await openAIService.isArtPromptAPI(lastWords);
      
              if(speech.contains('https')){
      
                generatedImageUrl = speech;
                generatedContent = null;
                setState(() {
                  //isLoading = true;
                });
              }
              else
              {
                generatedImageUrl = null;
                generatedContent = speech;
                setState(() {
                  
                });
                await systemSpeak(speech);
      
              }
      
              print(speech);
             
              await stopListening();
              
            }
            else
            {
             initSpeechToText();
            
              
            }
      
      
      
      
          },
          child: Icon(
            speechtoText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}
