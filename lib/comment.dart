import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mini/replies.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mini/ipconfig.dart';


class Comment extends StatefulWidget {
  final String activeEmail;
  const Comment({Key? key, required this.activeEmail}) : super(key: key);
  
  @override
  State<Comment> createState() => _CommentState();
}

class _CommentState extends State<Comment> {
  TextEditingController commentController= TextEditingController();
  List<dynamic> userComments = [];
  List<dynamic> numberlikeOutput = [];
  int noLiked = 0;
  var userData;
  var commentData;
  String Name = '';
  var userlike;
  int commentId = 0;
  String email = '';
  File? _image;
  final picker = ImagePicker();
  late WebSocketChannel channel;
  bool isLoading = false;


  

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

   Future<void> postComment() async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email') ?? '';
  });

  final uri = Uri.parse("http://$ipconfig/apisocial/apiComments.php");
  var request = http.MultipartRequest('POST', uri);
  request.fields['comments'] = commentController.text;
  request.fields['email'] = email;
  request.fields['name'] = Name;
  request.fields['activeEmail'] = widget.activeEmail;

  if (_image != null) {
    var pic = await http.MultipartFile.fromPath("image_01", _image!.path);
    request.files.add(pic);
  }

  var response = await request.send();

  if (response.statusCode == 200) {
    print('comment sent');
    // allComments();


    channel = IOWebSocketChannel.connect('ws://$ipconfig:8080');
    // Send the message via WebSocket
    channel.sink.add(json.encode({
      'comments': commentController.text,
      'activeEmail': widget.activeEmail,
      'email': email,
      'name': Name,
      'recipientEmail': widget.activeEmail,
      'image_01': _image != null ? _image!.path.split('/').last : ''
    }));
    print("Message sent via WebSocket");



 


    setState(() {
      commentController.clear();
      _image = null;
    });
  } else {
    print('comment not uploaded');
  }
  allComments();
}

  void cancelImage() {
    setState(() {
     _image = null;
    });
  }

  

void allComments() async {
  channel = IOWebSocketChannel.connect('ws://$ipconfig:8080');
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
    email = preferences.getString('email') ?? '';
  });
setState(() {
  isLoading = true;
});
  var myurl = "http://$ipconfig/apisocial/userData.php";
  var res = await http.post(Uri.parse(myurl), body: {'email': email});
  var jsonRes = json.decode(res.body);
  if (jsonRes['success'] == 'login successful') {
    setState(() {
      userData = jsonRes['data'][0];
      Name = userData['name'];
      commentId = userData['id'];
    });
    print(Name);
  }

  var url = "http://$ipconfig/apisocial/api_fetch_comment.php";
  var response = await http.post(Uri.parse(url), body: {'activeEmail': widget.activeEmail});
  var jsonResponse = json.decode(response.body);

  
  if (response.statusCode == 200) {
    
    setState(() {
      commentData = jsonResponse;
      userComments = jsonResponse;
      // Fetch liked status for each comment
      userComments.forEach((comment) {
        fetchUnLiked(comment);
      });
       userComments.forEach((comment) {
        fetchLiked(comment);
      });

      
    });

    channel.sink.add(json.encode({
      'recieverEmail': widget.activeEmail
    }));
    channel.stream.listen(
      (message) {
        print("Message received via WebSocket: $message");  // Debug print
        setState(() {
          userComments.add(json.decode(message));
          print(userComments);
        });
      },
      
      onError: (error) {
        print("WebSocket error: $error");
      },
      onDone: () {
        print("WebSocket connection closed");
      },
    );

     await Future.forEach(userComments, (comment) async {
      await getNoOfLiked(comment);
    });
    await Future.forEach(userComments, (comment) async {
      await getNoOfDisliked(comment);
    });
    await Future.forEach(userComments, (comment) async {
      await getNoOfReply(comment);
    });
  }
  setState(() {
  isLoading = false;
});
}


bool isLiked(Map<String, dynamic> comment) {
  return comment['isLiked'] ?? false;
}

  void like(Map<String, dynamic> comment) async{
    var url = "http://$ipconfig/apisocial/comment_like_box.php";
    disableDislike(comment);
    
    var response = await http.post(Uri.parse(url),
    body: {
         'commentId': comment['id'].toString(),
        'activeEmail': widget.activeEmail,
        'email' : email
    },
    );
   
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
  comment['isLiked'] = true;
  getNoOfLiked(comment);
  getNoOfDisliked(comment);
});
channel = IOWebSocketChannel.connect('ws://$ipconfig:8080');
    // Send the message via WebSocket
    print("Message sent via WebSocket");
  print('success');  
   
}
}

void unlike(Map<String, dynamic> comment) async{
 var url = "http://$ipconfig/apisocial/comment_unlike_box.php";
   
    var response = await http.post(Uri.parse(url),
    body: {
       'commentId': comment['id'].toString(),
        'activeEmail': widget.activeEmail,
        'email' : email
       
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'unlike successful'){
setState(() {
   comment['isLiked'] = false;
   getNoOfLiked(comment);
});
  print('success');
    
}
}

void fetchLiked(Map<String, dynamic> comment) async{
 var url = "http://$ipconfig/apisocial/fetch_comment_like.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'commentId': comment['id'].toString(),
        'activeEmail': widget.activeEmail,
        'email' : email
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
  // userlike = jsonResponse['data'][0];

   comment['isLiked'] = true;
});
// print('complete : $userlike');
}
}


bool isdislike(Map<String, dynamic> comment) {
  return comment['isdislike'] ?? false;
}

  void dislike(Map<String, dynamic> comment) async{
    var url = "http://$ipconfig/apisocial/comment_dislike_box.php";
    unlike(comment);
   
    var response = await http.post(Uri.parse(url),
    body: {
         'commentId': comment['id'].toString(),
        'activeEmail': widget.activeEmail,
        'email' : email
    },
    );
   
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
  comment['isdislike'] = true;
  getNoOfDisliked(comment);
  getNoOfLiked(comment);
});
  print('success');  
   
}
}

void disableDislike(Map<String, dynamic> comment) async{
 var url = "http://$ipconfig/apisocial/comment_disableDislike_box.php";
    getNoOfLiked(comment);
    var response = await http.post(Uri.parse(url),
    body: {
       'commentId': comment['id'].toString(),
        'activeEmail': widget.activeEmail,
        'email' : email
       
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'unlike successful'){
setState(() {
   comment['isdislike'] = false;
   getNoOfDisliked(comment);
   
});
  print('success');
    
}
}

void fetchUnLiked(Map<String, dynamic> comment) async{
 var url = "http://$ipconfig/apisocial/fetch_comment_enableUnLiked.php";
    var response = await http.post(Uri.parse(url),
    body: {
        'commentId': comment['id'].toString(),
        'activeEmail': widget.activeEmail,
        'email' : email
    },
    );
   
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['success'] == 'like successful'){
setState(() {
  // userlike = jsonResponse['data'][0];

   comment['isdislike'] = true;
});
// print('complete : $userlike');
}
}

Future<void> getNoOfLiked(Map<String, dynamic> comment) async {

  
  var url = "http://$ipconfig/apisocial/commentLikeNumber.php";
   
  var liked = await http.post(Uri.parse(url), body: {
    'commentId': comment['id'].toString(),
    'activeEmail': widget.activeEmail,
  });

  if (liked.statusCode == 200) {
    var jsonLikeOutput = json.decode(liked.body);
    setState(() {
      comment['noLiked'] = jsonLikeOutput.length; // Store the number of likes in the comment itself
    });
    // channel.sink.add(json.encode({
    //   'noLiked': comment['noLiked'],
    //   'email': email,
    //   'recipientEmail': widget.activeEmail,
    // }));

    //  channel.sink.add(json.encode({
    //   'recieverEmail': widget.activeEmail
    // }));
    // channel.stream.listen(
    //   (message) {
    //     print("Message received via WebSocket: $message");  // Debug print
    //     setState(() {
    //       numberlikeOutput.add(json.decode(message));
    //       comment['noLiked'] = numberlikeOutput.last['noliked'];
    //     });
    //   },
      
    //   onError: (error) {
    //     print("WebSocket error: $error");
    //   },
    //   onDone: () {
    //     print("WebSocket connection closed");
    //   },
    // );
    // // print(jsonLikeOutput.length);
    // print(comment['id'].toString());
  } else {
    // Handle other status codes (e.g., display an error message)
    print('Failed to get likes. Status code: ${liked.statusCode}');
  }
}

Future<void> getNoOfDisliked(Map<String, dynamic> comment) async {
  var url = "http://$ipconfig/apisocial/commentDisLikeNumber.php";

  var liked = await http.post(Uri.parse(url), body: {
    'commentId': comment['id'].toString(),
    'activeEmail': widget.activeEmail,
  });

  if (liked.statusCode == 200) {
    var jsonLikeOutput = json.decode(liked.body);
    setState(() {
      comment['noDisLiked'] = jsonLikeOutput.length; // Store the number of likes in the comment itself
    });
    print(jsonLikeOutput.length);
    print(comment['id'].toString());
  } else {
    // Handle other status codes (e.g., display an error message)
    print('Failed to get likes. Status code: ${liked.statusCode}');
  }
}

Future<void> getNoOfReply(Map<String, dynamic> comment) async {
  var url = "http://$ipconfig/apisocial/commentReplyNo.php";

  var reply = await http.post(Uri.parse(url), body: {
    'replyId': comment['id'].toString(),
    'activeEmail': widget.activeEmail,
  });

  if (reply.statusCode == 200) {
    var jsonLikeOutput = json.decode(reply.body);
    setState(() {
      comment['noReply'] = jsonLikeOutput.length; // Store the number of likes in the comment itself
    });
    print(comment['noReply'].toString());
  } else {
    // Handle other status codes (e.g., display an error message)
    print('Failed to get likes. Status code: ${reply.statusCode}');
  }
}

  @override

  void initState(){
    super.initState();
   allComments();
    
  }

  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Comments'),
    ),
    body: 
    isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF010043)),
              ),
            )
          
                :
       Column(
      children: [
        Expanded(
          child: commentData.isEmpty
                ? 
                Padding(
  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
  child: Center(
    child: Container(
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 60,
              color: Colors.blue.shade900, 
            ),
            SizedBox(height: 12),
            Text(
              'No Comments',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF5F5F5),  // Light text color for contrast
              ),
            ),
            SizedBox(height: 8),
            Text(
              'please add a review here. Please check back later too!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFFB0BEC5),  // Muted text color to complement the background
              ),
            ),
          ],
        ),
      ),
    ),
  ),
)
:ListView.builder(
            itemCount: userComments.length,
            itemBuilder: (context, index) {
              var comment = userComments[index];
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
                                 Text(comment['name'] ?? '', style: TextStyle(fontSize: 20),),
                               Text(comment['comments'] ?? ''),
                                // Text(comment['id'].toString(),),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
  
                          comment['image_01'] == null || comment['image_01'].isEmpty ? Container():
                          Container(
                            color: Colors.black45,
                            width: 100,
                            child: Image.network(
                              "http://192.168.153.26/practice/uploaded_img/${comment['image_01']}",
                              // fit: BoxFit.cover, 
                            ),
                          ),
                           SizedBox(height: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  // GestureDetector(
                                  //   child: Text('8 mins', style: TextStyle(fontSize: 18),),
                                  // ),
                                  // SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: (){isLiked(comment) ? unlike(comment) : like(userComments[index]);},
                                    child: Row(
                                      children: [
                                        isLiked(comment) ? Icon(Icons.thumb_up, color: Colors.green,) : Icon(Icons.thumb_up_off_alt,),
                                        SizedBox(width: 10,),
                                        
                                        comment['noLiked'] == null || comment['noLiked'] == 0 ? Text('') : Text(comment['noLiked'].toString())
                                      ],
                                    )
                                  ),
                                
                                   SizedBox(width: 20),
                                  GestureDetector(
                                    onTap: (){isdislike(comment) ?  disableDislike(comment) : dislike(comment);},
                                    child: Row(
                                      children: [
                                        isdislike(comment) ?  Icon(Icons.thumb_down, color: Colors.green,) : Icon(Icons.thumb_down_off_alt,),
                                        SizedBox(width: 10,),
                                        
                                        comment['noDisLiked'] == null || comment['noDisLiked'] == 0 ? Text('') : Text(comment['noDisLiked'].toString())
                                      ],
                                    )
                                  ),
                                
                                  SizedBox(width: 20),
                                  GestureDetector(
                                     onTap: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => ReplyClass(commentId: comment['id'])));
                                        },
                                    child: Text('Reply', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10,),

                              GestureDetector(
                                onTap: () {
                                   Navigator.push(context, MaterialPageRoute(builder: (context) => ReplyClass(commentId: comment['id'])));
                                },
                                child: Row(
                                  children: [
                                   comment['noReply'] == 0 || comment['noReply'] == null ? Text('') : Text(comment['noReply'].toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                                    SizedBox(width: 8,),
                                    comment['noReply'] == 0 || comment['noReply'] == null ? Text('') : comment['noReply'] == 1 ? Text('Reply',style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)) : Text('Replies', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
                                  ],
                                ))
                            ],
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
        Container(
          color: Colors.white, // Ensure this container doesn't cover ListView
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
                        onPressed: () { postComment(); },
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

