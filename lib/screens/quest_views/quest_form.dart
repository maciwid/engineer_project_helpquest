import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
import 'package:helpquest/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:number_inc_dec/number_inc_dec.dart';



class QuestFormCreate extends StatefulWidget {
  final bool isLocal;
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
  //String _currentStatus;
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
                          SizedBox(height: 10.0),
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
                          SizedBox(height: 20.0),
                          NumberInputWithIncrementDecrement(
                            controller: TextEditingController(),
                            min: 0,
                            max: 200,
                            onIncrement: (val)=> setState(()=>_currentPrize = val),
                            onDecrement: (val)=> setState(()=>_currentPrize = val),
                          ),
                          SizedBox(height: 50.0),
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
                                    "looking for a hero",
                                    _currentPrize,
                                    user.uid
                                );
                                await DatabaseService(key: user.uid).addQuestToCollection(qid, true);
                                Navigator.pop(context);
                              }
                            },
                          ),
                          SizedBox(height: 50.0),
                        ],
                      ),
                    )
                ),
              ),
            );
  }
}





class QuestFormEdit extends StatefulWidget {
  final Quest quest;
  QuestFormEdit(this.quest);
  @override
  _QuestFormEditState createState() => _QuestFormEditState();
}

class _QuestFormEditState extends State<QuestFormEdit> {
  final _formKey = GlobalKey<FormState>();
  // form values
  String _currentTitle;
  String _currentCategory;
  String _currentDescription;
  String _currentStatus;
  num _currentPrize;
  final List<String> categories = ['delivery', 'transport', 'manual labor', 'other'];
  final List<String> statuses = ['looking for a hero', 'in progress', 'completed'];
  @override
  Widget build(BuildContext context) {

    //final user = Provider.of<User>(context);

          return Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10.0),
                  Text(
                    'Edit Quest',
                    style: titleTextStyle,
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField(
                      value:  _currentStatus  ?? widget.quest.status,
                      items: statuses.map((status){
                        return DropdownMenuItem(
                          value: status,
                          child: Text('$status'),
                        );
                      }).toList(),
                      onChanged: (val) => setState(()=>_currentStatus = val)
                  ),
                  SizedBox(height: 20,),
                  TextFormField(
                    initialValue: widget.quest.title,
                    decoration: textInputDecoration,
                    validator: (val) => val.isEmpty ? 'Please enter a title':null,
                    onChanged: (val) => setState(()=> _currentTitle = val),
                  ),
                  SizedBox(height: 20,),
                  DropdownButtonFormField(
                    value: _currentCategory ?? widget.quest.category,
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
                    initialValue: widget.quest.description,
                    decoration: textInputDecoration.copyWith(hintText: "Description"),
                    validator: (val) => val.isEmpty ? 'Enter a description':null,
                    onChanged: (val) => setState(()=> _currentDescription = val),
                  ),
                  SizedBox(height: 20.0),
                  NumberInputWithIncrementDecrement(
                    controller: TextEditingController(),
                    min: 0,
                    max: 200,
                    onIncrement: (val)=> setState(()=>_currentPrize = val),
                    onDecrement: (val)=> setState(()=>_currentPrize = val),
                  ),
                  SizedBox(height: 50.0),
                  RaisedButton(
                    color: Colors.pink[400],
                    child:Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: ()async{
                      if(_formKey.currentState.validate()){
                        await DatabaseService(key: widget.quest.qid).updateQuestData(
                            widget.quest.qid,
                            _currentTitle ?? widget.quest.title,
                            _currentCategory ?? widget.quest.category,
                            _currentDescription ?? widget.quest.description,
                            _currentStatus ?? widget.quest.status,
                            _currentPrize ?? widget.quest.prize,
                            widget.quest.employerID);
                        Navigator.pop(context);
                      }
                    },
                  ),
                  SizedBox(height: 50.0),
                ],
              )
          );

  }
}
