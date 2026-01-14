import 'package:flutter/material.dart';

class HomeController {
  void logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void goToPets(BuildContext context) {
    Navigator.pushNamed(context, '/pets');
  }

  void goToRequests(BuildContext context) {
    Navigator.pushNamed(context, '/my-requests');
  }

  void goToShelters(BuildContext context) {
    Navigator.pushNamed(context, '/shelters');
  }
}
