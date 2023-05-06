// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ai_voice_assistant/openai_serices.dart';
import 'package:flutter/material.dart';

List<TextBubbles> textBubbles = [];


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final TextEditingController textEditingController = TextEditingController();







  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CHAT',
          style: TextStyle(color: Colors.white, fontFamily: 'Cera Pro'),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(26, 24, 54, 1),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              color: Colors.white,
            )),
      ),
      backgroundColor: Color.fromRGBO(26, 24, 54, 1),
      body: SafeArea(
        child: Column(
          children: [

            Expanded(child: ListView.builder(
              itemCount: textBubbles.length,
              itemBuilder: (context , index)
              {
                return textBubbles[textBubbles.length - index - 1];
              },


              

            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
           // children: textBubbles,


            ))






            ,Container(
              margin: EdgeInsets.all(15),
              //color: Colors.blue[900],
              height: 45,
              child: Row(
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(35),
                        boxShadow: const [
                          BoxShadow(
                              offset: Offset(0, 3),
                              blurRadius: 5,
                              color: Colors.grey)
                        ]),
                    child:  Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: TextField(
                        controller: textEditingController,
                        //maxLines: 1,
                        decoration: const InputDecoration(
                        
                          isDense: true,
                            hintText: 'Type Something Here.....',
                            //hintStyle: TextStyle(color: Colors.blueAccent),
                            border: InputBorder.none),
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 15,
                  ),
                  Center(
                    child: InkWell(
                      child: Icon(
                        Icons.send_outlined,
                        color: Colors.white,
                        size: 25,
                      ),
                      onTap: () async{
                  
                        textBubbles.clear();
                        String que = textEditingController.text;
                        final tb =TextBubbles(text: textEditingController.text, isME: true , type: 'text',);
                        textEditingController.clear();

                       
                        
                        setState(() {
                           textBubbles.add(tb);
                          
                        });
                       
                  
                  
                         final res = await OpenAIService().isArtPromptAPI(que);
                         final rb;

                         if(res.contains('https'))
                         {
                            rb = TextBubbles(text: res, isME: false , type: 'img',);

                         }
                         else
                         {
                            rb = TextBubbles(text: res, isME: false , type: 'text',);
                         }
                  
                        
                  
                  
                  
                         setState(() {
                           
                         textBubbles.add(rb);
                         });
                  
                  
                        print(res);
                        
                         
                  
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




class TextBubbles extends StatelessWidget {

  String text;
  bool isME;
  String type;

  TextBubbles({
    Key? key,
    required this.text,
    required this.isME,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return type == 'text' ? Padding(
      padding: EdgeInsets.all(10.0),
      child:Column(
        crossAxisAlignment:
            isME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [

          Material(
            borderRadius: isME
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isME ? Color.fromRGBO(48, 46, 97, 1) : Color.fromRGBO(91, 72, 215, 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: TextStyle(
                    color: isME ? Colors.white : Colors.white, fontSize: 15),
              ),
            ),
          ),
        ],
      )





      
      
      
      ,
    ):  Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isME ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
         
          Material(
            borderRadius: isME
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isME ? Color.fromRGBO(48, 46, 97, 1) : Color.fromRGBO(91, 72, 215, 1),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Container(
              
                height: 200,
                width: 150,
                
                child: text == "" ? const CircularProgressIndicator() : Image.network(text)),
            ),
          ),
        ],
      ),
    )
    
    
    
    ;
  }
}
