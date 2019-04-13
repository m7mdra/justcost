import 'package:flutter/material.dart';
import 'package:justcost/screens/edit_profile/personal_information.dart';

class UpdatePersonalInformationScreen extends StatefulWidget {
  final PersonalInformation personalInformation;

  UpdatePersonalInformationScreen(
      [this.personalInformation = const PersonalInformation(
          "Mega son of himSelf", "male", "address,address,address")])
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Personal Information'),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _fullNameController,
                minLines: 1,
                decoration: InputDecoration(
                    hintText: 'Full Name',
                    labelText: 'Full Name',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
              ),
              SizedBox(
                height: 8,
              ),
              TextField(
                controller: _addressController,
                minLines: 1,
                decoration: InputDecoration(
                    hintText: 'Address',
                    labelText: 'Address',
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16))),
              ),
              SizedBox(
                height: 16,
              ),
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
              SizedBox(
                height: 16,
              ),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    var information = PersonalInformation(
                        _fullNameController.text,
                        genderGroupValue,
                        _addressController.text);
                    Navigator.of(context).pop(information);
                  },
                  child: Text('Submit'),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}
