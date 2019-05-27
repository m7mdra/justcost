import 'package:flutter/material.dart';
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
  String genderGroupValue;
  TextEditingController _fullNameController;
  TextEditingController _addressController;
  FocusNode _fullNameNode = FocusNode();
  FocusNode _addressNode = FocusNode();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _fullNameController =
        TextEditingController(text: widget.personalInformation.fullName);
    _addressController =
        TextEditingController(text: widget.personalInformation.address);
    genderGroupValue = widget.personalInformation.gender;
  }

  @override
  void dispose() {
    super.dispose();
    _fullNameController.dispose();
    _addressController.dispose();
    _fullNameNode.dispose();
    _addressNode.dispose();
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
                    FocusScope.of(context).requestFocus(_addressNode);
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
                TextFormField(
                  focusNode: _addressNode,
                  maxLines: 1,
                  controller: _addressController,
                  validator: (address) {
                    return address.isEmpty
                        ? "Address Field can not be empty"
                        : null;
                  },
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_on),
                      contentPadding: EdgeInsets.all(8),
                      hintText: 'Address',
                      labelText: 'Address',
                      errorMaxLines: 1,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
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
                    RadioListTile<String>(
                        value: 'male',
                        groupValue: genderGroupValue,
                        title: Text('Male'),
                        onChanged: (value) {
                          setState(() => genderGroupValue = value);
                        }),
                    RadioListTile<String>(
                        value: 'female',
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
                          if (genderGroupValue == null ||
                              genderGroupValue.isEmpty) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Select gender first'),
                            ));
                            return;
                          }
                          FocusScope.of(context).requestFocus(FocusNode());
                          var information = PersonalInformation(
                              _fullNameController.text,
                              genderGroupValue,
                              _addressController.text);
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
