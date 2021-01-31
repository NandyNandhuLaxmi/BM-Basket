import 'package:bmbasket/screens/home/accountdetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:bmbasket/screens/login/login.dart';
import 'package:bmbasket/bloc/service/UserServices.dart';
import 'package:bmbasket/screens/home/home.dart';
import 'package:bmbasket/bloc/model/Address.dart';
import 'package:bmbasket/bloc/provider/UserAddressProvider.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:bmbasket/bloc/model/data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    print("nameis" + displayName);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Account',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: 'DancingScript',
              fontSize: 25,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(EvaIcons.edit, color: Color(0xFFFFFFFF)),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => AddressFormScreen()));
              },
            ),
          ],
        ),
        body: (isloggen == null || isloggen == false)
            ? Column(children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: ClipRRect(
                    child: Image.asset(
                      'assets/images/undraw_My_universe_re_txot.png',
                      width: 500,
                      height: 500,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: RaisedButton(
                    color: Colors.green,
                    hoverColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0)),
                    child: const Text('Login account'),
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                  ),
                )
              ])
            : AccountDetails());
  }
}

class AddressFormScreen extends StatefulWidget {
  @override
  _AddressFormScreenState createState() => _AddressFormScreenState();
}

class _AddressFormScreenState extends State<AddressFormScreen> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController line1Controller = TextEditingController();
  TextEditingController line2Controller = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();

  Address address = Address();
  Position _currentPosition;
  String _line1;
  String _street, _subLocality, _city;
  String _pinCode;

  bool flag = false;

  _getCurrentLocation() async {
    setState(() {
      flag = true;
    });
    await getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position value) {
      setState(() {
        _currentPosition = value;
      });
    });
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      print(_currentPosition.latitude);
      print(_currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _street = place.street;
        _subLocality = place.subLocality;
        _city = place.locality;
        _pinCode = place.postalCode;
        _line1 = _street + " " + _subLocality;
        line1Controller.text = _line1;
        line2Controller.text = "";
        cityController.text = _city;
        pinCodeController.text = _pinCode;
        print(_line1);
        print(_city);
        print(_pinCode);
      });
      setState(() {
        flag = false;
      });
    } catch (e) {
      setState(() {
        flag = false;
      });
      print(e);
    }
  }

  @override
  void initState() {
    print("Init Called==============");
    setState(() {
      flag = true;
    });
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home())),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            'Address Details',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: 'DancingScript',
              fontSize: 25,
            ),
          ),
          leading: IconButton(
              icon: Icon(EvaIcons.arrowBack, color: Color(0xFFFFFFFF)),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (context) => Home()));
              }),
        ),
        body: flag
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Text(
                      'Address Details',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: FormBuilder(
                          key: _formKey,
                          initialValue: {
                            'address-type': 'Home',
                          },
                          child: Column(
                            children: [
                              FormBuilderTextField(
                                controller: nameController,
                                attribute: "name",
                                decoration: InputDecoration(
                                  labelText: "Name",
                                ),
                                validators: [
                                  FormBuilderValidators.minLength(1,
                                      errorText: "Please enter your name"),
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    //log(val);
                                    address.name = val;
                                    //log(address.name);
                                  });
                                },
                              ),
                              FormBuilderTextField(
                                controller: line1Controller,
                                attribute: "address-line-1",
                                decoration: InputDecoration(
                                  labelText: "Address Line 1",
                                ),
                                validators: [
                                  FormBuilderValidators.minLength(2,
                                      errorText: "Enter valid address"),
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    address.addressLine1 = val;
                                  });
                                },
                              ),
                              FormBuilderTextField(
                                controller: line2Controller,
                                attribute: "address-line-2",
                                decoration:
                                    InputDecoration(labelText: "Phone No."),
                                onChanged: (val) {
                                  setState(() {
                                    address.addressLine2 = val;
                                  });
                                },
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: FormBuilderTextField(
                                      controller: cityController,
                                      attribute: "city",
                                      decoration:
                                          InputDecoration(labelText: "City"),
                                      validators: [
                                        FormBuilderValidators.minLength(2,
                                            errorText: "Enter valid city"),
                                      ],
                                      onChanged: (val) {
                                        setState(() {
                                          address.city = cityController.text;
                                        });
                                        print(val);
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 40,
                                  ),
                                  Flexible(
                                    child: FormBuilderTextField(
                                      controller: pinCodeController,
                                      attribute: "pin",
                                      decoration:
                                          InputDecoration(labelText: "PinCode"),
                                      validators: [
                                        FormBuilderValidators.min(6,
                                            errorText: "Enter valid PinCode"),
                                      ],
                                      keyboardType: TextInputType.number,
                                      onChanged: (val) {
                                        setState(() {
                                          address.pinCode = val;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              FormBuilderSwitch(
                                label: Text(
                                  'Set this as my default delivery address',
                                  style: TextStyle(fontSize: 16),
                                ),
                                attribute: "default-address",
                                initialValue: false,
                                onChanged: (value) {
                                  address.defaultDelivery = value;
                                },
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              MaterialButton(
                                onPressed: () async {
                                  setState(() {
                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();
                                      if (address != null) {
                                        if (address.pinCode == null) {
                                          address.pinCode = _pinCode;
                                        }

                                        if (address.city == null) {
                                          address.city = _city;
                                        }
                                        if (address.addressLine1 == null) {
                                          address.addressLine1 = _line1;
                                        }
                                        if (address.defaultDelivery != true) {
                                          address.defaultDelivery = false;
                                        }
                                      }
                                    }
                                  });
                                  final databaseReference =
                                      FirebaseFirestore.instance;

                                  if (isloggen == true) {
                                    UserAddress userAddress = UserAddress();
                                    final firebaseuser =
                                        FirebaseAuth.instance.currentUser;
                                    if (nameController.text != null &&
                                        nameController.text.isNotEmpty &&
                                        nameController.text.length > 1 &&
                                        line1Controller.text != null &&
                                        line1Controller.text.isNotEmpty &&
                                        line2Controller.text != null &&
                                        line2Controller.text.isNotEmpty &&
                                        line2Controller.text.length > 5 &&
                                        cityController.text != null &&
                                        cityController.text.isNotEmpty &&
                                        pinCodeController.text != null &&
                                        pinCodeController.text.isNotEmpty &&
                                        pinCodeController.text.length > 3) {
                                      await databaseReference
                                          .collection("users")
                                          .doc(firebaseuser.uid)
                                          .set({
                                        "username": nameController.text,
                                        "address": line1Controller.text,
                                        "phone": line2Controller.text,
                                        "city": cityController.text,
                                        "pincode": pinCodeController.text
                                      });
                                      setState(() {
                                        userAddress.name = nameController.text;
                                        userAddress.address =
                                            line1Controller.text;
                                        userAddress.phone =
                                            line2Controller.text;
                                        userAddress.city = cityController.text;
                                        userAddress.pincode =
                                            pinCodeController.text;
                                      });

                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => Home()));
                                    }
                                  }
                                },
                                child: Text(
                                  'Save Address',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                color: Colors.green,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
