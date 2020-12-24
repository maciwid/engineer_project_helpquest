import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/shared/loading.dart';
import 'package:helpquest/shared/local_data.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:number_inc_dec/number_inc_dec.dart';



class QuestFormCreate extends StatefulWidget {
  bool isLocal;
  QuestFormCreate(this.isLocal);
  @override
  _QuestFormCreateState createState() => _QuestFormCreateState();
}

class _QuestFormCreateState extends State<QuestFormCreate> {
  final _formKey = GlobalKey<FormState>();
  var uuid = Uuid();
  // form values
  String qid;
  String _currentTitle;
  String _currentCategory;
  String _currentDescription;
  String _currentStatus;
  num _currentPrize;
  final List<String> categories = ['delivery', 'transport', 'manual labor', 'other'];
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
            return SingleChildScrollView(
              child: Container(
                decoration: boxBackgroundDecoration,
                child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Create Quest',
                            style: titleTextStyle,
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(hintText: "Quest Title"),
                            validator: (val) => val.isEmpty ? 'Please enter a quest title':null,
                            onChanged: (val) => setState(()=> _currentTitle = val),
                          ),
                          SizedBox(height: 20.0),
                          DropdownButtonFormField(
                            items: categories.map((cat){
                              return DropdownMenuItem(
                                value: cat,
                                child: Text('$cat'),
                              );
                            }).toList(),
                              onChanged: (val) => setState(()=>_currentCategory=val)
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(hintText: "Description"),
                            validator: (val) => val.isEmpty ? 'Enter a description':null,
                            onChanged: (val) => setState(()=> _currentDescription = val),
                          ),
                          NumberInputWithIncrementDecrement(
                            controller: TextEditingController(),
                            min: 0,
                            max: 200,
                            onIncrement: (val)=> setState(()=>_currentPrize = val),
                            onDecrement: (val)=> setState(()=>_currentPrize = val),
                          ),
                          RaisedButton(
                            color: Colors.pink[400],
                            child:Row(
                              children: [
                                Icon(Icons.add_circle_outline),
                                Text(
                                  'Create Quest',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            onPressed: ()async{
                              if(_formKey.currentState.validate()){
                                qid = uuid.v1();
                                await DatabaseService(key: qid).updateQuestData(
                                    qid,
                                    _currentTitle,
                                    _currentCategory,
                                    _currentDescription,
                                    _currentStatus,
                                    _currentPrize,
                                    user.uid
                                );
                                await DatabaseService(key: user.uid).addQuestToCollection(qid, true);
                                Navigator.pop(context);
                              }
                            },
                          ),
                          SizedBox(height: 40.0),
                        ],
                      ),
                    )
                ),
              ),
            );
  }
}


class QuestFormView extends StatefulWidget {
  final String qid;
  QuestFormView(this.qid);
  @override
  _QuestFormViewState createState() => _QuestFormViewState();
}

class _QuestFormViewState extends State<QuestFormView> {
  bool enableEdit;
  final _formKey = GlobalKey<FormState>();

  void _showEditQuestPanel(){
    showModalBottomSheet(context: context, builder: (context){
      return QuestFormEdit();
    });
  }
  @override
  Widget build(BuildContext context) {
//TODO
    final userData = Provider.of<User>(context);

    return StreamBuilder<Quest>(
        stream: DatabaseService(key: widget.qid).quest,
        builder: (context, snapshot) {
          if(snapshot.hasData){

            Quest questData = snapshot.data;
            if(userData.uid == questData.employerID)
              enableEdit = true;
            return Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    FlatButton.icon(
                onPressed: (){
                  if(enableEdit)
                  _showEditQuestPanel;
                  },
                  icon: Icon(
                      Icons.settings,
                      color: (enableEdit) ? Color.fromRGBO(255, 95, 155, 1) : Color.fromRGBO(255, 95, 155, 0))),
                    Text(
                      'Quest Details',
                      style: titleTextStyle,
                    ),
                    SizedBox(height: 20.0),
                    Text("questData.title", style: mediumTextStyle,),
                    Text("Employer: ${userData.username}", style: mediumTextStyle,),
                    Text("Category: ${questData.category}", style: mediumTextStyle,),
                    Text(questData.description, style: simpleTextStyle,),
                  ],
                )
            );
          }else{
            return Loading();
          }

        }
    );
  }
}


class QuestFormEdit extends StatefulWidget {
  @override
  _QuestFormViewState createState() => _QuestFormViewState();
}

class _QuestFormEditState extends State<QuestFormView> {
  final _formKey = GlobalKey<FormState>();
  // form values
  String _currentTitle;
  String _currentCategory;
  String _currentDescription;
  String _currentStatus;
  num _currentPrize;
  final List<String> categories = ['delivery', 'transport', 'manual labor', 'other'];
  @override
  Widget build(BuildContext context) {

    //final user = Provider.of<User>(context);
    final quest = Provider.of<Quest>(context);

    return StreamBuilder<Quest>(
      stream: DatabaseService(key: quest.qid).quest,
      builder: (context, snapshot) {
        if(snapshot.hasData){

          Quest questData = snapshot.data;
          return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Text(
                    'Edit Quest',
                    style: titleTextStyle,
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: questData.title,
                    decoration: textInputDecoration,
                    validator: (val) => val.isEmpty ? 'Please enter a title':null,
                    onChanged: (val) => setState(()=> _currentTitle = val),
                  ),
                  SizedBox(height: 20,),
                  DropdownButtonFormField(
                      items: categories.map((cat){
                        return DropdownMenuItem(
                          value: cat,
                          child: Text('$cat'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(()=>_currentCategory=val)
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Description"),
                    validator: (val) => val.isEmpty ? 'Enter a description':null,
                    onChanged: (val) => setState(()=> _currentDescription = val),
                  ),
                  NumberInputWithIncrementDecrement(
                    controller: TextEditingController(),
                    min: 0,
                    max: 200,
                    onIncrement: (val)=> setState(()=>_currentPrize = val),
                    onDecrement: (val)=> setState(()=>_currentPrize = val),
                  ),

                  RaisedButton(
                    color: Colors.pink[400],
                    child:Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: ()async{
                      if(_formKey.currentState.validate()){
                        await DatabaseService(key: questData.qid).updateQuestData(
                            questData.qid,
                            _currentTitle ?? questData.title,
                            _currentCategory ?? questData.category,
                            _currentDescription ?? questData.description,
                            _currentStatus ?? questData.status,
                            _currentPrize ?? questData.prize,
                            questData.employerID);
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              )
          );
        }else{
          return Loading();
        }

      }
    );
  }
}
