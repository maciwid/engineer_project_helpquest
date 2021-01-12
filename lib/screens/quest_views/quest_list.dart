import 'package:flutter/material.dart';
import 'package:helpquest/models/filter.dart';
import 'package:helpquest/models/user.dart';
import 'package:provider/provider.dart';
import 'package:helpquest/models/quest.dart';
import 'package:helpquest/screens/quest_views/quest_tile.dart';

    class QuestList extends StatefulWidget {
      final Filter _filter;
      final bool checkCompleted;
      final bool _owned;
      QuestList(this._owned, this.checkCompleted, this._filter);
      @override
      _QuestListState createState() => _QuestListState();
    }
    
    class _QuestListState extends State<QuestList> {
      @override
      Widget build(BuildContext context) {

        final quests = Provider.of<List<Quest>>(context) ?? [];
        final userData = Provider.of<UserData>(context);
        //print(quests);
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            shrinkWrap: false,
            itemCount: quests.length,
            itemBuilder: (context, index){
             if(widget._owned){
               if(quests[index].employerID==userData.uid) {
                 if(widget.checkCompleted) {
                   if (quests[index].status != "completed")
                     return QuestTile(quest: quests[index]);
                   else
                     return Container();
                 }else
                  return QuestTile(quest: quests[index]);
               } else return Container();
              }
              else{
                if(quests[index].status!="completed")
                 return filterFunction(widget._filter, quests[index]);//QuestTile(quest: quests[index]);
                else return Container();
              }
          },
          ),
        );
      }
    }

    Widget filterFunction(Filter filter, Quest quest){
      bool checkCategory = false;
      bool checkRegion = false;
      bool checkEmployer = false;
      bool checkTitle = false;
      bool checkStatus = false;
      bool checkType = false;

      bool categoryPass = true;
      bool regionPass = true;
      bool employerPass = true;
      bool statusPass=true;
      bool titlePass=true;
      bool typePass = true;

      if(filter.category != null )
        checkCategory = true;
      if(filter.region != null)
        checkRegion = true;
      if(filter.title != null)
        checkTitle = true;
      if(filter.employer != null)
        checkEmployer = true;
      if(filter.type != null)
        checkType = true;
      if(filter.showInProgress == false)
        checkStatus = true;

      if(checkCategory)
        if(filter.category != quest.category)
          categoryPass = false;
      if(checkRegion)
        if(filter.region != quest.region)
          regionPass = false;
      if(checkEmployer)
        if(!quest.empUserName.contains(filter.employer))
          employerPass = false;
      if(checkTitle)
        if(!quest.title.contains(filter.title))
          titlePass = false;
      if(checkType)
        if(quest.type != filter.type)
          typePass = false;
      if(checkStatus)
        if(quest.status == "in progress")
          statusPass = false;

      if(categoryPass && regionPass && employerPass && statusPass && typePass && titlePass) {
        return QuestTile(quest: quest);
      } else {
        return Container();
      }
    }