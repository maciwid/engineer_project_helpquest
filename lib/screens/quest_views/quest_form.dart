import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/models/user.dart';
import 'package:helpquest/services/database.dart';
import 'package:helpquest/shared/constants.dart';
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
  String _questType;
  String _questStatus = 'looking for a hero';
  String _currentCategory;
  String _currentDescription;
  String _currentRegion;
  //String _currentStatus;
  num _currentPrize;
  TextEditingController prizeController = new TextEditingController();
  final List<String> regions = ['dolnośląskie', 'kujawsko-pomorskie', 'lubelskie', 'lubuskie', 'łódzkie', 'małopolskie', 'mazowieckie',
                                'opolskie', 'podkarpackie', 'podlaskie', 'pomorskie', 'śląskie', 'świętokrzyskie', 'warmińsko-mazurskie', 'wielkopolskie', '	zachodniopomorskie'];
  final List<String> categories = ['delivery', 'transport', 'manual labor', 'shopping', 'other'];
  @override
  Widget build(BuildContext context) {
     setState(() {
       if(widget.isLocal)
         _questType = 'local';
       else
         _questType = 'virtual';
     });
    final user = Provider.of<User>(context);
            return StreamBuilder<UserData>(
              stream: DatabaseService(key: user.uid).userData,
              builder: (context, snapshot) {
                return Container(
                  decoration: boxBackgroundDecoration,
                  child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 60.0),
                            Text(
                              'Create Quest',
                              style: titleTextStyle,
                            ),
                            SizedBox(height: 40.0),
                            TextFormField(
                              style: mediumTextStyle,
                              decoration: textInputDecoration.copyWith(hintText: "Quest Title"),
                              validator: (val) => val.isEmpty ? 'Enter a quest title':null,
                              onChanged: (val) => setState(()=> _currentTitle = val),
                            ),
                            SizedBox(height: 20.0),
                            DropdownButtonFormField(
                                validator: (value) => value == null ? 'Field required' : null,
                                hint: Text("Category", style: simpleTextStyle,),
                                dropdownColor: primaryColor2,
                                style: mediumTextStyle,
                              decoration: textInputDecoration,
                              items: categories.map((cat){
                                return DropdownMenuItem(
                                  value: cat,
                                  child: Text('$cat'),
                                );
                              }).toList(),
                                onChanged: (val) => setState(()=>_currentCategory=val)
                            ),
                            Visibility(
                                visible: widget.isLocal,
                                child: SizedBox(height: 20.0)),
                            Visibility(
                              visible: widget.isLocal,
                              child: DropdownButtonFormField(
                                  validator: (value) => value == null ? 'Field required' : null,
                                  hint: Text("Region", style: simpleTextStyle,),
                                  dropdownColor: primaryColor2,
                                  style: mediumTextStyle,
                                  decoration: textInputDecoration,
                                  items: regions.map((reg){
                                    return DropdownMenuItem(
                                      value: reg,
                                      child: Text('$reg'),
                                    );
                                  }).toList(),
                                  onChanged: (val) => setState(()=>_currentRegion=val)
                              ),
                            ),
                            SizedBox(height: 20.0),
                            TextFormField(
                              style: mediumTextStyle,
                              decoration: textInputDecoration.copyWith(hintText: "Description"),
                              validator: (val) => val.isEmpty ? 'Enter a description':null,
                              onChanged: (val) => setState(()=> _currentDescription = val),
                            ),
                            SizedBox(height: 15.0),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Text("Prize:", style: simpleTextStyle)),
                            NumberInputWithIncrementDecrement(
                              controller: prizeController,
                              initialValue: 0,
                              style: mediumTextStyle,
                              isInt: true,
                              incDecBgColor: primaryColor2shade,
                              numberFieldDecoration: textInputDecoration,
                              min: 0,
                              max: 200,
                              onIncrement: (val)=> setState(()=>_currentPrize = val.toInt()),
                              onDecrement: (val)=> setState(()=>_currentPrize = val.toInt()),
                              onSubmitted: (val)=> setState(()=>_currentPrize = val),
                            ),
                            SizedBox(height: 20.0),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 90),
                              child: RaisedButton(
                                color: Colors.pink[400],
                                child:Row(
                                  children: [
                                    Icon(Icons.add_circle_outline),
                                    SizedBox(width: 20),
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
                                        _questType,
                                        _currentTitle,
                                        _currentCategory,
                                        _currentRegion,
                                        _currentDescription,
                                        _questStatus,
                                        _currentPrize ?? 0,
                                        user.uid,
                                        snapshot.data.username,
                                        DateTime.now().millisecondsSinceEpoch
                                    );
                                    await DatabaseService(key: user.uid).addQuestToCollection(qid, true);
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 50.0),
                          ],
                        ),
                      )
                  ),
                );
              }
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
  String _currentRegion;
  String _currentDescription;
  String _currentStatus;
  num _currentPrize;
  final List<String> regions = ['dolnośląskie', 'kujawsko-pomorskie', 'lubelskie', 'lubuskie', 'łódzkie', 'małopolskie', 'mazowieckie',
    'opolskie', 'podkarpackie', 'podlaskie', 'pomorskie', 'śląskie', 'świętokrzyskie', 'warmińsko-mazurskie', 'wielkopolskie', '	zachodniopomorskie'];
  final List<String> categories = ['delivery', 'transport', 'manual labor', 'shopping', 'other'];
  final List<String> statuses = ['looking for a hero', 'in progress', 'completed'];
  @override
  Widget build(BuildContext context) {

    //final user = Provider.of<User>(context);
              return Container(
                decoration: boxBackgroundDecoration,
                child: Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 40.0),
                          Text(
                            'Edit Quest',
                            style: titleTextStyle,
                          ),
                          SizedBox(height: 30.0),
                          DropdownButtonFormField(
                              validator: (value) => value == null ? 'Field required' : null,
                              dropdownColor: primaryColor2,
                              style: mediumTextStyle,
                              decoration: textInputDecoration,
                               hint: Text("set status"),
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
                            style: mediumTextStyle,
                            initialValue: widget.quest.title,
                            decoration: textInputDecoration,
                            validator: (val) => val.isEmpty ? 'Please enter a title':null,
                            onChanged: (val) => setState(()=> _currentTitle = val),
                          ),
                          SizedBox(height: 20,),
                          DropdownButtonFormField(
                              validator: (value) => value == null ? 'Field required' : null,
                            value: _currentCategory ?? widget.quest.category,
                              hint: Text("set category"),
                              dropdownColor: primaryColor2,
                              style: mediumTextStyle,
                              decoration: textInputDecoration,
                              items: categories.map((cat){
                                return DropdownMenuItem(
                                  value: cat,
                                  child: Text('$cat'),
                                );
                              }).toList(),
                              onChanged: (val) => setState(()=>_currentCategory=val)
                          ),
                          Visibility(
                              visible: widget.quest.region != null,
                              child: SizedBox(height: 20.0)),

                          Visibility(
                            visible:  widget.quest.region != null,
                            child: (widget.quest.region != null) ? DropdownButtonFormField(
                                value: _currentRegion ?? widget.quest.region,
                                hint: Text("Region", style: simpleTextStyle,),
                                dropdownColor: primaryColor2,
                                style: mediumTextStyle,
                                decoration: textInputDecoration,
                                items: regions.map((reg){
                                  return DropdownMenuItem(
                                    value: reg,
                                    child: Text('$reg'),
                                  );
                                }).toList(),
                                onChanged: (val) => setState(()=>_currentRegion=val)
                            ) : Container()
                          ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            style: mediumTextStyle,
                            initialValue: widget.quest.description,
                            decoration: textInputDecoration.copyWith(hintText: "Description"),
                            validator: (val) => val.isEmpty ? 'Enter a description':null,
                            onChanged: (val) => setState(()=> _currentDescription = val),
                          ),
                          SizedBox(height: 5.0),
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Prize:", style: simpleTextStyle.copyWith(fontSize: 18),)),
                          NumberInputWithIncrementDecrement(
                            controller: TextEditingController(),
                            style: mediumTextStyle,
                            isInt: true,
                            incDecBgColor: primaryColor2shade,
                            numberFieldDecoration: textInputDecoration,
                            min: 0,
                            max: 200,
                            initialValue: widget.quest.prize,
                            onIncrement: (val)=> setState(()=>_currentPrize = val),
                            onDecrement: (val)=> setState(()=>_currentPrize = val),
                          ),
                          SizedBox(height: 15.0),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 90),
                            child: RaisedButton(
                              color: Colors.pink[400],
                              child:Text(
                                'Update',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: ()async{
                                if(_formKey.currentState.validate()){
                                  await DatabaseService(key: widget.quest.qid).updateQuestData(
                                      widget.quest.qid,
                                      widget.quest.type,
                                      _currentTitle ?? widget.quest.title,
                                      _currentCategory ?? widget.quest.category,
                                      _currentRegion ?? widget.quest.region,
                                      _currentDescription ?? widget.quest.description,
                                      _currentStatus ?? widget.quest.status,
                                      _currentPrize ?? widget.quest.prize,
                                      widget.quest.employerID,
                                      widget.quest.empUserName,
                                      DateTime.now().millisecondsSinceEpoch);
                                  Navigator.pop(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              );


  }
}
