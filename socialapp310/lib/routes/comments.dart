import 'package:socialapp310/utils/color.dart';
import 'package:socialapp310/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:socialapp310/models/user.dart';
import 'package:socialapp310/routes/homefeed/postCard.dart';


class CommentScreen extends StatefulWidget{

  @override
  _CommentScreenState createState() => _CommentScreenState();
}


class _CommentScreenState extends State<CommentScreen>{
  List<String> _comments = [
    "sup",
    "bruh",
    "how u",
    "bleh",
  ];

  void _addComments(String val){
    setState(() {
      _comments.add(val);
    });
  }
  Widget _buildCommentList() {
    return ListView.builder(
        itemBuilder: (context, index) {
          if (index < _comments.length) {
            return _buildCommentItem(_comments[index]);
          }
        }
        );
  }

  Widget _buildCommentItem(String comment){
    return ListTile(title: Text(comment));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightgrey,
      appBar: AppBar(
        backgroundColor: AppColors.primarypurple,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
        title: RichText(
            text: TextSpan(
                children: [
                  TextSpan(text:  'Comments',
                      style: kAppBarTitleTextStyle)
                ]
            )

        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: _buildCommentList()
          ),
          TextField(
            onSubmitted: (String submittedStr){
              _addComments(submittedStr);
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(20),
                  hintText:'Add a comment'
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              iconSize: 25,
              color: AppColors.primarypurple,
              onPressed: () {

              },
          ),
        ],
      ),
    );
  }
  }
