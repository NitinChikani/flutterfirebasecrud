import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EditRegister extends StatefulWidget {
  final String id;
  final String keys;
  final String name;
  final String email;
  final String pass;
  final String dob;
  // ignore: non_constant_identifier_names
  final Function updatesDetails;

  EditRegister(this.id, this.name, this.email, this.keys, this.pass, this.dob,
      this.updatesDetails);

  @override
  _EditRegisterState createState() => _EditRegisterState();
}

class _EditRegisterState extends State<EditRegister> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _autoValidate = false;

  String name;
  String id;
  String keys;
  String pass;
  String email;
  String dob;

  @override
  void initState() {
    debugPrint("Name ${widget.name}");
    debugPrint("Email ${widget.email}");
    debugPrint("Dob ${widget.dob}");
    debugPrint("Pass ${widget.pass}");
    debugPrint("Key ${widget.keys}");
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    _dobController.text = widget.dob;
    _pwdController.text = widget.pass;
    _cpwdController.text = widget.pass;
    super.initState();

    setState(() {
      id = widget.id;
      keys = widget.keys;
    });
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {});
    });
    debugPrint('....');
  }

  //Raise Button
  void _validation() {
    Navigator.pop(context);
    final name = _nameController.text;
    final email = _emailController.text;
    final pass = _pwdController.text;
    final dob = _dobController.text;

    widget.updatesDetails(id, keys, name, email, pass, dob);
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _cpwdController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(15.0),
          child: Form(
            key: _formkey,
            autovalidate: _autoValidate,
            child: FormUI(),
          ),
        ),
      ),
    );
  }

  Widget FormUI() {
    return Column(
      children: <Widget>[
        TextFormField(
          decoration: InputDecoration(hintText: "Enter Your Name"),
          controller: _nameController,
          validator: (String value) {
            if (value.isEmpty) {
              return "Name Required";
            } else {
              return null;
            }
          },
        ),
        TextFormField(
          decoration: InputDecoration(hintText: "Enter Your Email"),
          controller: _emailController,
        ),
        TextFormField(
          decoration: InputDecoration(hintText: "Date Of Birth"),
          controller: _dobController,
          onTap: _presentDatePicker,
        ),
        TextFormField(
            decoration: InputDecoration(hintText: "Enter Password"),
            obscureText: true,
            controller: _pwdController,
            validator: (val) {
              if (val.isEmpty) {
                return 'Password Required';
              }
              if (val.length < 6) {
                return 'Password must be atleast 8 characters long';
              }
              return null;
            }),
        TextFormField(
            decoration: InputDecoration(hintText: "Enter Confirm Password"),
            obscureText: true,
            controller: _cpwdController,
            validator: (val) {
              if (val.isEmpty) {
                return 'Empty';
              }
              if (val != _pwdController.text) {
                return 'Not Match';
              }
              return null;
            }),
        RaisedButton(
          onPressed: _validation,
          child: Text('Update'),
        ),
      ],
    );
  }
}
