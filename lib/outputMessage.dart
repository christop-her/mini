import 'package:flutter/material.dart';

class outputed extends StatefulWidget {
  const outputed({super.key});

  @override
  State<outputed> createState() => _outputedState();
}

class _outputedState extends State<outputed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Chats', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(50),
                    
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text('inbox', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600, color: Colors.white),),
                  )),
              ],
            ),
          ),
          SizedBox(height: 20,),
          Expanded(
            child: ListView.builder(
              // itemCount: outputMessage.length,
              itemBuilder: (context, index) {
                // var message = outputMessage[index];
                return Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          // color: Colors.green[200],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              // onTap: () {
                              //   Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) => MobileMessage(dataUrl: message['email']),
                              //     ),
                              //   );
                              // },
                              child: Column(
                                children: [
                              
                                  Row(
                                    children: [
                                       Container(
                                        width: 80,
                                        height: 80,

                                       ),
                                       SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(message['person'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,),),
                    // Text(message['myMessage'], style: TextStyle(fontSize: 15,),),

                  ],
                ),
                                    ],
                                  ),
                                 
                                    
                                  // Text(message['activeEmail']),
                                  // Text(message['email']),
                                  
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}