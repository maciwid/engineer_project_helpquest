import "package:flutter/material.dart";
import 'package:helpquest/models/filter.dart';
import 'package:helpquest/shared/constants.dart';


typedef void FilterCallback(Filter val);

class FilterSettings extends StatefulWidget {
  final FilterCallback callback;
  Filter initFilter;
  FilterSettings({this.callback, this.initFilter});
  @override
  _FilterSettingsState createState() => _FilterSettingsState();
}

class _FilterSettingsState extends State<FilterSettings> {
  String _currentTitle;
  String _currentCategory;
  String _currentRegion;
  String _employerName;
  String _currentType;
  bool _showInProgress;
  TextEditingController empNameController = new TextEditingController();
  TextEditingController titleController = new TextEditingController();
  final List<String> regions = ['dolnośląskie', 'kujawsko-pomorskie', 'lubelskie', 'lubuskie', 'łódzkie', 'małopolskie', 'mazowieckie',
    'opolskie', 'podkarpackie', 'podlaskie', 'pomorskie', 'śląskie', 'świętokrzyskie', 'warmińsko-mazurskie', 'wielkopolskie', '	zachodniopomorskie'];
  final List<String> categories = ['delivery', 'transport', 'manual labor', 'shopping', 'other'];
  final List<String> types = ['local', 'virtual'];
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    titleController.text = widget.initFilter.title;
    empNameController.text = widget.initFilter.employer;
    _showInProgress = widget.initFilter.showInProgress ?? true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: boxBackgroundDecoration,
        child: Form(
        key: _formKey,
        child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
        child: Column(
        children: <Widget>[
        SizedBox(height: 40.0),
        Text(
        'Filter Settings',
        style: titleTextStyle,
        ),
        SizedBox(height: 30.0),
          DropdownButtonFormField(
            //validator: (value) => value == null ? 'Field required' : null,
              hint: Text("Type (virtual/local)", style: simpleTextStyle,),
              value: _currentType ?? widget.initFilter.type,
              dropdownColor: primaryColor2,
              style: mediumTextStyle,
              decoration: textInputDecoration,
              items: types.map((type){
                return DropdownMenuItem(
                  value: type,
                  child: Text('$type'),
                );
              }).toList(),
              onChanged: (val) => setState(()=>{
                  _currentType = val
              })
          ),
        SizedBox(height: 20,),
        TextFormField(
          controller: titleController,
          style: mediumTextStyle,
          decoration: textInputDecoration.copyWith(hintText: "Filter by title"),
          onChanged: (val) => setState(()=> _currentTitle = val),
        ),
          SizedBox(height: 20.0),
          TextFormField(
            controller: empNameController,
            style: mediumTextStyle,
            decoration: textInputDecoration.copyWith(hintText: "Filter by employer username"),
            onChanged: (val) => setState(()=> _employerName = val),
          ),
        SizedBox(height: 20.0),
        DropdownButtonFormField(
        //validator: (value) => value == null ? 'Field required' : null,
        hint: Text("Filter by category", style: simpleTextStyle,),
        value: _currentCategory ?? widget.initFilter.category,
        dropdownColor: primaryColor2,
        style: mediumTextStyle,
        decoration: textInputDecoration,
        items: categories.map((cat){
        return DropdownMenuItem(
        value: cat,
        child: Text('$cat'),
        );
        }).toList(),
        onChanged: (val) => setState(()=>{
            _currentCategory=val
        })
        ),
        SizedBox(height: 20.0),
        DropdownButtonFormField(
        //validator: (value) => value == null ? 'Field required' : null,
        hint: Text("Filter by region", style: simpleTextStyle,),
        value: _currentRegion ?? widget.initFilter.region,
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
        SizedBox(height: 15.0),
        Align(
        alignment: Alignment.centerLeft,
        child: CheckboxListTile(
          title: Text("Show quests in progress", style: simpleTextStyle,),
          value: _showInProgress,
          activeColor: primaryColor2shade,
          onChanged: (val){
            setState(() {
              _showInProgress = val;
            });
          }),
        ),
        SizedBox(height: 10,),
        Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 60),
        child: Row(
          children: [
            RaisedButton(
              color: Colors.pink[400],
              child:Row(
                children: [
                  Icon(Icons.clear),
                  SizedBox(width: 20),
                  Text(
                    'Reset',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              onPressed: (){
                if(_formKey.currentState.validate()){
                  setState(() {
                    empNameController.clear();
                    titleController.clear();
                    _currentType = null;
                    _employerName = null;
                    _currentTitle = null;
                    _currentRegion = null;
                    _currentCategory = null;
                    widget.initFilter = Filter();
                  });
                }
              },
            ),
            SizedBox(width: 40,),
            RaisedButton(
            color: Colors.pink[400],
            child:Row(
              children: [
                Icon(Icons.filter_list),
                SizedBox(width: 20),
                Text(
                'Filter',
                style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            onPressed: (){
            if(_formKey.currentState.validate()){
            widget.callback(Filter(
                type: _currentType ?? widget.initFilter.type,
                title: _currentTitle ?? widget.initFilter.title,
                category: _currentCategory ?? widget.initFilter.category,
                region: _currentRegion ?? widget.initFilter.region,
                employer: _employerName ?? widget.initFilter.employer,
                showInProgress: _showInProgress));
            Navigator.pop(context);
            }
            },
            ),
          ],
        ),
        ),
        SizedBox(height: 50.0),
        ],
        ),
    )
    ),
    );
    }

}
