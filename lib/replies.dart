import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini/ipconfig.dart';

class ReplyClass extends StatefulWidget {
  final int commentId;
  const ReplyClass({Key? key, required this.commentId}) : super(key: key);
  
  @override
  State<ReplyClass> createState() => _ReplyClassState();
}

class _ReplyClassState extends State<ReplyClass> {
  TextEditingController commentController= TextEditingController();
  List<dynamic> userComments = [];
  List<dynamic> userReply = [];
  var noLiked;
  var noDisLiked;
  var userData;
  String Name = '';
  String comment = '';
  int userCommentId = 0;
  int userReplyId = 0;
  String userName = '';
  var commentImage;
  String email = '';
  String activeEmail = '';
  File? _image;
  final picker = ImagePicker();


  

 void userDetails() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email') ?? '';
  });

  var url = "http://$ipconfig/apisocial/userData.php";
  var response = await http.post(Uri.parse(url),
  body: {
    'email': email
  }
  );
  var jsonResponse =json.decode(response.body);
  if(jsonResponse['success'] == 'login successful'){
      setState(() {
       userData = jsonResponse['data'][0];
        Name = userData['name'];
       
      });
  }
 }
   Future<void> _getImageFromGallery() async {
    
  final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      } else {
        print('No image selected.');
      }
    });
  }

   Future<void> postReply() async {
 
    SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email') ?? '';
  });

  final uri = Uri.parse("http://$ipconfig/apisocial/apiReply.php");
  var request = http.MultipartRequest('POST', uri);
  request.fields['replies'] = commentController.text;
  request.fields['email'] = email;
  request.fields['name'] = Name;
  request.fields['replyId'] = widget.commentId.toString();
  request.fields['activeEmail'] = activeEmail;

 if (_image != null) {
    var pic = await http.MultipartFile.fromPath("image_01", _image!.path);
    request.files.add(pic);
  }

  var response = await request.send();

  if (response.statusCode == 200) {
    print('reply sent');
    getReply();
     setState(() {
      commentController.clear();
      _image = null;
    });

  
    setState(() {
      _image = null;
    });

  } else {
    print('comment not uploaded');
  }
}

  void cancelImage() {
    setState(() {
     _image = null;
    });
  }

void getCommentId() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email') ?? '';
  });
  
  
  getReply();

var myurl = "http://$ipconfig/apisocial/userData.php";
  var res = await http.post(Uri.parse(myurl),
  body: {
    'email': email
  }
  );
  var jsonRes =json.decode(res.body);
  if(jsonRes['success'] == 'login successful'){
      setState(() {
       userData = jsonRes['data'][0];
        Name = userData['name'];  
      });
      
      
  }
  

  var url = "http://$ipconfig/apisocial/fetch_commentId.php";
  var response = await http.post(Uri.parse(url),
  body: {
    'id': widget.commentId.toString()
  },
  );
 var jsonResponse = json.decode(response.body);
 if(response.statusCode == 200){
  setState(() {
    userComments = jsonResponse;
    userName = userComments[0]['name'];
    comment = userComments[0]['comments'];
    commentImage = userComments[0]['image_01'];
    activeEmail = userComments[0]['activeEmail'];
    userCommentId = userComments[0]['id'];

  

    getNoOfLiked();
   getNoOfDisliked();
  
  
  fetchLiked();
  fetchUnLiked();

  });

//    var replyurl = "http://192.168.120.26/practice/fetch_replyId.php";
//   var replyResponse = await http.post(Uri.parse(replyurl),
//   body: {
//     'id': userReply[0]['id'].toString()
//   },
//   );
//  var jsonReplyResponse = json.decode(replyResponse.body);
//  if(response.statusCode == 200){
//   userReply = jsonReplyResponse;
//   setState(() {
//      userReply.forEach((reply) {
//         fetchReplyLiked(reply);
//       });
//       print(userReplyId.toString());
//   });
//  }

   
   
 }
 else if(jsonResponse['success'] == 'fetch unsuccessful'){
  print('object');
 }
  
}
bool isReply = false;
void getReply() async {
 
  var url = "http://$ipconfig/apisocial/api_fetch_reply.php";
  var response = await http.post(Uri.parse(url),
  body: {
    'id': widget.commentId.toString()
  },
  );
 var jsonResponse = json.decode(response.body);
//  print(widget.commentId.toString());
 if(jsonResponse['success'] == 'fetch successful'){
  setState(() {
    print(jsonResponse['data']);
    userReply = jsonResponse['data']; // Assuming 'data' contains the array of replies
        userName = userReply[0]['name'];
        activeEmail = userReply[0]['activeEmail'];
        userReplyId = userReply[0]['id'];
        isReply = true;
        
        userReply.forEach((reply) {
        fetchReplyLiked(reply);
      });
       userReply.forEach((reply) {
        fetchUnReplyLiked(reply);
      });
         
  });

    await Future.forEach(userReply, (reply) async {
      await getNoOfReplyLiked(reply);
    });
    await Future.forEach(userReply, (reply) async {
      await getNoOfReplyDisliked(reply);
    });

  // print(widget.commentId.toString());
 } else if (jsonResponse['success'] == 'fetch unsuccessful'){
  setState(() {
    isReply = false;
  });
 }
  
}
 bool isLiked = false;

 void like() async{
    var url = "http://$ipconfig/apisocial/comment_like_box.php";
    disableDislike();
    var response = await http.post(Uri.parse(url),
    body: {
         'commentId': widget.commentId.toString(),
        'activeEmail': activeEmail,
        'email' : email
    },
    );
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
  isLiked = true;
  getNoOfLiked();
  getNoOfDisliked();
});
  print('success');  
   
}
}

void unlike() async{
 var url = "http://$ipconfig/apisocial/comment_unlike_box.php";
   
    var response = await http.post(Uri.parse(url),
    body: {
       'commentId': widget.commentId.toString(),
        'activeEmail': activeEmail,
        'email' : email
       
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'unlike successful'){
setState(() {
   isLiked = false;
   getNoOfLiked();
});
  print('success');
    
}
}

void fetchLiked() async{
 var url = "http://$ipconfig/apisocial/fetch_comment_like.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'commentId': widget.commentId.toString(),
        'activeEmail': activeEmail,
        'email' : email
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
   isLiked = true;
});
}
}

bool isdislike = false;

  void dislike() async{
    var url = "http://$ipconfig/apisocial/comment_dislike_box.php";
    unlike();
    var response = await http.post(Uri.parse(url),
    body: {
         'commentId': widget.commentId.toString(),
        'activeEmail':activeEmail,
        'email' : email
    },
    );
   
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
  isdislike = true;
   getNoOfDisliked();
  getNoOfLiked();
});
  print('success');  
   
}
}

void disableDislike() async{
 var url = "http://$ipconfig/apisocial/comment_disableDislike_box.php";
    
    var response = await http.post(Uri.parse(url),
    body: {
       'commentId': widget.commentId.toString(),
        'activeEmail': activeEmail,
        'email' : email
       
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'unlike successful'){
setState(() {
   isdislike = false;
   getNoOfDisliked();
});
  print('success');
    
}
}


void fetchUnLiked() async{
 var url = "http://$ipconfig/apisocial/fetch_comment_enableUnLiked.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'commentId': widget.commentId.toString(),
        'activeEmail': activeEmail,
        'email' : email
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
   isdislike = true;
});

}
}

Future<void> getNoOfLiked() async {
  var url = "http://$ipconfig/apisocial/commentLikeNumber.php";

  var liked = await http.post(Uri.parse(url), body: {
    'commentId': widget.commentId.toString(),
    'activeEmail': activeEmail,
  });

  if (liked.statusCode == 200) {
    var jsonLikeOutput = json.decode(liked.body);
    setState(() {
      noLiked = jsonLikeOutput.length; // Store the number of likes in the comment itself
    });
    // print(jsonLikeOutput.length);
    // print(comment['id'].toString());
  } else {
    // Handle other status codes (e.g., display an error message)
    print('Failed to get likes. Status code: ${liked.statusCode}');
  }
}

Future<void> getNoOfDisliked() async {
  var url = "http://$ipconfig/apisocial/commentDisLikeNumber.php";

  var liked = await http.post(Uri.parse(url), body: {
    'commentId': widget.commentId.toString(),
    'activeEmail': activeEmail,
  });

  if (liked.statusCode == 200) {
    var jsonLikeOutput = json.decode(liked.body);
    setState(() {
      noDisLiked = jsonLikeOutput.length; // Store the number of likes in the comment itself
    });
    // print(jsonLikeOutput.length);
    // print(comment['id'].toString());
  } else {
    // Handle other status codes (e.g., display an error message)
    print('Failed to get likes. Status code: ${liked.statusCode}');
  }
}






bool isReplyLiked(Map<String, dynamic> reply) {
  return reply['isReplyLiked'] ?? false;
}

  void replyLike(Map<String, dynamic> reply) async{
    var url = "http://$ipconfig/apisocial/reply_like_box.php";
    ReplydisableDislike(reply);
    
    var response = await http.post(Uri.parse(url),
    body: {
         'replyId': reply['id'].toString(),
        'activeEmail': activeEmail,
        'email' : email
    },
    );
   
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
  reply['isReplyLiked'] = true;
  getNoOfReplyLiked(reply);
  getNoOfReplyDisliked(reply);
});
  print('success');  
   
}
}

void unReplyLike(Map<String, dynamic> reply) async{
 var url = "http://$ipconfig/apisocial/reply_unlike_box.php";
   
    var response = await http.post(Uri.parse(url),
    body: {
       'replyId': reply['id'].toString(),
        'activeEmail': activeEmail,
        'email' : email
       
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'unlike successful'){
setState(() {
   reply['isReplyLiked'] = false;
   getNoOfReplyLiked(reply);
});
  print('success');
    
}
}

void fetchReplyLiked(Map<String, dynamic> reply) async{
 var url = "http://$ipconfig/apisocial/fetch_reply_like.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'replyId': reply['id'].toString(),
        'activeEmail': activeEmail,
        'email' : email
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
  // userlike = jsonResponse['data'][0];

   reply['isReplyLiked'] = true;
});
// print('complete : $userlike');
}
}

Future<void> getNoOfReplyLiked(Map<String, dynamic> reply) async {
  var url = "http://$ipconfig/apisocial/replyLikeNumber.php";

  var liked = await http.post(Uri.parse(url), body: {
    'replyId': reply['id'].toString(),
    'activeEmail': activeEmail,
  });

  if (liked.statusCode == 200) {
    var jsonLikeOutput = json.decode(liked.body);
    setState(() {
      reply['noReplyLiked'] = jsonLikeOutput.length; // Store the number of likes in the comment itself
    });
    print(jsonLikeOutput.length);
    print(reply['id'].toString());
  } else {
    // Handle other status codes (e.g., display an error message)
    print('Failed to get likes. Status code: ${liked.statusCode}');
  }
}

bool isReplydislike(Map<String, dynamic> reply) {
  return reply['isReplydislike'] ?? false;
}

  void replyDislike(Map<String, dynamic> reply) async{
    var url = "http://$ipconfig/apisocial/reply_dislike_box.php";
    unReplyLike(reply);
   
    var response = await http.post(Uri.parse(url),
    body: {
         'replyId': reply['id'].toString(),
        'activeEmail': activeEmail,
        'email' : email
    },
    );
   
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
  reply['isReplydislike'] = true;
  getNoOfReplyDisliked(reply);
  getNoOfReplyLiked(reply);
});
  print('success');  
   
}
}

void ReplydisableDislike(Map<String, dynamic> reply) async{
 var url = "http://$ipconfig/apisocial/reply_disableDislike_box.php";
    getNoOfReplyLiked(reply);
    var response = await http.post(Uri.parse(url),
    body: {
       'replyId': reply['id'].toString(),
        'activeEmail': activeEmail,
        'email' : email
       
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'unlike successful'){
setState(() {
   reply['isReplydislike'] = false;
   getNoOfReplyDisliked(reply);
   
});
  print('success');
    
}
}

void fetchUnReplyLiked(Map<String, dynamic> reply) async{
 var url = "http://$ipconfig/apisocial/fetch_reply_enableUnLiked.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'replyId': reply['id'].toString(),
        'activeEmail': activeEmail,
        'email' : email
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
  // userlike = jsonResponse['data'][0];

   reply['isReplydislike'] = true;
});
// print('complete : $userlike');
}
}


Future<void> getNoOfReplyDisliked(Map<String, dynamic> reply) async {
  var url = "http://$ipconfig/apisocial/replyDisLikeNumber.php";

  var liked = await http.post(Uri.parse(url), body: {
    'replyId': reply['id'].toString(),
    'activeEmail': activeEmail,
  });

  if (liked.statusCode == 200) {
    var jsonLikeOutput = json.decode(liked.body);
    setState(() {
      reply['noReplyDisLiked'] = jsonLikeOutput.length; // Store the number of likes in the comment itself
    });
    print(jsonLikeOutput.length);
    print(reply['id'].toString());
  } else {
    // Handle other status codes (e.g., display an error message)
    print('Failed to get likes. Status code: ${liked.statusCode}');
  }
}


  @override

   void initState(){
    super.initState();
    getCommentId();
    
  }

  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Replies'),
    ),
    body: Column(
      children: [
       Expanded(
         child: Row(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Container(
               width: 50,
               height: 50,
               decoration: BoxDecoration(
                 color: Colors.black12,
                 border: Border.all(
                   color: Colors.white,
                   width: 5,
                 ),
                 borderRadius: BorderRadius.circular(100),
               ),
               child: Icon(Icons.person_add_alt_rounded, size: 50, color: Colors.white,),
             ),
             Expanded(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Container(
                     padding: EdgeInsets.all(10),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(20),
                       color: Colors.black12,
                     ),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(userName, style: TextStyle(fontSize: 20),),
                         Text(comment),
                         Text(widget.commentId.toString())
                       ],
                     ),
                   ),
                   SizedBox(height: 10),
                   commentImage == null ||  commentImage.isEmpty ?
                   Container():
                   Container(
                     color: Colors.black45,
                     width: 100,
                     child: Image.network(
                       "http://$ipconfig/apisocial/uploaded_img/${commentImage}",
                       // fit: BoxFit.cover, 
                     ),
                   ),
                   SizedBox(height: 10,),
                  Row(
                   children: [
              
                     Row(
                       children: [
                         GestureDetector(
                           onTap: (){isLiked ? unlike() : like();},
                           child: isLiked ? Icon(Icons.thumb_up, color: Colors.green,) : Icon(Icons.thumb_up_off_alt,)
                         ),
                          SizedBox(width: 8,),
                         Text(noLiked.toString())
                       ],
                     ),
         
                      SizedBox(width: 20),
                     Row(
                       children: [
                         GestureDetector(
                           onTap: (){isdislike ?  disableDislike() : dislike();},
                           child:isdislike ?  Icon(Icons.thumb_down, color: Colors.green,) : Icon(Icons.thumb_down_off_alt,)
                         ),
                         SizedBox(width: 8,),
                         Text(noDisLiked.toString())
                       ],
                     ),
         
                     SizedBox(width: 20),
                     GestureDetector(
                       child: Text('Reply', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                     ),
                   ],
                 ),
         Expanded(
                   child: isReply ?  ListView.builder(
         
                     itemCount: userReply.length,
                     itemBuilder: (context, index) {
                       var reply = userReply[index];
                       return Container(
                         padding: EdgeInsets.all(10),
                         child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Container(
             width: 50,
             height: 50,
             decoration: BoxDecoration(
               color: Colors.black12,
               border: Border.all(
                 color: Colors.white,
                 width: 5,
               ),
               borderRadius: BorderRadius.circular(100),
             ),
             child: Icon(Icons.person_add_alt_rounded, size: 50, color: Colors.white,),
           ),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Container(
                   padding: EdgeInsets.all(10),
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(20),
                     color: Colors.black12,
                   ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(reply['name'], style: TextStyle(fontSize: 20),),
                       Text(reply['replies']),
                       Text(reply['id'].toString(),),
                     ],
                   ),
                 ),
                 SizedBox(height: 10),
                 reply['image_01'] == null || reply['image_01'].isEmpty ?
         
                 Container() :
                 Container(
                   color: Colors.black45,
                   width: 100,
                   child: Image.network(
                     "http://$ipconfig/apisocial/uploaded_img/${reply['image_01']}",
                     // fit: BoxFit.cover, 
                   ),
                 ),
                 Row(
                   children: [
                      Row(
                       children: [
                         GestureDetector(
                                    onTap: (){isReplyLiked(reply) ? unReplyLike(reply) : replyLike(userReply[index]);},
                                    child: Row(
                                      children: [
                                        isReplyLiked(reply) ? Icon(Icons.thumb_up, color: Colors.green,) : Icon(Icons.thumb_up_off_alt,),
                                        SizedBox(width: 10,),
                                        
                                        Text(reply['noReplyLiked'].toString())
                                      ],
                                    )
                                  ),
                                
                                   SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: (){isReplydislike(reply) ?  ReplydisableDislike(reply) : replyDislike(reply);},
                                    child: Row(
                                      children: [
                                        isReplydislike(reply) ?  Icon(Icons.thumb_down, color: Colors.green,) : Icon(Icons.thumb_down_off_alt,),
                                        SizedBox(width: 10,),
                                        Text(reply['noReplyDisLiked'].toString())
                                      ],
                                    )
                                  ),
                       ],
                     ),
                   ],
                 ),
               ],
             ),
           ),
         ],
                         ),
                       );
                     },
                   ) : Container()
                 ),
                   
                 ],
               ),
             ),
           ],
         ),
       ),
            
       
        Container(
          color: Colors.white, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _image != null ? Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: Image.file(
                      _image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  IconButton(onPressed: (){cancelImage();}, icon: Icon(Icons.cancel_outlined))
                ],
              ) : Container(),
              BottomAppBar(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.0),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: (){ _getImageFromGallery(); },
                        icon: Icon(Icons.photo_library_rounded),
                      ),
                      Expanded(
                        child: Container(
                  decoration: BoxDecoration(
                  
                   border: Border.all(
                    color: Colors.black,
                    width: 1
                   ),
                 borderRadius: BorderRadius.circular(50)
                  ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextField(
                              controller: commentController,
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                // border: OutlineInputBorder(),
                               border: InputBorder.none
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 8.0),
                      IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () { postReply(); },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  }

