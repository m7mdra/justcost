import 'package:flutter/material.dart';
import 'package:justcost/data/city/model/city.dart';
import 'package:justcost/i10n/app_localizations.dart';
import 'package:justcost/screens/city/city_picker_screen.dart';
import 'package:justcost/screens/edit_profile/personal_information.dart';

class UpdatePersonalInformationScreen extends StatefulWidget {
  final PersonalInformation personalInformation;

  UpdatePersonalInformationScreen([this.personalInformation])
      : super(key: Key('updatePersonalInformation'));

  @override
  _UpdatePersonalInformationScreenState createState() =>
      _UpdatePersonalInformationScreenState();
}

class _UpdatePersonalInformationScreenState
    extends State<UpdatePersonalInformationScreen> {
  int genderGroupValue;
  City city;
  TextEditingController _fullNameController;
  TextEditingController _cityController;
  FocusNode _fullNameNode = FocusNode();
  FocusNode _cityNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fullNameController =
        TextEditingController(text: widget.personalInformation.fullName);
    _cityController = TextEditingController();
    if (widget.personalInformation.city != null)
      _cityController.text = widget.personalInformation.city.name;
    genderGroupValue = widget.personalInformation.gender;
    this.city = widget.personalInformation.city;
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _cityController.dispose();
    _fullNameNode.dispose();
    _cityNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Update Personal Information'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  focusNode: _fullNameNode,
                  validator: (text) {
                    if (text.isEmpty) {
                      return 'Full name field is required.';
                    } else
                      return null;
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(_cityNode);
                  },
                  controller: _fullNameController,
                  minLines: 1,
                  decoration: InputDecoration(
                      hintText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                      labelText: 'Full Name',
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        enabled: false,
                        enableInteractiveSelection: false,
                        focusNode: _cityNode,
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        validator: (city) {
                          return city.isEmpty
                              ? AppLocalizations.of(context)
                                  .phoneNumberEmptyError
                              : null;
                          //TODO: change error message.
                        },
                        controller: _cityController,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.location_city),
                            contentPadding: EdgeInsets.all(8),
                            hintText: 'ie: Dubai, Abu Dhabi',
                            labelText: 'City',
                            errorMaxLines: 1,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8))),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    OutlineButton(
                      onPressed: () async {
                        City city = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => CityPickerScreen()));
                        if (city != null) {
                          setState(() {
                            this.city = city;
                          });
                          _cityController.text = city.name;
                        }
                      },
                      child: Text('Pick City'),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Column(
                  children: <Widget>[
                    Text(
                      'Gender',
                      style: Theme.of(context).textTheme.subhead,
                    ),
                    RadioListTile<int>(
                        value: 1,
                        groupValue: genderGroupValue,
                        title: Text('Male'),
                        onChanged: (value) {
                          setState(() => genderGroupValue = value);
                        }),
                    RadioListTile<int>(
                        value: 0,
                        groupValue: genderGroupValue,
                        title: Text('Female'),
                        onChanged: (value) {
                          setState(() => genderGroupValue = value);
                        }),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          if (genderGroupValue == null) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Select gender first'),
                            ));
                            return;
                          }
                          FocusScope.of(context).requestFocus(FocusNode());
                          var information = PersonalInformation(
                              _fullNameController.text, genderGroupValue, city);
                          Navigator.of(context).pop(information);
                        }
                      },
                      child: Text('Submit'),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    OutlineButton(
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                      child: Text('Cancel'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      )),
    );
  }
}
